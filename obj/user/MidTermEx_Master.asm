
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 dc 02 00 00       	call   800312 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 23 80 00       	push   $0x802300
  80004a:	e8 5d 15 00 00       	call   8015ac <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 4a 16 00 00       	call   8016ad <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 04 23 80 00       	push   $0x802304
  80006b:	e8 32 05 00 00       	call   8005a2 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 41 23 80 00       	push   $0x802341
  80007b:	e8 22 05 00 00       	call   8005a2 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 4f 23 80 00       	push   $0x80234f
  80008b:	e8 12 05 00 00       	call   8005a2 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 60 23 80 00       	push   $0x802360
  80009b:	e8 02 05 00 00       	call   8005a2 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 6f 23 80 00       	push   $0x80236f
  8000ab:	e8 f2 04 00 00       	call   8005a2 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
		select = getchar() ;
  8000b3:	e8 3d 02 00 00       	call   8002f5 <getchar>
  8000b8:	88 45 f3             	mov    %al,-0xd(%ebp)
		cputchar(select);
  8000bb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	50                   	push   %eax
  8000c3:	e8 0e 02 00 00       	call   8002d6 <cputchar>
  8000c8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	e8 01 02 00 00       	call   8002d6 <cputchar>
  8000d5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8000d8:	e8 ea 15 00 00       	call   8016c7 <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 89 23 80 00       	push   $0x802389
  8000e9:	e8 be 14 00 00       	call   8015ac <smalloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*protType = 0 ;
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == '1') 		*protType = 1 ;
  8000fd:	80 7d f3 31          	cmpb   $0x31,-0xd(%ebp)
  800101:	75 0b                	jne    80010e <_main+0xd6>
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  80010c:	eb 0f                	jmp    80011d <_main+0xe5>
	else if (select == '2') *protType = 2 ;
  80010e:	80 7d f3 32          	cmpb   $0x32,-0xd(%ebp)
  800112:	75 09                	jne    80011d <_main+0xe5>
  800114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

	struct semaphore T, finished, finishedCountMutex;
	struct uspinlock *sT, *sfinishedCountMutex;
	int *numOfFinished ;
	if (*protType == 1)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	8b 00                	mov    (%eax),%eax
  800122:	83 f8 01             	cmp    $0x1,%eax
  800125:	75 44                	jne    80016b <_main+0x133>
	{
		T = create_semaphore("T", 0);
  800127:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	6a 00                	push   $0x0
  80012f:	68 92 23 80 00       	push   $0x802392
  800134:	50                   	push   %eax
  800135:	e8 f6 1b 00 00       	call   801d30 <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 94 23 80 00       	push   $0x802394
  80014a:	50                   	push   %eax
  80014b:	e8 e0 1b 00 00       	call   801d30 <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 9d 23 80 00       	push   $0x80239d
  800160:	50                   	push   %eax
  800161:	e8 ca 1b 00 00       	call   801d30 <create_semaphore>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	eb 62                	jmp    8001cd <_main+0x195>
	}
	else if (*protType == 2)
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	83 f8 02             	cmp    $0x2,%eax
  800173:	75 58                	jne    8001cd <_main+0x195>
	{
		sT = smalloc("T", sizeof(struct uspinlock), 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 44                	push   $0x44
  80017c:	68 92 23 80 00       	push   $0x802392
  800181:	e8 26 14 00 00       	call   8015ac <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 92 23 80 00       	push   $0x802392
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 05 1c 00 00       	call   801da3 <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 9d 23 80 00       	push   $0x80239d
  8001ad:	e8 fa 13 00 00       	call   8015ac <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 9d 23 80 00       	push   $0x80239d
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 d9 1b 00 00       	call   801da3 <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 b0 23 80 00       	push   $0x8023b0
  8001d9:	e8 ce 13 00 00       	call   8015ac <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f2:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 be 23 80 00       	push   $0x8023be
  800218:	e8 9b 16 00 00       	call   8018b8 <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 30 80 00       	mov    0x803020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 c8 23 80 00       	push   $0x8023c8
  80024e:	e8 65 16 00 00       	call   8018b8 <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 72 16 00 00       	call   8018d6 <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 64 16 00 00       	call   8018d6 <sys_run_env>
  800272:	83 c4 10             	add    $0x10,%esp

	/*[5] WAIT TILL FINISHING BOTH PROCESSES*/
	if (*protType == 1)
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	75 1c                	jne    80029b <_main+0x263>
	{
		wait_semaphore(finished);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	e8 da 1a 00 00       	call   801d64 <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 cc 1a 00 00       	call   801d64 <wait_semaphore>
  800298:	83 c4 10             	add    $0x10,%esp
	}
	if (*protType == 2)
  80029b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 02             	cmp    $0x2,%eax
  8002a3:	75 0d                	jne    8002b2 <_main+0x27a>
	{
		while (*numOfFinished != 2) ;
  8002a5:	90                   	nop
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	83 f8 02             	cmp    $0x2,%eax
  8002ae:	75 f6                	jne    8002a6 <_main+0x26e>
  8002b0:	eb 0b                	jmp    8002bd <_main+0x285>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8002b2:	90                   	nop
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	83 f8 02             	cmp    $0x2,%eax
  8002bb:	75 f6                	jne    8002b3 <_main+0x27b>
	}

	/*[6] PRINT X*/
	atomic_cprintf("%~Final value of X = %d\n", *X);
  8002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 d2 23 80 00       	push   $0x8023d2
  8002cb:	e8 44 03 00 00       	call   800614 <atomic_cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp

	return;
  8002d3:	90                   	nop
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8002e2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	e8 06 15 00 00       	call   8017f5 <sys_cputc>
  8002ef:	83 c4 10             	add    $0x10,%esp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <getchar>:


int
getchar(void)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8002fb:	e8 94 13 00 00       	call   801694 <sys_cgetc>
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <iscons>:

int iscons(int fdnum)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80030b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80031b:	e8 06 16 00 00       	call   801926 <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	c1 e0 03             	shl    $0x3,%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800339:	01 d0                	add    %edx,%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800343:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800348:	a1 20 30 80 00       	mov    0x803020,%eax
  80034d:	8a 40 20             	mov    0x20(%eax),%al
  800350:	84 c0                	test   %al,%al
  800352:	74 0d                	je     800361 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800354:	a1 20 30 80 00       	mov    0x803020,%eax
  800359:	83 c0 20             	add    $0x20,%eax
  80035c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800365:	7e 0a                	jle    800371 <libmain+0x5f>
		binaryname = argv[0];
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 b9 fc ff ff       	call   800038 <_main>
  80037f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800382:	a1 00 30 80 00       	mov    0x803000,%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	0f 84 01 01 00 00    	je     800490 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	bb e4 24 80 00       	mov    $0x8024e4,%ebx
  80039a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	89 de                	mov    %ebx,%esi
  8003a3:	89 d1                	mov    %edx,%ecx
  8003a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003af:	b0 00                	mov    $0x0,%al
  8003b1:	89 d7                	mov    %edx,%edi
  8003b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c9:	50                   	push   %eax
  8003ca:	e8 8d 17 00 00       	call   801b5c <sys_utilities>
  8003cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003d2:	e8 d6 12 00 00       	call   8016ad <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 04 24 80 00       	push   $0x802404
  8003df:	e8 be 01 00 00       	call   8005a2 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	74 18                	je     800406 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ee:	e8 87 17 00 00       	call   801b7a <sys_get_optimal_num_faults>
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 2c 24 80 00       	push   $0x80242c
  8003fc:	e8 a1 01 00 00       	call   8005a2 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	eb 59                	jmp    80045f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800406:	a1 20 30 80 00       	mov    0x803020,%eax
  80040b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800411:	a1 20 30 80 00       	mov    0x803020,%eax
  800416:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	52                   	push   %edx
  800420:	50                   	push   %eax
  800421:	68 50 24 80 00       	push   $0x802450
  800426:	e8 77 01 00 00       	call   8005a2 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042e:	a1 20 30 80 00       	mov    0x803020,%eax
  800433:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800439:	a1 20 30 80 00       	mov    0x803020,%eax
  80043e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800444:	a1 20 30 80 00       	mov    0x803020,%eax
  800449:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80044f:	51                   	push   %ecx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	68 78 24 80 00       	push   $0x802478
  800457:	e8 46 01 00 00       	call   8005a2 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045f:	a1 20 30 80 00       	mov    0x803020,%eax
  800464:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	50                   	push   %eax
  80046e:	68 d0 24 80 00       	push   $0x8024d0
  800473:	e8 2a 01 00 00       	call   8005a2 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	68 04 24 80 00       	push   $0x802404
  800483:	e8 1a 01 00 00       	call   8005a2 <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80048b:	e8 37 12 00 00       	call   8016c7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800490:	e8 1f 00 00 00       	call   8004b4 <exit>
}
  800495:	90                   	nop
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	6a 00                	push   $0x0
  8004a9:	e8 44 14 00 00       	call   8018f2 <sys_destroy_env>
  8004ae:	83 c4 10             	add    $0x10,%esp
}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <exit>:

void
exit(void)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ba:	e8 99 14 00 00       	call   801958 <sys_exit_env>
}
  8004bf:	90                   	nop
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d4:	89 0a                	mov    %ecx,(%edx)
  8004d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d9:	88 d1                	mov    %dl,%cl
  8004db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004de:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ec:	75 30                	jne    80051e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ee:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004f4:	a0 44 30 80 00       	mov    0x803044,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ff:	8b 09                	mov    (%ecx),%ecx
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800506:	83 c1 08             	add    $0x8,%ecx
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	53                   	push   %ebx
  80050c:	51                   	push   %ecx
  80050d:	e8 57 11 00 00       	call   801669 <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 40 04             	mov    0x4(%eax),%eax
  800524:	8d 50 01             	lea    0x1(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052d:	90                   	nop
  80052e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800543:	00 00 00 
	b.cnt = 0;
  800546:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	50                   	push   %eax
  80055d:	68 c2 04 80 00       	push   $0x8004c2
  800562:	e8 5a 02 00 00       	call   8007c1 <vprintfmt>
  800567:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80056a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800570:	a0 44 30 80 00       	mov    0x803044,%al
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	51                   	push   %ecx
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	83 c0 08             	add    $0x8,%eax
  80058a:	50                   	push   %eax
  80058b:	e8 d9 10 00 00       	call   801669 <sys_cputs>
  800590:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800593:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80059a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 6f ff ff ff       	call   800533 <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	c1 e0 08             	shl    $0x8,%eax
  8005e2:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 34 ff ff ff       	call   800533 <vcprintf>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800605:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80060c:	07 00 00 

	return cnt;
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80061a:	e8 8e 10 00 00       	call   8016ad <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80061f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 f4             	pushl  -0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 ff fe ff ff       	call   800533 <vcprintf>
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80063a:	e8 88 10 00 00       	call   8016c7 <sys_unlock_cons>
	return cnt;
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	53                   	push   %ebx
  800648:	83 ec 14             	sub    $0x14,%esp
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800657:	8b 45 18             	mov    0x18(%ebp),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800662:	77 55                	ja     8006b9 <printnum+0x75>
  800664:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800667:	72 05                	jb     80066e <printnum+0x2a>
  800669:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066c:	77 4b                	ja     8006b9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80066e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800671:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800674:	8b 45 18             	mov    0x18(%ebp),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 f4             	pushl  -0xc(%ebp)
  800681:	ff 75 f0             	pushl  -0x10(%ebp)
  800684:	e8 13 1a 00 00       	call   80209c <__udivdi3>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	ff 75 20             	pushl  0x20(%ebp)
  800692:	53                   	push   %ebx
  800693:	ff 75 18             	pushl  0x18(%ebp)
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	ff 75 08             	pushl  0x8(%ebp)
  80069e:	e8 a1 ff ff ff       	call   800644 <printnum>
  8006a3:	83 c4 20             	add    $0x20,%esp
  8006a6:	eb 1a                	jmp    8006c2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 20             	pushl  0x20(%ebp)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	ff d0                	call   *%eax
  8006b6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b9:	ff 4d 1c             	decl   0x1c(%ebp)
  8006bc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c0:	7f e6                	jg     8006a8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d0:	53                   	push   %ebx
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	e8 d3 1a 00 00       	call   8021ac <__umoddi3>
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	05 74 27 80 00       	add    $0x802774,%eax
  8006e1:	8a 00                	mov    (%eax),%al
  8006e3:	0f be c0             	movsbl %al,%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800702:	7e 1c                	jle    800720 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 08             	lea    0x8(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 08             	sub    $0x8,%eax
  800719:	8b 50 04             	mov    0x4(%eax),%edx
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	eb 40                	jmp    800760 <getuint+0x65>
	else if (lflag)
  800720:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800724:	74 1e                	je     800744 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	eb 1c                	jmp    800760 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800765:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800769:	7e 1c                	jle    800787 <getint+0x25>
		return va_arg(*ap, long long);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	8d 50 08             	lea    0x8(%eax),%edx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 10                	mov    %edx,(%eax)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	83 e8 08             	sub    $0x8,%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	eb 38                	jmp    8007bf <getint+0x5d>
	else if (lflag)
  800787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078b:	74 1a                	je     8007a7 <getint+0x45>
		return va_arg(*ap, long);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
  8007a5:	eb 18                	jmp    8007bf <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8d 50 04             	lea    0x4(%eax),%edx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 10                	mov    %edx,(%eax)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	99                   	cltd   
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	eb 17                	jmp    8007e2 <vprintfmt+0x21>
			if (ch == '\0')
  8007cb:	85 db                	test   %ebx,%ebx
  8007cd:	0f 84 c1 03 00 00    	je     800b94 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	53                   	push   %ebx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	83 fb 25             	cmp    $0x25,%ebx
  8007f3:	75 d6                	jne    8007cb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800800:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800807:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80080e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8d 50 01             	lea    0x1(%eax),%edx
  80081b:	89 55 10             	mov    %edx,0x10(%ebp)
  80081e:	8a 00                	mov    (%eax),%al
  800820:	0f b6 d8             	movzbl %al,%ebx
  800823:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800826:	83 f8 5b             	cmp    $0x5b,%eax
  800829:	0f 87 3d 03 00 00    	ja     800b6c <vprintfmt+0x3ab>
  80082f:	8b 04 85 98 27 80 00 	mov    0x802798(,%eax,4),%eax
  800836:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800838:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d7                	jmp    800815 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80083e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800842:	eb d1                	jmp    800815 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800844:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084e:	89 d0                	mov    %edx,%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	01 d8                	add    %ebx,%eax
  800859:	83 e8 30             	sub    $0x30,%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8a 00                	mov    (%eax),%al
  800864:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800867:	83 fb 2f             	cmp    $0x2f,%ebx
  80086a:	7e 3e                	jle    8008aa <vprintfmt+0xe9>
  80086c:	83 fb 39             	cmp    $0x39,%ebx
  80086f:	7f 39                	jg     8008aa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800871:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800874:	eb d5                	jmp    80084b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088a:	eb 1f                	jmp    8008ab <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800890:	79 83                	jns    800815 <vprintfmt+0x54>
				width = 0;
  800892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800899:	e9 77 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80089e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a5:	e9 6b ff ff ff       	jmp    800815 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	0f 89 60 ff ff ff    	jns    800815 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c2:	e9 4e ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ca:	e9 46 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	ff d0                	call   *%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 9b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800905:	85 db                	test   %ebx,%ebx
  800907:	79 02                	jns    80090b <vprintfmt+0x14a>
				err = -err;
  800909:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090b:	83 fb 64             	cmp    $0x64,%ebx
  80090e:	7f 0b                	jg     80091b <vprintfmt+0x15a>
  800910:	8b 34 9d e0 25 80 00 	mov    0x8025e0(,%ebx,4),%esi
  800917:	85 f6                	test   %esi,%esi
  800919:	75 19                	jne    800934 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091b:	53                   	push   %ebx
  80091c:	68 85 27 80 00       	push   $0x802785
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 70 02 00 00       	call   800b9c <printfmt>
  80092c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092f:	e9 5b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800934:	56                   	push   %esi
  800935:	68 8e 27 80 00       	push   $0x80278e
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 08             	pushl  0x8(%ebp)
  800940:	e8 57 02 00 00       	call   800b9c <printfmt>
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 42 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 30                	mov    (%eax),%esi
  80095e:	85 f6                	test   %esi,%esi
  800960:	75 05                	jne    800967 <vprintfmt+0x1a6>
				p = "(null)";
  800962:	be 91 27 80 00       	mov    $0x802791,%esi
			if (width > 0 && padc != '-')
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	7e 6d                	jle    8009da <vprintfmt+0x219>
  80096d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800971:	74 67                	je     8009da <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	50                   	push   %eax
  80097a:	56                   	push   %esi
  80097b:	e8 1e 03 00 00       	call   800c9e <strnlen>
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800986:	eb 16                	jmp    80099e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099b:	ff 4d e4             	decl   -0x1c(%ebp)
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7f e4                	jg     800988 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	eb 34                	jmp    8009da <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009aa:	74 1c                	je     8009c8 <vprintfmt+0x207>
  8009ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8009af:	7e 05                	jle    8009b6 <vprintfmt+0x1f5>
  8009b1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b4:	7e 12                	jle    8009c8 <vprintfmt+0x207>
					putch('?', putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	6a 3f                	push   $0x3f
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb 0f                	jmp    8009d7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009da:	89 f0                	mov    %esi,%eax
  8009dc:	8d 70 01             	lea    0x1(%eax),%esi
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	0f be d8             	movsbl %al,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	74 24                	je     800a0c <vprintfmt+0x24b>
  8009e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ec:	78 b8                	js     8009a6 <vprintfmt+0x1e5>
  8009ee:	ff 4d e0             	decl   -0x20(%ebp)
  8009f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f5:	79 af                	jns    8009a6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	eb 13                	jmp    800a0c <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 20                	push   $0x20
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7f e7                	jg     8009f9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a12:	e9 78 01 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a20:	50                   	push   %eax
  800a21:	e8 3c fd ff ff       	call   800762 <getint>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	85 d2                	test   %edx,%edx
  800a37:	79 23                	jns    800a5c <vprintfmt+0x29b>
				putch('-', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 2d                	push   $0x2d
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	f7 d8                	neg    %eax
  800a51:	83 d2 00             	adc    $0x0,%edx
  800a54:	f7 da                	neg    %edx
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 84 fc ff ff       	call   8006fb <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a87:	e9 98 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	6a 58                	push   $0x58
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 58                	push   $0x58
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 58                	push   $0x58
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 ce 00 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 30                	push   $0x30
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 78                	push   $0x78
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b03:	eb 1f                	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0e:	50                   	push   %eax
  800b0f:	e8 e7 fb ff ff       	call   8006fb <getuint>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b24:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	52                   	push   %edx
  800b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 00 fb ff ff       	call   800644 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
			break;
  800b47:	eb 46                	jmp    800b8f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	eb 35                	jmp    800b8f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b5a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b61:	eb 2c                	jmp    800b8f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b63:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b6a:	eb 23                	jmp    800b8f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 25                	push   $0x25
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7c:	ff 4d 10             	decl   0x10(%ebp)
  800b7f:	eb 03                	jmp    800b84 <vprintfmt+0x3c3>
  800b81:	ff 4d 10             	decl   0x10(%ebp)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	48                   	dec    %eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3c 25                	cmp    $0x25,%al
  800b8c:	75 f3                	jne    800b81 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b8e:	90                   	nop
		}
	}
  800b8f:	e9 35 fc ff ff       	jmp    8007c9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b94:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 04 fc ff ff       	call   8007c1 <vprintfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc0:	90                   	nop
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8b 40 08             	mov    0x8(%eax),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 10                	mov    (%eax),%edx
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 04             	mov    0x4(%eax),%eax
  800be0:	39 c2                	cmp    %eax,%edx
  800be2:	73 12                	jae    800bf6 <sprintputch+0x33>
		*b->buf++ = ch;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bef:	89 0a                	mov    %ecx,(%edx)
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
}
  800bf6:	90                   	nop
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	01 d0                	add    %edx,%eax
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c1e:	74 06                	je     800c26 <vsnprintf+0x2d>
  800c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c24:	7f 07                	jg     800c2d <vsnprintf+0x34>
		return -E_INVAL;
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	eb 20                	jmp    800c4d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2d:	ff 75 14             	pushl  0x14(%ebp)
  800c30:	ff 75 10             	pushl  0x10(%ebp)
  800c33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c36:	50                   	push   %eax
  800c37:	68 c3 0b 80 00       	push   $0x800bc3
  800c3c:	e8 80 fb ff ff       	call   8007c1 <vprintfmt>
  800c41:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c47:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c55:	8d 45 10             	lea    0x10(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 89 ff ff ff       	call   800bf9 <vsnprintf>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c88:	eb 06                	jmp    800c90 <strlen+0x15>
		n++;
  800c8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 f1                	jne    800c8a <strlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cab:	eb 09                	jmp    800cb6 <strnlen+0x18>
		n++;
  800cad:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	ff 4d 0c             	decl   0xc(%ebp)
  800cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cba:	74 09                	je     800cc5 <strnlen+0x27>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e8                	jne    800cad <strnlen+0xf>
		n++;
	return n;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd6:	90                   	nop
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 e4                	jne    800cd7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0b:	eb 1f                	jmp    800d2c <strncpy+0x34>
		*dst++ = *src;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	89 55 08             	mov    %edx,0x8(%ebp)
  800d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d19:	8a 12                	mov    (%edx),%dl
  800d1b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 03                	je     800d29 <strncpy+0x31>
			src++;
  800d26:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d29:	ff 45 fc             	incl   -0x4(%ebp)
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d32:	72 d9                	jb     800d0d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 30                	je     800d7b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d4b:	eb 16                	jmp    800d63 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	89 55 08             	mov    %edx,0x8(%ebp)
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d63:	ff 4d 10             	decl   0x10(%ebp)
  800d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6a:	74 09                	je     800d75 <strlcpy+0x3c>
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 d8                	jne    800d4d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	29 c2                	sub    %eax,%edx
  800d83:	89 d0                	mov    %edx,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d8a:	eb 06                	jmp    800d92 <strcmp+0xb>
		p++, q++;
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	74 0e                	je     800da9 <strcmp+0x22>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 10                	mov    (%eax),%dl
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	38 c2                	cmp    %al,%dl
  800da7:	74 e3                	je     800d8c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	0f b6 d0             	movzbl %al,%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f b6 c0             	movzbl %al,%eax
  800db9:	29 c2                	sub    %eax,%edx
  800dbb:	89 d0                	mov    %edx,%eax
}
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dc2:	eb 09                	jmp    800dcd <strncmp+0xe>
		n--, p++, q++;
  800dc4:	ff 4d 10             	decl   0x10(%ebp)
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 17                	je     800dea <strncmp+0x2b>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 0e                	je     800dea <strncmp+0x2b>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 10                	mov    (%eax),%dl
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	38 c2                	cmp    %al,%dl
  800de8:	74 da                	je     800dc4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	75 07                	jne    800df7 <strncmp+0x38>
		return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	eb 14                	jmp    800e0b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 12                	jmp    800e2d <strchr+0x20>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	75 05                	jne    800e2a <strchr+0x1d>
			return (char *) s;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	eb 11                	jmp    800e3b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 e5                	jne    800e1b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e49:	eb 0d                	jmp    800e58 <strfind+0x1b>
		if (*s == c)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e53:	74 0e                	je     800e63 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 ea                	jne    800e4b <strfind+0xe>
  800e61:	eb 01                	jmp    800e64 <strfind+0x27>
		if (*s == c)
			break;
  800e63:	90                   	nop
	return (char *) s;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e79:	76 63                	jbe    800ede <memset+0x75>
		uint64 data_block = c;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	99                   	cltd   
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e8f:	c1 e0 08             	shl    $0x8,%eax
  800e92:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e95:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ea2:	c1 e0 10             	shl    $0x10,%eax
  800ea5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ebe:	eb 18                	jmp    800ed8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ec0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec3:	8d 41 08             	lea    0x8(%ecx),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 01                	mov    %eax,(%ecx)
  800ed1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ed4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edc:	77 e2                	ja     800ec0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 23                	je     800f07 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eea:	eb 0e                	jmp    800efa <memset+0x91>
			*p8++ = (uint8)c;
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8d 50 01             	lea    0x1(%eax),%edx
  800ef2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 e5                	jne    800eec <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f22:	76 24                	jbe    800f48 <memcpy+0x3c>
		while(n >= 8){
  800f24:	eb 1c                	jmp    800f42 <memcpy+0x36>
			*d64 = *s64;
  800f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f29:	8b 50 04             	mov    0x4(%eax),%edx
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f31:	89 01                	mov    %eax,(%ecx)
  800f33:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f36:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f3a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f3e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	77 de                	ja     800f26 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 31                	je     800f7f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x66>
			*d8++ = *s8++;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801240:	75 bb                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	48                   	dec    %eax
  80124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801254:	74 3d                	je     801293 <ltostr+0xc3>
		start = 1 ;
  801256:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125d:	eb 34                	jmp    801293 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 c2                	add    %eax,%edx
  801274:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801280:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128b:	88 02                	mov    %al,(%edx)
		start++ ;
  80128d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801290:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801299:	7c c4                	jl     80125f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 c4 f9 ff ff       	call   800c7b <strlen>
  8012b7:	83 c4 04             	add    $0x4,%esp
  8012ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b6 f9 ff ff       	call   800c7b <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d9:	eb 17                	jmp    8012f2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 c2                	add    %eax,%edx
  8012e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	01 c8                	add    %ecx,%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f8:	7c e1                	jl     8012db <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801308:	eb 1f                	jmp    801329 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	8d 50 01             	lea    0x1(%eax),%edx
  801310:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	01 c8                	add    %ecx,%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801326:	ff 45 f8             	incl   -0x8(%ebp)
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132f:	7c d9                	jl     80130a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801331:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c6 00 00             	movb   $0x0,(%eax)
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	8b 00                	mov    (%eax),%eax
  801350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801362:	eb 0c                	jmp    801370 <strsplit+0x31>
			*string++ = 0;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 08             	mov    %edx,0x8(%ebp)
  80136d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	74 18                	je     801391 <strsplit+0x52>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	50                   	push   %eax
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	e8 83 fa ff ff       	call   800e0d <strchr>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	75 d3                	jne    801364 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 5a                	je     8013f4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	83 f8 0f             	cmp    $0xf,%eax
  8013a2:	75 07                	jne    8013ab <strsplit+0x6c>
		{
			return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 66                	jmp    801411 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b6:	89 0a                	mov    %ecx,(%edx)
  8013b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 c2                	add    %eax,%edx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c9:	eb 03                	jmp    8013ce <strsplit+0x8f>
			string++;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	74 8b                	je     801362 <strsplit+0x23>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	0f be c0             	movsbl %al,%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 25 fa ff ff       	call   800e0d <strchr>
  8013e8:	83 c4 08             	add    $0x8,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 dc                	je     8013cb <strsplit+0x8c>
			string++;
	}
  8013ef:	e9 6e ff ff ff       	jmp    801362 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 4a                	jmp    801472 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 40                	cmp    $0x40,%al
  801448:	7e 25                	jle    80146f <str2lower+0x5c>
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 5a                	cmp    $0x5a,%al
  801456:	7f 17                	jg     80146f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	01 ca                	add    %ecx,%edx
  801468:	8a 12                	mov    (%edx),%dl
  80146a:	83 c2 20             	add    $0x20,%edx
  80146d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 01 f8 ff ff       	call   800c7b <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801480:	7f a6                	jg     801428 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80148d:	a1 08 30 80 00       	mov    0x803008,%eax
  801492:	85 c0                	test   %eax,%eax
  801494:	74 42                	je     8014d8 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	68 00 00 00 82       	push   $0x82000000
  80149e:	68 00 00 00 80       	push   $0x80000000
  8014a3:	e8 8c 07 00 00       	call   801c34 <initialize_dynamic_allocator>
  8014a8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014ab:	e8 e7 05 00 00       	call   801a97 <sys_get_uheap_strategy>
  8014b0:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014b5:	a1 40 30 80 00       	mov    0x803040,%eax
  8014ba:	05 00 10 00 00       	add    $0x1000,%eax
  8014bf:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014c4:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8014c9:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8014ce:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8014d5:	00 00 00 
	}
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	68 06 04 00 00       	push   $0x406
  8014f7:	50                   	push   %eax
  8014f8:	e8 e4 01 00 00       	call   8016e1 <__sys_allocate_page>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801507:	79 14                	jns    80151d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 08 29 80 00       	push   $0x802908
  801511:	6a 1f                	push   $0x1f
  801513:	68 44 29 80 00       	push   $0x802944
  801518:	e8 8e 09 00 00       	call   801eab <_panic>
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	50                   	push   %eax
  80153c:	e8 e7 01 00 00       	call   801728 <__sys_unmap_frame>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801547:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80154b:	79 14                	jns    801561 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 50 29 80 00       	push   $0x802950
  801555:	6a 2a                	push   $0x2a
  801557:	68 44 29 80 00       	push   $0x802944
  80155c:	e8 4a 09 00 00       	call   801eab <_panic>
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80156a:	e8 18 ff ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  80156f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801573:	75 07                	jne    80157c <malloc+0x18>
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
  80157a:	eb 14                	jmp    801590 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	68 90 29 80 00       	push   $0x802990
  801584:	6a 3e                	push   $0x3e
  801586:	68 44 29 80 00       	push   $0x802944
  80158b:	e8 1b 09 00 00       	call   801eab <_panic>
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	68 b8 29 80 00       	push   $0x8029b8
  8015a0:	6a 49                	push   $0x49
  8015a2:	68 44 29 80 00       	push   $0x802944
  8015a7:	e8 ff 08 00 00       	call   801eab <_panic>

008015ac <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 18             	sub    $0x18,%esp
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015b8:	e8 ca fe ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  8015bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c1:	75 07                	jne    8015ca <smalloc+0x1e>
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	eb 14                	jmp    8015de <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	68 dc 29 80 00       	push   $0x8029dc
  8015d2:	6a 5a                	push   $0x5a
  8015d4:	68 44 29 80 00       	push   $0x802944
  8015d9:	e8 cd 08 00 00       	call   801eab <_panic>
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015e6:	e8 9c fe ff ff       	call   801487 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 04 2a 80 00       	push   $0x802a04
  8015f3:	6a 6a                	push   $0x6a
  8015f5:	68 44 29 80 00       	push   $0x802944
  8015fa:	e8 ac 08 00 00       	call   801eab <_panic>

008015ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801605:	e8 7d fe ff ff       	call   801487 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 28 2a 80 00       	push   $0x802a28
  801612:	68 88 00 00 00       	push   $0x88
  801617:	68 44 29 80 00       	push   $0x802944
  80161c:	e8 8a 08 00 00       	call   801eab <_panic>

00801621 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 50 2a 80 00       	push   $0x802a50
  80162f:	68 9b 00 00 00       	push   $0x9b
  801634:	68 44 29 80 00       	push   $0x802944
  801639:	e8 6d 08 00 00       	call   801eab <_panic>

0080163e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801650:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801653:	8b 7d 18             	mov    0x18(%ebp),%edi
  801656:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801659:	cd 30                	int    $0x30
  80165b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801675:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801678:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	51                   	push   %ecx
  801682:	52                   	push   %edx
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	50                   	push   %eax
  801687:	6a 00                	push   $0x0
  801689:	e8 b0 ff ff ff       	call   80163e <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_cgetc>:

int
sys_cgetc(void)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 02                	push   $0x2
  8016a3:	e8 96 ff ff ff       	call   80163e <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 03                	push   $0x3
  8016bc:	e8 7d ff ff ff       	call   80163e <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	90                   	nop
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 04                	push   $0x4
  8016d6:	e8 63 ff ff ff       	call   80163e <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	90                   	nop
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 08                	push   $0x8
  8016f4:	e8 45 ff ff ff       	call   80163e <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801703:	8b 75 18             	mov    0x18(%ebp),%esi
  801706:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801709:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	51                   	push   %ecx
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 09                	push   $0x9
  801719:	e8 20 ff ff ff       	call   80163e <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	6a 0a                	push   $0xa
  801738:	e8 01 ff ff ff       	call   80163e <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 0b                	push   $0xb
  801753:	e8 e6 fe ff ff       	call   80163e <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 0c                	push   $0xc
  80176c:	e8 cd fe ff ff       	call   80163e <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 0d                	push   $0xd
  801785:	e8 b4 fe ff ff       	call   80163e <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 0e                	push   $0xe
  80179e:	e8 9b fe ff ff       	call   80163e <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 0f                	push   $0xf
  8017b7:	e8 82 fe ff ff       	call   80163e <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	6a 10                	push   $0x10
  8017d1:	e8 68 fe ff ff       	call   80163e <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 11                	push   $0x11
  8017ea:	e8 4f fe ff ff       	call   80163e <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801801:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	50                   	push   %eax
  80180e:	6a 01                	push   $0x1
  801810:	e8 29 fe ff ff       	call   80163e <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 14                	push   $0x14
  80182a:	e8 0f fe ff ff       	call   80163e <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	90                   	nop
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801841:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801844:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	51                   	push   %ecx
  80184e:	52                   	push   %edx
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	6a 15                	push   $0x15
  801855:	e8 e4 fd ff ff       	call   80163e <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	52                   	push   %edx
  80186f:	50                   	push   %eax
  801870:	6a 16                	push   $0x16
  801872:	e8 c7 fd ff ff       	call   80163e <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80187f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	51                   	push   %ecx
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 17                	push   $0x17
  801891:	e8 a8 fd ff ff       	call   80163e <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 18                	push   $0x18
  8018ae:	e8 8b fd ff ff       	call   80163e <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 14             	pushl  0x14(%ebp)
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	6a 19                	push   $0x19
  8018cc:	e8 6d fd ff ff       	call   80163e <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	50                   	push   %eax
  8018e5:	6a 1a                	push   $0x1a
  8018e7:	e8 52 fd ff ff       	call   80163e <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	50                   	push   %eax
  801901:	6a 1b                	push   $0x1b
  801903:	e8 36 fd ff ff       	call   80163e <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 05                	push   $0x5
  80191c:	e8 1d fd ff ff       	call   80163e <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 06                	push   $0x6
  801935:	e8 04 fd ff ff       	call   80163e <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 07                	push   $0x7
  80194e:	e8 eb fc ff ff       	call   80163e <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_exit_env>:


void sys_exit_env(void)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 1c                	push   $0x1c
  801967:	e8 d2 fc ff ff       	call   80163e <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801978:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80197b:	8d 50 04             	lea    0x4(%eax),%edx
  80197e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	52                   	push   %edx
  801988:	50                   	push   %eax
  801989:	6a 1d                	push   $0x1d
  80198b:	e8 ae fc ff ff       	call   80163e <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
	return result;
  801993:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80199c:	89 01                	mov    %eax,(%ecx)
  80199e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	c9                   	leave  
  8019a5:	c2 04 00             	ret    $0x4

008019a8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 13                	push   $0x13
  8019ba:	e8 7f fc ff ff       	call   80163e <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 1e                	push   $0x1e
  8019d4:	e8 65 fc ff ff       	call   80163e <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	50                   	push   %eax
  8019f7:	6a 1f                	push   $0x1f
  8019f9:	e8 40 fc ff ff       	call   80163e <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <rsttst>:
void rsttst()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 21                	push   $0x21
  801a13:	e8 26 fc ff ff       	call   80163e <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1b:	90                   	nop
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	8b 45 14             	mov    0x14(%ebp),%eax
  801a27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801a2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	6a 20                	push   $0x20
  801a3e:	e8 fb fb ff ff       	call   80163e <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
	return ;
  801a46:	90                   	nop
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <chktst>:
void chktst(uint32 n)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 08             	pushl  0x8(%ebp)
  801a57:	6a 22                	push   $0x22
  801a59:	e8 e0 fb ff ff       	call   80163e <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a61:	90                   	nop
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <inctst>:

void inctst()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 23                	push   $0x23
  801a73:	e8 c6 fb ff ff       	call   80163e <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <gettst>:
uint32 gettst()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 24                	push   $0x24
  801a8d:	e8 ac fb ff ff       	call   80163e <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 25                	push   $0x25
  801aa6:	e8 93 fb ff ff       	call   80163e <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
  801aae:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ab3:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	6a 26                	push   $0x26
  801ad2:	e8 67 fb ff ff       	call   80163e <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ae1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	53                   	push   %ebx
  801af0:	51                   	push   %ecx
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 27                	push   $0x27
  801af5:	e8 44 fb ff ff       	call   80163e <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 28                	push   $0x28
  801b15:	e8 24 fb ff ff       	call   80163e <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	51                   	push   %ecx
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 29                	push   $0x29
  801b35:	e8 04 fb ff ff       	call   80163e <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 12                	push   $0x12
  801b51:	e8 e8 fa ff ff       	call   80163e <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return ;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 2a                	push   $0x2a
  801b6f:	e8 ca fa ff ff       	call   80163e <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 2b                	push   $0x2b
  801b89:	e8 b0 fa ff ff       	call   80163e <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 2d                	push   $0x2d
  801ba4:	e8 95 fa ff ff       	call   80163e <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return;
  801bac:	90                   	nop
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 2c                	push   $0x2c
  801bc0:	e8 79 fa ff ff       	call   80163e <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	68 74 2a 80 00       	push   $0x802a74
  801bd9:	68 25 01 00 00       	push   $0x125
  801bde:	68 a7 2a 80 00       	push   $0x802aa7
  801be3:	e8 c3 02 00 00       	call   801eab <_panic>

00801be8 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	ba 60 30 80 00       	mov    $0x803060,%edx
  801bf6:	29 d0                	sub    %edx,%eax
  801bf8:	c1 f8 02             	sar    $0x2,%eax
  801bfb:	89 c2                	mov    %eax,%edx
  801bfd:	89 d0                	mov    %edx,%eax
  801bff:	c1 e0 02             	shl    $0x2,%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	c1 e0 02             	shl    $0x2,%eax
  801c07:	01 d0                	add    %edx,%eax
  801c09:	c1 e0 02             	shl    $0x2,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	89 c1                	mov    %eax,%ecx
  801c10:	c1 e1 08             	shl    $0x8,%ecx
  801c13:	01 c8                	add    %ecx,%eax
  801c15:	89 c1                	mov    %eax,%ecx
  801c17:	c1 e1 10             	shl    $0x10,%ecx
  801c1a:	01 c8                	add    %ecx,%eax
  801c1c:	01 c0                	add    %eax,%eax
  801c1e:	01 d0                	add    %edx,%eax
  801c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c26:	c1 e0 0c             	shl    $0xc,%eax
  801c29:	89 c2                	mov    %eax,%edx
  801c2b:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c30:	01 d0                	add    %edx,%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	05 00 00 00 02       	add    $0x2000000,%eax
  801c42:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c45:	73 16                	jae    801c5d <initialize_dynamic_allocator+0x29>
  801c47:	68 b8 2a 80 00       	push   $0x802ab8
  801c4c:	68 de 2a 80 00       	push   $0x802ade
  801c51:	6a 26                	push   $0x26
  801c53:	68 f3 2a 80 00       	push   $0x802af3
  801c58:	e8 4e 02 00 00       	call   801eab <_panic>
		is_initialized = 1;
  801c5d:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801c64:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	68 0c 2b 80 00       	push   $0x802b0c
  801c6f:	6a 2e                	push   $0x2e
  801c71:	68 f3 2a 80 00       	push   $0x802af3
  801c76:	e8 30 02 00 00       	call   801eab <_panic>

00801c7b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 40 2b 80 00       	push   $0x802b40
  801c89:	6a 3a                	push   $0x3a
  801c8b:	68 f3 2a 80 00       	push   $0x802af3
  801c90:	e8 16 02 00 00       	call   801eab <_panic>

00801c95 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801c9b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ca2:	76 16                	jbe    801cba <alloc_block+0x25>
  801ca4:	68 68 2b 80 00       	push   $0x802b68
  801ca9:	68 de 2a 80 00       	push   $0x802ade
  801cae:	6a 46                	push   $0x46
  801cb0:	68 f3 2a 80 00       	push   $0x802af3
  801cb5:	e8 f1 01 00 00       	call   801eab <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	68 8c 2b 80 00       	push   $0x802b8c
  801cc2:	6a 4d                	push   $0x4d
  801cc4:	68 f3 2a 80 00       	push   $0x802af3
  801cc9:	e8 dd 01 00 00       	call   801eab <_panic>

00801cce <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd7:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801cdc:	39 c2                	cmp    %eax,%edx
  801cde:	72 0c                	jb     801cec <free_block+0x1e>
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	a1 40 30 80 00       	mov    0x803040,%eax
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	72 16                	jb     801d02 <free_block+0x34>
  801cec:	68 b0 2b 80 00       	push   $0x802bb0
  801cf1:	68 de 2a 80 00       	push   $0x802ade
  801cf6:	6a 5b                	push   $0x5b
  801cf8:	68 f3 2a 80 00       	push   $0x802af3
  801cfd:	e8 a9 01 00 00       	call   801eab <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	68 e8 2b 80 00       	push   $0x802be8
  801d0a:	6a 63                	push   $0x63
  801d0c:	68 f3 2a 80 00       	push   $0x802af3
  801d11:	e8 95 01 00 00       	call   801eab <_panic>

00801d16 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d1c:	83 ec 04             	sub    $0x4,%esp
  801d1f:	68 0c 2c 80 00       	push   $0x802c0c
  801d24:	6a 72                	push   $0x72
  801d26:	68 f3 2a 80 00       	push   $0x802af3
  801d2b:	e8 7b 01 00 00       	call   801eab <_panic>

00801d30 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801d36:	83 ec 04             	sub    $0x4,%esp
  801d39:	68 30 2c 80 00       	push   $0x802c30
  801d3e:	6a 07                	push   $0x7
  801d40:	68 5f 2c 80 00       	push   $0x802c5f
  801d45:	e8 61 01 00 00       	call   801eab <_panic>

00801d4a <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	68 70 2c 80 00       	push   $0x802c70
  801d58:	6a 0b                	push   $0xb
  801d5a:	68 5f 2c 80 00       	push   $0x802c5f
  801d5f:	e8 47 01 00 00       	call   801eab <_panic>

00801d64 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	68 9c 2c 80 00       	push   $0x802c9c
  801d72:	6a 10                	push   $0x10
  801d74:	68 5f 2c 80 00       	push   $0x802c5f
  801d79:	e8 2d 01 00 00       	call   801eab <_panic>

00801d7e <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	68 cc 2c 80 00       	push   $0x802ccc
  801d8c:	6a 15                	push   $0x15
  801d8e:	68 5f 2c 80 00       	push   $0x802c5f
  801d93:	e8 13 01 00 00       	call   801eab <_panic>

00801d98 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8b 40 10             	mov    0x10(%eax),%eax
}
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  801da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dad:	74 1c                	je     801dcb <init_uspinlock+0x28>
  801daf:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  801db3:	74 16                	je     801dcb <init_uspinlock+0x28>
  801db5:	68 fc 2c 80 00       	push   $0x802cfc
  801dba:	68 1b 2d 80 00       	push   $0x802d1b
  801dbf:	6a 10                	push   $0x10
  801dc1:	68 30 2d 80 00       	push   $0x802d30
  801dc6:	e8 e0 00 00 00       	call   801eab <_panic>
	strcpy(lk->name, name);
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	83 c0 04             	add    $0x4,%eax
  801dd1:	83 ec 08             	sub    $0x8,%esp
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	50                   	push   %eax
  801dd8:	e8 ed ee ff ff       	call   800cca <strcpy>
  801ddd:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  801de0:	b8 01 00 00 00       	mov    $0x1,%eax
  801de5:	2b 45 10             	sub    0x10(%ebp),%eax
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 10                	mov    %edx,(%eax)
}
  801def:	90                   	nop
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  801df8:	90                   	nop
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e0f:	f0 87 02             	lock xchg %eax,(%edx)
  801e12:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  801e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	75 dd                	jne    801df9 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	8d 48 04             	lea    0x4(%eax),%ecx
  801e22:	a1 20 30 80 00       	mov    0x803020,%eax
  801e27:	8d 50 20             	lea    0x20(%eax),%edx
  801e2a:	a1 20 30 80 00       	mov    0x803020,%eax
  801e2f:	8b 40 10             	mov    0x10(%eax),%eax
  801e32:	51                   	push   %ecx
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	68 40 2d 80 00       	push   $0x802d40
  801e3a:	e8 63 e7 ff ff       	call   8005a2 <cprintf>
  801e3f:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  801e42:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  801e47:	90                   	nop
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	8b 00                	mov    (%eax),%eax
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 18                	jne    801e71 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	83 c0 04             	add    $0x4,%eax
  801e5f:	50                   	push   %eax
  801e60:	68 64 2d 80 00       	push   $0x802d64
  801e65:	6a 2b                	push   $0x2b
  801e67:	68 30 2d 80 00       	push   $0x802d30
  801e6c:	e8 3a 00 00 00       	call   801eab <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  801e71:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8d 48 04             	lea    0x4(%eax),%ecx
  801e88:	a1 20 30 80 00       	mov    0x803020,%eax
  801e8d:	8d 50 20             	lea    0x20(%eax),%edx
  801e90:	a1 20 30 80 00       	mov    0x803020,%eax
  801e95:	8b 40 10             	mov    0x10(%eax),%eax
  801e98:	51                   	push   %ecx
  801e99:	52                   	push   %edx
  801e9a:	50                   	push   %eax
  801e9b:	68 84 2d 80 00       	push   $0x802d84
  801ea0:	e8 fd e6 ff ff       	call   8005a2 <cprintf>
  801ea5:	83 c4 10             	add    $0x10,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801eb1:	8d 45 10             	lea    0x10(%ebp),%eax
  801eb4:	83 c0 04             	add    $0x4,%eax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801eba:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	74 16                	je     801ed9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801ec3:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	50                   	push   %eax
  801ecc:	68 a8 2d 80 00       	push   $0x802da8
  801ed1:	e8 cc e6 ff ff       	call   8005a2 <cprintf>
  801ed6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801ed9:	a1 04 30 80 00       	mov    0x803004,%eax
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	50                   	push   %eax
  801ee8:	68 b0 2d 80 00       	push   $0x802db0
  801eed:	6a 74                	push   $0x74
  801eef:	e8 db e6 ff ff       	call   8005cf <cprintf_colored>
  801ef4:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  801efa:	83 ec 08             	sub    $0x8,%esp
  801efd:	ff 75 f4             	pushl  -0xc(%ebp)
  801f00:	50                   	push   %eax
  801f01:	e8 2d e6 ff ff       	call   800533 <vcprintf>
  801f06:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	6a 00                	push   $0x0
  801f0e:	68 d8 2d 80 00       	push   $0x802dd8
  801f13:	e8 1b e6 ff ff       	call   800533 <vcprintf>
  801f18:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801f1b:	e8 94 e5 ff ff       	call   8004b4 <exit>

	// should not return here
	while (1) ;
  801f20:	eb fe                	jmp    801f20 <_panic+0x75>

00801f22 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801f28:	a1 20 30 80 00       	mov    0x803020,%eax
  801f2d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f36:	39 c2                	cmp    %eax,%edx
  801f38:	74 14                	je     801f4e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	68 dc 2d 80 00       	push   $0x802ddc
  801f42:	6a 26                	push   $0x26
  801f44:	68 28 2e 80 00       	push   $0x802e28
  801f49:	e8 5d ff ff ff       	call   801eab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f5c:	e9 c5 00 00 00       	jmp    802026 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	01 d0                	add    %edx,%eax
  801f70:	8b 00                	mov    (%eax),%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 08                	jne    801f7e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801f76:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801f79:	e9 a5 00 00 00       	jmp    802023 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801f7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f85:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f8c:	eb 69                	jmp    801ff7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801f8e:	a1 20 30 80 00       	mov    0x803020,%eax
  801f93:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801f99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f9c:	89 d0                	mov    %edx,%eax
  801f9e:	01 c0                	add    %eax,%eax
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	c1 e0 03             	shl    $0x3,%eax
  801fa5:	01 c8                	add    %ecx,%eax
  801fa7:	8a 40 04             	mov    0x4(%eax),%al
  801faa:	84 c0                	test   %al,%al
  801fac:	75 46                	jne    801ff4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fae:	a1 20 30 80 00       	mov    0x803020,%eax
  801fb3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801fb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fbc:	89 d0                	mov    %edx,%eax
  801fbe:	01 c0                	add    %eax,%eax
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	c1 e0 03             	shl    $0x3,%eax
  801fc5:	01 c8                	add    %ecx,%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fd4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	01 c8                	add    %ecx,%eax
  801fe5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fe7:	39 c2                	cmp    %eax,%edx
  801fe9:	75 09                	jne    801ff4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801feb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ff2:	eb 15                	jmp    802009 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ff4:	ff 45 e8             	incl   -0x18(%ebp)
  801ff7:	a1 20 30 80 00       	mov    0x803020,%eax
  801ffc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802005:	39 c2                	cmp    %eax,%edx
  802007:	77 85                	ja     801f8e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802009:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80200d:	75 14                	jne    802023 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	68 34 2e 80 00       	push   $0x802e34
  802017:	6a 3a                	push   $0x3a
  802019:	68 28 2e 80 00       	push   $0x802e28
  80201e:	e8 88 fe ff ff       	call   801eab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802023:	ff 45 f0             	incl   -0x10(%ebp)
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80202c:	0f 8c 2f ff ff ff    	jl     801f61 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802032:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802039:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802040:	eb 26                	jmp    802068 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802042:	a1 20 30 80 00       	mov    0x803020,%eax
  802047:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80204d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802050:	89 d0                	mov    %edx,%eax
  802052:	01 c0                	add    %eax,%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	c1 e0 03             	shl    $0x3,%eax
  802059:	01 c8                	add    %ecx,%eax
  80205b:	8a 40 04             	mov    0x4(%eax),%al
  80205e:	3c 01                	cmp    $0x1,%al
  802060:	75 03                	jne    802065 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802062:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802065:	ff 45 e0             	incl   -0x20(%ebp)
  802068:	a1 20 30 80 00       	mov    0x803020,%eax
  80206d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	77 c8                	ja     802042 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802080:	74 14                	je     802096 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	68 88 2e 80 00       	push   $0x802e88
  80208a:	6a 44                	push   $0x44
  80208c:	68 28 2e 80 00       	push   $0x802e28
  802091:	e8 15 fe ff ff       	call   801eab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    
  802099:	66 90                	xchg   %ax,%ax
  80209b:	90                   	nop

0080209c <__udivdi3>:
  80209c:	55                   	push   %ebp
  80209d:	57                   	push   %edi
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	83 ec 1c             	sub    $0x1c,%esp
  8020a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020b3:	89 ca                	mov    %ecx,%edx
  8020b5:	89 f8                	mov    %edi,%eax
  8020b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020bb:	85 f6                	test   %esi,%esi
  8020bd:	75 2d                	jne    8020ec <__udivdi3+0x50>
  8020bf:	39 cf                	cmp    %ecx,%edi
  8020c1:	77 65                	ja     802128 <__udivdi3+0x8c>
  8020c3:	89 fd                	mov    %edi,%ebp
  8020c5:	85 ff                	test   %edi,%edi
  8020c7:	75 0b                	jne    8020d4 <__udivdi3+0x38>
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	31 d2                	xor    %edx,%edx
  8020d0:	f7 f7                	div    %edi
  8020d2:	89 c5                	mov    %eax,%ebp
  8020d4:	31 d2                	xor    %edx,%edx
  8020d6:	89 c8                	mov    %ecx,%eax
  8020d8:	f7 f5                	div    %ebp
  8020da:	89 c1                	mov    %eax,%ecx
  8020dc:	89 d8                	mov    %ebx,%eax
  8020de:	f7 f5                	div    %ebp
  8020e0:	89 cf                	mov    %ecx,%edi
  8020e2:	89 fa                	mov    %edi,%edx
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	39 ce                	cmp    %ecx,%esi
  8020ee:	77 28                	ja     802118 <__udivdi3+0x7c>
  8020f0:	0f bd fe             	bsr    %esi,%edi
  8020f3:	83 f7 1f             	xor    $0x1f,%edi
  8020f6:	75 40                	jne    802138 <__udivdi3+0x9c>
  8020f8:	39 ce                	cmp    %ecx,%esi
  8020fa:	72 0a                	jb     802106 <__udivdi3+0x6a>
  8020fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802100:	0f 87 9e 00 00 00    	ja     8021a4 <__udivdi3+0x108>
  802106:	b8 01 00 00 00       	mov    $0x1,%eax
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	83 c4 1c             	add    $0x1c,%esp
  802110:	5b                   	pop    %ebx
  802111:	5e                   	pop    %esi
  802112:	5f                   	pop    %edi
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    
  802115:	8d 76 00             	lea    0x0(%esi),%esi
  802118:	31 ff                	xor    %edi,%edi
  80211a:	31 c0                	xor    %eax,%eax
  80211c:	89 fa                	mov    %edi,%edx
  80211e:	83 c4 1c             	add    $0x1c,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    
  802126:	66 90                	xchg   %ax,%ax
  802128:	89 d8                	mov    %ebx,%eax
  80212a:	f7 f7                	div    %edi
  80212c:	31 ff                	xor    %edi,%edi
  80212e:	89 fa                	mov    %edi,%edx
  802130:	83 c4 1c             	add    $0x1c,%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    
  802138:	bd 20 00 00 00       	mov    $0x20,%ebp
  80213d:	89 eb                	mov    %ebp,%ebx
  80213f:	29 fb                	sub    %edi,%ebx
  802141:	89 f9                	mov    %edi,%ecx
  802143:	d3 e6                	shl    %cl,%esi
  802145:	89 c5                	mov    %eax,%ebp
  802147:	88 d9                	mov    %bl,%cl
  802149:	d3 ed                	shr    %cl,%ebp
  80214b:	89 e9                	mov    %ebp,%ecx
  80214d:	09 f1                	or     %esi,%ecx
  80214f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802153:	89 f9                	mov    %edi,%ecx
  802155:	d3 e0                	shl    %cl,%eax
  802157:	89 c5                	mov    %eax,%ebp
  802159:	89 d6                	mov    %edx,%esi
  80215b:	88 d9                	mov    %bl,%cl
  80215d:	d3 ee                	shr    %cl,%esi
  80215f:	89 f9                	mov    %edi,%ecx
  802161:	d3 e2                	shl    %cl,%edx
  802163:	8b 44 24 08          	mov    0x8(%esp),%eax
  802167:	88 d9                	mov    %bl,%cl
  802169:	d3 e8                	shr    %cl,%eax
  80216b:	09 c2                	or     %eax,%edx
  80216d:	89 d0                	mov    %edx,%eax
  80216f:	89 f2                	mov    %esi,%edx
  802171:	f7 74 24 0c          	divl   0xc(%esp)
  802175:	89 d6                	mov    %edx,%esi
  802177:	89 c3                	mov    %eax,%ebx
  802179:	f7 e5                	mul    %ebp
  80217b:	39 d6                	cmp    %edx,%esi
  80217d:	72 19                	jb     802198 <__udivdi3+0xfc>
  80217f:	74 0b                	je     80218c <__udivdi3+0xf0>
  802181:	89 d8                	mov    %ebx,%eax
  802183:	31 ff                	xor    %edi,%edi
  802185:	e9 58 ff ff ff       	jmp    8020e2 <__udivdi3+0x46>
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802190:	89 f9                	mov    %edi,%ecx
  802192:	d3 e2                	shl    %cl,%edx
  802194:	39 c2                	cmp    %eax,%edx
  802196:	73 e9                	jae    802181 <__udivdi3+0xe5>
  802198:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80219b:	31 ff                	xor    %edi,%edi
  80219d:	e9 40 ff ff ff       	jmp    8020e2 <__udivdi3+0x46>
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	31 c0                	xor    %eax,%eax
  8021a6:	e9 37 ff ff ff       	jmp    8020e2 <__udivdi3+0x46>
  8021ab:	90                   	nop

008021ac <__umoddi3>:
  8021ac:	55                   	push   %ebp
  8021ad:	57                   	push   %edi
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	83 ec 1c             	sub    $0x1c,%esp
  8021b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021cb:	89 f3                	mov    %esi,%ebx
  8021cd:	89 fa                	mov    %edi,%edx
  8021cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021d3:	89 34 24             	mov    %esi,(%esp)
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 1a                	jne    8021f4 <__umoddi3+0x48>
  8021da:	39 f7                	cmp    %esi,%edi
  8021dc:	0f 86 a2 00 00 00    	jbe    802284 <__umoddi3+0xd8>
  8021e2:	89 c8                	mov    %ecx,%eax
  8021e4:	89 f2                	mov    %esi,%edx
  8021e6:	f7 f7                	div    %edi
  8021e8:	89 d0                	mov    %edx,%eax
  8021ea:	31 d2                	xor    %edx,%edx
  8021ec:	83 c4 1c             	add    $0x1c,%esp
  8021ef:	5b                   	pop    %ebx
  8021f0:	5e                   	pop    %esi
  8021f1:	5f                   	pop    %edi
  8021f2:	5d                   	pop    %ebp
  8021f3:	c3                   	ret    
  8021f4:	39 f0                	cmp    %esi,%eax
  8021f6:	0f 87 ac 00 00 00    	ja     8022a8 <__umoddi3+0xfc>
  8021fc:	0f bd e8             	bsr    %eax,%ebp
  8021ff:	83 f5 1f             	xor    $0x1f,%ebp
  802202:	0f 84 ac 00 00 00    	je     8022b4 <__umoddi3+0x108>
  802208:	bf 20 00 00 00       	mov    $0x20,%edi
  80220d:	29 ef                	sub    %ebp,%edi
  80220f:	89 fe                	mov    %edi,%esi
  802211:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802215:	89 e9                	mov    %ebp,%ecx
  802217:	d3 e0                	shl    %cl,%eax
  802219:	89 d7                	mov    %edx,%edi
  80221b:	89 f1                	mov    %esi,%ecx
  80221d:	d3 ef                	shr    %cl,%edi
  80221f:	09 c7                	or     %eax,%edi
  802221:	89 e9                	mov    %ebp,%ecx
  802223:	d3 e2                	shl    %cl,%edx
  802225:	89 14 24             	mov    %edx,(%esp)
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	d3 e0                	shl    %cl,%eax
  80222c:	89 c2                	mov    %eax,%edx
  80222e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802232:	d3 e0                	shl    %cl,%eax
  802234:	89 44 24 04          	mov    %eax,0x4(%esp)
  802238:	8b 44 24 08          	mov    0x8(%esp),%eax
  80223c:	89 f1                	mov    %esi,%ecx
  80223e:	d3 e8                	shr    %cl,%eax
  802240:	09 d0                	or     %edx,%eax
  802242:	d3 eb                	shr    %cl,%ebx
  802244:	89 da                	mov    %ebx,%edx
  802246:	f7 f7                	div    %edi
  802248:	89 d3                	mov    %edx,%ebx
  80224a:	f7 24 24             	mull   (%esp)
  80224d:	89 c6                	mov    %eax,%esi
  80224f:	89 d1                	mov    %edx,%ecx
  802251:	39 d3                	cmp    %edx,%ebx
  802253:	0f 82 87 00 00 00    	jb     8022e0 <__umoddi3+0x134>
  802259:	0f 84 91 00 00 00    	je     8022f0 <__umoddi3+0x144>
  80225f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802263:	29 f2                	sub    %esi,%edx
  802265:	19 cb                	sbb    %ecx,%ebx
  802267:	89 d8                	mov    %ebx,%eax
  802269:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80226d:	d3 e0                	shl    %cl,%eax
  80226f:	89 e9                	mov    %ebp,%ecx
  802271:	d3 ea                	shr    %cl,%edx
  802273:	09 d0                	or     %edx,%eax
  802275:	89 e9                	mov    %ebp,%ecx
  802277:	d3 eb                	shr    %cl,%ebx
  802279:	89 da                	mov    %ebx,%edx
  80227b:	83 c4 1c             	add    $0x1c,%esp
  80227e:	5b                   	pop    %ebx
  80227f:	5e                   	pop    %esi
  802280:	5f                   	pop    %edi
  802281:	5d                   	pop    %ebp
  802282:	c3                   	ret    
  802283:	90                   	nop
  802284:	89 fd                	mov    %edi,%ebp
  802286:	85 ff                	test   %edi,%edi
  802288:	75 0b                	jne    802295 <__umoddi3+0xe9>
  80228a:	b8 01 00 00 00       	mov    $0x1,%eax
  80228f:	31 d2                	xor    %edx,%edx
  802291:	f7 f7                	div    %edi
  802293:	89 c5                	mov    %eax,%ebp
  802295:	89 f0                	mov    %esi,%eax
  802297:	31 d2                	xor    %edx,%edx
  802299:	f7 f5                	div    %ebp
  80229b:	89 c8                	mov    %ecx,%eax
  80229d:	f7 f5                	div    %ebp
  80229f:	89 d0                	mov    %edx,%eax
  8022a1:	e9 44 ff ff ff       	jmp    8021ea <__umoddi3+0x3e>
  8022a6:	66 90                	xchg   %ax,%ax
  8022a8:	89 c8                	mov    %ecx,%eax
  8022aa:	89 f2                	mov    %esi,%edx
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	3b 04 24             	cmp    (%esp),%eax
  8022b7:	72 06                	jb     8022bf <__umoddi3+0x113>
  8022b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022bd:	77 0f                	ja     8022ce <__umoddi3+0x122>
  8022bf:	89 f2                	mov    %esi,%edx
  8022c1:	29 f9                	sub    %edi,%ecx
  8022c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022c7:	89 14 24             	mov    %edx,(%esp)
  8022ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022d2:	8b 14 24             	mov    (%esp),%edx
  8022d5:	83 c4 1c             	add    $0x1c,%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    
  8022dd:	8d 76 00             	lea    0x0(%esi),%esi
  8022e0:	2b 04 24             	sub    (%esp),%eax
  8022e3:	19 fa                	sbb    %edi,%edx
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	e9 71 ff ff ff       	jmp    80225f <__umoddi3+0xb3>
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022f4:	72 ea                	jb     8022e0 <__umoddi3+0x134>
  8022f6:	89 d9                	mov    %ebx,%ecx
  8022f8:	e9 62 ff ff ff       	jmp    80225f <__umoddi3+0xb3>

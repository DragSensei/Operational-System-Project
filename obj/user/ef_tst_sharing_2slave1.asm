
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 58 02 00 00       	call   80028e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 5e 1a 00 00       	call   801aa9 <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80004e:	e8 c4 17 00 00       	call   801817 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800053:	e8 6f 18 00 00       	call   8018c7 <sys_calculate_free_frames>
  800058:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	68 00 21 80 00       	push   $0x802100
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	e8 df 16 00 00       	call   80174a <sget>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  800071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  800077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80007d:	74 1a                	je     800099 <_main+0x61>
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	ff 75 e8             	pushl  -0x18(%ebp)
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 04 21 80 00       	push   $0x802104
  80008d:	6a 20                	push   $0x20
  80008f:	68 7f 21 80 00       	push   $0x80217f
  800094:	e8 a5 03 00 00       	call   80043e <_panic>
		expected = 1 ; /*1table*/
  800099:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000a0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000a3:	e8 1f 18 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000a8:	29 c3                	sub    %eax,%ebx
  8000aa:	89 d8                	mov    %ebx,%eax
  8000ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000b5:	74 24                	je     8000db <_main+0xa3>
  8000b7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ba:	e8 08 18 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000bf:	29 c3                	sub    %eax,%ebx
  8000c1:	89 d8                	mov    %ebx,%eax
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c9:	50                   	push   %eax
  8000ca:	68 a0 21 80 00       	push   $0x8021a0
  8000cf:	6a 23                	push   $0x23
  8000d1:	68 7f 21 80 00       	push   $0x80217f
  8000d6:	e8 63 03 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  8000db:	e8 51 17 00 00       	call   801831 <sys_unlock_cons>
	//sys_unlock_cons();

	sys_lock_cons();
  8000e0:	e8 32 17 00 00       	call   801817 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8000e5:	e8 dd 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 38 22 80 00       	push   $0x802238
  8000f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f8:	e8 4d 16 00 00       	call   80174a <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800106:	05 00 10 00 00       	add    $0x1000,%eax
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80010e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800111:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800114:	74 1a                	je     800130 <_main+0xf8>
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	ff 75 d8             	pushl  -0x28(%ebp)
  80011c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011f:	68 04 21 80 00       	push   $0x802104
  800124:	6a 2d                	push   $0x2d
  800126:	68 7f 21 80 00       	push   $0x80217f
  80012b:	e8 0e 03 00 00       	call   80043e <_panic>
		expected = 0 ;
  800130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800137:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013a:	e8 88 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800149:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80014c:	74 24                	je     800172 <_main+0x13a>
  80014e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800151:	e8 71 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  800156:	29 c3                	sub    %eax,%ebx
  800158:	89 d8                	mov    %ebx,%eax
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 e0             	pushl  -0x20(%ebp)
  800160:	50                   	push   %eax
  800161:	68 a0 21 80 00       	push   $0x8021a0
  800166:	6a 30                	push   $0x30
  800168:	68 7f 21 80 00       	push   $0x80217f
  80016d:	e8 cc 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800172:	e8 ba 16 00 00       	call   801831 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 3c 22 80 00       	push   $0x80223c
  800189:	6a 35                	push   $0x35
  80018b:	68 7f 21 80 00       	push   $0x80217f
  800190:	e8 a9 02 00 00       	call   80043e <_panic>

	sys_lock_cons();
  800195:	e8 7d 16 00 00       	call   801817 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 28 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  80019f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 73 22 80 00       	push   $0x802273
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 98 15 00 00       	call   80174a <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001bb:	05 00 20 00 00       	add    $0x2000,%eax
  8001c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001c9:	74 1a                	je     8001e5 <_main+0x1ad>
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d4:	68 04 21 80 00       	push   $0x802104
  8001d9:	6a 3c                	push   $0x3c
  8001db:	68 7f 21 80 00       	push   $0x80217f
  8001e0:	e8 59 02 00 00       	call   80043e <_panic>
		expected = 0 ;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001ec:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ef:	e8 d3 16 00 00       	call   8018c7 <sys_calculate_free_frames>
  8001f4:	29 c3                	sub    %eax,%ebx
  8001f6:	89 d8                	mov    %ebx,%eax
  8001f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8001fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800201:	74 24                	je     800227 <_main+0x1ef>
  800203:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800206:	e8 bc 16 00 00       	call   8018c7 <sys_calculate_free_frames>
  80020b:	29 c3                	sub    %eax,%ebx
  80020d:	89 d8                	mov    %ebx,%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	50                   	push   %eax
  800216:	68 a0 21 80 00       	push   $0x8021a0
  80021b:	6a 3f                	push   $0x3f
  80021d:	68 7f 21 80 00       	push   $0x80217f
  800222:	e8 17 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800227:	e8 05 16 00 00       	call   801831 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80022c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	83 f8 0a             	cmp    $0xa,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 3c 22 80 00       	push   $0x80223c
  80023e:	6a 44                	push   $0x44
  800240:	68 7f 21 80 00       	push   $0x80217f
  800245:	e8 f4 01 00 00       	call   80043e <_panic>

	sys_lock_cons();
  80024a:	e8 c8 15 00 00       	call   801817 <sys_lock_cons>
	{
		*z = *x + *y ;
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	8b 10                	mov    (%eax),%edx
  800254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800257:	8b 00                	mov    (%eax),%eax
  800259:	01 c2                	add    %eax,%edx
  80025b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025e:	89 10                	mov    %edx,(%eax)
	}
	sys_unlock_cons();
  800260:	e8 cc 15 00 00       	call   801831 <sys_unlock_cons>

	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	83 f8 1e             	cmp    $0x1e,%eax
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 3c 22 80 00       	push   $0x80223c
  800277:	6a 4c                	push   $0x4c
  800279:	68 7f 21 80 00       	push   $0x80217f
  80027e:	e8 bb 01 00 00       	call   80043e <_panic>

	//To indicate that it's completed successfully
	inctst();
  800283:	e8 46 19 00 00       	call   801bce <inctst>

	return;
  800288:	90                   	nop
}
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800297:	e8 f4 17 00 00       	call   801a90 <sys_getenvindex>
  80029c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 d0                	mov    %edx,%eax
  8002a4:	c1 e0 02             	shl    $0x2,%eax
  8002a7:	01 d0                	add    %edx,%eax
  8002a9:	c1 e0 03             	shl    $0x3,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 02             	shl    $0x2,%eax
  8002ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c9:	8a 40 20             	mov    0x20(%eax),%al
  8002cc:	84 c0                	test   %al,%al
  8002ce:	74 0d                	je     8002dd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d5:	83 c0 20             	add    $0x20,%eax
  8002d8:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e1:	7e 0a                	jle    8002ed <libmain+0x5f>
		binaryname = argv[0];
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	e8 3d fd ff ff       	call   800038 <_main>
  8002fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800303:	85 c0                	test   %eax,%eax
  800305:	0f 84 01 01 00 00    	je     80040c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800311:	bb 70 23 80 00       	mov    $0x802370,%ebx
  800316:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	89 de                	mov    %ebx,%esi
  80031f:	89 d1                	mov    %edx,%ecx
  800321:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800323:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800326:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032b:	b0 00                	mov    $0x0,%al
  80032d:	89 d7                	mov    %edx,%edi
  80032f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800331:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800338:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	e8 7b 19 00 00       	call   801cc6 <sys_utilities>
  80034b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80034e:	e8 c4 14 00 00       	call   801817 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	68 90 22 80 00       	push   $0x802290
  80035b:	e8 ac 03 00 00       	call   80070c <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800366:	85 c0                	test   %eax,%eax
  800368:	74 18                	je     800382 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036a:	e8 75 19 00 00       	call   801ce4 <sys_get_optimal_num_faults>
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	50                   	push   %eax
  800373:	68 b8 22 80 00       	push   $0x8022b8
  800378:	e8 8f 03 00 00       	call   80070c <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	eb 59                	jmp    8003db <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800382:	a1 20 30 80 00       	mov    0x803020,%eax
  800387:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80038d:	a1 20 30 80 00       	mov    0x803020,%eax
  800392:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	68 dc 22 80 00       	push   $0x8022dc
  8003a2:	e8 65 03 00 00       	call   80070c <cprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003af:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ba:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c5:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003cb:	51                   	push   %ecx
  8003cc:	52                   	push   %edx
  8003cd:	50                   	push   %eax
  8003ce:	68 04 23 80 00       	push   $0x802304
  8003d3:	e8 34 03 00 00       	call   80070c <cprintf>
  8003d8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	50                   	push   %eax
  8003ea:	68 5c 23 80 00       	push   $0x80235c
  8003ef:	e8 18 03 00 00       	call   80070c <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 90 22 80 00       	push   $0x802290
  8003ff:	e8 08 03 00 00       	call   80070c <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800407:	e8 25 14 00 00       	call   801831 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040c:	e8 1f 00 00 00       	call   800430 <exit>
}
  800411:	90                   	nop
  800412:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800415:	5b                   	pop    %ebx
  800416:	5e                   	pop    %esi
  800417:	5f                   	pop    %edi
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    

0080041a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	6a 00                	push   $0x0
  800425:	e8 32 16 00 00       	call   801a5c <sys_destroy_env>
  80042a:	83 c4 10             	add    $0x10,%esp
}
  80042d:	90                   	nop
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <exit>:

void
exit(void)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800436:	e8 87 16 00 00       	call   801ac2 <sys_exit_env>
}
  80043b:	90                   	nop
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800444:	8d 45 10             	lea    0x10(%ebp),%eax
  800447:	83 c0 04             	add    $0x4,%eax
  80044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80044d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 16                	je     80046c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800456:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	50                   	push   %eax
  80045f:	68 d4 23 80 00       	push   $0x8023d4
  800464:	e8 a3 02 00 00       	call   80070c <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046c:	a1 04 30 80 00       	mov    0x803004,%eax
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 08             	pushl  0x8(%ebp)
  80047a:	50                   	push   %eax
  80047b:	68 dc 23 80 00       	push   $0x8023dc
  800480:	6a 74                	push   $0x74
  800482:	e8 b2 02 00 00       	call   800739 <cprintf_colored>
  800487:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 04 02 00 00       	call   80069d <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	6a 00                	push   $0x0
  8004a1:	68 04 24 80 00       	push   $0x802404
  8004a6:	e8 f2 01 00 00       	call   80069d <vcprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ae:	e8 7d ff ff ff       	call   800430 <exit>

	// should not return here
	while (1) ;
  8004b3:	eb fe                	jmp    8004b3 <_panic+0x75>

008004b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	74 14                	je     8004e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004cd:	83 ec 04             	sub    $0x4,%esp
  8004d0:	68 08 24 80 00       	push   $0x802408
  8004d5:	6a 26                	push   $0x26
  8004d7:	68 54 24 80 00       	push   $0x802454
  8004dc:	e8 5d ff ff ff       	call   80043e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	e9 c5 00 00 00       	jmp    8005b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	85 c0                	test   %eax,%eax
  800507:	75 08                	jne    800511 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800509:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050c:	e9 a5 00 00 00       	jmp    8005b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80051f:	eb 69                	jmp    80058a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800521:	a1 20 30 80 00       	mov    0x803020,%eax
  800526:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80052c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	01 c0                	add    %eax,%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	c1 e0 03             	shl    $0x3,%eax
  800538:	01 c8                	add    %ecx,%eax
  80053a:	8a 40 04             	mov    0x4(%eax),%al
  80053d:	84 c0                	test   %al,%al
  80053f:	75 46                	jne    800587 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800541:	a1 20 30 80 00       	mov    0x803020,%eax
  800546:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80054c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	01 c0                	add    %eax,%eax
  800553:	01 d0                	add    %edx,%eax
  800555:	c1 e0 03             	shl    $0x3,%eax
  800558:	01 c8                	add    %ecx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80055f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800567:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057a:	39 c2                	cmp    %eax,%edx
  80057c:	75 09                	jne    800587 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80057e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800585:	eb 15                	jmp    80059c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800587:	ff 45 e8             	incl   -0x18(%ebp)
  80058a:	a1 20 30 80 00       	mov    0x803020,%eax
  80058f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	77 85                	ja     800521 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80059c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005a0:	75 14                	jne    8005b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005a2:	83 ec 04             	sub    $0x4,%esp
  8005a5:	68 60 24 80 00       	push   $0x802460
  8005aa:	6a 3a                	push   $0x3a
  8005ac:	68 54 24 80 00       	push   $0x802454
  8005b1:	e8 88 fe ff ff       	call   80043e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005b6:	ff 45 f0             	incl   -0x10(%ebp)
  8005b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005bf:	0f 8c 2f ff ff ff    	jl     8004f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005d3:	eb 26                	jmp    8005fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005da:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	01 c0                	add    %eax,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	c1 e0 03             	shl    $0x3,%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8a 40 04             	mov    0x4(%eax),%al
  8005f1:	3c 01                	cmp    $0x1,%al
  8005f3:	75 03                	jne    8005f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f8:	ff 45 e0             	incl   -0x20(%ebp)
  8005fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800600:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	39 c2                	cmp    %eax,%edx
  80060b:	77 c8                	ja     8005d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80060d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800610:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800613:	74 14                	je     800629 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	68 b4 24 80 00       	push   $0x8024b4
  80061d:	6a 44                	push   $0x44
  80061f:	68 54 24 80 00       	push   $0x802454
  800624:	e8 15 fe ff ff       	call   80043e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800629:	90                   	nop
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	53                   	push   %ebx
  800630:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	8d 48 01             	lea    0x1(%eax),%ecx
  80063b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063e:	89 0a                	mov    %ecx,(%edx)
  800640:	8b 55 08             	mov    0x8(%ebp),%edx
  800643:	88 d1                	mov    %dl,%cl
  800645:	8b 55 0c             	mov    0xc(%ebp),%edx
  800648:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	3d ff 00 00 00       	cmp    $0xff,%eax
  800656:	75 30                	jne    800688 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800658:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80065e:	a0 44 30 80 00       	mov    0x803044,%al
  800663:	0f b6 c0             	movzbl %al,%eax
  800666:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800669:	8b 09                	mov    (%ecx),%ecx
  80066b:	89 cb                	mov    %ecx,%ebx
  80066d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800670:	83 c1 08             	add    $0x8,%ecx
  800673:	52                   	push   %edx
  800674:	50                   	push   %eax
  800675:	53                   	push   %ebx
  800676:	51                   	push   %ecx
  800677:	e8 57 11 00 00       	call   8017d3 <sys_cputs>
  80067c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 40 04             	mov    0x4(%eax),%eax
  80068e:	8d 50 01             	lea    0x1(%eax),%edx
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	89 50 04             	mov    %edx,0x4(%eax)
}
  800697:	90                   	nop
  800698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ad:	00 00 00 
	b.cnt = 0;
  8006b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 08             	pushl  0x8(%ebp)
  8006c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c6:	50                   	push   %eax
  8006c7:	68 2c 06 80 00       	push   $0x80062c
  8006cc:	e8 5a 02 00 00       	call   80092b <vprintfmt>
  8006d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006d4:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006da:	a0 44 30 80 00       	mov    0x803044,%al
  8006df:	0f b6 c0             	movzbl %al,%eax
  8006e2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006e8:	52                   	push   %edx
  8006e9:	50                   	push   %eax
  8006ea:	51                   	push   %ecx
  8006eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f1:	83 c0 08             	add    $0x8,%eax
  8006f4:	50                   	push   %eax
  8006f5:	e8 d9 10 00 00       	call   8017d3 <sys_cputs>
  8006fa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006fd:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800704:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80070a:	c9                   	leave  
  80070b:	c3                   	ret    

0080070c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800712:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800719:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 f4             	pushl  -0xc(%ebp)
  800728:	50                   	push   %eax
  800729:	e8 6f ff ff ff       	call   80069d <vcprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
  80073c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	c1 e0 08             	shl    $0x8,%eax
  80074c:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800751:	8d 45 0c             	lea    0xc(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 34 ff ff ff       	call   80069d <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80076f:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800776:	07 00 00 

	return cnt;
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077c:	c9                   	leave  
  80077d:	c3                   	ret    

0080077e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800784:	e8 8e 10 00 00       	call   801817 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800789:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 ff fe ff ff       	call   80069d <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007a4:	e8 88 10 00 00       	call   801831 <sys_unlock_cons>
	return cnt;
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	53                   	push   %ebx
  8007b2:	83 ec 14             	sub    $0x14,%esp
  8007b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cc:	77 55                	ja     800823 <printnum+0x75>
  8007ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d1:	72 05                	jb     8007d8 <printnum+0x2a>
  8007d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d6:	77 4b                	ja     800823 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007de:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e6:	52                   	push   %edx
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ee:	e8 a9 16 00 00       	call   801e9c <__udivdi3>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	ff 75 20             	pushl  0x20(%ebp)
  8007fc:	53                   	push   %ebx
  8007fd:	ff 75 18             	pushl  0x18(%ebp)
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 08             	pushl  0x8(%ebp)
  800808:	e8 a1 ff ff ff       	call   8007ae <printnum>
  80080d:	83 c4 20             	add    $0x20,%esp
  800810:	eb 1a                	jmp    80082c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 20             	pushl  0x20(%ebp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	ff d0                	call   *%eax
  800820:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800823:	ff 4d 1c             	decl   0x1c(%ebp)
  800826:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80082a:	7f e6                	jg     800812 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80082c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083a:	53                   	push   %ebx
  80083b:	51                   	push   %ecx
  80083c:	52                   	push   %edx
  80083d:	50                   	push   %eax
  80083e:	e8 69 17 00 00       	call   801fac <__umoddi3>
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	05 14 27 80 00       	add    $0x802714,%eax
  80084b:	8a 00                	mov    (%eax),%al
  80084d:	0f be c0             	movsbl %al,%eax
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	50                   	push   %eax
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
}
  80085f:	90                   	nop
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800868:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086c:	7e 1c                	jle    80088a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	8d 50 08             	lea    0x8(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	89 10                	mov    %edx,(%eax)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	83 e8 08             	sub    $0x8,%eax
  800883:	8b 50 04             	mov    0x4(%eax),%edx
  800886:	8b 00                	mov    (%eax),%eax
  800888:	eb 40                	jmp    8008ca <getuint+0x65>
	else if (lflag)
  80088a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088e:	74 1e                	je     8008ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	8d 50 04             	lea    0x4(%eax),%edx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	89 10                	mov    %edx,(%eax)
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	83 e8 04             	sub    $0x4,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	eb 1c                	jmp    8008ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d3:	7e 1c                	jle    8008f1 <getint+0x25>
		return va_arg(*ap, long long);
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	8d 50 08             	lea    0x8(%eax),%edx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	89 10                	mov    %edx,(%eax)
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	83 e8 08             	sub    $0x8,%eax
  8008ea:	8b 50 04             	mov    0x4(%eax),%edx
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	eb 38                	jmp    800929 <getint+0x5d>
	else if (lflag)
  8008f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f5:	74 1a                	je     800911 <getint+0x45>
		return va_arg(*ap, long);
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	8d 50 04             	lea    0x4(%eax),%edx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 10                	mov    %edx,(%eax)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	99                   	cltd   
  80090f:	eb 18                	jmp    800929 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	8d 50 04             	lea    0x4(%eax),%edx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	89 10                	mov    %edx,(%eax)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	83 e8 04             	sub    $0x4,%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	99                   	cltd   
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
  800930:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	eb 17                	jmp    80094c <vprintfmt+0x21>
			if (ch == '\0')
  800935:	85 db                	test   %ebx,%ebx
  800937:	0f 84 c1 03 00 00    	je     800cfe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	53                   	push   %ebx
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094c:	8b 45 10             	mov    0x10(%ebp),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	89 55 10             	mov    %edx,0x10(%ebp)
  800955:	8a 00                	mov    (%eax),%al
  800957:	0f b6 d8             	movzbl %al,%ebx
  80095a:	83 fb 25             	cmp    $0x25,%ebx
  80095d:	75 d6                	jne    800935 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800963:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80096a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800971:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800978:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097f:	8b 45 10             	mov    0x10(%ebp),%eax
  800982:	8d 50 01             	lea    0x1(%eax),%edx
  800985:	89 55 10             	mov    %edx,0x10(%ebp)
  800988:	8a 00                	mov    (%eax),%al
  80098a:	0f b6 d8             	movzbl %al,%ebx
  80098d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800990:	83 f8 5b             	cmp    $0x5b,%eax
  800993:	0f 87 3d 03 00 00    	ja     800cd6 <vprintfmt+0x3ab>
  800999:	8b 04 85 38 27 80 00 	mov    0x802738(,%eax,4),%eax
  8009a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a6:	eb d7                	jmp    80097f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ac:	eb d1                	jmp    80097f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	c1 e0 02             	shl    $0x2,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	01 c0                	add    %eax,%eax
  8009c1:	01 d8                	add    %ebx,%eax
  8009c3:	83 e8 30             	sub    $0x30,%eax
  8009c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d4:	7e 3e                	jle    800a14 <vprintfmt+0xe9>
  8009d6:	83 fb 39             	cmp    $0x39,%ebx
  8009d9:	7f 39                	jg     800a14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009de:	eb d5                	jmp    8009b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	83 c0 04             	add    $0x4,%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 e8 04             	sub    $0x4,%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f4:	eb 1f                	jmp    800a15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	79 83                	jns    80097f <vprintfmt+0x54>
				width = 0;
  8009fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a03:	e9 77 ff ff ff       	jmp    80097f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0f:	e9 6b ff ff ff       	jmp    80097f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a19:	0f 89 60 ff ff ff    	jns    80097f <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a2c:	e9 4e ff ff ff       	jmp    80097f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a34:	e9 46 ff ff ff       	jmp    80097f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
			break;
  800a59:	e9 9b 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	83 c0 04             	add    $0x4,%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	83 e8 04             	sub    $0x4,%eax
  800a6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6f:	85 db                	test   %ebx,%ebx
  800a71:	79 02                	jns    800a75 <vprintfmt+0x14a>
				err = -err;
  800a73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a75:	83 fb 64             	cmp    $0x64,%ebx
  800a78:	7f 0b                	jg     800a85 <vprintfmt+0x15a>
  800a7a:	8b 34 9d 80 25 80 00 	mov    0x802580(,%ebx,4),%esi
  800a81:	85 f6                	test   %esi,%esi
  800a83:	75 19                	jne    800a9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a85:	53                   	push   %ebx
  800a86:	68 25 27 80 00       	push   $0x802725
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 70 02 00 00       	call   800d06 <printfmt>
  800a96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a99:	e9 5b 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9e:	56                   	push   %esi
  800a9f:	68 2e 27 80 00       	push   $0x80272e
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	e8 57 02 00 00       	call   800d06 <printfmt>
  800aaf:	83 c4 10             	add    $0x10,%esp
			break;
  800ab2:	e9 42 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 30                	mov    (%eax),%esi
  800ac8:	85 f6                	test   %esi,%esi
  800aca:	75 05                	jne    800ad1 <vprintfmt+0x1a6>
				p = "(null)";
  800acc:	be 31 27 80 00       	mov    $0x802731,%esi
			if (width > 0 && padc != '-')
  800ad1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad5:	7e 6d                	jle    800b44 <vprintfmt+0x219>
  800ad7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800adb:	74 67                	je     800b44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	50                   	push   %eax
  800ae4:	56                   	push   %esi
  800ae5:	e8 1e 03 00 00       	call   800e08 <strnlen>
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800af0:	eb 16                	jmp    800b08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800af2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b05:	ff 4d e4             	decl   -0x1c(%ebp)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	7f e4                	jg     800af2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0e:	eb 34                	jmp    800b44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b14:	74 1c                	je     800b32 <vprintfmt+0x207>
  800b16:	83 fb 1f             	cmp    $0x1f,%ebx
  800b19:	7e 05                	jle    800b20 <vprintfmt+0x1f5>
  800b1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1e:	7e 12                	jle    800b32 <vprintfmt+0x207>
					putch('?', putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	6a 3f                	push   $0x3f
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	eb 0f                	jmp    800b41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	53                   	push   %ebx
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b41:	ff 4d e4             	decl   -0x1c(%ebp)
  800b44:	89 f0                	mov    %esi,%eax
  800b46:	8d 70 01             	lea    0x1(%eax),%esi
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be d8             	movsbl %al,%ebx
  800b4e:	85 db                	test   %ebx,%ebx
  800b50:	74 24                	je     800b76 <vprintfmt+0x24b>
  800b52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b56:	78 b8                	js     800b10 <vprintfmt+0x1e5>
  800b58:	ff 4d e0             	decl   -0x20(%ebp)
  800b5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5f:	79 af                	jns    800b10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b61:	eb 13                	jmp    800b76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 20                	push   $0x20
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b73:	ff 4d e4             	decl   -0x1c(%ebp)
  800b76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7a:	7f e7                	jg     800b63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b7c:	e9 78 01 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 e8             	pushl  -0x18(%ebp)
  800b87:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8a:	50                   	push   %eax
  800b8b:	e8 3c fd ff ff       	call   8008cc <getint>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9f:	85 d2                	test   %edx,%edx
  800ba1:	79 23                	jns    800bc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	6a 2d                	push   $0x2d
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	ff d0                	call   *%eax
  800bb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb9:	f7 d8                	neg    %eax
  800bbb:	83 d2 00             	adc    $0x0,%edx
  800bbe:	f7 da                	neg    %edx
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bcd:	e9 bc 00 00 00       	jmp    800c8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 84 fc ff ff       	call   800865 <getuint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 98 00 00 00       	jmp    800c8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 58                	push   $0x58
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	6a 58                	push   $0x58
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 58                	push   $0x58
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			break;
  800c26:	e9 ce 00 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 30                	push   $0x30
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 78                	push   $0x78
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	83 c0 04             	add    $0x4,%eax
  800c51:	89 45 14             	mov    %eax,0x14(%ebp)
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	83 e8 04             	sub    $0x4,%eax
  800c5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c6d:	eb 1f                	jmp    800c8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 e8             	pushl  -0x18(%ebp)
  800c75:	8d 45 14             	lea    0x14(%ebp),%eax
  800c78:	50                   	push   %eax
  800c79:	e8 e7 fb ff ff       	call   800865 <getuint>
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c95:	83 ec 04             	sub    $0x4,%esp
  800c98:	52                   	push   %edx
  800c99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c9c:	50                   	push   %eax
  800c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	e8 00 fb ff ff       	call   8007ae <printnum>
  800cae:	83 c4 20             	add    $0x20,%esp
			break;
  800cb1:	eb 46                	jmp    800cf9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	53                   	push   %ebx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
			break;
  800cc2:	eb 35                	jmp    800cf9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cc4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ccb:	eb 2c                	jmp    800cf9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ccd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cd4:	eb 23                	jmp    800cf9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	6a 25                	push   $0x25
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce6:	ff 4d 10             	decl   0x10(%ebp)
  800ce9:	eb 03                	jmp    800cee <vprintfmt+0x3c3>
  800ceb:	ff 4d 10             	decl   0x10(%ebp)
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	48                   	dec    %eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 25                	cmp    $0x25,%al
  800cf6:	75 f3                	jne    800ceb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cf8:	90                   	nop
		}
	}
  800cf9:	e9 35 fc ff ff       	jmp    800933 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 04 fc ff ff       	call   80092b <vprintfmt>
  800d27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d2a:	90                   	nop
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8b 40 08             	mov    0x8(%eax),%eax
  800d36:	8d 50 01             	lea    0x1(%eax),%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8b 10                	mov    (%eax),%edx
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8b 40 04             	mov    0x4(%eax),%eax
  800d4a:	39 c2                	cmp    %eax,%edx
  800d4c:	73 12                	jae    800d60 <sprintputch+0x33>
		*b->buf++ = ch;
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	8d 48 01             	lea    0x1(%eax),%ecx
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	89 0a                	mov    %ecx,(%edx)
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	88 10                	mov    %dl,(%eax)
}
  800d60:	90                   	nop
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	01 d0                	add    %edx,%eax
  800d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d88:	74 06                	je     800d90 <vsnprintf+0x2d>
  800d8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8e:	7f 07                	jg     800d97 <vsnprintf+0x34>
		return -E_INVAL;
  800d90:	b8 03 00 00 00       	mov    $0x3,%eax
  800d95:	eb 20                	jmp    800db7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d97:	ff 75 14             	pushl  0x14(%ebp)
  800d9a:	ff 75 10             	pushl  0x10(%ebp)
  800d9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	68 2d 0d 80 00       	push   $0x800d2d
  800da6:	e8 80 fb ff ff       	call   80092b <vprintfmt>
  800dab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc2:	83 c0 04             	add    $0x4,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	ff 75 08             	pushl  0x8(%ebp)
  800dd5:	e8 89 ff ff ff       	call   800d63 <vsnprintf>
  800dda:	83 c4 10             	add    $0x10,%esp
  800ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df2:	eb 06                	jmp    800dfa <strlen+0x15>
		n++;
  800df4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	84 c0                	test   %al,%al
  800e01:	75 f1                	jne    800df4 <strlen+0xf>
		n++;
	return n;
  800e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e15:	eb 09                	jmp    800e20 <strnlen+0x18>
		n++;
  800e17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	ff 4d 0c             	decl   0xc(%ebp)
  800e20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e24:	74 09                	je     800e2f <strnlen+0x27>
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e8                	jne    800e17 <strnlen+0xf>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e40:	90                   	nop
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8d 50 01             	lea    0x1(%eax),%edx
  800e47:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e53:	8a 12                	mov    (%edx),%dl
  800e55:	88 10                	mov    %dl,(%eax)
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	84 c0                	test   %al,%al
  800e5b:	75 e4                	jne    800e41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e75:	eb 1f                	jmp    800e96 <strncpy+0x34>
		*dst++ = *src;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8d 50 01             	lea    0x1(%eax),%edx
  800e7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	74 03                	je     800e93 <strncpy+0x31>
			src++;
  800e90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e93:	ff 45 fc             	incl   -0x4(%ebp)
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9c:	72 d9                	jb     800e77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	74 30                	je     800ee5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb5:	eb 16                	jmp    800ecd <strlcpy+0x2a>
			*dst++ = *src++;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec9:	8a 12                	mov    (%edx),%dl
  800ecb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ecd:	ff 4d 10             	decl   0x10(%ebp)
  800ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed4:	74 09                	je     800edf <strlcpy+0x3c>
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	75 d8                	jne    800eb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	29 c2                	sub    %eax,%edx
  800eed:	89 d0                	mov    %edx,%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef4:	eb 06                	jmp    800efc <strcmp+0xb>
		p++, q++;
  800ef6:	ff 45 08             	incl   0x8(%ebp)
  800ef9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	74 0e                	je     800f13 <strcmp+0x22>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 10                	mov    (%eax),%dl
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	38 c2                	cmp    %al,%dl
  800f11:	74 e3                	je     800ef6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 d0             	movzbl %al,%edx
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	0f b6 c0             	movzbl %al,%eax
  800f23:	29 c2                	sub    %eax,%edx
  800f25:	89 d0                	mov    %edx,%eax
}
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f2c:	eb 09                	jmp    800f37 <strncmp+0xe>
		n--, p++, q++;
  800f2e:	ff 4d 10             	decl   0x10(%ebp)
  800f31:	ff 45 08             	incl   0x8(%ebp)
  800f34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	74 17                	je     800f54 <strncmp+0x2b>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	84 c0                	test   %al,%al
  800f44:	74 0e                	je     800f54 <strncmp+0x2b>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 da                	je     800f2e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	75 07                	jne    800f61 <strncmp+0x38>
		return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5f:	eb 14                	jmp    800f75 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 d0             	movzbl %al,%edx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	0f b6 c0             	movzbl %al,%eax
  800f71:	29 c2                	sub    %eax,%edx
  800f73:	89 d0                	mov    %edx,%eax
}
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f83:	eb 12                	jmp    800f97 <strchr+0x20>
		if (*s == c)
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8d:	75 05                	jne    800f94 <strchr+0x1d>
			return (char *) s;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	eb 11                	jmp    800fa5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	75 e5                	jne    800f85 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 04             	sub    $0x4,%esp
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb3:	eb 0d                	jmp    800fc2 <strfind+0x1b>
		if (*s == c)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fbd:	74 0e                	je     800fcd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	75 ea                	jne    800fb5 <strfind+0xe>
  800fcb:	eb 01                	jmp    800fce <strfind+0x27>
		if (*s == c)
			break;
  800fcd:	90                   	nop
	return (char *) s;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fdf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fe3:	76 63                	jbe    801048 <memset+0x75>
		uint64 data_block = c;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	99                   	cltd   
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ff9:	c1 e0 08             	shl    $0x8,%eax
  800ffc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80100c:	c1 e0 10             	shl    $0x10,%eax
  80100f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801012:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	89 c2                	mov    %eax,%edx
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
  801022:	09 45 f0             	or     %eax,-0x10(%ebp)
  801025:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801028:	eb 18                	jmp    801042 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80102a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102d:	8d 41 08             	lea    0x8(%ecx),%eax
  801030:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	89 01                	mov    %eax,(%ecx)
  80103b:	89 51 04             	mov    %edx,0x4(%ecx)
  80103e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801042:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801046:	77 e2                	ja     80102a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104c:	74 23                	je     801071 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801054:	eb 0e                	jmp    801064 <memset+0x91>
			*p8++ = (uint8)c;
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801062:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106a:	89 55 10             	mov    %edx,0x10(%ebp)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	75 e5                	jne    801056 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801088:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108c:	76 24                	jbe    8010b2 <memcpy+0x3c>
		while(n >= 8){
  80108e:	eb 1c                	jmp    8010ac <memcpy+0x36>
			*d64 = *s64;
  801090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801093:	8b 50 04             	mov    0x4(%eax),%edx
  801096:	8b 00                	mov    (%eax),%eax
  801098:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80109b:	89 01                	mov    %eax,(%ecx)
  80109d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010a0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010a4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010a8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b0:	77 de                	ja     801090 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b6:	74 31                	je     8010e9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010c4:	eb 16                	jmp    8010dc <memcpy+0x66>
			*d8++ = *s8++;
  8010c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010d8:	8a 12                	mov    (%edx),%dl
  8010da:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 dd                	jne    8010c6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801103:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801106:	73 50                	jae    801158 <memmove+0x6a>
  801108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801113:	76 43                	jbe    801158 <memmove+0x6a>
		s += n;
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801121:	eb 10                	jmp    801133 <memmove+0x45>
			*--d = *--s;
  801123:	ff 4d f8             	decl   -0x8(%ebp)
  801126:	ff 4d fc             	decl   -0x4(%ebp)
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 10                	mov    (%eax),%dl
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 e3                	jne    801123 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801140:	eb 23                	jmp    801165 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	8d 50 01             	lea    0x1(%eax),%edx
  801148:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801151:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801154:	8a 12                	mov    (%edx),%dl
  801156:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115e:	89 55 10             	mov    %edx,0x10(%ebp)
  801161:	85 c0                	test   %eax,%eax
  801163:	75 dd                	jne    801142 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80117c:	eb 2a                	jmp    8011a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	38 c2                	cmp    %al,%dl
  80118a:	74 16                	je     8011a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 d0             	movzbl %al,%edx
  801194:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	eb 18                	jmp    8011ba <memcmp+0x50>
		s1++, s2++;
  8011a2:	ff 45 fc             	incl   -0x4(%ebp)
  8011a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	75 c9                	jne    80117e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011cd:	eb 15                	jmp    8011e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 d0             	movzbl %al,%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	39 c2                	cmp    %eax,%edx
  8011df:	74 0d                	je     8011ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ea:	72 e3                	jb     8011cf <memfind+0x13>
  8011ec:	eb 01                	jmp    8011ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ee:	90                   	nop
	return (void *) s;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801201:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801208:	eb 03                	jmp    80120d <strtol+0x19>
		s++;
  80120a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 20                	cmp    $0x20,%al
  801214:	74 f4                	je     80120a <strtol+0x16>
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 09                	cmp    $0x9,%al
  80121d:	74 eb                	je     80120a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2b                	cmp    $0x2b,%al
  801226:	75 05                	jne    80122d <strtol+0x39>
		s++;
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	eb 13                	jmp    801240 <strtol+0x4c>
	else if (*s == '-')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 2d                	cmp    $0x2d,%al
  801234:	75 0a                	jne    801240 <strtol+0x4c>
		s++, neg = 1;
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	74 06                	je     80124c <strtol+0x58>
  801246:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124a:	75 20                	jne    80126c <strtol+0x78>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 30                	cmp    $0x30,%al
  801253:	75 17                	jne    80126c <strtol+0x78>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	40                   	inc    %eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 78                	cmp    $0x78,%al
  80125d:	75 0d                	jne    80126c <strtol+0x78>
		s += 2, base = 16;
  80125f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801263:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126a:	eb 28                	jmp    801294 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80126c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801270:	75 15                	jne    801287 <strtol+0x93>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 30                	cmp    $0x30,%al
  801279:	75 0c                	jne    801287 <strtol+0x93>
		s++, base = 8;
  80127b:	ff 45 08             	incl   0x8(%ebp)
  80127e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801285:	eb 0d                	jmp    801294 <strtol+0xa0>
	else if (base == 0)
  801287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128b:	75 07                	jne    801294 <strtol+0xa0>
		base = 10;
  80128d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 2f                	cmp    $0x2f,%al
  80129b:	7e 19                	jle    8012b6 <strtol+0xc2>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 39                	cmp    $0x39,%al
  8012a4:	7f 10                	jg     8012b6 <strtol+0xc2>
			dig = *s - '0';
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 30             	sub    $0x30,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b4:	eb 42                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 60                	cmp    $0x60,%al
  8012bd:	7e 19                	jle    8012d8 <strtol+0xe4>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 7a                	cmp    $0x7a,%al
  8012c6:	7f 10                	jg     8012d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	0f be c0             	movsbl %al,%eax
  8012d0:	83 e8 57             	sub    $0x57,%eax
  8012d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d6:	eb 20                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 40                	cmp    $0x40,%al
  8012df:	7e 39                	jle    80131a <strtol+0x126>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 5a                	cmp    $0x5a,%al
  8012e8:	7f 30                	jg     80131a <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	83 e8 37             	sub    $0x37,%eax
  8012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012fe:	7d 19                	jge    801319 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801300:	ff 45 08             	incl   0x8(%ebp)
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801314:	e9 7b ff ff ff       	jmp    801294 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801319:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131e:	74 08                	je     801328 <strtol+0x134>
		*endptr = (char *) s;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	8b 55 08             	mov    0x8(%ebp),%edx
  801326:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132c:	74 07                	je     801335 <strtol+0x141>
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801331:	f7 d8                	neg    %eax
  801333:	eb 03                	jmp    801338 <strtol+0x144>
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <ltostr>:

void
ltostr(long value, char *str)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801347:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80134e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801352:	79 13                	jns    801367 <ltostr+0x2d>
	{
		neg = 1;
  801354:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801361:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801364:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80136f:	99                   	cltd   
  801370:	f7 f9                	idiv   %ecx
  801372:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	8d 50 01             	lea    0x1(%eax),%edx
  80137b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137e:	89 c2                	mov    %eax,%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801388:	83 c2 30             	add    $0x30,%edx
  80138b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801395:	f7 e9                	imul   %ecx
  801397:	c1 fa 02             	sar    $0x2,%edx
  80139a:	89 c8                	mov    %ecx,%eax
  80139c:	c1 f8 1f             	sar    $0x1f,%eax
  80139f:	29 c2                	sub    %eax,%edx
  8013a1:	89 d0                	mov    %edx,%eax
  8013a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013aa:	75 bb                	jne    801367 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	48                   	dec    %eax
  8013b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013be:	74 3d                	je     8013fd <ltostr+0xc3>
		start = 1 ;
  8013c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c7:	eb 34                	jmp    8013fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801400:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801403:	7c c4                	jl     8013c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801405:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801410:	90                   	nop
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	e8 c4 f9 ff ff       	call   800de5 <strlen>
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	e8 b6 f9 ff ff       	call   800de5 <strlen>
  80142f:	83 c4 04             	add    $0x4,%esp
  801432:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 17                	jmp    80145c <strcconcat+0x49>
		final[s] = str1[s] ;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 c2                	add    %eax,%edx
  80144d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	01 c8                	add    %ecx,%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801459:	ff 45 fc             	incl   -0x4(%ebp)
  80145c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801462:	7c e1                	jl     801445 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801464:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801472:	eb 1f                	jmp    801493 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	01 c2                	add    %eax,%edx
  801484:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	01 c8                	add    %ecx,%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801490:	ff 45 f8             	incl   -0x8(%ebp)
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801499:	7c d9                	jl     801474 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cc:	eb 0c                	jmp    8014da <strsplit+0x31>
			*string++ = 0;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8d 50 01             	lea    0x1(%eax),%edx
  8014d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 18                	je     8014fb <strsplit+0x52>
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	50                   	push   %eax
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	e8 83 fa ff ff       	call   800f77 <strchr>
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	75 d3                	jne    8014ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	84 c0                	test   %al,%al
  801502:	74 5a                	je     80155e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	83 f8 0f             	cmp    $0xf,%eax
  80150c:	75 07                	jne    801515 <strsplit+0x6c>
		{
			return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	eb 66                	jmp    80157b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	8d 48 01             	lea    0x1(%eax),%ecx
  80151d:	8b 55 14             	mov    0x14(%ebp),%edx
  801520:	89 0a                	mov    %ecx,(%edx)
  801522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	01 c2                	add    %eax,%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801533:	eb 03                	jmp    801538 <strsplit+0x8f>
			string++;
  801535:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 8b                	je     8014cc <strsplit+0x23>
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 25 fa ff ff       	call   800f77 <strchr>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	74 dc                	je     801535 <strsplit+0x8c>
			string++;
	}
  801559:	e9 6e ff ff ff       	jmp    8014cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80155f:	8b 45 14             	mov    0x14(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156b:	8b 45 10             	mov    0x10(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801576:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801589:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801590:	eb 4a                	jmp    8015dc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801592:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	01 c2                	add    %eax,%edx
  80159a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	01 c8                	add    %ecx,%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	01 d0                	add    %edx,%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 40                	cmp    $0x40,%al
  8015b2:	7e 25                	jle    8015d9 <str2lower+0x5c>
  8015b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 5a                	cmp    $0x5a,%al
  8015c0:	7f 17                	jg     8015d9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	01 d0                	add    %edx,%eax
  8015ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d0:	01 ca                	add    %ecx,%edx
  8015d2:	8a 12                	mov    (%edx),%dl
  8015d4:	83 c2 20             	add    $0x20,%edx
  8015d7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015d9:	ff 45 fc             	incl   -0x4(%ebp)
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	e8 01 f8 ff ff       	call   800de5 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ea:	7f a6                	jg     801592 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015f7:	a1 08 30 80 00       	mov    0x803008,%eax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 42                	je     801642 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	68 00 00 00 82       	push   $0x82000000
  801608:	68 00 00 00 80       	push   $0x80000000
  80160d:	e8 8c 07 00 00       	call   801d9e <initialize_dynamic_allocator>
  801612:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801615:	e8 e7 05 00 00       	call   801c01 <sys_get_uheap_strategy>
  80161a:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80161f:	a1 40 30 80 00       	mov    0x803040,%eax
  801624:	05 00 10 00 00       	add    $0x1000,%eax
  801629:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  80162e:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801633:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801638:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80163f:	00 00 00 
	}
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	68 06 04 00 00       	push   $0x406
  801661:	50                   	push   %eax
  801662:	e8 e4 01 00 00       	call   80184b <__sys_allocate_page>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80166d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801671:	79 14                	jns    801687 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 a8 28 80 00       	push   $0x8028a8
  80167b:	6a 1f                	push   $0x1f
  80167d:	68 e4 28 80 00       	push   $0x8028e4
  801682:	e8 b7 ed ff ff       	call   80043e <_panic>
	return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	50                   	push   %eax
  8016a6:	e8 e7 01 00 00       	call   801892 <__sys_unmap_frame>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b5:	79 14                	jns    8016cb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 f0 28 80 00       	push   $0x8028f0
  8016bf:	6a 2a                	push   $0x2a
  8016c1:	68 e4 28 80 00       	push   $0x8028e4
  8016c6:	e8 73 ed ff ff       	call   80043e <_panic>
}
  8016cb:	90                   	nop
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016d4:	e8 18 ff ff ff       	call   8015f1 <uheap_init>
	if (size == 0) return NULL ;
  8016d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016dd:	75 07                	jne    8016e6 <malloc+0x18>
  8016df:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e4:	eb 14                	jmp    8016fa <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016e6:	83 ec 04             	sub    $0x4,%esp
  8016e9:	68 30 29 80 00       	push   $0x802930
  8016ee:	6a 3e                	push   $0x3e
  8016f0:	68 e4 28 80 00       	push   $0x8028e4
  8016f5:	e8 44 ed ff ff       	call   80043e <_panic>
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 58 29 80 00       	push   $0x802958
  80170a:	6a 49                	push   $0x49
  80170c:	68 e4 28 80 00       	push   $0x8028e4
  801711:	e8 28 ed ff ff       	call   80043e <_panic>

00801716 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 18             	sub    $0x18,%esp
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801722:	e8 ca fe ff ff       	call   8015f1 <uheap_init>
	if (size == 0) return NULL ;
  801727:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172b:	75 07                	jne    801734 <smalloc+0x1e>
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	eb 14                	jmp    801748 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 7c 29 80 00       	push   $0x80297c
  80173c:	6a 5a                	push   $0x5a
  80173e:	68 e4 28 80 00       	push   $0x8028e4
  801743:	e8 f6 ec ff ff       	call   80043e <_panic>
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801750:	e8 9c fe ff ff       	call   8015f1 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	68 a4 29 80 00       	push   $0x8029a4
  80175d:	6a 6a                	push   $0x6a
  80175f:	68 e4 28 80 00       	push   $0x8028e4
  801764:	e8 d5 ec ff ff       	call   80043e <_panic>

00801769 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80176f:	e8 7d fe ff ff       	call   8015f1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	68 c8 29 80 00       	push   $0x8029c8
  80177c:	68 88 00 00 00       	push   $0x88
  801781:	68 e4 28 80 00       	push   $0x8028e4
  801786:	e8 b3 ec ff ff       	call   80043e <_panic>

0080178b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 f0 29 80 00       	push   $0x8029f0
  801799:	68 9b 00 00 00       	push   $0x9b
  80179e:	68 e4 28 80 00       	push   $0x8028e4
  8017a3:	e8 96 ec ff ff       	call   80043e <_panic>

008017a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	57                   	push   %edi
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017c3:	cd 30                	int    $0x30
  8017c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	5b                   	pop    %ebx
  8017cf:	5e                   	pop    %esi
  8017d0:	5f                   	pop    %edi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8017df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	51                   	push   %ecx
  8017ec:	52                   	push   %edx
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	50                   	push   %eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	e8 b0 ff ff ff       	call   8017a8 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	90                   	nop
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 02                	push   $0x2
  80180d:	e8 96 ff ff ff       	call   8017a8 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 03                	push   $0x3
  801826:	e8 7d ff ff ff       	call   8017a8 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 04                	push   $0x4
  801840:	e8 63 ff ff ff       	call   8017a8 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	52                   	push   %edx
  80185b:	50                   	push   %eax
  80185c:	6a 08                	push   $0x8
  80185e:	e8 45 ff ff ff       	call   8017a8 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	56                   	push   %esi
  80186c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186d:	8b 75 18             	mov    0x18(%ebp),%esi
  801870:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801873:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	56                   	push   %esi
  80187d:	53                   	push   %ebx
  80187e:	51                   	push   %ecx
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	6a 09                	push   $0x9
  801883:	e8 20 ff ff ff       	call   8017a8 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	6a 0a                	push   $0xa
  8018a2:	e8 01 ff ff ff       	call   8017a8 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	6a 0b                	push   $0xb
  8018bd:	e8 e6 fe ff ff       	call   8017a8 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 0c                	push   $0xc
  8018d6:	e8 cd fe ff ff       	call   8017a8 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 0d                	push   $0xd
  8018ef:	e8 b4 fe ff ff       	call   8017a8 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0e                	push   $0xe
  801908:	e8 9b fe ff ff       	call   8017a8 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 0f                	push   $0xf
  801921:	e8 82 fe ff ff       	call   8017a8 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 10                	push   $0x10
  80193b:	e8 68 fe ff ff       	call   8017a8 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 11                	push   $0x11
  801954:	e8 4f fe ff ff       	call   8017a8 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_cputc>:

void
sys_cputc(const char c)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80196b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	50                   	push   %eax
  801978:	6a 01                	push   $0x1
  80197a:	e8 29 fe ff ff       	call   8017a8 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	90                   	nop
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 14                	push   $0x14
  801994:	e8 0f fe ff ff       	call   8017a8 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	51                   	push   %ecx
  8019b8:	52                   	push   %edx
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	50                   	push   %eax
  8019bd:	6a 15                	push   $0x15
  8019bf:	e8 e4 fd ff ff       	call   8017a8 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	52                   	push   %edx
  8019d9:	50                   	push   %eax
  8019da:	6a 16                	push   $0x16
  8019dc:	e8 c7 fd ff ff       	call   8017a8 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	51                   	push   %ecx
  8019f7:	52                   	push   %edx
  8019f8:	50                   	push   %eax
  8019f9:	6a 17                	push   $0x17
  8019fb:	e8 a8 fd ff ff       	call   8017a8 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	6a 18                	push   $0x18
  801a18:	e8 8b fd ff ff       	call   8017a8 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 14             	pushl  0x14(%ebp)
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	6a 19                	push   $0x19
  801a36:	e8 6d fd ff ff       	call   8017a8 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	50                   	push   %eax
  801a4f:	6a 1a                	push   $0x1a
  801a51:	e8 52 fd ff ff       	call   8017a8 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	50                   	push   %eax
  801a6b:	6a 1b                	push   $0x1b
  801a6d:	e8 36 fd ff ff       	call   8017a8 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 05                	push   $0x5
  801a86:	e8 1d fd ff ff       	call   8017a8 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 06                	push   $0x6
  801a9f:	e8 04 fd ff ff       	call   8017a8 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 07                	push   $0x7
  801ab8:	e8 eb fc ff ff       	call   8017a8 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 1c                	push   $0x1c
  801ad1:	e8 d2 fc ff ff       	call   8017a8 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ae2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae5:	8d 50 04             	lea    0x4(%eax),%edx
  801ae8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 1d                	push   $0x1d
  801af5:	e8 ae fc ff ff       	call   8017a8 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return result;
  801afd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b06:	89 01                	mov    %eax,(%ecx)
  801b08:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	c9                   	leave  
  801b0f:	c2 04 00             	ret    $0x4

00801b12 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 10             	pushl  0x10(%ebp)
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 13                	push   $0x13
  801b24:	e8 7f fc ff ff       	call   8017a8 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2c:	90                   	nop
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 1e                	push   $0x1e
  801b3e:	e8 65 fc ff ff       	call   8017a8 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b54:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	50                   	push   %eax
  801b61:	6a 1f                	push   $0x1f
  801b63:	e8 40 fc ff ff       	call   8017a8 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <rsttst>:
void rsttst()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 21                	push   $0x21
  801b7d:	e8 26 fc ff ff       	call   8017a8 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 04             	sub    $0x4,%esp
  801b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b94:	8b 55 18             	mov    0x18(%ebp),%edx
  801b97:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 20                	push   $0x20
  801ba8:	e8 fb fb ff ff       	call   8017a8 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <chktst>:
void chktst(uint32 n)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	6a 22                	push   $0x22
  801bc3:	e8 e0 fb ff ff       	call   8017a8 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <inctst>:

void inctst()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 23                	push   $0x23
  801bdd:	e8 c6 fb ff ff       	call   8017a8 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return ;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <gettst>:
uint32 gettst()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 24                	push   $0x24
  801bf7:	e8 ac fb ff ff       	call   8017a8 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 25                	push   $0x25
  801c10:	e8 93 fb ff ff       	call   8017a8 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
  801c18:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c1d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 26                	push   $0x26
  801c3c:	e8 67 fb ff ff       	call   8017a8 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	53                   	push   %ebx
  801c5a:	51                   	push   %ecx
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 27                	push   $0x27
  801c5f:	e8 44 fb ff ff       	call   8017a8 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 28                	push   $0x28
  801c7f:	e8 24 fb ff ff       	call   8017a8 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c8c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	51                   	push   %ecx
  801c98:	ff 75 10             	pushl  0x10(%ebp)
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 29                	push   $0x29
  801c9f:	e8 04 fb ff ff       	call   8017a8 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	6a 12                	push   $0x12
  801cbb:	e8 e8 fa ff ff       	call   8017a8 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	6a 2a                	push   $0x2a
  801cd9:	e8 ca fa ff ff       	call   8017a8 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
	return;
  801ce1:	90                   	nop
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 2b                	push   $0x2b
  801cf3:	e8 b0 fa ff ff       	call   8017a8 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 2d                	push   $0x2d
  801d0e:	e8 95 fa ff ff       	call   8017a8 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	6a 2c                	push   $0x2c
  801d2a:	e8 79 fa ff ff       	call   8017a8 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	68 14 2a 80 00       	push   $0x802a14
  801d43:	68 25 01 00 00       	push   $0x125
  801d48:	68 47 2a 80 00       	push   $0x802a47
  801d4d:	e8 ec e6 ff ff       	call   80043e <_panic>

00801d52 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d60:	29 d0                	sub    %edx,%eax
  801d62:	c1 f8 02             	sar    $0x2,%eax
  801d65:	89 c2                	mov    %eax,%edx
  801d67:	89 d0                	mov    %edx,%eax
  801d69:	c1 e0 02             	shl    $0x2,%eax
  801d6c:	01 d0                	add    %edx,%eax
  801d6e:	c1 e0 02             	shl    $0x2,%eax
  801d71:	01 d0                	add    %edx,%eax
  801d73:	c1 e0 02             	shl    $0x2,%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	89 c1                	mov    %eax,%ecx
  801d7a:	c1 e1 08             	shl    $0x8,%ecx
  801d7d:	01 c8                	add    %ecx,%eax
  801d7f:	89 c1                	mov    %eax,%ecx
  801d81:	c1 e1 10             	shl    $0x10,%ecx
  801d84:	01 c8                	add    %ecx,%eax
  801d86:	01 c0                	add    %eax,%eax
  801d88:	01 d0                	add    %edx,%eax
  801d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d90:	c1 e0 0c             	shl    $0xc,%eax
  801d93:	89 c2                	mov    %eax,%edx
  801d95:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d9a:	01 d0                	add    %edx,%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	05 00 00 00 02       	add    $0x2000000,%eax
  801dac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801daf:	73 16                	jae    801dc7 <initialize_dynamic_allocator+0x29>
  801db1:	68 58 2a 80 00       	push   $0x802a58
  801db6:	68 7e 2a 80 00       	push   $0x802a7e
  801dbb:	6a 26                	push   $0x26
  801dbd:	68 93 2a 80 00       	push   $0x802a93
  801dc2:	e8 77 e6 ff ff       	call   80043e <_panic>
		is_initialized = 1;
  801dc7:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801dce:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	68 ac 2a 80 00       	push   $0x802aac
  801dd9:	6a 2e                	push   $0x2e
  801ddb:	68 93 2a 80 00       	push   $0x802a93
  801de0:	e8 59 e6 ff ff       	call   80043e <_panic>

00801de5 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801deb:	83 ec 04             	sub    $0x4,%esp
  801dee:	68 e0 2a 80 00       	push   $0x802ae0
  801df3:	6a 3a                	push   $0x3a
  801df5:	68 93 2a 80 00       	push   $0x802a93
  801dfa:	e8 3f e6 ff ff       	call   80043e <_panic>

00801dff <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e05:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e0c:	76 16                	jbe    801e24 <alloc_block+0x25>
  801e0e:	68 08 2b 80 00       	push   $0x802b08
  801e13:	68 7e 2a 80 00       	push   $0x802a7e
  801e18:	6a 46                	push   $0x46
  801e1a:	68 93 2a 80 00       	push   $0x802a93
  801e1f:	e8 1a e6 ff ff       	call   80043e <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	68 2c 2b 80 00       	push   $0x802b2c
  801e2c:	6a 4d                	push   $0x4d
  801e2e:	68 93 2a 80 00       	push   $0x802a93
  801e33:	e8 06 e6 ff ff       	call   80043e <_panic>

00801e38 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e41:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e46:	39 c2                	cmp    %eax,%edx
  801e48:	72 0c                	jb     801e56 <free_block+0x1e>
  801e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e4d:	a1 40 30 80 00       	mov    0x803040,%eax
  801e52:	39 c2                	cmp    %eax,%edx
  801e54:	72 16                	jb     801e6c <free_block+0x34>
  801e56:	68 50 2b 80 00       	push   $0x802b50
  801e5b:	68 7e 2a 80 00       	push   $0x802a7e
  801e60:	6a 5b                	push   $0x5b
  801e62:	68 93 2a 80 00       	push   $0x802a93
  801e67:	e8 d2 e5 ff ff       	call   80043e <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 88 2b 80 00       	push   $0x802b88
  801e74:	6a 63                	push   $0x63
  801e76:	68 93 2a 80 00       	push   $0x802a93
  801e7b:	e8 be e5 ff ff       	call   80043e <_panic>

00801e80 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	68 ac 2b 80 00       	push   $0x802bac
  801e8e:	6a 72                	push   $0x72
  801e90:	68 93 2a 80 00       	push   $0x802a93
  801e95:	e8 a4 e5 ff ff       	call   80043e <_panic>
  801e9a:	66 90                	xchg   %ax,%ax

00801e9c <__udivdi3>:
  801e9c:	55                   	push   %ebp
  801e9d:	57                   	push   %edi
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 1c             	sub    $0x1c,%esp
  801ea3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ea7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eaf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801eb3:	89 ca                	mov    %ecx,%edx
  801eb5:	89 f8                	mov    %edi,%eax
  801eb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ebb:	85 f6                	test   %esi,%esi
  801ebd:	75 2d                	jne    801eec <__udivdi3+0x50>
  801ebf:	39 cf                	cmp    %ecx,%edi
  801ec1:	77 65                	ja     801f28 <__udivdi3+0x8c>
  801ec3:	89 fd                	mov    %edi,%ebp
  801ec5:	85 ff                	test   %edi,%edi
  801ec7:	75 0b                	jne    801ed4 <__udivdi3+0x38>
  801ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ece:	31 d2                	xor    %edx,%edx
  801ed0:	f7 f7                	div    %edi
  801ed2:	89 c5                	mov    %eax,%ebp
  801ed4:	31 d2                	xor    %edx,%edx
  801ed6:	89 c8                	mov    %ecx,%eax
  801ed8:	f7 f5                	div    %ebp
  801eda:	89 c1                	mov    %eax,%ecx
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	f7 f5                	div    %ebp
  801ee0:	89 cf                	mov    %ecx,%edi
  801ee2:	89 fa                	mov    %edi,%edx
  801ee4:	83 c4 1c             	add    $0x1c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
  801eec:	39 ce                	cmp    %ecx,%esi
  801eee:	77 28                	ja     801f18 <__udivdi3+0x7c>
  801ef0:	0f bd fe             	bsr    %esi,%edi
  801ef3:	83 f7 1f             	xor    $0x1f,%edi
  801ef6:	75 40                	jne    801f38 <__udivdi3+0x9c>
  801ef8:	39 ce                	cmp    %ecx,%esi
  801efa:	72 0a                	jb     801f06 <__udivdi3+0x6a>
  801efc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f00:	0f 87 9e 00 00 00    	ja     801fa4 <__udivdi3+0x108>
  801f06:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0b:	89 fa                	mov    %edi,%edx
  801f0d:	83 c4 1c             	add    $0x1c,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
  801f15:	8d 76 00             	lea    0x0(%esi),%esi
  801f18:	31 ff                	xor    %edi,%edi
  801f1a:	31 c0                	xor    %eax,%eax
  801f1c:	89 fa                	mov    %edi,%edx
  801f1e:	83 c4 1c             	add    $0x1c,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	89 d8                	mov    %ebx,%eax
  801f2a:	f7 f7                	div    %edi
  801f2c:	31 ff                	xor    %edi,%edi
  801f2e:	89 fa                	mov    %edi,%edx
  801f30:	83 c4 1c             	add    $0x1c,%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
  801f38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f3d:	89 eb                	mov    %ebp,%ebx
  801f3f:	29 fb                	sub    %edi,%ebx
  801f41:	89 f9                	mov    %edi,%ecx
  801f43:	d3 e6                	shl    %cl,%esi
  801f45:	89 c5                	mov    %eax,%ebp
  801f47:	88 d9                	mov    %bl,%cl
  801f49:	d3 ed                	shr    %cl,%ebp
  801f4b:	89 e9                	mov    %ebp,%ecx
  801f4d:	09 f1                	or     %esi,%ecx
  801f4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f53:	89 f9                	mov    %edi,%ecx
  801f55:	d3 e0                	shl    %cl,%eax
  801f57:	89 c5                	mov    %eax,%ebp
  801f59:	89 d6                	mov    %edx,%esi
  801f5b:	88 d9                	mov    %bl,%cl
  801f5d:	d3 ee                	shr    %cl,%esi
  801f5f:	89 f9                	mov    %edi,%ecx
  801f61:	d3 e2                	shl    %cl,%edx
  801f63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f67:	88 d9                	mov    %bl,%cl
  801f69:	d3 e8                	shr    %cl,%eax
  801f6b:	09 c2                	or     %eax,%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	89 f2                	mov    %esi,%edx
  801f71:	f7 74 24 0c          	divl   0xc(%esp)
  801f75:	89 d6                	mov    %edx,%esi
  801f77:	89 c3                	mov    %eax,%ebx
  801f79:	f7 e5                	mul    %ebp
  801f7b:	39 d6                	cmp    %edx,%esi
  801f7d:	72 19                	jb     801f98 <__udivdi3+0xfc>
  801f7f:	74 0b                	je     801f8c <__udivdi3+0xf0>
  801f81:	89 d8                	mov    %ebx,%eax
  801f83:	31 ff                	xor    %edi,%edi
  801f85:	e9 58 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f90:	89 f9                	mov    %edi,%ecx
  801f92:	d3 e2                	shl    %cl,%edx
  801f94:	39 c2                	cmp    %eax,%edx
  801f96:	73 e9                	jae    801f81 <__udivdi3+0xe5>
  801f98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f9b:	31 ff                	xor    %edi,%edi
  801f9d:	e9 40 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801fa2:	66 90                	xchg   %ax,%ax
  801fa4:	31 c0                	xor    %eax,%eax
  801fa6:	e9 37 ff ff ff       	jmp    801ee2 <__udivdi3+0x46>
  801fab:	90                   	nop

00801fac <__umoddi3>:
  801fac:	55                   	push   %ebp
  801fad:	57                   	push   %edi
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 1c             	sub    $0x1c,%esp
  801fb3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fb7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fcb:	89 f3                	mov    %esi,%ebx
  801fcd:	89 fa                	mov    %edi,%edx
  801fcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd3:	89 34 24             	mov    %esi,(%esp)
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	75 1a                	jne    801ff4 <__umoddi3+0x48>
  801fda:	39 f7                	cmp    %esi,%edi
  801fdc:	0f 86 a2 00 00 00    	jbe    802084 <__umoddi3+0xd8>
  801fe2:	89 c8                	mov    %ecx,%eax
  801fe4:	89 f2                	mov    %esi,%edx
  801fe6:	f7 f7                	div    %edi
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	31 d2                	xor    %edx,%edx
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	39 f0                	cmp    %esi,%eax
  801ff6:	0f 87 ac 00 00 00    	ja     8020a8 <__umoddi3+0xfc>
  801ffc:	0f bd e8             	bsr    %eax,%ebp
  801fff:	83 f5 1f             	xor    $0x1f,%ebp
  802002:	0f 84 ac 00 00 00    	je     8020b4 <__umoddi3+0x108>
  802008:	bf 20 00 00 00       	mov    $0x20,%edi
  80200d:	29 ef                	sub    %ebp,%edi
  80200f:	89 fe                	mov    %edi,%esi
  802011:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802015:	89 e9                	mov    %ebp,%ecx
  802017:	d3 e0                	shl    %cl,%eax
  802019:	89 d7                	mov    %edx,%edi
  80201b:	89 f1                	mov    %esi,%ecx
  80201d:	d3 ef                	shr    %cl,%edi
  80201f:	09 c7                	or     %eax,%edi
  802021:	89 e9                	mov    %ebp,%ecx
  802023:	d3 e2                	shl    %cl,%edx
  802025:	89 14 24             	mov    %edx,(%esp)
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	d3 e0                	shl    %cl,%eax
  80202c:	89 c2                	mov    %eax,%edx
  80202e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802032:	d3 e0                	shl    %cl,%eax
  802034:	89 44 24 04          	mov    %eax,0x4(%esp)
  802038:	8b 44 24 08          	mov    0x8(%esp),%eax
  80203c:	89 f1                	mov    %esi,%ecx
  80203e:	d3 e8                	shr    %cl,%eax
  802040:	09 d0                	or     %edx,%eax
  802042:	d3 eb                	shr    %cl,%ebx
  802044:	89 da                	mov    %ebx,%edx
  802046:	f7 f7                	div    %edi
  802048:	89 d3                	mov    %edx,%ebx
  80204a:	f7 24 24             	mull   (%esp)
  80204d:	89 c6                	mov    %eax,%esi
  80204f:	89 d1                	mov    %edx,%ecx
  802051:	39 d3                	cmp    %edx,%ebx
  802053:	0f 82 87 00 00 00    	jb     8020e0 <__umoddi3+0x134>
  802059:	0f 84 91 00 00 00    	je     8020f0 <__umoddi3+0x144>
  80205f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802063:	29 f2                	sub    %esi,%edx
  802065:	19 cb                	sbb    %ecx,%ebx
  802067:	89 d8                	mov    %ebx,%eax
  802069:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80206d:	d3 e0                	shl    %cl,%eax
  80206f:	89 e9                	mov    %ebp,%ecx
  802071:	d3 ea                	shr    %cl,%edx
  802073:	09 d0                	or     %edx,%eax
  802075:	89 e9                	mov    %ebp,%ecx
  802077:	d3 eb                	shr    %cl,%ebx
  802079:	89 da                	mov    %ebx,%edx
  80207b:	83 c4 1c             	add    $0x1c,%esp
  80207e:	5b                   	pop    %ebx
  80207f:	5e                   	pop    %esi
  802080:	5f                   	pop    %edi
  802081:	5d                   	pop    %ebp
  802082:	c3                   	ret    
  802083:	90                   	nop
  802084:	89 fd                	mov    %edi,%ebp
  802086:	85 ff                	test   %edi,%edi
  802088:	75 0b                	jne    802095 <__umoddi3+0xe9>
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	31 d2                	xor    %edx,%edx
  802091:	f7 f7                	div    %edi
  802093:	89 c5                	mov    %eax,%ebp
  802095:	89 f0                	mov    %esi,%eax
  802097:	31 d2                	xor    %edx,%edx
  802099:	f7 f5                	div    %ebp
  80209b:	89 c8                	mov    %ecx,%eax
  80209d:	f7 f5                	div    %ebp
  80209f:	89 d0                	mov    %edx,%eax
  8020a1:	e9 44 ff ff ff       	jmp    801fea <__umoddi3+0x3e>
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	89 c8                	mov    %ecx,%eax
  8020aa:	89 f2                	mov    %esi,%edx
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5f                   	pop    %edi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
  8020b4:	3b 04 24             	cmp    (%esp),%eax
  8020b7:	72 06                	jb     8020bf <__umoddi3+0x113>
  8020b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020bd:	77 0f                	ja     8020ce <__umoddi3+0x122>
  8020bf:	89 f2                	mov    %esi,%edx
  8020c1:	29 f9                	sub    %edi,%ecx
  8020c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020c7:	89 14 24             	mov    %edx,(%esp)
  8020ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020d2:	8b 14 24             	mov    (%esp),%edx
  8020d5:	83 c4 1c             	add    $0x1c,%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5f                   	pop    %edi
  8020db:	5d                   	pop    %ebp
  8020dc:	c3                   	ret    
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	2b 04 24             	sub    (%esp),%eax
  8020e3:	19 fa                	sbb    %edi,%edx
  8020e5:	89 d1                	mov    %edx,%ecx
  8020e7:	89 c6                	mov    %eax,%esi
  8020e9:	e9 71 ff ff ff       	jmp    80205f <__umoddi3+0xb3>
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020f4:	72 ea                	jb     8020e0 <__umoddi3+0x134>
  8020f6:	89 d9                	mov    %ebx,%ecx
  8020f8:	e9 62 ff ff ff       	jmp    80205f <__umoddi3+0xb3>

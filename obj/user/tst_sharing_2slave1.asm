
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 7c 02 00 00       	call   8002b2 <libmain>
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
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 30 80 00       	mov    0x803020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 30 80 00       	mov    0x803020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 40 21 80 00       	push   $0x802140
  800061:	6a 0d                	push   $0xd
  800063:	68 5c 21 80 00       	push   $0x80215c
  800068:	e8 f5 03 00 00       	call   800462 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800074:	e8 54 1a 00 00       	call   801acd <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 ba 17 00 00       	call   80183b <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 65 18 00 00       	call   8018eb <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 77 21 80 00       	push   $0x802177
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 d5 16 00 00       	call   80176e <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 7c 21 80 00       	push   $0x80217c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 5c 21 80 00       	push   $0x80215c
  8000c2:	e8 9b 03 00 00       	call   800462 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 15 18 00 00       	call   8018eb <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 fe 17 00 00       	call   8018eb <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 f8 21 80 00       	push   $0x8021f8
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 5c 21 80 00       	push   $0x80215c
  800104:	e8 59 03 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 47 17 00 00       	call   801855 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 28 17 00 00       	call   80183b <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 d3 17 00 00       	call   8018eb <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 90 22 80 00       	push   $0x802290
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 43 16 00 00       	call   80176e <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 7c 21 80 00       	push   $0x80217c
  800152:	6a 2f                	push   $0x2f
  800154:	68 5c 21 80 00       	push   $0x80215c
  800159:	e8 04 03 00 00       	call   800462 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 7e 17 00 00       	call   8018eb <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 67 17 00 00       	call   8018eb <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 f8 21 80 00       	push   $0x8021f8
  800194:	6a 32                	push   $0x32
  800196:	68 5c 21 80 00       	push   $0x80215c
  80019b:	e8 c2 02 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 b0 16 00 00       	call   801855 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 94 22 80 00       	push   $0x802294
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 5c 21 80 00       	push   $0x80215c
  8001be:	e8 9f 02 00 00       	call   800462 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 73 16 00 00       	call   80183b <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 1e 17 00 00       	call   8018eb <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 cb 22 80 00       	push   $0x8022cb
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 8e 15 00 00       	call   80176e <sget>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e9:	05 00 20 00 00       	add    $0x2000,%eax
  8001ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001f7:	74 1a                	je     800213 <_main+0x1db>
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	68 7c 21 80 00       	push   $0x80217c
  800207:	6a 3f                	push   $0x3f
  800209:	68 5c 21 80 00       	push   $0x80215c
  80020e:	e8 4f 02 00 00       	call   800462 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 c9 16 00 00       	call   8018eb <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 b2 16 00 00       	call   8018eb <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 f8 21 80 00       	push   $0x8021f8
  800249:	6a 42                	push   $0x42
  80024b:	68 5c 21 80 00       	push   $0x80215c
  800250:	e8 0d 02 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 fb 15 00 00       	call   801855 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 94 22 80 00       	push   $0x802294
  80026c:	6a 47                	push   $0x47
  80026e:	68 5c 21 80 00       	push   $0x80215c
  800273:	e8 ea 01 00 00       	call   800462 <_panic>

	*z = *x + *y ;
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	01 c2                	add    %eax,%edx
  800284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800287:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028c:	8b 00                	mov    (%eax),%eax
  80028e:	83 f8 1e             	cmp    $0x1e,%eax
  800291:	74 14                	je     8002a7 <_main+0x26f>
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	68 94 22 80 00       	push   $0x802294
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 5c 21 80 00       	push   $0x80215c
  8002a2:	e8 bb 01 00 00       	call   800462 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 46 19 00 00       	call   801bf2 <inctst>

	return;
  8002ac:	90                   	nop
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002bb:	e8 f4 17 00 00       	call   801ab4 <sys_getenvindex>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c6:	89 d0                	mov    %edx,%eax
  8002c8:	c1 e0 02             	shl    $0x2,%eax
  8002cb:	01 d0                	add    %edx,%eax
  8002cd:	c1 e0 03             	shl    $0x3,%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c1 e0 02             	shl    $0x2,%eax
  8002de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ed:	8a 40 20             	mov    0x20(%eax),%al
  8002f0:	84 c0                	test   %al,%al
  8002f2:	74 0d                	je     800301 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f9:	83 c0 20             	add    $0x20,%eax
  8002fc:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800305:	7e 0a                	jle    800311 <libmain+0x5f>
		binaryname = argv[0];
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	8b 00                	mov    (%eax),%eax
  80030c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 19 fd ff ff       	call   800038 <_main>
  80031f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800322:	a1 00 30 80 00       	mov    0x803000,%eax
  800327:	85 c0                	test   %eax,%eax
  800329:	0f 84 01 01 00 00    	je     800430 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800335:	bb c8 23 80 00       	mov    $0x8023c8,%ebx
  80033a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033f:	89 c7                	mov    %eax,%edi
  800341:	89 de                	mov    %ebx,%esi
  800343:	89 d1                	mov    %edx,%ecx
  800345:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800347:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80034a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034f:	b0 00                	mov    $0x0,%al
  800351:	89 d7                	mov    %edx,%edi
  800353:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800355:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	50                   	push   %eax
  800363:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	e8 7b 19 00 00       	call   801cea <sys_utilities>
  80036f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800372:	e8 c4 14 00 00       	call   80183b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800377:	83 ec 0c             	sub    $0xc,%esp
  80037a:	68 e8 22 80 00       	push   $0x8022e8
  80037f:	e8 ac 03 00 00       	call   800730 <cprintf>
  800384:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	74 18                	je     8003a6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038e:	e8 75 19 00 00       	call   801d08 <sys_get_optimal_num_faults>
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	50                   	push   %eax
  800397:	68 10 23 80 00       	push   $0x802310
  80039c:	e8 8f 03 00 00       	call   800730 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	eb 59                	jmp    8003ff <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ab:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	52                   	push   %edx
  8003c0:	50                   	push   %eax
  8003c1:	68 34 23 80 00       	push   $0x802334
  8003c6:	e8 65 03 00 00       	call   800730 <cprintf>
  8003cb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e9:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003ef:	51                   	push   %ecx
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 5c 23 80 00       	push   $0x80235c
  8003f7:	e8 34 03 00 00       	call   800730 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	50                   	push   %eax
  80040e:	68 b4 23 80 00       	push   $0x8023b4
  800413:	e8 18 03 00 00       	call   800730 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	68 e8 22 80 00       	push   $0x8022e8
  800423:	e8 08 03 00 00       	call   800730 <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042b:	e8 25 14 00 00       	call   801855 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800430:	e8 1f 00 00 00       	call   800454 <exit>
}
  800435:	90                   	nop
  800436:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800439:	5b                   	pop    %ebx
  80043a:	5e                   	pop    %esi
  80043b:	5f                   	pop    %edi
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800444:	83 ec 0c             	sub    $0xc,%esp
  800447:	6a 00                	push   $0x0
  800449:	e8 32 16 00 00       	call   801a80 <sys_destroy_env>
  80044e:	83 c4 10             	add    $0x10,%esp
}
  800451:	90                   	nop
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <exit>:

void
exit(void)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80045a:	e8 87 16 00 00       	call   801ae6 <sys_exit_env>
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800468:	8d 45 10             	lea    0x10(%ebp),%eax
  80046b:	83 c0 04             	add    $0x4,%eax
  80046e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	85 c0                	test   %eax,%eax
  800478:	74 16                	je     800490 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80047a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	50                   	push   %eax
  800483:	68 2c 24 80 00       	push   $0x80242c
  800488:	e8 a3 02 00 00       	call   800730 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800490:	a1 04 30 80 00       	mov    0x803004,%eax
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	50                   	push   %eax
  80049f:	68 34 24 80 00       	push   $0x802434
  8004a4:	6a 74                	push   $0x74
  8004a6:	e8 b2 02 00 00       	call   80075d <cprintf_colored>
  8004ab:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b7:	50                   	push   %eax
  8004b8:	e8 04 02 00 00       	call   8006c1 <vcprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	6a 00                	push   $0x0
  8004c5:	68 5c 24 80 00       	push   $0x80245c
  8004ca:	e8 f2 01 00 00       	call   8006c1 <vcprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d2:	e8 7d ff ff ff       	call   800454 <exit>

	// should not return here
	while (1) ;
  8004d7:	eb fe                	jmp    8004d7 <_panic+0x75>

008004d9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004df:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	39 c2                	cmp    %eax,%edx
  8004ef:	74 14                	je     800505 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 60 24 80 00       	push   $0x802460
  8004f9:	6a 26                	push   $0x26
  8004fb:	68 ac 24 80 00       	push   $0x8024ac
  800500:	e8 5d ff ff ff       	call   800462 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800513:	e9 c5 00 00 00       	jmp    8005dd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	85 c0                	test   %eax,%eax
  80052b:	75 08                	jne    800535 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80052d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800530:	e9 a5 00 00 00       	jmp    8005da <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800543:	eb 69                	jmp    8005ae <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800545:	a1 20 30 80 00       	mov    0x803020,%eax
  80054a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800550:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800553:	89 d0                	mov    %edx,%eax
  800555:	01 c0                	add    %eax,%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	c1 e0 03             	shl    $0x3,%eax
  80055c:	01 c8                	add    %ecx,%eax
  80055e:	8a 40 04             	mov    0x4(%eax),%al
  800561:	84 c0                	test   %al,%al
  800563:	75 46                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 03             	shl    $0x3,%eax
  80057c:	01 c8                	add    %ecx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 09                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a9:	eb 15                	jmp    8005c0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e8             	incl   -0x18(%ebp)
  8005ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	77 85                	ja     800545 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c4:	75 14                	jne    8005da <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005c6:	83 ec 04             	sub    $0x4,%esp
  8005c9:	68 b8 24 80 00       	push   $0x8024b8
  8005ce:	6a 3a                	push   $0x3a
  8005d0:	68 ac 24 80 00       	push   $0x8024ac
  8005d5:	e8 88 fe ff ff       	call   800462 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005da:	ff 45 f0             	incl   -0x10(%ebp)
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e3:	0f 8c 2f ff ff ff    	jl     800518 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f7:	eb 26                	jmp    80061f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fe:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800604:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800607:	89 d0                	mov    %edx,%eax
  800609:	01 c0                	add    %eax,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	c1 e0 03             	shl    $0x3,%eax
  800610:	01 c8                	add    %ecx,%eax
  800612:	8a 40 04             	mov    0x4(%eax),%al
  800615:	3c 01                	cmp    $0x1,%al
  800617:	75 03                	jne    80061c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800619:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	ff 45 e0             	incl   -0x20(%ebp)
  80061f:	a1 20 30 80 00       	mov    0x803020,%eax
  800624:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80062a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	77 c8                	ja     8005f9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800634:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800637:	74 14                	je     80064d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800639:	83 ec 04             	sub    $0x4,%esp
  80063c:	68 0c 25 80 00       	push   $0x80250c
  800641:	6a 44                	push   $0x44
  800643:	68 ac 24 80 00       	push   $0x8024ac
  800648:	e8 15 fe ff ff       	call   800462 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064d:	90                   	nop
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	53                   	push   %ebx
  800654:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 48 01             	lea    0x1(%eax),%ecx
  80065f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800662:	89 0a                	mov    %ecx,(%edx)
  800664:	8b 55 08             	mov    0x8(%ebp),%edx
  800667:	88 d1                	mov    %dl,%cl
  800669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800670:	8b 45 0c             	mov    0xc(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067a:	75 30                	jne    8006ac <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80067c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800682:	a0 44 30 80 00       	mov    0x803044,%al
  800687:	0f b6 c0             	movzbl %al,%eax
  80068a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068d:	8b 09                	mov    (%ecx),%ecx
  80068f:	89 cb                	mov    %ecx,%ebx
  800691:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800694:	83 c1 08             	add    $0x8,%ecx
  800697:	52                   	push   %edx
  800698:	50                   	push   %eax
  800699:	53                   	push   %ebx
  80069a:	51                   	push   %ecx
  80069b:	e8 57 11 00 00       	call   8017f7 <sys_cputs>
  8006a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 40 04             	mov    0x4(%eax),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006bb:	90                   	nop
  8006bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d1:	00 00 00 
	b.cnt = 0;
  8006d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	ff 75 08             	pushl  0x8(%ebp)
  8006e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	68 50 06 80 00       	push   $0x800650
  8006f0:	e8 5a 02 00 00       	call   80094f <vprintfmt>
  8006f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006fe:	a0 44 30 80 00       	mov    0x803044,%al
  800703:	0f b6 c0             	movzbl %al,%eax
  800706:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80070c:	52                   	push   %edx
  80070d:	50                   	push   %eax
  80070e:	51                   	push   %ecx
  80070f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800715:	83 c0 08             	add    $0x8,%eax
  800718:	50                   	push   %eax
  800719:	e8 d9 10 00 00       	call   8017f7 <sys_cputs>
  80071e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800721:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800728:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800736:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80073d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800740:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 f4             	pushl  -0xc(%ebp)
  80074c:	50                   	push   %eax
  80074d:	e8 6f ff ff ff       	call   8006c1 <vcprintf>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800758:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    

0080075d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800763:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	c1 e0 08             	shl    $0x8,%eax
  800770:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	83 c0 04             	add    $0x4,%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 34 ff ff ff       	call   8006c1 <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800793:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80079a:	07 00 00 

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a8:	e8 8e 10 00 00       	call   80183b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 ff fe ff ff       	call   8006c1 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c8:	e8 88 10 00 00       	call   801855 <sys_unlock_cons>
	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	53                   	push   %ebx
  8007d6:	83 ec 14             	sub    $0x14,%esp
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f0:	77 55                	ja     800847 <printnum+0x75>
  8007f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f5:	72 05                	jb     8007fc <printnum+0x2a>
  8007f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007fa:	77 4b                	ja     800847 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800802:	8b 45 18             	mov    0x18(%ebp),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 f4             	pushl  -0xc(%ebp)
  80080f:	ff 75 f0             	pushl  -0x10(%ebp)
  800812:	e8 a9 16 00 00       	call   801ec0 <__udivdi3>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	ff 75 20             	pushl  0x20(%ebp)
  800820:	53                   	push   %ebx
  800821:	ff 75 18             	pushl  0x18(%ebp)
  800824:	52                   	push   %edx
  800825:	50                   	push   %eax
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 a1 ff ff ff       	call   8007d2 <printnum>
  800831:	83 c4 20             	add    $0x20,%esp
  800834:	eb 1a                	jmp    800850 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 20             	pushl  0x20(%ebp)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800847:	ff 4d 1c             	decl   0x1c(%ebp)
  80084a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084e:	7f e6                	jg     800836 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800850:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800853:	bb 00 00 00 00       	mov    $0x0,%ebx
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085e:	53                   	push   %ebx
  80085f:	51                   	push   %ecx
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	e8 69 17 00 00       	call   801fd0 <__umoddi3>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	05 74 27 80 00       	add    $0x802774,%eax
  80086f:	8a 00                	mov    (%eax),%al
  800871:	0f be c0             	movsbl %al,%eax
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	90                   	nop
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800890:	7e 1c                	jle    8008ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	8d 50 08             	lea    0x8(%eax),%edx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 10                	mov    %edx,(%eax)
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	83 e8 08             	sub    $0x8,%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	eb 40                	jmp    8008ee <getuint+0x65>
	else if (lflag)
  8008ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b2:	74 1e                	je     8008d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	8d 50 04             	lea    0x4(%eax),%edx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	89 10                	mov    %edx,(%eax)
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	eb 1c                	jmp    8008ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 04             	lea    0x4(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f7:	7e 1c                	jle    800915 <getint+0x25>
		return va_arg(*ap, long long);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 08             	lea    0x8(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 08             	sub    $0x8,%eax
  80090e:	8b 50 04             	mov    0x4(%eax),%edx
  800911:	8b 00                	mov    (%eax),%eax
  800913:	eb 38                	jmp    80094d <getint+0x5d>
	else if (lflag)
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	74 1a                	je     800935 <getint+0x45>
		return va_arg(*ap, long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
  800933:	eb 18                	jmp    80094d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 50 04             	lea    0x4(%eax),%edx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 10                	mov    %edx,(%eax)
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	99                   	cltd   
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800957:	eb 17                	jmp    800970 <vprintfmt+0x21>
			if (ch == '\0')
  800959:	85 db                	test   %ebx,%ebx
  80095b:	0f 84 c1 03 00 00    	je     800d22 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	53                   	push   %ebx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800970:	8b 45 10             	mov    0x10(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 10             	mov    %edx,0x10(%ebp)
  800979:	8a 00                	mov    (%eax),%al
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	83 fb 25             	cmp    $0x25,%ebx
  800981:	75 d6                	jne    800959 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800983:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800987:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f b6 d8             	movzbl %al,%ebx
  8009b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b4:	83 f8 5b             	cmp    $0x5b,%eax
  8009b7:	0f 87 3d 03 00 00    	ja     800cfa <vprintfmt+0x3ab>
  8009bd:	8b 04 85 98 27 80 00 	mov    0x802798(,%eax,4),%eax
  8009c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d7                	jmp    8009a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d0:	eb d1                	jmp    8009a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 02             	shl    $0x2,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d8                	add    %ebx,%eax
  8009e7:	83 e8 30             	sub    $0x30,%eax
  8009ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f8:	7e 3e                	jle    800a38 <vprintfmt+0xe9>
  8009fa:	83 fb 39             	cmp    $0x39,%ebx
  8009fd:	7f 39                	jg     800a38 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a02:	eb d5                	jmp    8009d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a18:	eb 1f                	jmp    800a39 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	79 83                	jns    8009a3 <vprintfmt+0x54>
				width = 0;
  800a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a27:	e9 77 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a33:	e9 6b ff ff ff       	jmp    8009a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a38:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	0f 89 60 ff ff ff    	jns    8009a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a49:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a50:	e9 4e ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a55:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a58:	e9 46 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 9b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	79 02                	jns    800a99 <vprintfmt+0x14a>
				err = -err;
  800a97:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a99:	83 fb 64             	cmp    $0x64,%ebx
  800a9c:	7f 0b                	jg     800aa9 <vprintfmt+0x15a>
  800a9e:	8b 34 9d e0 25 80 00 	mov    0x8025e0(,%ebx,4),%esi
  800aa5:	85 f6                	test   %esi,%esi
  800aa7:	75 19                	jne    800ac2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa9:	53                   	push   %ebx
  800aaa:	68 85 27 80 00       	push   $0x802785
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 70 02 00 00       	call   800d2a <printfmt>
  800aba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abd:	e9 5b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac2:	56                   	push   %esi
  800ac3:	68 8e 27 80 00       	push   $0x80278e
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 57 02 00 00       	call   800d2a <printfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
			break;
  800ad6:	e9 42 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 30                	mov    (%eax),%esi
  800aec:	85 f6                	test   %esi,%esi
  800aee:	75 05                	jne    800af5 <vprintfmt+0x1a6>
				p = "(null)";
  800af0:	be 91 27 80 00       	mov    $0x802791,%esi
			if (width > 0 && padc != '-')
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7e 6d                	jle    800b68 <vprintfmt+0x219>
  800afb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aff:	74 67                	je     800b68 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	50                   	push   %eax
  800b08:	56                   	push   %esi
  800b09:	e8 1e 03 00 00       	call   800e2c <strnlen>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b14:	eb 16                	jmp    800b2c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b30:	7f e4                	jg     800b16 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	eb 34                	jmp    800b68 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b38:	74 1c                	je     800b56 <vprintfmt+0x207>
  800b3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3d:	7e 05                	jle    800b44 <vprintfmt+0x1f5>
  800b3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b42:	7e 12                	jle    800b56 <vprintfmt+0x207>
					putch('?', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 3f                	push   $0x3f
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	eb 0f                	jmp    800b65 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b65:	ff 4d e4             	decl   -0x1c(%ebp)
  800b68:	89 f0                	mov    %esi,%eax
  800b6a:	8d 70 01             	lea    0x1(%eax),%esi
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f be d8             	movsbl %al,%ebx
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	74 24                	je     800b9a <vprintfmt+0x24b>
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	78 b8                	js     800b34 <vprintfmt+0x1e5>
  800b7c:	ff 4d e0             	decl   -0x20(%ebp)
  800b7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b83:	79 af                	jns    800b34 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b85:	eb 13                	jmp    800b9a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 20                	push   $0x20
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	7f e7                	jg     800b87 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba0:	e9 78 01 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bab:	8d 45 14             	lea    0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	e8 3c fd ff ff       	call   8008f0 <getint>
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	85 d2                	test   %edx,%edx
  800bc5:	79 23                	jns    800bea <vprintfmt+0x29b>
				putch('-', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 2d                	push   $0x2d
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	f7 d8                	neg    %eax
  800bdf:	83 d2 00             	adc    $0x0,%edx
  800be2:	f7 da                	neg    %edx
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 bc 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bff:	50                   	push   %eax
  800c00:	e8 84 fc ff ff       	call   800889 <getuint>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c15:	e9 98 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 58                	push   $0x58
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			break;
  800c4a:	e9 ce 00 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 30                	push   $0x30
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 78                	push   $0x78
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	83 e8 04             	sub    $0x4,%eax
  800c7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c91:	eb 1f                	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 e7 fb ff ff       	call   800889 <getuint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	83 ec 04             	sub    $0x4,%esp
  800cbc:	52                   	push   %edx
  800cbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 00 fb ff ff       	call   8007d2 <printnum>
  800cd2:	83 c4 20             	add    $0x20,%esp
			break;
  800cd5:	eb 46                	jmp    800d1d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	53                   	push   %ebx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			break;
  800ce6:	eb 35                	jmp    800d1d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cef:	eb 2c                	jmp    800d1d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cf8:	eb 23                	jmp    800d1d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 25                	push   $0x25
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	eb 03                	jmp    800d12 <vprintfmt+0x3c3>
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	48                   	dec    %eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	3c 25                	cmp    $0x25,%al
  800d1a:	75 f3                	jne    800d0f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d1c:	90                   	nop
		}
	}
  800d1d:	e9 35 fc ff ff       	jmp    800957 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d22:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d30:	8d 45 10             	lea    0x10(%ebp),%eax
  800d33:	83 c0 04             	add    $0x4,%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	ff 75 08             	pushl  0x8(%ebp)
  800d46:	e8 04 fc ff ff       	call   80094f <vprintfmt>
  800d4b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4e:	90                   	nop
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8b 40 08             	mov    0x8(%eax),%eax
  800d5a:	8d 50 01             	lea    0x1(%eax),%edx
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 10                	mov    (%eax),%edx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8b 40 04             	mov    0x4(%eax),%eax
  800d6e:	39 c2                	cmp    %eax,%edx
  800d70:	73 12                	jae    800d84 <sprintputch+0x33>
		*b->buf++ = ch;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7d:	89 0a                	mov    %ecx,(%edx)
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	88 10                	mov    %dl,(%eax)
}
  800d84:	90                   	nop
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dac:	74 06                	je     800db4 <vsnprintf+0x2d>
  800dae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db2:	7f 07                	jg     800dbb <vsnprintf+0x34>
		return -E_INVAL;
  800db4:	b8 03 00 00 00       	mov    $0x3,%eax
  800db9:	eb 20                	jmp    800ddb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbb:	ff 75 14             	pushl  0x14(%ebp)
  800dbe:	ff 75 10             	pushl  0x10(%ebp)
  800dc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc4:	50                   	push   %eax
  800dc5:	68 51 0d 80 00       	push   $0x800d51
  800dca:	e8 80 fb ff ff       	call   80094f <vprintfmt>
  800dcf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de3:	8d 45 10             	lea    0x10(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	ff 75 f4             	pushl  -0xc(%ebp)
  800df2:	50                   	push   %eax
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	ff 75 08             	pushl  0x8(%ebp)
  800df9:	e8 89 ff ff ff       	call   800d87 <vsnprintf>
  800dfe:	83 c4 10             	add    $0x10,%esp
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e16:	eb 06                	jmp    800e1e <strlen+0x15>
		n++;
  800e18:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1b:	ff 45 08             	incl   0x8(%ebp)
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 f1                	jne    800e18 <strlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e39:	eb 09                	jmp    800e44 <strnlen+0x18>
		n++;
  800e3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	ff 4d 0c             	decl   0xc(%ebp)
  800e44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e48:	74 09                	je     800e53 <strnlen+0x27>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	75 e8                	jne    800e3b <strnlen+0xf>
		n++;
	return n;
  800e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e64:	90                   	nop
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8d 50 01             	lea    0x1(%eax),%edx
  800e6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e74:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e77:	8a 12                	mov    (%edx),%dl
  800e79:	88 10                	mov    %dl,(%eax)
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e4                	jne    800e65 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e99:	eb 1f                	jmp    800eba <strncpy+0x34>
		*dst++ = *src;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ea1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea7:	8a 12                	mov    (%edx),%dl
  800ea9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 03                	je     800eb7 <strncpy+0x31>
			src++;
  800eb4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb7:	ff 45 fc             	incl   -0x4(%ebp)
  800eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec0:	72 d9                	jb     800e9b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	74 30                	je     800f09 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed9:	eb 16                	jmp    800ef1 <strlcpy+0x2a>
			*dst++ = *src++;
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8d 50 01             	lea    0x1(%eax),%edx
  800ee1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eed:	8a 12                	mov    (%edx),%dl
  800eef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef1:	ff 4d 10             	decl   0x10(%ebp)
  800ef4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef8:	74 09                	je     800f03 <strlcpy+0x3c>
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 d8                	jne    800edb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f18:	eb 06                	jmp    800f20 <strcmp+0xb>
		p++, q++;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strcmp+0x22>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 e3                	je     800f1a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	0f b6 d0             	movzbl %al,%edx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 c0             	movzbl %al,%eax
  800f47:	29 c2                	sub    %eax,%edx
  800f49:	89 d0                	mov    %edx,%eax
}
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f50:	eb 09                	jmp    800f5b <strncmp+0xe>
		n--, p++, q++;
  800f52:	ff 4d 10             	decl   0x10(%ebp)
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5f:	74 17                	je     800f78 <strncmp+0x2b>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	84 c0                	test   %al,%al
  800f68:	74 0e                	je     800f78 <strncmp+0x2b>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 10                	mov    (%eax),%dl
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	38 c2                	cmp    %al,%dl
  800f76:	74 da                	je     800f52 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	75 07                	jne    800f85 <strncmp+0x38>
		return 0;
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	eb 14                	jmp    800f99 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f b6 d0             	movzbl %al,%edx
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 c0             	movzbl %al,%eax
  800f95:	29 c2                	sub    %eax,%edx
  800f97:	89 d0                	mov    %edx,%eax
}
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 04             	sub    $0x4,%esp
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa7:	eb 12                	jmp    800fbb <strchr+0x20>
		if (*s == c)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb1:	75 05                	jne    800fb8 <strchr+0x1d>
			return (char *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	eb 11                	jmp    800fc9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	75 e5                	jne    800fa9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd7:	eb 0d                	jmp    800fe6 <strfind+0x1b>
		if (*s == c)
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe1:	74 0e                	je     800ff1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe3:	ff 45 08             	incl   0x8(%ebp)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	84 c0                	test   %al,%al
  800fed:	75 ea                	jne    800fd9 <strfind+0xe>
  800fef:	eb 01                	jmp    800ff2 <strfind+0x27>
		if (*s == c)
			break;
  800ff1:	90                   	nop
	return (char *) s;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801003:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801007:	76 63                	jbe    80106c <memset+0x75>
		uint64 data_block = c;
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	99                   	cltd   
  80100d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801010:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801019:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80101d:	c1 e0 08             	shl    $0x8,%eax
  801020:	09 45 f0             	or     %eax,-0x10(%ebp)
  801023:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801030:	c1 e0 10             	shl    $0x10,%eax
  801033:	09 45 f0             	or     %eax,-0x10(%ebp)
  801036:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103f:	89 c2                	mov    %eax,%edx
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	09 45 f0             	or     %eax,-0x10(%ebp)
  801049:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80104c:	eb 18                	jmp    801066 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80104e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801051:	8d 41 08             	lea    0x8(%ecx),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	89 01                	mov    %eax,(%ecx)
  80105f:	89 51 04             	mov    %edx,0x4(%ecx)
  801062:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801066:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106a:	77 e2                	ja     80104e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 23                	je     801095 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801078:	eb 0e                	jmp    801088 <memset+0x91>
			*p8++ = (uint8)c;
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107d:	8d 50 01             	lea    0x1(%eax),%edx
  801080:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108e:	89 55 10             	mov    %edx,0x10(%ebp)
  801091:	85 c0                	test   %eax,%eax
  801093:	75 e5                	jne    80107a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b0:	76 24                	jbe    8010d6 <memcpy+0x3c>
		while(n >= 8){
  8010b2:	eb 1c                	jmp    8010d0 <memcpy+0x36>
			*d64 = *s64;
  8010b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ba:	8b 00                	mov    (%eax),%eax
  8010bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010bf:	89 01                	mov    %eax,(%ecx)
  8010c1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010c8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010cc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010d0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d4:	77 de                	ja     8010b4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 31                	je     80110d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010e8:	eb 16                	jmp    801100 <memcpy+0x66>
			*d8++ = *s8++;
  8010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	8d 50 ff             	lea    -0x1(%eax),%edx
  801106:	89 55 10             	mov    %edx,0x10(%ebp)
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 dd                	jne    8010ea <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801127:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112a:	73 50                	jae    80117c <memmove+0x6a>
  80112c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801137:	76 43                	jbe    80117c <memmove+0x6a>
		s += n;
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801145:	eb 10                	jmp    801157 <memmove+0x45>
			*--d = *--s;
  801147:	ff 4d f8             	decl   -0x8(%ebp)
  80114a:	ff 4d fc             	decl   -0x4(%ebp)
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801150:	8a 10                	mov    (%eax),%dl
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115d:	89 55 10             	mov    %edx,0x10(%ebp)
  801160:	85 c0                	test   %eax,%eax
  801162:	75 e3                	jne    801147 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801164:	eb 23                	jmp    801189 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	8d 50 01             	lea    0x1(%eax),%edx
  80116c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801172:	8d 4a 01             	lea    0x1(%edx),%ecx
  801175:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801178:	8a 12                	mov    (%edx),%dl
  80117a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	85 c0                	test   %eax,%eax
  801187:	75 dd                	jne    801166 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a0:	eb 2a                	jmp    8011cc <memcmp+0x3e>
		if (*s1 != *s2)
  8011a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a5:	8a 10                	mov    (%eax),%dl
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	38 c2                	cmp    %al,%dl
  8011ae:	74 16                	je     8011c6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	0f b6 d0             	movzbl %al,%edx
  8011b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	0f b6 c0             	movzbl %al,%eax
  8011c0:	29 c2                	sub    %eax,%edx
  8011c2:	89 d0                	mov    %edx,%eax
  8011c4:	eb 18                	jmp    8011de <memcmp+0x50>
		s1++, s2++;
  8011c6:	ff 45 fc             	incl   -0x4(%ebp)
  8011c9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	75 c9                	jne    8011a2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f1:	eb 15                	jmp    801208 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f b6 d0             	movzbl %al,%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	0f b6 c0             	movzbl %al,%eax
  801201:	39 c2                	cmp    %eax,%edx
  801203:	74 0d                	je     801212 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801205:	ff 45 08             	incl   0x8(%ebp)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120e:	72 e3                	jb     8011f3 <memfind+0x13>
  801210:	eb 01                	jmp    801213 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801212:	90                   	nop
	return (void *) s;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801225:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122c:	eb 03                	jmp    801231 <strtol+0x19>
		s++;
  80122e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 20                	cmp    $0x20,%al
  801238:	74 f4                	je     80122e <strtol+0x16>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 09                	cmp    $0x9,%al
  801241:	74 eb                	je     80122e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 2b                	cmp    $0x2b,%al
  80124a:	75 05                	jne    801251 <strtol+0x39>
		s++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
  80124f:	eb 13                	jmp    801264 <strtol+0x4c>
	else if (*s == '-')
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 2d                	cmp    $0x2d,%al
  801258:	75 0a                	jne    801264 <strtol+0x4c>
		s++, neg = 1;
  80125a:	ff 45 08             	incl   0x8(%ebp)
  80125d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801268:	74 06                	je     801270 <strtol+0x58>
  80126a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126e:	75 20                	jne    801290 <strtol+0x78>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 30                	cmp    $0x30,%al
  801277:	75 17                	jne    801290 <strtol+0x78>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	40                   	inc    %eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 78                	cmp    $0x78,%al
  801281:	75 0d                	jne    801290 <strtol+0x78>
		s += 2, base = 16;
  801283:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801287:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128e:	eb 28                	jmp    8012b8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801294:	75 15                	jne    8012ab <strtol+0x93>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 30                	cmp    $0x30,%al
  80129d:	75 0c                	jne    8012ab <strtol+0x93>
		s++, base = 8;
  80129f:	ff 45 08             	incl   0x8(%ebp)
  8012a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a9:	eb 0d                	jmp    8012b8 <strtol+0xa0>
	else if (base == 0)
  8012ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012af:	75 07                	jne    8012b8 <strtol+0xa0>
		base = 10;
  8012b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 2f                	cmp    $0x2f,%al
  8012bf:	7e 19                	jle    8012da <strtol+0xc2>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 39                	cmp    $0x39,%al
  8012c8:	7f 10                	jg     8012da <strtol+0xc2>
			dig = *s - '0';
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	83 e8 30             	sub    $0x30,%eax
  8012d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d8:	eb 42                	jmp    80131c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 60                	cmp    $0x60,%al
  8012e1:	7e 19                	jle    8012fc <strtol+0xe4>
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 7a                	cmp    $0x7a,%al
  8012ea:	7f 10                	jg     8012fc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	0f be c0             	movsbl %al,%eax
  8012f4:	83 e8 57             	sub    $0x57,%eax
  8012f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fa:	eb 20                	jmp    80131c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 40                	cmp    $0x40,%al
  801303:	7e 39                	jle    80133e <strtol+0x126>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 5a                	cmp    $0x5a,%al
  80130c:	7f 30                	jg     80133e <strtol+0x126>
			dig = *s - 'A' + 10;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	83 e8 37             	sub    $0x37,%eax
  801319:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801322:	7d 19                	jge    80133d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801324:	ff 45 08             	incl   0x8(%ebp)
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132e:	89 c2                	mov    %eax,%edx
  801330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801338:	e9 7b ff ff ff       	jmp    8012b8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80133d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801342:	74 08                	je     80134c <strtol+0x134>
		*endptr = (char *) s;
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	8b 55 08             	mov    0x8(%ebp),%edx
  80134a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80134c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801350:	74 07                	je     801359 <strtol+0x141>
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	f7 d8                	neg    %eax
  801357:	eb 03                	jmp    80135c <strtol+0x144>
  801359:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <ltostr>:

void
ltostr(long value, char *str)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80136b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801376:	79 13                	jns    80138b <ltostr+0x2d>
	{
		neg = 1;
  801378:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801385:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801388:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801393:	99                   	cltd   
  801394:	f7 f9                	idiv   %ecx
  801396:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801399:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a2:	89 c2                	mov    %eax,%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ac:	83 c2 30             	add    $0x30,%edx
  8013af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b9:	f7 e9                	imul   %ecx
  8013bb:	c1 fa 02             	sar    $0x2,%edx
  8013be:	89 c8                	mov    %ecx,%eax
  8013c0:	c1 f8 1f             	sar    $0x1f,%eax
  8013c3:	29 c2                	sub    %eax,%edx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ce:	75 bb                	jne    80138b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013da:	48                   	dec    %eax
  8013db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e2:	74 3d                	je     801421 <ltostr+0xc3>
		start = 1 ;
  8013e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013eb:	eb 34                	jmp    801421 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 c8                	add    %ecx,%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 c2                	add    %eax,%edx
  801416:	8a 45 eb             	mov    -0x15(%ebp),%al
  801419:	88 02                	mov    %al,(%edx)
		start++ ;
  80141b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801427:	7c c4                	jl     8013ed <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801429:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801434:	90                   	nop
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 c4 f9 ff ff       	call   800e09 <strlen>
  801445:	83 c4 04             	add    $0x4,%esp
  801448:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	e8 b6 f9 ff ff       	call   800e09 <strlen>
  801453:	83 c4 04             	add    $0x4,%esp
  801456:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801467:	eb 17                	jmp    801480 <strcconcat+0x49>
		final[s] = str1[s] ;
  801469:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 c2                	add    %eax,%edx
  801471:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	01 c8                	add    %ecx,%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80147d:	ff 45 fc             	incl   -0x4(%ebp)
  801480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801483:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801486:	7c e1                	jl     801469 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801488:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801496:	eb 1f                	jmp    8014b7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149b:	8d 50 01             	lea    0x1(%eax),%edx
  80149e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a1:	89 c2                	mov    %eax,%edx
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	01 c2                	add    %eax,%edx
  8014a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	01 c8                	add    %ecx,%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b4:	ff 45 f8             	incl   -0x8(%ebp)
  8014b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014bd:	7c d9                	jl     801498 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ca:	90                   	nop
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 d0                	add    %edx,%eax
  8014ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f0:	eb 0c                	jmp    8014fe <strsplit+0x31>
			*string++ = 0;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	74 18                	je     80151f <strsplit+0x52>
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	50                   	push   %eax
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	e8 83 fa ff ff       	call   800f9b <strchr>
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 d3                	jne    8014f2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	74 5a                	je     801582 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801528:	8b 45 14             	mov    0x14(%ebp),%eax
  80152b:	8b 00                	mov    (%eax),%eax
  80152d:	83 f8 0f             	cmp    $0xf,%eax
  801530:	75 07                	jne    801539 <strsplit+0x6c>
		{
			return 0;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
  801537:	eb 66                	jmp    80159f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801539:	8b 45 14             	mov    0x14(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	8d 48 01             	lea    0x1(%eax),%ecx
  801541:	8b 55 14             	mov    0x14(%ebp),%edx
  801544:	89 0a                	mov    %ecx,(%edx)
  801546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154d:	8b 45 10             	mov    0x10(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801557:	eb 03                	jmp    80155c <strsplit+0x8f>
			string++;
  801559:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	84 c0                	test   %al,%al
  801563:	74 8b                	je     8014f0 <strsplit+0x23>
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	0f be c0             	movsbl %al,%eax
  80156d:	50                   	push   %eax
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	e8 25 fa ff ff       	call   800f9b <strchr>
  801576:	83 c4 08             	add    $0x8,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	74 dc                	je     801559 <strsplit+0x8c>
			string++;
	}
  80157d:	e9 6e ff ff ff       	jmp    8014f0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801582:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801583:	8b 45 14             	mov    0x14(%ebp),%eax
  801586:	8b 00                	mov    (%eax),%eax
  801588:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158f:	8b 45 10             	mov    0x10(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80159a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b4:	eb 4a                	jmp    801600 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	01 c2                	add    %eax,%edx
  8015be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	01 c8                	add    %ecx,%eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	3c 40                	cmp    $0x40,%al
  8015d6:	7e 25                	jle    8015fd <str2lower+0x5c>
  8015d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3c 5a                	cmp    $0x5a,%al
  8015e4:	7f 17                	jg     8015fd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	01 d0                	add    %edx,%eax
  8015ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f4:	01 ca                	add    %ecx,%edx
  8015f6:	8a 12                	mov    (%edx),%dl
  8015f8:	83 c2 20             	add    $0x20,%edx
  8015fb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015fd:	ff 45 fc             	incl   -0x4(%ebp)
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	e8 01 f8 ff ff       	call   800e09 <strlen>
  801608:	83 c4 04             	add    $0x4,%esp
  80160b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160e:	7f a6                	jg     8015b6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80161b:	a1 08 30 80 00       	mov    0x803008,%eax
  801620:	85 c0                	test   %eax,%eax
  801622:	74 42                	je     801666 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	68 00 00 00 82       	push   $0x82000000
  80162c:	68 00 00 00 80       	push   $0x80000000
  801631:	e8 8c 07 00 00       	call   801dc2 <initialize_dynamic_allocator>
  801636:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801639:	e8 e7 05 00 00       	call   801c25 <sys_get_uheap_strategy>
  80163e:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801643:	a1 40 30 80 00       	mov    0x803040,%eax
  801648:	05 00 10 00 00       	add    $0x1000,%eax
  80164d:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801652:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801657:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  80165c:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801663:	00 00 00 
	}
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	68 06 04 00 00       	push   $0x406
  801685:	50                   	push   %eax
  801686:	e8 e4 01 00 00       	call   80186f <__sys_allocate_page>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801695:	79 14                	jns    8016ab <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 08 29 80 00       	push   $0x802908
  80169f:	6a 1f                	push   $0x1f
  8016a1:	68 44 29 80 00       	push   $0x802944
  8016a6:	e8 b7 ed ff ff       	call   800462 <_panic>
	return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	50                   	push   %eax
  8016ca:	e8 e7 01 00 00       	call   8018b6 <__sys_unmap_frame>
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d9:	79 14                	jns    8016ef <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	68 50 29 80 00       	push   $0x802950
  8016e3:	6a 2a                	push   $0x2a
  8016e5:	68 44 29 80 00       	push   $0x802944
  8016ea:	e8 73 ed ff ff       	call   800462 <_panic>
}
  8016ef:	90                   	nop
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016f8:	e8 18 ff ff ff       	call   801615 <uheap_init>
	if (size == 0) return NULL ;
  8016fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801701:	75 07                	jne    80170a <malloc+0x18>
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 14                	jmp    80171e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80170a:	83 ec 04             	sub    $0x4,%esp
  80170d:	68 90 29 80 00       	push   $0x802990
  801712:	6a 3e                	push   $0x3e
  801714:	68 44 29 80 00       	push   $0x802944
  801719:	e8 44 ed ff ff       	call   800462 <_panic>
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	68 b8 29 80 00       	push   $0x8029b8
  80172e:	6a 49                	push   $0x49
  801730:	68 44 29 80 00       	push   $0x802944
  801735:	e8 28 ed ff ff       	call   800462 <_panic>

0080173a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 18             	sub    $0x18,%esp
  801740:	8b 45 10             	mov    0x10(%ebp),%eax
  801743:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801746:	e8 ca fe ff ff       	call   801615 <uheap_init>
	if (size == 0) return NULL ;
  80174b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174f:	75 07                	jne    801758 <smalloc+0x1e>
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 14                	jmp    80176c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 dc 29 80 00       	push   $0x8029dc
  801760:	6a 5a                	push   $0x5a
  801762:	68 44 29 80 00       	push   $0x802944
  801767:	e8 f6 ec ff ff       	call   800462 <_panic>
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801774:	e8 9c fe ff ff       	call   801615 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	68 04 2a 80 00       	push   $0x802a04
  801781:	6a 6a                	push   $0x6a
  801783:	68 44 29 80 00       	push   $0x802944
  801788:	e8 d5 ec ff ff       	call   800462 <_panic>

0080178d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801793:	e8 7d fe ff ff       	call   801615 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 28 2a 80 00       	push   $0x802a28
  8017a0:	68 88 00 00 00       	push   $0x88
  8017a5:	68 44 29 80 00       	push   $0x802944
  8017aa:	e8 b3 ec ff ff       	call   800462 <_panic>

008017af <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 50 2a 80 00       	push   $0x802a50
  8017bd:	68 9b 00 00 00       	push   $0x9b
  8017c2:	68 44 29 80 00       	push   $0x802944
  8017c7:	e8 96 ec ff ff       	call   800462 <_panic>

008017cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017e7:	cd 30                	int    $0x30
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5f                   	pop    %edi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801800:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801803:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801806:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	51                   	push   %ecx
  801810:	52                   	push   %edx
  801811:	ff 75 0c             	pushl  0xc(%ebp)
  801814:	50                   	push   %eax
  801815:	6a 00                	push   $0x0
  801817:	e8 b0 ff ff ff       	call   8017cc <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_cgetc>:

int
sys_cgetc(void)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 02                	push   $0x2
  801831:	e8 96 ff ff ff       	call   8017cc <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 03                	push   $0x3
  80184a:	e8 7d ff ff ff       	call   8017cc <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 04                	push   $0x4
  801864:	e8 63 ff ff ff       	call   8017cc <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 08                	push   $0x8
  801882:	e8 45 ff ff ff       	call   8017cc <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801891:	8b 75 18             	mov    0x18(%ebp),%esi
  801894:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801897:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	51                   	push   %ecx
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 09                	push   $0x9
  8018a7:	e8 20 ff ff ff       	call   8017cc <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	6a 0a                	push   $0xa
  8018c6:	e8 01 ff ff ff       	call   8017cc <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 0b                	push   $0xb
  8018e1:	e8 e6 fe ff ff       	call   8017cc <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 0c                	push   $0xc
  8018fa:	e8 cd fe ff ff       	call   8017cc <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 0d                	push   $0xd
  801913:	e8 b4 fe ff ff       	call   8017cc <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 0e                	push   $0xe
  80192c:	e8 9b fe ff ff       	call   8017cc <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 0f                	push   $0xf
  801945:	e8 82 fe ff ff       	call   8017cc <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 10                	push   $0x10
  80195f:	e8 68 fe ff ff       	call   8017cc <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 11                	push   $0x11
  801978:	e8 4f fe ff ff       	call   8017cc <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_cputc>:

void
sys_cputc(const char c)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80198f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	50                   	push   %eax
  80199c:	6a 01                	push   $0x1
  80199e:	e8 29 fe ff ff       	call   8017cc <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	90                   	nop
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 14                	push   $0x14
  8019b8:	e8 0f fe ff ff       	call   8017cc <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	51                   	push   %ecx
  8019dc:	52                   	push   %edx
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	50                   	push   %eax
  8019e1:	6a 15                	push   $0x15
  8019e3:	e8 e4 fd ff ff       	call   8017cc <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 16                	push   $0x16
  801a00:	e8 c7 fd ff ff       	call   8017cc <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	51                   	push   %ecx
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 17                	push   $0x17
  801a1f:	e8 a8 fd ff ff       	call   8017cc <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 18                	push   $0x18
  801a3c:	e8 8b fd ff ff       	call   8017cc <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	ff 75 14             	pushl  0x14(%ebp)
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	6a 19                	push   $0x19
  801a5a:	e8 6d fd ff ff       	call   8017cc <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	50                   	push   %eax
  801a73:	6a 1a                	push   $0x1a
  801a75:	e8 52 fd ff ff       	call   8017cc <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	50                   	push   %eax
  801a8f:	6a 1b                	push   $0x1b
  801a91:	e8 36 fd ff ff       	call   8017cc <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 05                	push   $0x5
  801aaa:	e8 1d fd ff ff       	call   8017cc <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 06                	push   $0x6
  801ac3:	e8 04 fd ff ff       	call   8017cc <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 07                	push   $0x7
  801adc:	e8 eb fc ff ff       	call   8017cc <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 1c                	push   $0x1c
  801af5:	e8 d2 fc ff ff       	call   8017cc <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b09:	8d 50 04             	lea    0x4(%eax),%edx
  801b0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 1d                	push   $0x1d
  801b19:	e8 ae fc ff ff       	call   8017cc <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2a:	89 01                	mov    %eax,(%ecx)
  801b2c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	c9                   	leave  
  801b33:	c2 04 00             	ret    $0x4

00801b36 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 13                	push   $0x13
  801b48:	e8 7f fc ff ff       	call   8017cc <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 1e                	push   $0x1e
  801b62:	e8 65 fc ff ff       	call   8017cc <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b78:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	50                   	push   %eax
  801b85:	6a 1f                	push   $0x1f
  801b87:	e8 40 fc ff ff       	call   8017cc <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <rsttst>:
void rsttst()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 21                	push   $0x21
  801ba1:	e8 26 fc ff ff       	call   8017cc <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba9:	90                   	nop
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb8:	8b 55 18             	mov    0x18(%ebp),%edx
  801bbb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	ff 75 10             	pushl  0x10(%ebp)
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	6a 20                	push   $0x20
  801bcc:	e8 fb fb ff ff       	call   8017cc <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <chktst>:
void chktst(uint32 n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 08             	pushl  0x8(%ebp)
  801be5:	6a 22                	push   $0x22
  801be7:	e8 e0 fb ff ff       	call   8017cc <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <inctst>:

void inctst()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 23                	push   $0x23
  801c01:	e8 c6 fb ff ff       	call   8017cc <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <gettst>:
uint32 gettst()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 24                	push   $0x24
  801c1b:	e8 ac fb ff ff       	call   8017cc <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 25                	push   $0x25
  801c34:	e8 93 fb ff ff       	call   8017cc <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
  801c3c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c41:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 26                	push   $0x26
  801c60:	e8 67 fb ff ff       	call   8017cc <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	53                   	push   %ebx
  801c7e:	51                   	push   %ecx
  801c7f:	52                   	push   %edx
  801c80:	50                   	push   %eax
  801c81:	6a 27                	push   $0x27
  801c83:	e8 44 fb ff ff       	call   8017cc <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	6a 28                	push   $0x28
  801ca3:	e8 24 fb ff ff       	call   8017cc <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cb0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	51                   	push   %ecx
  801cbc:	ff 75 10             	pushl  0x10(%ebp)
  801cbf:	52                   	push   %edx
  801cc0:	50                   	push   %eax
  801cc1:	6a 29                	push   $0x29
  801cc3:	e8 04 fb ff ff       	call   8017cc <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	6a 12                	push   $0x12
  801cdf:	e8 e8 fa ff ff       	call   8017cc <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 2a                	push   $0x2a
  801cfd:	e8 ca fa ff ff       	call   8017cc <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 2b                	push   $0x2b
  801d17:	e8 b0 fa ff ff       	call   8017cc <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	6a 2d                	push   $0x2d
  801d32:	e8 95 fa ff ff       	call   8017cc <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 2c                	push   $0x2c
  801d4e:	e8 79 fa ff ff       	call   8017cc <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	68 74 2a 80 00       	push   $0x802a74
  801d67:	68 25 01 00 00       	push   $0x125
  801d6c:	68 a7 2a 80 00       	push   $0x802aa7
  801d71:	e8 ec e6 ff ff       	call   800462 <_panic>

00801d76 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d84:	29 d0                	sub    %edx,%eax
  801d86:	c1 f8 02             	sar    $0x2,%eax
  801d89:	89 c2                	mov    %eax,%edx
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	c1 e0 02             	shl    $0x2,%eax
  801d90:	01 d0                	add    %edx,%eax
  801d92:	c1 e0 02             	shl    $0x2,%eax
  801d95:	01 d0                	add    %edx,%eax
  801d97:	c1 e0 02             	shl    $0x2,%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	89 c1                	mov    %eax,%ecx
  801d9e:	c1 e1 08             	shl    $0x8,%ecx
  801da1:	01 c8                	add    %ecx,%eax
  801da3:	89 c1                	mov    %eax,%ecx
  801da5:	c1 e1 10             	shl    $0x10,%ecx
  801da8:	01 c8                	add    %ecx,%eax
  801daa:	01 c0                	add    %eax,%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db4:	c1 e0 0c             	shl    $0xc,%eax
  801db7:	89 c2                	mov    %eax,%edx
  801db9:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801dbe:	01 d0                	add    %edx,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	05 00 00 00 02       	add    $0x2000000,%eax
  801dd0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dd3:	73 16                	jae    801deb <initialize_dynamic_allocator+0x29>
  801dd5:	68 b8 2a 80 00       	push   $0x802ab8
  801dda:	68 de 2a 80 00       	push   $0x802ade
  801ddf:	6a 26                	push   $0x26
  801de1:	68 f3 2a 80 00       	push   $0x802af3
  801de6:	e8 77 e6 ff ff       	call   800462 <_panic>
		is_initialized = 1;
  801deb:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801df2:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	68 0c 2b 80 00       	push   $0x802b0c
  801dfd:	6a 2e                	push   $0x2e
  801dff:	68 f3 2a 80 00       	push   $0x802af3
  801e04:	e8 59 e6 ff ff       	call   800462 <_panic>

00801e09 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 40 2b 80 00       	push   $0x802b40
  801e17:	6a 3a                	push   $0x3a
  801e19:	68 f3 2a 80 00       	push   $0x802af3
  801e1e:	e8 3f e6 ff ff       	call   800462 <_panic>

00801e23 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e29:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e30:	76 16                	jbe    801e48 <alloc_block+0x25>
  801e32:	68 68 2b 80 00       	push   $0x802b68
  801e37:	68 de 2a 80 00       	push   $0x802ade
  801e3c:	6a 46                	push   $0x46
  801e3e:	68 f3 2a 80 00       	push   $0x802af3
  801e43:	e8 1a e6 ff ff       	call   800462 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 8c 2b 80 00       	push   $0x802b8c
  801e50:	6a 4d                	push   $0x4d
  801e52:	68 f3 2a 80 00       	push   $0x802af3
  801e57:	e8 06 e6 ff ff       	call   800462 <_panic>

00801e5c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e62:	8b 55 08             	mov    0x8(%ebp),%edx
  801e65:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e6a:	39 c2                	cmp    %eax,%edx
  801e6c:	72 0c                	jb     801e7a <free_block+0x1e>
  801e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e71:	a1 40 30 80 00       	mov    0x803040,%eax
  801e76:	39 c2                	cmp    %eax,%edx
  801e78:	72 16                	jb     801e90 <free_block+0x34>
  801e7a:	68 b0 2b 80 00       	push   $0x802bb0
  801e7f:	68 de 2a 80 00       	push   $0x802ade
  801e84:	6a 5b                	push   $0x5b
  801e86:	68 f3 2a 80 00       	push   $0x802af3
  801e8b:	e8 d2 e5 ff ff       	call   800462 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 e8 2b 80 00       	push   $0x802be8
  801e98:	6a 63                	push   $0x63
  801e9a:	68 f3 2a 80 00       	push   $0x802af3
  801e9f:	e8 be e5 ff ff       	call   800462 <_panic>

00801ea4 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 0c 2c 80 00       	push   $0x802c0c
  801eb2:	6a 72                	push   $0x72
  801eb4:	68 f3 2a 80 00       	push   $0x802af3
  801eb9:	e8 a4 e5 ff ff       	call   800462 <_panic>
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <__udivdi3>:
  801ec0:	55                   	push   %ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 1c             	sub    $0x1c,%esp
  801ec7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ecb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ecf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ed3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed7:	89 ca                	mov    %ecx,%edx
  801ed9:	89 f8                	mov    %edi,%eax
  801edb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801edf:	85 f6                	test   %esi,%esi
  801ee1:	75 2d                	jne    801f10 <__udivdi3+0x50>
  801ee3:	39 cf                	cmp    %ecx,%edi
  801ee5:	77 65                	ja     801f4c <__udivdi3+0x8c>
  801ee7:	89 fd                	mov    %edi,%ebp
  801ee9:	85 ff                	test   %edi,%edi
  801eeb:	75 0b                	jne    801ef8 <__udivdi3+0x38>
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	31 d2                	xor    %edx,%edx
  801ef4:	f7 f7                	div    %edi
  801ef6:	89 c5                	mov    %eax,%ebp
  801ef8:	31 d2                	xor    %edx,%edx
  801efa:	89 c8                	mov    %ecx,%eax
  801efc:	f7 f5                	div    %ebp
  801efe:	89 c1                	mov    %eax,%ecx
  801f00:	89 d8                	mov    %ebx,%eax
  801f02:	f7 f5                	div    %ebp
  801f04:	89 cf                	mov    %ecx,%edi
  801f06:	89 fa                	mov    %edi,%edx
  801f08:	83 c4 1c             	add    $0x1c,%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5e                   	pop    %esi
  801f0d:	5f                   	pop    %edi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    
  801f10:	39 ce                	cmp    %ecx,%esi
  801f12:	77 28                	ja     801f3c <__udivdi3+0x7c>
  801f14:	0f bd fe             	bsr    %esi,%edi
  801f17:	83 f7 1f             	xor    $0x1f,%edi
  801f1a:	75 40                	jne    801f5c <__udivdi3+0x9c>
  801f1c:	39 ce                	cmp    %ecx,%esi
  801f1e:	72 0a                	jb     801f2a <__udivdi3+0x6a>
  801f20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f24:	0f 87 9e 00 00 00    	ja     801fc8 <__udivdi3+0x108>
  801f2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2f:	89 fa                	mov    %edi,%edx
  801f31:	83 c4 1c             	add    $0x1c,%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5f                   	pop    %edi
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    
  801f39:	8d 76 00             	lea    0x0(%esi),%esi
  801f3c:	31 ff                	xor    %edi,%edi
  801f3e:	31 c0                	xor    %eax,%eax
  801f40:	89 fa                	mov    %edi,%edx
  801f42:	83 c4 1c             	add    $0x1c,%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5f                   	pop    %edi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	89 d8                	mov    %ebx,%eax
  801f4e:	f7 f7                	div    %edi
  801f50:	31 ff                	xor    %edi,%edi
  801f52:	89 fa                	mov    %edi,%edx
  801f54:	83 c4 1c             	add    $0x1c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
  801f5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f61:	89 eb                	mov    %ebp,%ebx
  801f63:	29 fb                	sub    %edi,%ebx
  801f65:	89 f9                	mov    %edi,%ecx
  801f67:	d3 e6                	shl    %cl,%esi
  801f69:	89 c5                	mov    %eax,%ebp
  801f6b:	88 d9                	mov    %bl,%cl
  801f6d:	d3 ed                	shr    %cl,%ebp
  801f6f:	89 e9                	mov    %ebp,%ecx
  801f71:	09 f1                	or     %esi,%ecx
  801f73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f77:	89 f9                	mov    %edi,%ecx
  801f79:	d3 e0                	shl    %cl,%eax
  801f7b:	89 c5                	mov    %eax,%ebp
  801f7d:	89 d6                	mov    %edx,%esi
  801f7f:	88 d9                	mov    %bl,%cl
  801f81:	d3 ee                	shr    %cl,%esi
  801f83:	89 f9                	mov    %edi,%ecx
  801f85:	d3 e2                	shl    %cl,%edx
  801f87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f8b:	88 d9                	mov    %bl,%cl
  801f8d:	d3 e8                	shr    %cl,%eax
  801f8f:	09 c2                	or     %eax,%edx
  801f91:	89 d0                	mov    %edx,%eax
  801f93:	89 f2                	mov    %esi,%edx
  801f95:	f7 74 24 0c          	divl   0xc(%esp)
  801f99:	89 d6                	mov    %edx,%esi
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	f7 e5                	mul    %ebp
  801f9f:	39 d6                	cmp    %edx,%esi
  801fa1:	72 19                	jb     801fbc <__udivdi3+0xfc>
  801fa3:	74 0b                	je     801fb0 <__udivdi3+0xf0>
  801fa5:	89 d8                	mov    %ebx,%eax
  801fa7:	31 ff                	xor    %edi,%edi
  801fa9:	e9 58 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fb4:	89 f9                	mov    %edi,%ecx
  801fb6:	d3 e2                	shl    %cl,%edx
  801fb8:	39 c2                	cmp    %eax,%edx
  801fba:	73 e9                	jae    801fa5 <__udivdi3+0xe5>
  801fbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fbf:	31 ff                	xor    %edi,%edi
  801fc1:	e9 40 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	31 c0                	xor    %eax,%eax
  801fca:	e9 37 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fcf:	90                   	nop

00801fd0 <__umoddi3>:
  801fd0:	55                   	push   %ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 1c             	sub    $0x1c,%esp
  801fd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fdb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fe3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fef:	89 f3                	mov    %esi,%ebx
  801ff1:	89 fa                	mov    %edi,%edx
  801ff3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	75 1a                	jne    802018 <__umoddi3+0x48>
  801ffe:	39 f7                	cmp    %esi,%edi
  802000:	0f 86 a2 00 00 00    	jbe    8020a8 <__umoddi3+0xd8>
  802006:	89 c8                	mov    %ecx,%eax
  802008:	89 f2                	mov    %esi,%edx
  80200a:	f7 f7                	div    %edi
  80200c:	89 d0                	mov    %edx,%eax
  80200e:	31 d2                	xor    %edx,%edx
  802010:	83 c4 1c             	add    $0x1c,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    
  802018:	39 f0                	cmp    %esi,%eax
  80201a:	0f 87 ac 00 00 00    	ja     8020cc <__umoddi3+0xfc>
  802020:	0f bd e8             	bsr    %eax,%ebp
  802023:	83 f5 1f             	xor    $0x1f,%ebp
  802026:	0f 84 ac 00 00 00    	je     8020d8 <__umoddi3+0x108>
  80202c:	bf 20 00 00 00       	mov    $0x20,%edi
  802031:	29 ef                	sub    %ebp,%edi
  802033:	89 fe                	mov    %edi,%esi
  802035:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802039:	89 e9                	mov    %ebp,%ecx
  80203b:	d3 e0                	shl    %cl,%eax
  80203d:	89 d7                	mov    %edx,%edi
  80203f:	89 f1                	mov    %esi,%ecx
  802041:	d3 ef                	shr    %cl,%edi
  802043:	09 c7                	or     %eax,%edi
  802045:	89 e9                	mov    %ebp,%ecx
  802047:	d3 e2                	shl    %cl,%edx
  802049:	89 14 24             	mov    %edx,(%esp)
  80204c:	89 d8                	mov    %ebx,%eax
  80204e:	d3 e0                	shl    %cl,%eax
  802050:	89 c2                	mov    %eax,%edx
  802052:	8b 44 24 08          	mov    0x8(%esp),%eax
  802056:	d3 e0                	shl    %cl,%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802060:	89 f1                	mov    %esi,%ecx
  802062:	d3 e8                	shr    %cl,%eax
  802064:	09 d0                	or     %edx,%eax
  802066:	d3 eb                	shr    %cl,%ebx
  802068:	89 da                	mov    %ebx,%edx
  80206a:	f7 f7                	div    %edi
  80206c:	89 d3                	mov    %edx,%ebx
  80206e:	f7 24 24             	mull   (%esp)
  802071:	89 c6                	mov    %eax,%esi
  802073:	89 d1                	mov    %edx,%ecx
  802075:	39 d3                	cmp    %edx,%ebx
  802077:	0f 82 87 00 00 00    	jb     802104 <__umoddi3+0x134>
  80207d:	0f 84 91 00 00 00    	je     802114 <__umoddi3+0x144>
  802083:	8b 54 24 04          	mov    0x4(%esp),%edx
  802087:	29 f2                	sub    %esi,%edx
  802089:	19 cb                	sbb    %ecx,%ebx
  80208b:	89 d8                	mov    %ebx,%eax
  80208d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802091:	d3 e0                	shl    %cl,%eax
  802093:	89 e9                	mov    %ebp,%ecx
  802095:	d3 ea                	shr    %cl,%edx
  802097:	09 d0                	or     %edx,%eax
  802099:	89 e9                	mov    %ebp,%ecx
  80209b:	d3 eb                	shr    %cl,%ebx
  80209d:	89 da                	mov    %ebx,%edx
  80209f:	83 c4 1c             	add    $0x1c,%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5f                   	pop    %edi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    
  8020a7:	90                   	nop
  8020a8:	89 fd                	mov    %edi,%ebp
  8020aa:	85 ff                	test   %edi,%edi
  8020ac:	75 0b                	jne    8020b9 <__umoddi3+0xe9>
  8020ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	f7 f7                	div    %edi
  8020b7:	89 c5                	mov    %eax,%ebp
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	31 d2                	xor    %edx,%edx
  8020bd:	f7 f5                	div    %ebp
  8020bf:	89 c8                	mov    %ecx,%eax
  8020c1:	f7 f5                	div    %ebp
  8020c3:	89 d0                	mov    %edx,%eax
  8020c5:	e9 44 ff ff ff       	jmp    80200e <__umoddi3+0x3e>
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	89 c8                	mov    %ecx,%eax
  8020ce:	89 f2                	mov    %esi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	3b 04 24             	cmp    (%esp),%eax
  8020db:	72 06                	jb     8020e3 <__umoddi3+0x113>
  8020dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020e1:	77 0f                	ja     8020f2 <__umoddi3+0x122>
  8020e3:	89 f2                	mov    %esi,%edx
  8020e5:	29 f9                	sub    %edi,%ecx
  8020e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020eb:	89 14 24             	mov    %edx,(%esp)
  8020ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020f6:	8b 14 24             	mov    (%esp),%edx
  8020f9:	83 c4 1c             	add    $0x1c,%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5f                   	pop    %edi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
  802101:	8d 76 00             	lea    0x0(%esi),%esi
  802104:	2b 04 24             	sub    (%esp),%eax
  802107:	19 fa                	sbb    %edi,%edx
  802109:	89 d1                	mov    %edx,%ecx
  80210b:	89 c6                	mov    %eax,%esi
  80210d:	e9 71 ff ff ff       	jmp    802083 <__umoddi3+0xb3>
  802112:	66 90                	xchg   %ax,%ax
  802114:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802118:	72 ea                	jb     802104 <__umoddi3+0x134>
  80211a:	89 d9                	mov    %ebx,%ecx
  80211c:	e9 62 ff ff ff       	jmp    802083 <__umoddi3+0xb3>

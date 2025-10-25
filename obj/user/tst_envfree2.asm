
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80004a:	bb 11 20 80 00       	mov    $0x802011,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 a4 1a 00 00       	call   801b2a <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 9d 16 00 00       	call   80172b <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 e0 16 00 00       	call   801776 <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 20 1e 80 00       	push   $0x801e20
  8000a4:	e8 7e 06 00 00       	call   800727 <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("sc_ms_leak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 53 1e 80 00       	push   $0x801e53
  8000cd:	e8 b4 17 00 00       	call   801886 <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_ms_noleak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000e3:	89 c2                	mov    %eax,%edx
  8000e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ea:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f0:	6a 32                	push   $0x32
  8000f2:	52                   	push   %edx
  8000f3:	50                   	push   %eax
  8000f4:	68 64 1e 80 00       	push   $0x801e64
  8000f9:	e8 88 17 00 00       	call   801886 <sys_create_env>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 d8             	mov    %eax,-0x28(%ebp)

	rsttst();
  800104:	e8 c9 18 00 00       	call   8019d2 <rsttst>

	//Run 2 processes
	sys_run_env(envIdProcessA);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	ff 75 dc             	pushl  -0x24(%ebp)
  80010f:	e8 90 17 00 00       	call   8018a4 <sys_run_env>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	ff 75 d8             	pushl  -0x28(%ebp)
  80011d:	e8 82 17 00 00       	call   8018a4 <sys_run_env>
  800122:	83 c4 10             	add    $0x10,%esp

	//env_sleep(30000);

	//to ensure that the slave environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  800125:	90                   	nop
  800126:	e8 21 19 00 00       	call   801a4c <gettst>
  80012b:	83 f8 02             	cmp    $0x2,%eax
  80012e:	75 f6                	jne    800126 <_main+0xee>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800130:	e8 f6 15 00 00       	call   80172b <sys_calculate_free_frames>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	50                   	push   %eax
  800139:	68 78 1e 80 00       	push   $0x801e78
  80013e:	e8 e4 05 00 00       	call   800727 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800146:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 ce 19 00 00       	call   801b2a <sys_utilities>
  80015c:	83 c4 10             	add    $0x10,%esp
	//Kill the 2 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80015f:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800165:	bb 75 20 80 00       	mov    $0x802075,%ebx
  80016a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80016f:	89 c7                	mov    %eax,%edi
  800171:	89 de                	mov    %ebx,%esi
  800173:	89 d1                	mov    %edx,%ecx
  800175:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800177:	8d 95 06 ff ff ff    	lea    -0xfa(%ebp),%edx
  80017d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800182:	b0 00                	mov    $0x0,%al
  800184:	89 d7                	mov    %edx,%edi
  800186:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 91 19 00 00       	call   801b2a <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a2:	e8 19 17 00 00       	call   8018c0 <sys_destroy_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b0:	e8 0b 17 00 00       	call   8018c0 <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 61 19 00 00       	call   801b2a <sys_utilities>
  8001c9:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001cc:	e8 5a 15 00 00       	call   80172b <sys_calculate_free_frames>
  8001d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d4:	e8 9d 15 00 00       	call   801776 <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001dc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8001e3:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  8001e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	48                   	dec    %eax
  8001ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	f7 75 cc             	divl   -0x34(%ebp)
  8001fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800200:	29 d0                	sub    %edx,%eax
  800202:	89 c1                	mov    %eax,%ecx
  800204:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80020b:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  800211:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800214:	01 d0                	add    %edx,%eax
  800216:	48                   	dec    %eax
  800217:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80021a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80021d:	ba 00 00 00 00       	mov    $0x0,%edx
  800222:	f7 75 c4             	divl   -0x3c(%ebp)
  800225:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800228:	29 d0                	sub    %edx,%eax
  80022a:	29 c1                	sub    %eax,%ecx
  80022c:	89 c8                	mov    %ecx,%eax
  80022e:	c1 e8 0c             	shr    $0xc,%eax
  800231:	89 45 bc             	mov    %eax,-0x44(%ebp)
	cprintf("expected = %d\n",expected);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	ff 75 bc             	pushl  -0x44(%ebp)
  80023a:	68 aa 1e 80 00       	push   $0x801eaa
  80023f:	e8 e3 04 00 00       	call   800727 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80024d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800250:	74 2e                	je     800280 <_main+0x248>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800252:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800255:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	50                   	push   %eax
  80025c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025f:	68 bc 1e 80 00       	push   $0x801ebc
  800264:	e8 be 04 00 00       	call   800727 <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 2c 1f 80 00       	push   $0x801f2c
  800274:	6a 3c                	push   $0x3c
  800276:	68 62 1f 80 00       	push   $0x801f62
  80027b:	e8 d9 01 00 00       	call   800459 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 78 1f 80 00       	push   $0x801f78
  800288:	e8 9a 04 00 00       	call   800727 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 c8 1f 80 00       	push   $0x801fc8
  800298:	e8 8a 04 00 00       	call   800727 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	return;
  8002a0:	90                   	nop
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 3d 16 00 00       	call   8018f4 <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	c1 e0 02             	shl    $0x2,%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c1 e0 03             	shl    $0x3,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 02             	shl    $0x2,%eax
  8002d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e4:	8a 40 20             	mov    0x20(%eax),%al
  8002e7:	84 c0                	test   %al,%al
  8002e9:	74 0d                	je     8002f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	83 c0 20             	add    $0x20,%eax
  8002f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fc:	7e 0a                	jle    800308 <libmain+0x5f>
		binaryname = argv[0];
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 22 fd ff ff       	call   800038 <_main>
  800316:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800319:	a1 00 30 80 00       	mov    0x803000,%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 01 01 00 00    	je     800427 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800326:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032c:	bb d4 21 80 00       	mov    $0x8021d4,%ebx
  800331:	ba 0e 00 00 00       	mov    $0xe,%edx
  800336:	89 c7                	mov    %eax,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800341:	b9 56 00 00 00       	mov    $0x56,%ecx
  800346:	b0 00                	mov    $0x0,%al
  800348:	89 d7                	mov    %edx,%edi
  80034a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800353:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	50                   	push   %eax
  80035a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	e8 c4 17 00 00       	call   801b2a <sys_utilities>
  800366:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800369:	e8 0d 13 00 00       	call   80167b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 f4 20 80 00       	push   $0x8020f4
  800376:	e8 ac 03 00 00       	call   800727 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	74 18                	je     80039d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800385:	e8 be 17 00 00       	call   801b48 <sys_get_optimal_num_faults>
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	50                   	push   %eax
  80038e:	68 1c 21 80 00       	push   $0x80211c
  800393:	e8 8f 03 00 00       	call   800727 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb 59                	jmp    8003f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039d:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 40 21 80 00       	push   $0x802140
  8003bd:	e8 65 03 00 00       	call   800727 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	68 68 21 80 00       	push   $0x802168
  8003ee:	e8 34 03 00 00       	call   800727 <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	50                   	push   %eax
  800405:	68 c0 21 80 00       	push   $0x8021c0
  80040a:	e8 18 03 00 00       	call   800727 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	68 f4 20 80 00       	push   $0x8020f4
  80041a:	e8 08 03 00 00       	call   800727 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800422:	e8 6e 12 00 00       	call   801695 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800427:	e8 1f 00 00 00       	call   80044b <exit>
}
  80042c:	90                   	nop
  80042d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	6a 00                	push   $0x0
  800440:	e8 7b 14 00 00       	call   8018c0 <sys_destroy_env>
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <exit>:

void
exit(void)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800451:	e8 d0 14 00 00       	call   801926 <sys_exit_env>
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80045f:	8d 45 10             	lea    0x10(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800468:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80046d:	85 c0                	test   %eax,%eax
  80046f:	74 16                	je     800487 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 38 22 80 00       	push   $0x802238
  80047f:	e8 a3 02 00 00       	call   800727 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800487:	a1 04 30 80 00       	mov    0x803004,%eax
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	ff 75 08             	pushl  0x8(%ebp)
  800495:	50                   	push   %eax
  800496:	68 40 22 80 00       	push   $0x802240
  80049b:	6a 74                	push   $0x74
  80049d:	e8 b2 02 00 00       	call   800754 <cprintf_colored>
  8004a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	e8 04 02 00 00       	call   8006b8 <vcprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 00                	push   $0x0
  8004bc:	68 68 22 80 00       	push   $0x802268
  8004c1:	e8 f2 01 00 00       	call   8006b8 <vcprintf>
  8004c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c9:	e8 7d ff ff ff       	call   80044b <exit>

	// should not return here
	while (1) ;
  8004ce:	eb fe                	jmp    8004ce <_panic+0x75>

008004d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	39 c2                	cmp    %eax,%edx
  8004e6:	74 14                	je     8004fc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 6c 22 80 00       	push   $0x80226c
  8004f0:	6a 26                	push   $0x26
  8004f2:	68 b8 22 80 00       	push   $0x8022b8
  8004f7:	e8 5d ff ff ff       	call   800459 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	e9 c5 00 00 00       	jmp    8005d4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80050f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800512:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	85 c0                	test   %eax,%eax
  800522:	75 08                	jne    80052c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800524:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800527:	e9 a5 00 00 00       	jmp    8005d1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80052c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800533:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80053a:	eb 69                	jmp    8005a5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80053c:	a1 20 30 80 00       	mov    0x803020,%eax
  800541:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800547:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054a:	89 d0                	mov    %edx,%eax
  80054c:	01 c0                	add    %eax,%eax
  80054e:	01 d0                	add    %edx,%eax
  800550:	c1 e0 03             	shl    $0x3,%eax
  800553:	01 c8                	add    %ecx,%eax
  800555:	8a 40 04             	mov    0x4(%eax),%al
  800558:	84 c0                	test   %al,%al
  80055a:	75 46                	jne    8005a2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80055c:	a1 20 30 80 00       	mov    0x803020,%eax
  800561:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800567:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056a:	89 d0                	mov    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	c1 e0 03             	shl    $0x3,%eax
  800573:	01 c8                	add    %ecx,%eax
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80057a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800582:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800595:	39 c2                	cmp    %eax,%edx
  800597:	75 09                	jne    8005a2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800599:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a0:	eb 15                	jmp    8005b7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
  8005a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	77 85                	ja     80053c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005bb:	75 14                	jne    8005d1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 c4 22 80 00       	push   $0x8022c4
  8005c5:	6a 3a                	push   $0x3a
  8005c7:	68 b8 22 80 00       	push   $0x8022b8
  8005cc:	e8 88 fe ff ff       	call   800459 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d1:	ff 45 f0             	incl   -0x10(%ebp)
  8005d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005da:	0f 8c 2f ff ff ff    	jl     80050f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005ee:	eb 26                	jmp    800616 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	89 d0                	mov    %edx,%eax
  800600:	01 c0                	add    %eax,%eax
  800602:	01 d0                	add    %edx,%eax
  800604:	c1 e0 03             	shl    $0x3,%eax
  800607:	01 c8                	add    %ecx,%eax
  800609:	8a 40 04             	mov    0x4(%eax),%al
  80060c:	3c 01                	cmp    $0x1,%al
  80060e:	75 03                	jne    800613 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800610:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	a1 20 30 80 00       	mov    0x803020,%eax
  80061b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800624:	39 c2                	cmp    %eax,%edx
  800626:	77 c8                	ja     8005f0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80062e:	74 14                	je     800644 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800630:	83 ec 04             	sub    $0x4,%esp
  800633:	68 18 23 80 00       	push   $0x802318
  800638:	6a 44                	push   $0x44
  80063a:	68 b8 22 80 00       	push   $0x8022b8
  80063f:	e8 15 fe ff ff       	call   800459 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800644:	90                   	nop
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
  80064a:	53                   	push   %ebx
  80064b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 48 01             	lea    0x1(%eax),%ecx
  800656:	8b 55 0c             	mov    0xc(%ebp),%edx
  800659:	89 0a                	mov    %ecx,(%edx)
  80065b:	8b 55 08             	mov    0x8(%ebp),%edx
  80065e:	88 d1                	mov    %dl,%cl
  800660:	8b 55 0c             	mov    0xc(%ebp),%edx
  800663:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800671:	75 30                	jne    8006a3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800673:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800679:	a0 44 30 80 00       	mov    0x803044,%al
  80067e:	0f b6 c0             	movzbl %al,%eax
  800681:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800684:	8b 09                	mov    (%ecx),%ecx
  800686:	89 cb                	mov    %ecx,%ebx
  800688:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068b:	83 c1 08             	add    $0x8,%ecx
  80068e:	52                   	push   %edx
  80068f:	50                   	push   %eax
  800690:	53                   	push   %ebx
  800691:	51                   	push   %ecx
  800692:	e8 a0 0f 00 00       	call   801637 <sys_cputs>
  800697:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	8b 40 04             	mov    0x4(%eax),%eax
  8006a9:	8d 50 01             	lea    0x1(%eax),%edx
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006b2:	90                   	nop
  8006b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c8:	00 00 00 
	b.cnt = 0;
  8006cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	ff 75 08             	pushl  0x8(%ebp)
  8006db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	68 47 06 80 00       	push   $0x800647
  8006e7:	e8 5a 02 00 00       	call   800946 <vprintfmt>
  8006ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006ef:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006f5:	a0 44 30 80 00       	mov    0x803044,%al
  8006fa:	0f b6 c0             	movzbl %al,%eax
  8006fd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	51                   	push   %ecx
  800706:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070c:	83 c0 08             	add    $0x8,%eax
  80070f:	50                   	push   %eax
  800710:	e8 22 0f 00 00       	call   801637 <sys_cputs>
  800715:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800718:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80071f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800734:	8d 45 0c             	lea    0xc(%ebp),%eax
  800737:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 f4             	pushl  -0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	e8 6f ff ff ff       	call   8006b8 <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80074f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	c1 e0 08             	shl    $0x8,%eax
  800767:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80076c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 f4             	pushl  -0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	e8 34 ff ff ff       	call   8006b8 <vcprintf>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80078a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800791:	07 00 00 

	return cnt;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80079f:	e8 d7 0e 00 00       	call   80167b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	e8 ff fe ff ff       	call   8006b8 <vcprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007bf:	e8 d1 0e 00 00       	call   801695 <sys_unlock_cons>
	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	83 ec 14             	sub    $0x14,%esp
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007df:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e7:	77 55                	ja     80083e <printnum+0x75>
  8007e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ec:	72 05                	jb     8007f3 <printnum+0x2a>
  8007ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f1:	77 4b                	ja     80083e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	52                   	push   %edx
  800802:	50                   	push   %eax
  800803:	ff 75 f4             	pushl  -0xc(%ebp)
  800806:	ff 75 f0             	pushl  -0x10(%ebp)
  800809:	e8 aa 13 00 00       	call   801bb8 <__udivdi3>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	53                   	push   %ebx
  800818:	ff 75 18             	pushl  0x18(%ebp)
  80081b:	52                   	push   %edx
  80081c:	50                   	push   %eax
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	ff 75 08             	pushl  0x8(%ebp)
  800823:	e8 a1 ff ff ff       	call   8007c9 <printnum>
  800828:	83 c4 20             	add    $0x20,%esp
  80082b:	eb 1a                	jmp    800847 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	ff 75 20             	pushl  0x20(%ebp)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80083e:	ff 4d 1c             	decl   0x1c(%ebp)
  800841:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800845:	7f e6                	jg     80082d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800847:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800855:	53                   	push   %ebx
  800856:	51                   	push   %ecx
  800857:	52                   	push   %edx
  800858:	50                   	push   %eax
  800859:	e8 6a 14 00 00       	call   801cc8 <__umoddi3>
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	05 94 25 80 00       	add    $0x802594,%eax
  800866:	8a 00                	mov    (%eax),%al
  800868:	0f be c0             	movsbl %al,%eax
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	50                   	push   %eax
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	90                   	nop
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800883:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800887:	7e 1c                	jle    8008a5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	8d 50 08             	lea    0x8(%eax),%edx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	89 10                	mov    %edx,(%eax)
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	83 e8 08             	sub    $0x8,%eax
  80089e:	8b 50 04             	mov    0x4(%eax),%edx
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	eb 40                	jmp    8008e5 <getuint+0x65>
	else if (lflag)
  8008a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a9:	74 1e                	je     8008c9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	8d 50 04             	lea    0x4(%eax),%edx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 10                	mov    %edx,(%eax)
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c7:	eb 1c                	jmp    8008e5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ee:	7e 1c                	jle    80090c <getint+0x25>
		return va_arg(*ap, long long);
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	8d 50 08             	lea    0x8(%eax),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	89 10                	mov    %edx,(%eax)
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	83 e8 08             	sub    $0x8,%eax
  800905:	8b 50 04             	mov    0x4(%eax),%edx
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	eb 38                	jmp    800944 <getint+0x5d>
	else if (lflag)
  80090c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800910:	74 1a                	je     80092c <getint+0x45>
		return va_arg(*ap, long);
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	8d 50 04             	lea    0x4(%eax),%edx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 10                	mov    %edx,(%eax)
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	99                   	cltd   
  80092a:	eb 18                	jmp    800944 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	89 10                	mov    %edx,(%eax)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	99                   	cltd   
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094e:	eb 17                	jmp    800967 <vprintfmt+0x21>
			if (ch == '\0')
  800950:	85 db                	test   %ebx,%ebx
  800952:	0f 84 c1 03 00 00    	je     800d19 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800967:	8b 45 10             	mov    0x10(%ebp),%eax
  80096a:	8d 50 01             	lea    0x1(%eax),%edx
  80096d:	89 55 10             	mov    %edx,0x10(%ebp)
  800970:	8a 00                	mov    (%eax),%al
  800972:	0f b6 d8             	movzbl %al,%ebx
  800975:	83 fb 25             	cmp    $0x25,%ebx
  800978:	75 d6                	jne    800950 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80097e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800985:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800993:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099a:	8b 45 10             	mov    0x10(%ebp),%eax
  80099d:	8d 50 01             	lea    0x1(%eax),%edx
  8009a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a3:	8a 00                	mov    (%eax),%al
  8009a5:	0f b6 d8             	movzbl %al,%ebx
  8009a8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ab:	83 f8 5b             	cmp    $0x5b,%eax
  8009ae:	0f 87 3d 03 00 00    	ja     800cf1 <vprintfmt+0x3ab>
  8009b4:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  8009bb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009bd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c1:	eb d7                	jmp    80099a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009c7:	eb d1                	jmp    80099a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	c1 e0 02             	shl    $0x2,%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	01 c0                	add    %eax,%eax
  8009dc:	01 d8                	add    %ebx,%eax
  8009de:	83 e8 30             	sub    $0x30,%eax
  8009e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ec:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ef:	7e 3e                	jle    800a2f <vprintfmt+0xe9>
  8009f1:	83 fb 39             	cmp    $0x39,%ebx
  8009f4:	7f 39                	jg     800a2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f9:	eb d5                	jmp    8009d0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	83 c0 04             	add    $0x4,%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 e8 04             	sub    $0x4,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a0f:	eb 1f                	jmp    800a30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	79 83                	jns    80099a <vprintfmt+0x54>
				width = 0;
  800a17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a1e:	e9 77 ff ff ff       	jmp    80099a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2a:	e9 6b ff ff ff       	jmp    80099a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	0f 89 60 ff ff ff    	jns    80099a <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a47:	e9 4e ff ff ff       	jmp    80099a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a4f:	e9 46 ff ff ff       	jmp    80099a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 c0 04             	add    $0x4,%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 e8 04             	sub    $0x4,%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	ff d0                	call   *%eax
  800a71:	83 c4 10             	add    $0x10,%esp
			break;
  800a74:	e9 9b 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 c0 04             	add    $0x4,%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8a:	85 db                	test   %ebx,%ebx
  800a8c:	79 02                	jns    800a90 <vprintfmt+0x14a>
				err = -err;
  800a8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a90:	83 fb 64             	cmp    $0x64,%ebx
  800a93:	7f 0b                	jg     800aa0 <vprintfmt+0x15a>
  800a95:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800a9c:	85 f6                	test   %esi,%esi
  800a9e:	75 19                	jne    800ab9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa0:	53                   	push   %ebx
  800aa1:	68 a5 25 80 00       	push   $0x8025a5
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	ff 75 08             	pushl  0x8(%ebp)
  800aac:	e8 70 02 00 00       	call   800d21 <printfmt>
  800ab1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab4:	e9 5b 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab9:	56                   	push   %esi
  800aba:	68 ae 25 80 00       	push   $0x8025ae
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	e8 57 02 00 00       	call   800d21 <printfmt>
  800aca:	83 c4 10             	add    $0x10,%esp
			break;
  800acd:	e9 42 02 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad5:	83 c0 04             	add    $0x4,%eax
  800ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 e8 04             	sub    $0x4,%eax
  800ae1:	8b 30                	mov    (%eax),%esi
  800ae3:	85 f6                	test   %esi,%esi
  800ae5:	75 05                	jne    800aec <vprintfmt+0x1a6>
				p = "(null)";
  800ae7:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	7e 6d                	jle    800b5f <vprintfmt+0x219>
  800af2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af6:	74 67                	je     800b5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	56                   	push   %esi
  800b00:	e8 1e 03 00 00       	call   800e23 <strnlen>
  800b05:	83 c4 10             	add    $0x10,%esp
  800b08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0b:	eb 16                	jmp    800b23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	50                   	push   %eax
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b20:	ff 4d e4             	decl   -0x1c(%ebp)
  800b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b27:	7f e4                	jg     800b0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b2f:	74 1c                	je     800b4d <vprintfmt+0x207>
  800b31:	83 fb 1f             	cmp    $0x1f,%ebx
  800b34:	7e 05                	jle    800b3b <vprintfmt+0x1f5>
  800b36:	83 fb 7e             	cmp    $0x7e,%ebx
  800b39:	7e 12                	jle    800b4d <vprintfmt+0x207>
					putch('?', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 3f                	push   $0x3f
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	eb 0f                	jmp    800b5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	53                   	push   %ebx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5f:	89 f0                	mov    %esi,%eax
  800b61:	8d 70 01             	lea    0x1(%eax),%esi
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f be d8             	movsbl %al,%ebx
  800b69:	85 db                	test   %ebx,%ebx
  800b6b:	74 24                	je     800b91 <vprintfmt+0x24b>
  800b6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b71:	78 b8                	js     800b2b <vprintfmt+0x1e5>
  800b73:	ff 4d e0             	decl   -0x20(%ebp)
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	79 af                	jns    800b2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7c:	eb 13                	jmp    800b91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 20                	push   $0x20
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b95:	7f e7                	jg     800b7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b97:	e9 78 01 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba5:	50                   	push   %eax
  800ba6:	e8 3c fd ff ff       	call   8008e7 <getint>
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bba:	85 d2                	test   %edx,%edx
  800bbc:	79 23                	jns    800be1 <vprintfmt+0x29b>
				putch('-', putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	6a 2d                	push   $0x2d
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	ff d0                	call   *%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd4:	f7 d8                	neg    %eax
  800bd6:	83 d2 00             	adc    $0x0,%edx
  800bd9:	f7 da                	neg    %edx
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be8:	e9 bc 00 00 00       	jmp    800ca9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf6:	50                   	push   %eax
  800bf7:	e8 84 fc ff ff       	call   800880 <getuint>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c05:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0c:	e9 98 00 00 00       	jmp    800ca9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	6a 58                	push   $0x58
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	6a 58                	push   $0x58
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	ff d0                	call   *%eax
  800c2e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 58                	push   $0x58
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			break;
  800c41:	e9 ce 00 00 00       	jmp    800d14 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	6a 30                	push   $0x30
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 78                	push   $0x78
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c66:	8b 45 14             	mov    0x14(%ebp),%eax
  800c69:	83 c0 04             	add    $0x4,%eax
  800c6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 e8 04             	sub    $0x4,%eax
  800c75:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c81:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c88:	eb 1f                	jmp    800ca9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c90:	8d 45 14             	lea    0x14(%ebp),%eax
  800c93:	50                   	push   %eax
  800c94:	e8 e7 fb ff ff       	call   800880 <getuint>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb0:	83 ec 04             	sub    $0x4,%esp
  800cb3:	52                   	push   %edx
  800cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cb7:	50                   	push   %eax
  800cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	ff 75 08             	pushl  0x8(%ebp)
  800cc4:	e8 00 fb ff ff       	call   8007c9 <printnum>
  800cc9:	83 c4 20             	add    $0x20,%esp
			break;
  800ccc:	eb 46                	jmp    800d14 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	53                   	push   %ebx
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	ff d0                	call   *%eax
  800cda:	83 c4 10             	add    $0x10,%esp
			break;
  800cdd:	eb 35                	jmp    800d14 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cdf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ce6:	eb 2c                	jmp    800d14 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ce8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cef:	eb 23                	jmp    800d14 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	6a 25                	push   $0x25
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	eb 03                	jmp    800d09 <vprintfmt+0x3c3>
  800d06:	ff 4d 10             	decl   0x10(%ebp)
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	48                   	dec    %eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	3c 25                	cmp    $0x25,%al
  800d11:	75 f3                	jne    800d06 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d13:	90                   	nop
		}
	}
  800d14:	e9 35 fc ff ff       	jmp    80094e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d19:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d27:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2a:	83 c0 04             	add    $0x4,%eax
  800d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	ff 75 f4             	pushl  -0xc(%ebp)
  800d36:	50                   	push   %eax
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	ff 75 08             	pushl  0x8(%ebp)
  800d3d:	e8 04 fc ff ff       	call   800946 <vprintfmt>
  800d42:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d45:	90                   	nop
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 40 08             	mov    0x8(%eax),%eax
  800d51:	8d 50 01             	lea    0x1(%eax),%edx
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 10                	mov    (%eax),%edx
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8b 40 04             	mov    0x4(%eax),%eax
  800d65:	39 c2                	cmp    %eax,%edx
  800d67:	73 12                	jae    800d7b <sprintputch+0x33>
		*b->buf++ = ch;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d74:	89 0a                	mov    %ecx,(%edx)
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	88 10                	mov    %dl,(%eax)
}
  800d7b:	90                   	nop
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	01 d0                	add    %edx,%eax
  800d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da3:	74 06                	je     800dab <vsnprintf+0x2d>
  800da5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da9:	7f 07                	jg     800db2 <vsnprintf+0x34>
		return -E_INVAL;
  800dab:	b8 03 00 00 00       	mov    $0x3,%eax
  800db0:	eb 20                	jmp    800dd2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db2:	ff 75 14             	pushl  0x14(%ebp)
  800db5:	ff 75 10             	pushl  0x10(%ebp)
  800db8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dbb:	50                   	push   %eax
  800dbc:	68 48 0d 80 00       	push   $0x800d48
  800dc1:	e8 80 fb ff ff       	call   800946 <vprintfmt>
  800dc6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dcc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dda:	8d 45 10             	lea    0x10(%ebp),%eax
  800ddd:	83 c0 04             	add    $0x4,%eax
  800de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	ff 75 f4             	pushl  -0xc(%ebp)
  800de9:	50                   	push   %eax
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	ff 75 08             	pushl  0x8(%ebp)
  800df0:	e8 89 ff ff ff       	call   800d7e <vsnprintf>
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 06                	jmp    800e15 <strlen+0x15>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 f1                	jne    800e0f <strlen+0xf>
		n++;
	return n;
  800e1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e30:	eb 09                	jmp    800e3b <strnlen+0x18>
		n++;
  800e32:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	ff 45 08             	incl   0x8(%ebp)
  800e38:	ff 4d 0c             	decl   0xc(%ebp)
  800e3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3f:	74 09                	je     800e4a <strnlen+0x27>
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e8                	jne    800e32 <strnlen+0xf>
		n++;
	return n;
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e5b:	90                   	nop
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8d 50 01             	lea    0x1(%eax),%edx
  800e62:	89 55 08             	mov    %edx,0x8(%ebp)
  800e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e6e:	8a 12                	mov    (%edx),%dl
  800e70:	88 10                	mov    %dl,(%eax)
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	84 c0                	test   %al,%al
  800e76:	75 e4                	jne    800e5c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e90:	eb 1f                	jmp    800eb1 <strncpy+0x34>
		*dst++ = *src;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8d 50 01             	lea    0x1(%eax),%edx
  800e98:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9e:	8a 12                	mov    (%edx),%dl
  800ea0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	84 c0                	test   %al,%al
  800ea9:	74 03                	je     800eae <strncpy+0x31>
			src++;
  800eab:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eae:	ff 45 fc             	incl   -0x4(%ebp)
  800eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb7:	72 d9                	jb     800e92 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 30                	je     800f00 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed0:	eb 16                	jmp    800ee8 <strlcpy+0x2a>
			*dst++ = *src++;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 08             	mov    %edx,0x8(%ebp)
  800edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee8:	ff 4d 10             	decl   0x10(%ebp)
  800eeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eef:	74 09                	je     800efa <strlcpy+0x3c>
  800ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	84 c0                	test   %al,%al
  800ef8:	75 d8                	jne    800ed2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f0f:	eb 06                	jmp    800f17 <strcmp+0xb>
		p++, q++;
  800f11:	ff 45 08             	incl   0x8(%ebp)
  800f14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strcmp+0x22>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 e3                	je     800f11 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f b6 c0             	movzbl %al,%eax
  800f3e:	29 c2                	sub    %eax,%edx
  800f40:	89 d0                	mov    %edx,%eax
}
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f47:	eb 09                	jmp    800f52 <strncmp+0xe>
		n--, p++, q++;
  800f49:	ff 4d 10             	decl   0x10(%ebp)
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f56:	74 17                	je     800f6f <strncmp+0x2b>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	84 c0                	test   %al,%al
  800f5f:	74 0e                	je     800f6f <strncmp+0x2b>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 10                	mov    (%eax),%dl
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	38 c2                	cmp    %al,%dl
  800f6d:	74 da                	je     800f49 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f73:	75 07                	jne    800f7c <strncmp+0x38>
		return 0;
  800f75:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7a:	eb 14                	jmp    800f90 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	0f b6 d0             	movzbl %al,%edx
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 c0             	movzbl %al,%eax
  800f8c:	29 c2                	sub    %eax,%edx
  800f8e:	89 d0                	mov    %edx,%eax
}
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9e:	eb 12                	jmp    800fb2 <strchr+0x20>
		if (*s == c)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa8:	75 05                	jne    800faf <strchr+0x1d>
			return (char *) s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	eb 11                	jmp    800fc0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800faf:	ff 45 08             	incl   0x8(%ebp)
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	84 c0                	test   %al,%al
  800fb9:	75 e5                	jne    800fa0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fce:	eb 0d                	jmp    800fdd <strfind+0x1b>
		if (*s == c)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd8:	74 0e                	je     800fe8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	84 c0                	test   %al,%al
  800fe4:	75 ea                	jne    800fd0 <strfind+0xe>
  800fe6:	eb 01                	jmp    800fe9 <strfind+0x27>
		if (*s == c)
			break;
  800fe8:	90                   	nop
	return (char *) s;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ffa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ffe:	76 63                	jbe    801063 <memset+0x75>
		uint64 data_block = c;
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	99                   	cltd   
  801004:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801007:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80100a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801010:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801014:	c1 e0 08             	shl    $0x8,%eax
  801017:	09 45 f0             	or     %eax,-0x10(%ebp)
  80101a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80101d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801023:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801027:	c1 e0 10             	shl    $0x10,%eax
  80102a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80102d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801036:	89 c2                	mov    %eax,%edx
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
  80103d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801040:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801043:	eb 18                	jmp    80105d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801045:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801048:	8d 41 08             	lea    0x8(%ecx),%eax
  80104b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80104e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801054:	89 01                	mov    %eax,(%ecx)
  801056:	89 51 04             	mov    %edx,0x4(%ecx)
  801059:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80105d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801061:	77 e2                	ja     801045 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801067:	74 23                	je     80108c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106f:	eb 0e                	jmp    80107f <memset+0x91>
			*p8++ = (uint8)c;
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	8d 50 ff             	lea    -0x1(%eax),%edx
  801085:	89 55 10             	mov    %edx,0x10(%ebp)
  801088:	85 c0                	test   %eax,%eax
  80108a:	75 e5                	jne    801071 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a7:	76 24                	jbe    8010cd <memcpy+0x3c>
		while(n >= 8){
  8010a9:	eb 1c                	jmp    8010c7 <memcpy+0x36>
			*d64 = *s64;
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	8b 50 04             	mov    0x4(%eax),%edx
  8010b1:	8b 00                	mov    (%eax),%eax
  8010b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010b6:	89 01                	mov    %eax,(%ecx)
  8010b8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010bf:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010c3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010cb:	77 de                	ja     8010ab <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d1:	74 31                	je     801104 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010df:	eb 16                	jmp    8010f7 <memcpy+0x66>
			*d8++ = *s8++;
  8010e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e4:	8d 50 01             	lea    0x1(%eax),%edx
  8010e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010f3:	8a 12                	mov    (%edx),%dl
  8010f5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801100:	85 c0                	test   %eax,%eax
  801102:	75 dd                	jne    8010e1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801121:	73 50                	jae    801173 <memmove+0x6a>
  801123:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112e:	76 43                	jbe    801173 <memmove+0x6a>
		s += n;
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80113c:	eb 10                	jmp    80114e <memmove+0x45>
			*--d = *--s;
  80113e:	ff 4d f8             	decl   -0x8(%ebp)
  801141:	ff 4d fc             	decl   -0x4(%ebp)
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	8a 10                	mov    (%eax),%dl
  801149:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	8d 50 ff             	lea    -0x1(%eax),%edx
  801154:	89 55 10             	mov    %edx,0x10(%ebp)
  801157:	85 c0                	test   %eax,%eax
  801159:	75 e3                	jne    80113e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80115b:	eb 23                	jmp    801180 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	8d 50 01             	lea    0x1(%eax),%edx
  801163:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801169:	8d 4a 01             	lea    0x1(%edx),%ecx
  80116c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	8d 50 ff             	lea    -0x1(%eax),%edx
  801179:	89 55 10             	mov    %edx,0x10(%ebp)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	75 dd                	jne    80115d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801197:	eb 2a                	jmp    8011c3 <memcmp+0x3e>
		if (*s1 != *s2)
  801199:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119c:	8a 10                	mov    (%eax),%dl
  80119e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	38 c2                	cmp    %al,%dl
  8011a5:	74 16                	je     8011bd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f b6 d0             	movzbl %al,%edx
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	0f b6 c0             	movzbl %al,%eax
  8011b7:	29 c2                	sub    %eax,%edx
  8011b9:	89 d0                	mov    %edx,%eax
  8011bb:	eb 18                	jmp    8011d5 <memcmp+0x50>
		s1++, s2++;
  8011bd:	ff 45 fc             	incl   -0x4(%ebp)
  8011c0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	75 c9                	jne    801199 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e3:	01 d0                	add    %edx,%eax
  8011e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011e8:	eb 15                	jmp    8011ff <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	0f b6 d0             	movzbl %al,%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	0f b6 c0             	movzbl %al,%eax
  8011f8:	39 c2                	cmp    %eax,%edx
  8011fa:	74 0d                	je     801209 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011fc:	ff 45 08             	incl   0x8(%ebp)
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801205:	72 e3                	jb     8011ea <memfind+0x13>
  801207:	eb 01                	jmp    80120a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801209:	90                   	nop
	return (void *) s;
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801215:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80121c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801223:	eb 03                	jmp    801228 <strtol+0x19>
		s++;
  801225:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 20                	cmp    $0x20,%al
  80122f:	74 f4                	je     801225 <strtol+0x16>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 09                	cmp    $0x9,%al
  801238:	74 eb                	je     801225 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 2b                	cmp    $0x2b,%al
  801241:	75 05                	jne    801248 <strtol+0x39>
		s++;
  801243:	ff 45 08             	incl   0x8(%ebp)
  801246:	eb 13                	jmp    80125b <strtol+0x4c>
	else if (*s == '-')
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 2d                	cmp    $0x2d,%al
  80124f:	75 0a                	jne    80125b <strtol+0x4c>
		s++, neg = 1;
  801251:	ff 45 08             	incl   0x8(%ebp)
  801254:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80125b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125f:	74 06                	je     801267 <strtol+0x58>
  801261:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801265:	75 20                	jne    801287 <strtol+0x78>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 30                	cmp    $0x30,%al
  80126e:	75 17                	jne    801287 <strtol+0x78>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	40                   	inc    %eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 78                	cmp    $0x78,%al
  801278:	75 0d                	jne    801287 <strtol+0x78>
		s += 2, base = 16;
  80127a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80127e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801285:	eb 28                	jmp    8012af <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128b:	75 15                	jne    8012a2 <strtol+0x93>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	3c 30                	cmp    $0x30,%al
  801294:	75 0c                	jne    8012a2 <strtol+0x93>
		s++, base = 8;
  801296:	ff 45 08             	incl   0x8(%ebp)
  801299:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a0:	eb 0d                	jmp    8012af <strtol+0xa0>
	else if (base == 0)
  8012a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a6:	75 07                	jne    8012af <strtol+0xa0>
		base = 10;
  8012a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	3c 2f                	cmp    $0x2f,%al
  8012b6:	7e 19                	jle    8012d1 <strtol+0xc2>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 39                	cmp    $0x39,%al
  8012bf:	7f 10                	jg     8012d1 <strtol+0xc2>
			dig = *s - '0';
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	83 e8 30             	sub    $0x30,%eax
  8012cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012cf:	eb 42                	jmp    801313 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 60                	cmp    $0x60,%al
  8012d8:	7e 19                	jle    8012f3 <strtol+0xe4>
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 7a                	cmp    $0x7a,%al
  8012e1:	7f 10                	jg     8012f3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	0f be c0             	movsbl %al,%eax
  8012eb:	83 e8 57             	sub    $0x57,%eax
  8012ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f1:	eb 20                	jmp    801313 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	3c 40                	cmp    $0x40,%al
  8012fa:	7e 39                	jle    801335 <strtol+0x126>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 5a                	cmp    $0x5a,%al
  801303:	7f 30                	jg     801335 <strtol+0x126>
			dig = *s - 'A' + 10;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	83 e8 37             	sub    $0x37,%eax
  801310:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	7d 19                	jge    801334 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80131b:	ff 45 08             	incl   0x8(%ebp)
  80131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801321:	0f af 45 10          	imul   0x10(%ebp),%eax
  801325:	89 c2                	mov    %eax,%edx
  801327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80132f:	e9 7b ff ff ff       	jmp    8012af <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801334:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801339:	74 08                	je     801343 <strtol+0x134>
		*endptr = (char *) s;
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	8b 55 08             	mov    0x8(%ebp),%edx
  801341:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801343:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801347:	74 07                	je     801350 <strtol+0x141>
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	f7 d8                	neg    %eax
  80134e:	eb 03                	jmp    801353 <strtol+0x144>
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <ltostr>:

void
ltostr(long value, char *str)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80135b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801362:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80136d:	79 13                	jns    801382 <ltostr+0x2d>
	{
		neg = 1;
  80136f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80137c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80137f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80138a:	99                   	cltd   
  80138b:	f7 f9                	idiv   %ecx
  80138d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801390:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801393:	8d 50 01             	lea    0x1(%eax),%edx
  801396:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801399:	89 c2                	mov    %eax,%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a3:	83 c2 30             	add    $0x30,%edx
  8013a6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b0:	f7 e9                	imul   %ecx
  8013b2:	c1 fa 02             	sar    $0x2,%edx
  8013b5:	89 c8                	mov    %ecx,%eax
  8013b7:	c1 f8 1f             	sar    $0x1f,%eax
  8013ba:	29 c2                	sub    %eax,%edx
  8013bc:	89 d0                	mov    %edx,%eax
  8013be:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c5:	75 bb                	jne    801382 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d1:	48                   	dec    %eax
  8013d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013d9:	74 3d                	je     801418 <ltostr+0xc3>
		start = 1 ;
  8013db:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013e2:	eb 34                	jmp    801418 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	01 c8                	add    %ecx,%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801405:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	01 c2                	add    %eax,%edx
  80140d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801410:	88 02                	mov    %al,(%edx)
		start++ ;
  801412:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801415:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80141e:	7c c4                	jl     8013e4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801420:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80142b:	90                   	nop
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801434:	ff 75 08             	pushl  0x8(%ebp)
  801437:	e8 c4 f9 ff ff       	call   800e00 <strlen>
  80143c:	83 c4 04             	add    $0x4,%esp
  80143f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	e8 b6 f9 ff ff       	call   800e00 <strlen>
  80144a:	83 c4 04             	add    $0x4,%esp
  80144d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145e:	eb 17                	jmp    801477 <strcconcat+0x49>
		final[s] = str1[s] ;
  801460:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801463:	8b 45 10             	mov    0x10(%ebp),%eax
  801466:	01 c2                	add    %eax,%edx
  801468:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	01 c8                	add    %ecx,%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801474:	ff 45 fc             	incl   -0x4(%ebp)
  801477:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80147d:	7c e1                	jl     801460 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80147f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801486:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80148d:	eb 1f                	jmp    8014ae <strcconcat+0x80>
		final[s++] = str2[i] ;
  80148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801492:	8d 50 01             	lea    0x1(%eax),%edx
  801495:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801498:	89 c2                	mov    %eax,%edx
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	01 c2                	add    %eax,%edx
  80149f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	01 c8                	add    %ecx,%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014ab:	ff 45 f8             	incl   -0x8(%ebp)
  8014ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b4:	7c d9                	jl     80148f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c1:	90                   	nop
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d3:	8b 00                	mov    (%eax),%eax
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 d0                	add    %edx,%eax
  8014e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e7:	eb 0c                	jmp    8014f5 <strsplit+0x31>
			*string++ = 0;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	84 c0                	test   %al,%al
  8014fc:	74 18                	je     801516 <strsplit+0x52>
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f be c0             	movsbl %al,%eax
  801506:	50                   	push   %eax
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	e8 83 fa ff ff       	call   800f92 <strchr>
  80150f:	83 c4 08             	add    $0x8,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	75 d3                	jne    8014e9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	84 c0                	test   %al,%al
  80151d:	74 5a                	je     801579 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80151f:	8b 45 14             	mov    0x14(%ebp),%eax
  801522:	8b 00                	mov    (%eax),%eax
  801524:	83 f8 0f             	cmp    $0xf,%eax
  801527:	75 07                	jne    801530 <strsplit+0x6c>
		{
			return 0;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 66                	jmp    801596 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801530:	8b 45 14             	mov    0x14(%ebp),%eax
  801533:	8b 00                	mov    (%eax),%eax
  801535:	8d 48 01             	lea    0x1(%eax),%ecx
  801538:	8b 55 14             	mov    0x14(%ebp),%edx
  80153b:	89 0a                	mov    %ecx,(%edx)
  80153d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 c2                	add    %eax,%edx
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80154e:	eb 03                	jmp    801553 <strsplit+0x8f>
			string++;
  801550:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	84 c0                	test   %al,%al
  80155a:	74 8b                	je     8014e7 <strsplit+0x23>
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	0f be c0             	movsbl %al,%eax
  801564:	50                   	push   %eax
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	e8 25 fa ff ff       	call   800f92 <strchr>
  80156d:	83 c4 08             	add    $0x8,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	74 dc                	je     801550 <strsplit+0x8c>
			string++;
	}
  801574:	e9 6e ff ff ff       	jmp    8014e7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801579:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80157a:	8b 45 14             	mov    0x14(%ebp),%eax
  80157d:	8b 00                	mov    (%eax),%eax
  80157f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801591:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ab:	eb 4a                	jmp    8015f7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	01 c2                	add    %eax,%edx
  8015b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c8                	add    %ecx,%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	3c 40                	cmp    $0x40,%al
  8015cd:	7e 25                	jle    8015f4 <str2lower+0x5c>
  8015cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	01 d0                	add    %edx,%eax
  8015d7:	8a 00                	mov    (%eax),%al
  8015d9:	3c 5a                	cmp    $0x5a,%al
  8015db:	7f 17                	jg     8015f4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 d0                	add    %edx,%eax
  8015e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015eb:	01 ca                	add    %ecx,%edx
  8015ed:	8a 12                	mov    (%edx),%dl
  8015ef:	83 c2 20             	add    $0x20,%edx
  8015f2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015f4:	ff 45 fc             	incl   -0x4(%ebp)
  8015f7:	ff 75 0c             	pushl  0xc(%ebp)
  8015fa:	e8 01 f8 ff ff       	call   800e00 <strlen>
  8015ff:	83 c4 04             	add    $0x4,%esp
  801602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801605:	7f a6                	jg     8015ad <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	57                   	push   %edi
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801621:	8b 7d 18             	mov    0x18(%ebp),%edi
  801624:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801627:	cd 30                	int    $0x30
  801629:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5f                   	pop    %edi
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801643:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801646:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	6a 00                	push   $0x0
  80164f:	51                   	push   %ecx
  801650:	52                   	push   %edx
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	50                   	push   %eax
  801655:	6a 00                	push   $0x0
  801657:	e8 b0 ff ff ff       	call   80160c <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_cgetc>:

int
sys_cgetc(void)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 02                	push   $0x2
  801671:	e8 96 ff ff ff       	call   80160c <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 03                	push   $0x3
  80168a:	e8 7d ff ff ff       	call   80160c <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 04                	push   $0x4
  8016a4:	e8 63 ff ff ff       	call   80160c <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	90                   	nop
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	6a 08                	push   $0x8
  8016c2:	e8 45 ff ff ff       	call   80160c <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	51                   	push   %ecx
  8016e3:	52                   	push   %edx
  8016e4:	50                   	push   %eax
  8016e5:	6a 09                	push   $0x9
  8016e7:	e8 20 ff ff ff       	call   80160c <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	6a 0a                	push   $0xa
  801706:	e8 01 ff ff ff       	call   80160c <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	6a 0b                	push   $0xb
  801721:	e8 e6 fe ff ff       	call   80160c <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 0c                	push   $0xc
  80173a:	e8 cd fe ff ff       	call   80160c <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 0d                	push   $0xd
  801753:	e8 b4 fe ff ff       	call   80160c <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 0e                	push   $0xe
  80176c:	e8 9b fe ff ff       	call   80160c <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 0f                	push   $0xf
  801785:	e8 82 fe ff ff       	call   80160c <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	6a 10                	push   $0x10
  80179f:	e8 68 fe ff ff       	call   80160c <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 11                	push   $0x11
  8017b8:	e8 4f fe ff ff       	call   80160c <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	50                   	push   %eax
  8017dc:	6a 01                	push   $0x1
  8017de:	e8 29 fe ff ff       	call   80160c <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 14                	push   $0x14
  8017f8:	e8 0f fe ff ff       	call   80160c <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	90                   	nop
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80180f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801812:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	51                   	push   %ecx
  80181c:	52                   	push   %edx
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	50                   	push   %eax
  801821:	6a 15                	push   $0x15
  801823:	e8 e4 fd ff ff       	call   80160c <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	52                   	push   %edx
  80183d:	50                   	push   %eax
  80183e:	6a 16                	push   $0x16
  801840:	e8 c7 fd ff ff       	call   80160c <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80184d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	51                   	push   %ecx
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 17                	push   $0x17
  80185f:	e8 a8 fd ff ff       	call   80160c <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 18                	push   $0x18
  80187c:	e8 8b fd ff ff       	call   80160c <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	ff 75 14             	pushl  0x14(%ebp)
  801891:	ff 75 10             	pushl  0x10(%ebp)
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	50                   	push   %eax
  801898:	6a 19                	push   $0x19
  80189a:	e8 6d fd ff ff       	call   80160c <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	50                   	push   %eax
  8018b3:	6a 1a                	push   $0x1a
  8018b5:	e8 52 fd ff ff       	call   80160c <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	50                   	push   %eax
  8018cf:	6a 1b                	push   $0x1b
  8018d1:	e8 36 fd ff ff       	call   80160c <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 05                	push   $0x5
  8018ea:	e8 1d fd ff ff       	call   80160c <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 06                	push   $0x6
  801903:	e8 04 fd ff ff       	call   80160c <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 07                	push   $0x7
  80191c:	e8 eb fc ff ff       	call   80160c <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_exit_env>:


void sys_exit_env(void)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 1c                	push   $0x1c
  801935:	e8 d2 fc ff ff       	call   80160c <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801946:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801949:	8d 50 04             	lea    0x4(%eax),%edx
  80194c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	52                   	push   %edx
  801956:	50                   	push   %eax
  801957:	6a 1d                	push   $0x1d
  801959:	e8 ae fc ff ff       	call   80160c <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return result;
  801961:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801964:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801967:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80196a:	89 01                	mov    %eax,(%ecx)
  80196c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	c9                   	leave  
  801973:	c2 04 00             	ret    $0x4

00801976 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	6a 13                	push   $0x13
  801988:	e8 7f fc ff ff       	call   80160c <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
	return ;
  801990:	90                   	nop
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_rcr2>:
uint32 sys_rcr2()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 1e                	push   $0x1e
  8019a2:	e8 65 fc ff ff       	call   80160c <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	50                   	push   %eax
  8019c5:	6a 1f                	push   $0x1f
  8019c7:	e8 40 fc ff ff       	call   80160c <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cf:	90                   	nop
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <rsttst>:
void rsttst()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 21                	push   $0x21
  8019e1:	e8 26 fc ff ff       	call   80160c <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e9:	90                   	nop
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8019fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	ff 75 10             	pushl  0x10(%ebp)
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	ff 75 08             	pushl  0x8(%ebp)
  801a0a:	6a 20                	push   $0x20
  801a0c:	e8 fb fb ff ff       	call   80160c <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
	return ;
  801a14:	90                   	nop
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <chktst>:
void chktst(uint32 n)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 22                	push   $0x22
  801a27:	e8 e0 fb ff ff       	call   80160c <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <inctst>:

void inctst()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 23                	push   $0x23
  801a41:	e8 c6 fb ff ff       	call   80160c <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
	return ;
  801a49:	90                   	nop
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <gettst>:
uint32 gettst()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 24                	push   $0x24
  801a5b:	e8 ac fb ff ff       	call   80160c <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 25                	push   $0x25
  801a74:	e8 93 fb ff ff       	call   80160c <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
  801a7c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a81:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 26                	push   $0x26
  801aa0:	e8 67 fb ff ff       	call   80160c <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aaf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	53                   	push   %ebx
  801abe:	51                   	push   %ecx
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 27                	push   $0x27
  801ac3:	e8 44 fb ff ff       	call   80160c <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 28                	push   $0x28
  801ae3:	e8 24 fb ff ff       	call   80160c <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801af0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	51                   	push   %ecx
  801afc:	ff 75 10             	pushl  0x10(%ebp)
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 29                	push   $0x29
  801b03:	e8 04 fb ff ff       	call   80160c <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 10             	pushl  0x10(%ebp)
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	6a 12                	push   $0x12
  801b1f:	e8 e8 fa ff ff       	call   80160c <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return ;
  801b27:	90                   	nop
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 2a                	push   $0x2a
  801b3d:	e8 ca fa ff ff       	call   80160c <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return;
  801b45:	90                   	nop
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 2b                	push   $0x2b
  801b57:	e8 b0 fa ff ff       	call   80160c <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	6a 2d                	push   $0x2d
  801b72:	e8 95 fa ff ff       	call   80160c <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 2c                	push   $0x2c
  801b8e:	e8 79 fa ff ff       	call   80160c <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return ;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	68 28 27 80 00       	push   $0x802728
  801ba7:	68 25 01 00 00       	push   $0x125
  801bac:	68 5b 27 80 00       	push   $0x80275b
  801bb1:	e8 a3 e8 ff ff       	call   800459 <_panic>
  801bb6:	66 90                	xchg   %ax,%ax

00801bb8 <__udivdi3>:
  801bb8:	55                   	push   %ebp
  801bb9:	57                   	push   %edi
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
  801bbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bcf:	89 ca                	mov    %ecx,%edx
  801bd1:	89 f8                	mov    %edi,%eax
  801bd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bd7:	85 f6                	test   %esi,%esi
  801bd9:	75 2d                	jne    801c08 <__udivdi3+0x50>
  801bdb:	39 cf                	cmp    %ecx,%edi
  801bdd:	77 65                	ja     801c44 <__udivdi3+0x8c>
  801bdf:	89 fd                	mov    %edi,%ebp
  801be1:	85 ff                	test   %edi,%edi
  801be3:	75 0b                	jne    801bf0 <__udivdi3+0x38>
  801be5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bea:	31 d2                	xor    %edx,%edx
  801bec:	f7 f7                	div    %edi
  801bee:	89 c5                	mov    %eax,%ebp
  801bf0:	31 d2                	xor    %edx,%edx
  801bf2:	89 c8                	mov    %ecx,%eax
  801bf4:	f7 f5                	div    %ebp
  801bf6:	89 c1                	mov    %eax,%ecx
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	f7 f5                	div    %ebp
  801bfc:	89 cf                	mov    %ecx,%edi
  801bfe:	89 fa                	mov    %edi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	39 ce                	cmp    %ecx,%esi
  801c0a:	77 28                	ja     801c34 <__udivdi3+0x7c>
  801c0c:	0f bd fe             	bsr    %esi,%edi
  801c0f:	83 f7 1f             	xor    $0x1f,%edi
  801c12:	75 40                	jne    801c54 <__udivdi3+0x9c>
  801c14:	39 ce                	cmp    %ecx,%esi
  801c16:	72 0a                	jb     801c22 <__udivdi3+0x6a>
  801c18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c1c:	0f 87 9e 00 00 00    	ja     801cc0 <__udivdi3+0x108>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	89 fa                	mov    %edi,%edx
  801c29:	83 c4 1c             	add    $0x1c,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
  801c31:	8d 76 00             	lea    0x0(%esi),%esi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	31 c0                	xor    %eax,%eax
  801c38:	89 fa                	mov    %edi,%edx
  801c3a:	83 c4 1c             	add    $0x1c,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	f7 f7                	div    %edi
  801c48:	31 ff                	xor    %edi,%edi
  801c4a:	89 fa                	mov    %edi,%edx
  801c4c:	83 c4 1c             	add    $0x1c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
  801c54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c59:	89 eb                	mov    %ebp,%ebx
  801c5b:	29 fb                	sub    %edi,%ebx
  801c5d:	89 f9                	mov    %edi,%ecx
  801c5f:	d3 e6                	shl    %cl,%esi
  801c61:	89 c5                	mov    %eax,%ebp
  801c63:	88 d9                	mov    %bl,%cl
  801c65:	d3 ed                	shr    %cl,%ebp
  801c67:	89 e9                	mov    %ebp,%ecx
  801c69:	09 f1                	or     %esi,%ecx
  801c6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c6f:	89 f9                	mov    %edi,%ecx
  801c71:	d3 e0                	shl    %cl,%eax
  801c73:	89 c5                	mov    %eax,%ebp
  801c75:	89 d6                	mov    %edx,%esi
  801c77:	88 d9                	mov    %bl,%cl
  801c79:	d3 ee                	shr    %cl,%esi
  801c7b:	89 f9                	mov    %edi,%ecx
  801c7d:	d3 e2                	shl    %cl,%edx
  801c7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c83:	88 d9                	mov    %bl,%cl
  801c85:	d3 e8                	shr    %cl,%eax
  801c87:	09 c2                	or     %eax,%edx
  801c89:	89 d0                	mov    %edx,%eax
  801c8b:	89 f2                	mov    %esi,%edx
  801c8d:	f7 74 24 0c          	divl   0xc(%esp)
  801c91:	89 d6                	mov    %edx,%esi
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	f7 e5                	mul    %ebp
  801c97:	39 d6                	cmp    %edx,%esi
  801c99:	72 19                	jb     801cb4 <__udivdi3+0xfc>
  801c9b:	74 0b                	je     801ca8 <__udivdi3+0xf0>
  801c9d:	89 d8                	mov    %ebx,%eax
  801c9f:	31 ff                	xor    %edi,%edi
  801ca1:	e9 58 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cac:	89 f9                	mov    %edi,%ecx
  801cae:	d3 e2                	shl    %cl,%edx
  801cb0:	39 c2                	cmp    %eax,%edx
  801cb2:	73 e9                	jae    801c9d <__udivdi3+0xe5>
  801cb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cb7:	31 ff                	xor    %edi,%edi
  801cb9:	e9 40 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	31 c0                	xor    %eax,%eax
  801cc2:	e9 37 ff ff ff       	jmp    801bfe <__udivdi3+0x46>
  801cc7:	90                   	nop

00801cc8 <__umoddi3>:
  801cc8:	55                   	push   %ebp
  801cc9:	57                   	push   %edi
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 1c             	sub    $0x1c,%esp
  801ccf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ce7:	89 f3                	mov    %esi,%ebx
  801ce9:	89 fa                	mov    %edi,%edx
  801ceb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cef:	89 34 24             	mov    %esi,(%esp)
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	75 1a                	jne    801d10 <__umoddi3+0x48>
  801cf6:	39 f7                	cmp    %esi,%edi
  801cf8:	0f 86 a2 00 00 00    	jbe    801da0 <__umoddi3+0xd8>
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	89 f2                	mov    %esi,%edx
  801d02:	f7 f7                	div    %edi
  801d04:	89 d0                	mov    %edx,%eax
  801d06:	31 d2                	xor    %edx,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	39 f0                	cmp    %esi,%eax
  801d12:	0f 87 ac 00 00 00    	ja     801dc4 <__umoddi3+0xfc>
  801d18:	0f bd e8             	bsr    %eax,%ebp
  801d1b:	83 f5 1f             	xor    $0x1f,%ebp
  801d1e:	0f 84 ac 00 00 00    	je     801dd0 <__umoddi3+0x108>
  801d24:	bf 20 00 00 00       	mov    $0x20,%edi
  801d29:	29 ef                	sub    %ebp,%edi
  801d2b:	89 fe                	mov    %edi,%esi
  801d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d31:	89 e9                	mov    %ebp,%ecx
  801d33:	d3 e0                	shl    %cl,%eax
  801d35:	89 d7                	mov    %edx,%edi
  801d37:	89 f1                	mov    %esi,%ecx
  801d39:	d3 ef                	shr    %cl,%edi
  801d3b:	09 c7                	or     %eax,%edi
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 e2                	shl    %cl,%edx
  801d41:	89 14 24             	mov    %edx,(%esp)
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	d3 e0                	shl    %cl,%eax
  801d48:	89 c2                	mov    %eax,%edx
  801d4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d4e:	d3 e0                	shl    %cl,%eax
  801d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d58:	89 f1                	mov    %esi,%ecx
  801d5a:	d3 e8                	shr    %cl,%eax
  801d5c:	09 d0                	or     %edx,%eax
  801d5e:	d3 eb                	shr    %cl,%ebx
  801d60:	89 da                	mov    %ebx,%edx
  801d62:	f7 f7                	div    %edi
  801d64:	89 d3                	mov    %edx,%ebx
  801d66:	f7 24 24             	mull   (%esp)
  801d69:	89 c6                	mov    %eax,%esi
  801d6b:	89 d1                	mov    %edx,%ecx
  801d6d:	39 d3                	cmp    %edx,%ebx
  801d6f:	0f 82 87 00 00 00    	jb     801dfc <__umoddi3+0x134>
  801d75:	0f 84 91 00 00 00    	je     801e0c <__umoddi3+0x144>
  801d7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d7f:	29 f2                	sub    %esi,%edx
  801d81:	19 cb                	sbb    %ecx,%ebx
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d89:	d3 e0                	shl    %cl,%eax
  801d8b:	89 e9                	mov    %ebp,%ecx
  801d8d:	d3 ea                	shr    %cl,%edx
  801d8f:	09 d0                	or     %edx,%eax
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 eb                	shr    %cl,%ebx
  801d95:	89 da                	mov    %ebx,%edx
  801d97:	83 c4 1c             	add    $0x1c,%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    
  801d9f:	90                   	nop
  801da0:	89 fd                	mov    %edi,%ebp
  801da2:	85 ff                	test   %edi,%edi
  801da4:	75 0b                	jne    801db1 <__umoddi3+0xe9>
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	f7 f7                	div    %edi
  801daf:	89 c5                	mov    %eax,%ebp
  801db1:	89 f0                	mov    %esi,%eax
  801db3:	31 d2                	xor    %edx,%edx
  801db5:	f7 f5                	div    %ebp
  801db7:	89 c8                	mov    %ecx,%eax
  801db9:	f7 f5                	div    %ebp
  801dbb:	89 d0                	mov    %edx,%eax
  801dbd:	e9 44 ff ff ff       	jmp    801d06 <__umoddi3+0x3e>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	89 c8                	mov    %ecx,%eax
  801dc6:	89 f2                	mov    %esi,%edx
  801dc8:	83 c4 1c             	add    $0x1c,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
  801dd0:	3b 04 24             	cmp    (%esp),%eax
  801dd3:	72 06                	jb     801ddb <__umoddi3+0x113>
  801dd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dd9:	77 0f                	ja     801dea <__umoddi3+0x122>
  801ddb:	89 f2                	mov    %esi,%edx
  801ddd:	29 f9                	sub    %edi,%ecx
  801ddf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801de3:	89 14 24             	mov    %edx,(%esp)
  801de6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dee:	8b 14 24             	mov    (%esp),%edx
  801df1:	83 c4 1c             	add    $0x1c,%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
  801df9:	8d 76 00             	lea    0x0(%esi),%esi
  801dfc:	2b 04 24             	sub    (%esp),%eax
  801dff:	19 fa                	sbb    %edi,%edx
  801e01:	89 d1                	mov    %edx,%ecx
  801e03:	89 c6                	mov    %eax,%esi
  801e05:	e9 71 ff ff ff       	jmp    801d7b <__umoddi3+0xb3>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e10:	72 ea                	jb     801dfc <__umoddi3+0x134>
  801e12:	89 d9                	mov    %ebx,%ecx
  801e14:	e9 62 ff ff ff       	jmp    801d7b <__umoddi3+0xb3>


obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 c1 02 00 00       	call   8002f7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	rsttst();
  800044:	e8 d7 19 00 00       	call   801a20 <rsttst>
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800049:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80004f:	bb a1 20 80 00       	mov    $0x8020a1,%ebx
  800054:	ba 05 00 00 00       	mov    $0x5,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800061:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800067:	b9 14 00 00 00       	mov    $0x14,%ecx
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	89 d7                	mov    %edx,%edi
  800073:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800075:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	50                   	push   %eax
  80007f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	e8 ed 1a 00 00       	call   801b78 <sys_utilities>
  80008b:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  80008e:	e8 e6 16 00 00       	call   801779 <sys_calculate_free_frames>
  800093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800096:	e8 29 17 00 00       	call   8017c4 <sys_pf_calculate_allocated_pages>
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a4:	68 80 1e 80 00       	push   $0x801e80
  8000a9:	e8 c7 06 00 00       	call   800775 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("sc_fib_recursive", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000bc:	89 c2                	mov    %eax,%edx
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c9:	6a 32                	push   $0x32
  8000cb:	52                   	push   %edx
  8000cc:	50                   	push   %eax
  8000cd:	68 b3 1e 80 00       	push   $0x801eb3
  8000d2:	e8 fd 17 00 00       	call   8018d4 <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_fact_recursive", (myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f5:	c1 e0 02             	shl    $0x2,%eax
  8000f8:	6a 32                	push   $0x32
  8000fa:	52                   	push   %edx
  8000fb:	50                   	push   %eax
  8000fc:	68 c4 1e 80 00       	push   $0x801ec4
  800101:	e8 ce 17 00 00       	call   8018d4 <sys_create_env>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessC = sys_create_env("sc_fos_add",(myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 d6 1e 80 00       	push   $0x801ed6
  80012d:	e8 a2 17 00 00       	call   8018d4 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 af 17 00 00       	call   8018f2 <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d8             	pushl  -0x28(%ebp)
  80014c:	e8 a1 17 00 00       	call   8018f2 <sys_run_env>
  800151:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 93 17 00 00       	call   8018f2 <sys_run_env>
  80015f:	83 c4 10             	add    $0x10,%esp

	//env_sleep(6000);
	while (gettst() != 3) ;
  800162:	90                   	nop
  800163:	e8 32 19 00 00       	call   801a9a <gettst>
  800168:	83 f8 03             	cmp    $0x3,%eax
  80016b:	75 f6                	jne    800163 <_main+0x12b>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80016d:	e8 07 16 00 00       	call   801779 <sys_calculate_free_frames>
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	68 e4 1e 80 00       	push   $0x801ee4
  80017b:	e8 f5 05 00 00       	call   800775 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800183:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 df 19 00 00       	call   801b78 <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80019c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001a2:	bb 05 21 80 00       	mov    $0x802105,%ebx
  8001a7:	ba 1a 00 00 00       	mov    $0x1a,%edx
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 de                	mov    %ebx,%esi
  8001b0:	89 d1                	mov    %edx,%ecx
  8001b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b4:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001ba:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001bf:	b0 00                	mov    $0x0,%al
  8001c1:	89 d7                	mov    %edx,%edi
  8001c3:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	6a 00                	push   $0x0
  8001ca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 a2 19 00 00       	call   801b78 <sys_utilities>
  8001d6:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001df:	e8 2a 17 00 00       	call   80190e <sys_destroy_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ed:	e8 1c 17 00 00       	call   80190e <sys_destroy_env>
  8001f2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessC);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001fb:	e8 0e 17 00 00       	call   80190e <sys_destroy_env>
  800200:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	6a 01                	push   $0x1
  800208:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	e8 64 19 00 00       	call   801b78 <sys_utilities>
  800214:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800217:	e8 5d 15 00 00       	call   801779 <sys_calculate_free_frames>
  80021c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80021f:	e8 a0 15 00 00       	call   8017c4 <sys_pf_calculate_allocated_pages>
  800224:	89 45 cc             	mov    %eax,-0x34(%ebp)

	cprintf("\n---# of free frames after KILLING programs = %d\n", sys_calculate_free_frames());
  800227:	e8 4d 15 00 00       	call   801779 <sys_calculate_free_frames>
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 18 1f 80 00       	push   $0x801f18
  800235:	e8 3b 05 00 00       	call   800775 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80023d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800244:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80024a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	48                   	dec    %eax
  800250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	f7 75 c8             	divl   -0x38(%ebp)
  80025e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800261:	29 d0                	sub    %edx,%eax
  800263:	89 c1                	mov    %eax,%ecx
  800265:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80026c:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800272:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	48                   	dec    %eax
  800278:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80027b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	f7 75 c0             	divl   -0x40(%ebp)
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	29 d0                	sub    %edx,%eax
  80028b:	29 c1                	sub    %eax,%ecx
  80028d:	89 c8                	mov    %ecx,%eax
  80028f:	c1 e8 0c             	shr    $0xc,%eax
  800292:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if ((freeFrames_before - freeFrames_after) != expected) {
  800295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800298:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80029b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80029e:	74 2e                	je     8002ce <_main+0x296>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  8002a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a6:	ff 75 b8             	pushl  -0x48(%ebp)
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ad:	68 4c 1f 80 00       	push   $0x801f4c
  8002b2:	e8 be 04 00 00       	call   800775 <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 bc 1f 80 00       	push   $0x801fbc
  8002c2:	6a 3e                	push   $0x3e
  8002c4:	68 f2 1f 80 00       	push   $0x801ff2
  8002c9:	e8 d9 01 00 00       	call   8004a7 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	68 08 20 80 00       	push   $0x802008
  8002d6:	e8 9a 04 00 00       	call   800775 <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	68 58 20 80 00       	push   $0x802058
  8002e6:	e8 8a 04 00 00       	call   800775 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ee:	90                   	nop
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800300:	e8 3d 16 00 00       	call   801942 <sys_getenvindex>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	c1 e0 02             	shl    $0x2,%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80031e:	01 d0                	add    %edx,%eax
  800320:	c1 e0 02             	shl    $0x2,%eax
  800323:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800328:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80032d:	a1 20 30 80 00       	mov    0x803020,%eax
  800332:	8a 40 20             	mov    0x20(%eax),%al
  800335:	84 c0                	test   %al,%al
  800337:	74 0d                	je     800346 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	83 c0 20             	add    $0x20,%eax
  800341:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80034a:	7e 0a                	jle    800356 <libmain+0x5f>
		binaryname = argv[0];
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 d4 fc ff ff       	call   800038 <_main>
  800364:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800367:	a1 00 30 80 00       	mov    0x803000,%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	0f 84 01 01 00 00    	je     800475 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800374:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80037a:	bb 64 22 80 00       	mov    $0x802264,%ebx
  80037f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800384:	89 c7                	mov    %eax,%edi
  800386:	89 de                	mov    %ebx,%esi
  800388:	89 d1                	mov    %edx,%ecx
  80038a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80038c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80038f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800394:	b0 00                	mov    $0x0,%al
  800396:	89 d7                	mov    %edx,%edi
  800398:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80039a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	50                   	push   %eax
  8003a8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003ae:	50                   	push   %eax
  8003af:	e8 c4 17 00 00       	call   801b78 <sys_utilities>
  8003b4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003b7:	e8 0d 13 00 00       	call   8016c9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	68 84 21 80 00       	push   $0x802184
  8003c4:	e8 ac 03 00 00       	call   800775 <cprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	74 18                	je     8003eb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003d3:	e8 be 17 00 00       	call   801b96 <sys_get_optimal_num_faults>
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	50                   	push   %eax
  8003dc:	68 ac 21 80 00       	push   $0x8021ac
  8003e1:	e8 8f 03 00 00       	call   800775 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	eb 59                	jmp    800444 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	52                   	push   %edx
  800405:	50                   	push   %eax
  800406:	68 d0 21 80 00       	push   $0x8021d0
  80040b:	e8 65 03 00 00       	call   800775 <cprintf>
  800410:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800413:	a1 20 30 80 00       	mov    0x803020,%eax
  800418:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800429:	a1 20 30 80 00       	mov    0x803020,%eax
  80042e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800434:	51                   	push   %ecx
  800435:	52                   	push   %edx
  800436:	50                   	push   %eax
  800437:	68 f8 21 80 00       	push   $0x8021f8
  80043c:	e8 34 03 00 00       	call   800775 <cprintf>
  800441:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800444:	a1 20 30 80 00       	mov    0x803020,%eax
  800449:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	50                   	push   %eax
  800453:	68 50 22 80 00       	push   $0x802250
  800458:	e8 18 03 00 00       	call   800775 <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	68 84 21 80 00       	push   $0x802184
  800468:	e8 08 03 00 00       	call   800775 <cprintf>
  80046d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800470:	e8 6e 12 00 00       	call   8016e3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800475:	e8 1f 00 00 00       	call   800499 <exit>
}
  80047a:	90                   	nop
  80047b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047e:	5b                   	pop    %ebx
  80047f:	5e                   	pop    %esi
  800480:	5f                   	pop    %edi
  800481:	5d                   	pop    %ebp
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 7b 14 00 00       	call   80190e <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 d0 14 00 00       	call   801974 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 c8 22 80 00       	push   $0x8022c8
  8004cd:	e8 a3 02 00 00       	call   800775 <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004da:	83 ec 0c             	sub    $0xc,%esp
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	68 d0 22 80 00       	push   $0x8022d0
  8004e9:	6a 74                	push   $0x74
  8004eb:	e8 b2 02 00 00       	call   8007a2 <cprintf_colored>
  8004f0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	50                   	push   %eax
  8004fd:	e8 04 02 00 00       	call   800706 <vcprintf>
  800502:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	6a 00                	push   $0x0
  80050a:	68 f8 22 80 00       	push   $0x8022f8
  80050f:	e8 f2 01 00 00       	call   800706 <vcprintf>
  800514:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800517:	e8 7d ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  80051c:	eb fe                	jmp    80051c <_panic+0x75>

0080051e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800524:	a1 20 30 80 00       	mov    0x803020,%eax
  800529:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80052f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800532:	39 c2                	cmp    %eax,%edx
  800534:	74 14                	je     80054a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800536:	83 ec 04             	sub    $0x4,%esp
  800539:	68 fc 22 80 00       	push   $0x8022fc
  80053e:	6a 26                	push   $0x26
  800540:	68 48 23 80 00       	push   $0x802348
  800545:	e8 5d ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80054a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	e9 c5 00 00 00       	jmp    800622 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80055d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800560:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	85 c0                	test   %eax,%eax
  800570:	75 08                	jne    80057a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800572:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800575:	e9 a5 00 00 00       	jmp    80061f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80057a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800581:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800588:	eb 69                	jmp    8005f3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80058a:	a1 20 30 80 00       	mov    0x803020,%eax
  80058f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800598:	89 d0                	mov    %edx,%eax
  80059a:	01 c0                	add    %eax,%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c1 e0 03             	shl    $0x3,%eax
  8005a1:	01 c8                	add    %ecx,%eax
  8005a3:	8a 40 04             	mov    0x4(%eax),%al
  8005a6:	84 c0                	test   %al,%al
  8005a8:	75 46                	jne    8005f0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8005af:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	01 c0                	add    %eax,%eax
  8005bc:	01 d0                	add    %edx,%eax
  8005be:	c1 e0 03             	shl    $0x3,%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	01 c8                	add    %ecx,%eax
  8005e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	75 09                	jne    8005f0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ee:	eb 15                	jmp    800605 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	ff 45 e8             	incl   -0x18(%ebp)
  8005f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	39 c2                	cmp    %eax,%edx
  800603:	77 85                	ja     80058a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800605:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800609:	75 14                	jne    80061f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	68 54 23 80 00       	push   $0x802354
  800613:	6a 3a                	push   $0x3a
  800615:	68 48 23 80 00       	push   $0x802348
  80061a:	e8 88 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80061f:	ff 45 f0             	incl   -0x10(%ebp)
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800625:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800628:	0f 8c 2f ff ff ff    	jl     80055d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80062e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800635:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80063c:	eb 26                	jmp    800664 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80063e:	a1 20 30 80 00       	mov    0x803020,%eax
  800643:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800649:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	c1 e0 03             	shl    $0x3,%eax
  800655:	01 c8                	add    %ecx,%eax
  800657:	8a 40 04             	mov    0x4(%eax),%al
  80065a:	3c 01                	cmp    $0x1,%al
  80065c:	75 03                	jne    800661 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80065e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800661:	ff 45 e0             	incl   -0x20(%ebp)
  800664:	a1 20 30 80 00       	mov    0x803020,%eax
  800669:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80066f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800672:	39 c2                	cmp    %eax,%edx
  800674:	77 c8                	ja     80063e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800679:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80067c:	74 14                	je     800692 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	68 a8 23 80 00       	push   $0x8023a8
  800686:	6a 44                	push   $0x44
  800688:	68 48 23 80 00       	push   $0x802348
  80068d:	e8 15 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800692:	90                   	nop
  800693:	c9                   	leave  
  800694:	c3                   	ret    

00800695 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
  800698:	53                   	push   %ebx
  800699:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	89 0a                	mov    %ecx,(%edx)
  8006a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ac:	88 d1                	mov    %dl,%cl
  8006ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bf:	75 30                	jne    8006f1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006c1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006c7:	a0 44 30 80 00       	mov    0x803044,%al
  8006cc:	0f b6 c0             	movzbl %al,%eax
  8006cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d2:	8b 09                	mov    (%ecx),%ecx
  8006d4:	89 cb                	mov    %ecx,%ebx
  8006d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d9:	83 c1 08             	add    $0x8,%ecx
  8006dc:	52                   	push   %edx
  8006dd:	50                   	push   %eax
  8006de:	53                   	push   %ebx
  8006df:	51                   	push   %ecx
  8006e0:	e8 a0 0f 00 00       	call   801685 <sys_cputs>
  8006e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 40 04             	mov    0x4(%eax),%eax
  8006f7:	8d 50 01             	lea    0x1(%eax),%edx
  8006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800700:	90                   	nop
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800716:	00 00 00 
	b.cnt = 0;
  800719:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800720:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072f:	50                   	push   %eax
  800730:	68 95 06 80 00       	push   $0x800695
  800735:	e8 5a 02 00 00       	call   800994 <vprintfmt>
  80073a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80073d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800743:	a0 44 30 80 00       	mov    0x803044,%al
  800748:	0f b6 c0             	movzbl %al,%eax
  80074b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	51                   	push   %ecx
  800754:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075a:	83 c0 08             	add    $0x8,%eax
  80075d:	50                   	push   %eax
  80075e:	e8 22 0f 00 00       	call   801685 <sys_cputs>
  800763:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800766:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80076d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800782:	8d 45 0c             	lea    0xc(%ebp),%eax
  800785:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 f4             	pushl  -0xc(%ebp)
  800791:	50                   	push   %eax
  800792:	e8 6f ff ff ff       	call   800706 <vcprintf>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	c1 e0 08             	shl    $0x8,%eax
  8007b5:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	e8 34 ff ff ff       	call   800706 <vcprintf>
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d8:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007df:	07 00 00 

	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007ed:	e8 d7 0e 00 00       	call   8016c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800801:	50                   	push   %eax
  800802:	e8 ff fe ff ff       	call   800706 <vcprintf>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80080d:	e8 d1 0e 00 00       	call   8016e3 <sys_unlock_cons>
	return cnt;
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 14             	sub    $0x14,%esp
  80081e:	8b 45 10             	mov    0x10(%ebp),%eax
  800821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80082a:	8b 45 18             	mov    0x18(%ebp),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800835:	77 55                	ja     80088c <printnum+0x75>
  800837:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083a:	72 05                	jb     800841 <printnum+0x2a>
  80083c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083f:	77 4b                	ja     80088c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800841:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800844:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800847:	8b 45 18             	mov    0x18(%ebp),%eax
  80084a:	ba 00 00 00 00       	mov    $0x0,%edx
  80084f:	52                   	push   %edx
  800850:	50                   	push   %eax
  800851:	ff 75 f4             	pushl  -0xc(%ebp)
  800854:	ff 75 f0             	pushl  -0x10(%ebp)
  800857:	e8 a8 13 00 00       	call   801c04 <__udivdi3>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	ff 75 20             	pushl  0x20(%ebp)
  800865:	53                   	push   %ebx
  800866:	ff 75 18             	pushl  0x18(%ebp)
  800869:	52                   	push   %edx
  80086a:	50                   	push   %eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 a1 ff ff ff       	call   800817 <printnum>
  800876:	83 c4 20             	add    $0x20,%esp
  800879:	eb 1a                	jmp    800895 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 20             	pushl  0x20(%ebp)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088c:	ff 4d 1c             	decl   0x1c(%ebp)
  80088f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800893:	7f e6                	jg     80087b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800895:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800898:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a3:	53                   	push   %ebx
  8008a4:	51                   	push   %ecx
  8008a5:	52                   	push   %edx
  8008a6:	50                   	push   %eax
  8008a7:	e8 68 14 00 00       	call   801d14 <__umoddi3>
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	05 14 26 80 00       	add    $0x802614,%eax
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
}
  8008c8:	90                   	nop
  8008c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d5:	7e 1c                	jle    8008f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	8d 50 08             	lea    0x8(%eax),%edx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	89 10                	mov    %edx,(%eax)
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	83 e8 08             	sub    $0x8,%eax
  8008ec:	8b 50 04             	mov    0x4(%eax),%edx
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	eb 40                	jmp    800933 <getuint+0x65>
	else if (lflag)
  8008f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f7:	74 1e                	je     800917 <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  800915:	eb 1c                	jmp    800933 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8d 50 04             	lea    0x4(%eax),%edx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	89 10                	mov    %edx,(%eax)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800938:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093c:	7e 1c                	jle    80095a <getint+0x25>
		return va_arg(*ap, long long);
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	8d 50 08             	lea    0x8(%eax),%edx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	89 10                	mov    %edx,(%eax)
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	83 e8 08             	sub    $0x8,%eax
  800953:	8b 50 04             	mov    0x4(%eax),%edx
  800956:	8b 00                	mov    (%eax),%eax
  800958:	eb 38                	jmp    800992 <getint+0x5d>
	else if (lflag)
  80095a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095e:	74 1a                	je     80097a <getint+0x45>
		return va_arg(*ap, long);
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	8d 50 04             	lea    0x4(%eax),%edx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	89 10                	mov    %edx,(%eax)
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	99                   	cltd   
  800978:	eb 18                	jmp    800992 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	8d 50 04             	lea    0x4(%eax),%edx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 10                	mov    %edx,(%eax)
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	83 e8 04             	sub    $0x4,%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	99                   	cltd   
}
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099c:	eb 17                	jmp    8009b5 <vprintfmt+0x21>
			if (ch == '\0')
  80099e:	85 db                	test   %ebx,%ebx
  8009a0:	0f 84 c1 03 00 00    	je     800d67 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8d 50 01             	lea    0x1(%eax),%edx
  8009bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8009be:	8a 00                	mov    (%eax),%al
  8009c0:	0f b6 d8             	movzbl %al,%ebx
  8009c3:	83 fb 25             	cmp    $0x25,%ebx
  8009c6:	75 d6                	jne    80099e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f1:	8a 00                	mov    (%eax),%al
  8009f3:	0f b6 d8             	movzbl %al,%ebx
  8009f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f9:	83 f8 5b             	cmp    $0x5b,%eax
  8009fc:	0f 87 3d 03 00 00    	ja     800d3f <vprintfmt+0x3ab>
  800a02:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800a09:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0f:	eb d7                	jmp    8009e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a11:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a15:	eb d1                	jmp    8009e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	c1 e0 02             	shl    $0x2,%eax
  800a26:	01 d0                	add    %edx,%eax
  800a28:	01 c0                	add    %eax,%eax
  800a2a:	01 d8                	add    %ebx,%eax
  800a2c:	83 e8 30             	sub    $0x30,%eax
  800a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3d:	7e 3e                	jle    800a7d <vprintfmt+0xe9>
  800a3f:	83 fb 39             	cmp    $0x39,%ebx
  800a42:	7f 39                	jg     800a7d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a44:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a47:	eb d5                	jmp    800a1e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 c0 04             	add    $0x4,%eax
  800a4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	83 e8 04             	sub    $0x4,%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5d:	eb 1f                	jmp    800a7e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	79 83                	jns    8009e8 <vprintfmt+0x54>
				width = 0;
  800a65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6c:	e9 77 ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a71:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a78:	e9 6b ff ff ff       	jmp    8009e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a82:	0f 89 60 ff ff ff    	jns    8009e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a95:	e9 4e ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a9a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9d:	e9 46 ff ff ff       	jmp    8009e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 c0 04             	add    $0x4,%eax
  800aa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	50                   	push   %eax
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
			break;
  800ac2:	e9 9b 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad8:	85 db                	test   %ebx,%ebx
  800ada:	79 02                	jns    800ade <vprintfmt+0x14a>
				err = -err;
  800adc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ade:	83 fb 64             	cmp    $0x64,%ebx
  800ae1:	7f 0b                	jg     800aee <vprintfmt+0x15a>
  800ae3:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800aea:	85 f6                	test   %esi,%esi
  800aec:	75 19                	jne    800b07 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aee:	53                   	push   %ebx
  800aef:	68 25 26 80 00       	push   $0x802625
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	ff 75 08             	pushl  0x8(%ebp)
  800afa:	e8 70 02 00 00       	call   800d6f <printfmt>
  800aff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b02:	e9 5b 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b07:	56                   	push   %esi
  800b08:	68 2e 26 80 00       	push   $0x80262e
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	ff 75 08             	pushl  0x8(%ebp)
  800b13:	e8 57 02 00 00       	call   800d6f <printfmt>
  800b18:	83 c4 10             	add    $0x10,%esp
			break;
  800b1b:	e9 42 02 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b20:	8b 45 14             	mov    0x14(%ebp),%eax
  800b23:	83 c0 04             	add    $0x4,%eax
  800b26:	89 45 14             	mov    %eax,0x14(%ebp)
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 30                	mov    (%eax),%esi
  800b31:	85 f6                	test   %esi,%esi
  800b33:	75 05                	jne    800b3a <vprintfmt+0x1a6>
				p = "(null)";
  800b35:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3e:	7e 6d                	jle    800bad <vprintfmt+0x219>
  800b40:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b44:	74 67                	je     800bad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	50                   	push   %eax
  800b4d:	56                   	push   %esi
  800b4e:	e8 1e 03 00 00       	call   800e71 <strnlen>
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b59:	eb 16                	jmp    800b71 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	50                   	push   %eax
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b75:	7f e4                	jg     800b5b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b77:	eb 34                	jmp    800bad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7d:	74 1c                	je     800b9b <vprintfmt+0x207>
  800b7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b82:	7e 05                	jle    800b89 <vprintfmt+0x1f5>
  800b84:	83 fb 7e             	cmp    $0x7e,%ebx
  800b87:	7e 12                	jle    800b9b <vprintfmt+0x207>
					putch('?', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 3f                	push   $0x3f
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	53                   	push   %ebx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800baa:	ff 4d e4             	decl   -0x1c(%ebp)
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	8d 70 01             	lea    0x1(%eax),%esi
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	0f be d8             	movsbl %al,%ebx
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	74 24                	je     800bdf <vprintfmt+0x24b>
  800bbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbf:	78 b8                	js     800b79 <vprintfmt+0x1e5>
  800bc1:	ff 4d e0             	decl   -0x20(%ebp)
  800bc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc8:	79 af                	jns    800b79 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bca:	eb 13                	jmp    800bdf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	6a 20                	push   $0x20
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be3:	7f e7                	jg     800bcc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be5:	e9 78 01 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bea:	83 ec 08             	sub    $0x8,%esp
  800bed:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf3:	50                   	push   %eax
  800bf4:	e8 3c fd ff ff       	call   800935 <getint>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c08:	85 d2                	test   %edx,%edx
  800c0a:	79 23                	jns    800c2f <vprintfmt+0x29b>
				putch('-', putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	6a 2d                	push   $0x2d
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	ff d0                	call   *%eax
  800c19:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c22:	f7 d8                	neg    %eax
  800c24:	83 d2 00             	adc    $0x0,%edx
  800c27:	f7 da                	neg    %edx
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c36:	e9 bc 00 00 00       	jmp    800cf7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c41:	8d 45 14             	lea    0x14(%ebp),%eax
  800c44:	50                   	push   %eax
  800c45:	e8 84 fc ff ff       	call   8008ce <getuint>
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c53:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5a:	e9 98 00 00 00       	jmp    800cf7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 58                	push   $0x58
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 58                	push   $0x58
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			break;
  800c8f:	e9 ce 00 00 00       	jmp    800d62 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 30                	push   $0x30
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	6a 78                	push   $0x78
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	ff d0                	call   *%eax
  800cb1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 c0 04             	add    $0x4,%eax
  800cba:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ccf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd6:	eb 1f                	jmp    800cf7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cde:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce1:	50                   	push   %eax
  800ce2:	e8 e7 fb ff ff       	call   8008ce <getuint>
  800ce7:	83 c4 10             	add    $0x10,%esp
  800cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ced:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	83 ec 04             	sub    $0x4,%esp
  800d01:	52                   	push   %edx
  800d02:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 f4             	pushl  -0xc(%ebp)
  800d09:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 00 fb ff ff       	call   800817 <printnum>
  800d17:	83 c4 20             	add    $0x20,%esp
			break;
  800d1a:	eb 46                	jmp    800d62 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	53                   	push   %ebx
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	ff d0                	call   *%eax
  800d28:	83 c4 10             	add    $0x10,%esp
			break;
  800d2b:	eb 35                	jmp    800d62 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d2d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d34:	eb 2c                	jmp    800d62 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d36:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d3d:	eb 23                	jmp    800d62 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	6a 25                	push   $0x25
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4f:	ff 4d 10             	decl   0x10(%ebp)
  800d52:	eb 03                	jmp    800d57 <vprintfmt+0x3c3>
  800d54:	ff 4d 10             	decl   0x10(%ebp)
  800d57:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5a:	48                   	dec    %eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3c 25                	cmp    $0x25,%al
  800d5f:	75 f3                	jne    800d54 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d61:	90                   	nop
		}
	}
  800d62:	e9 35 fc ff ff       	jmp    80099c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d67:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d75:	8d 45 10             	lea    0x10(%ebp),%eax
  800d78:	83 c0 04             	add    $0x4,%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	ff 75 f4             	pushl  -0xc(%ebp)
  800d84:	50                   	push   %eax
  800d85:	ff 75 0c             	pushl  0xc(%ebp)
  800d88:	ff 75 08             	pushl  0x8(%ebp)
  800d8b:	e8 04 fc ff ff       	call   800994 <vprintfmt>
  800d90:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d93:	90                   	nop
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 40 08             	mov    0x8(%eax),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 10                	mov    (%eax),%edx
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8b 40 04             	mov    0x4(%eax),%eax
  800db3:	39 c2                	cmp    %eax,%edx
  800db5:	73 12                	jae    800dc9 <sprintputch+0x33>
		*b->buf++ = ch;
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc2:	89 0a                	mov    %ecx,(%edx)
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	88 10                	mov    %dl,(%eax)
}
  800dc9:	90                   	nop
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	01 d0                	add    %edx,%eax
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ded:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df1:	74 06                	je     800df9 <vsnprintf+0x2d>
  800df3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df7:	7f 07                	jg     800e00 <vsnprintf+0x34>
		return -E_INVAL;
  800df9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfe:	eb 20                	jmp    800e20 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e00:	ff 75 14             	pushl  0x14(%ebp)
  800e03:	ff 75 10             	pushl  0x10(%ebp)
  800e06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e09:	50                   	push   %eax
  800e0a:	68 96 0d 80 00       	push   $0x800d96
  800e0f:	e8 80 fb ff ff       	call   800994 <vprintfmt>
  800e14:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e28:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2b:	83 c0 04             	add    $0x4,%eax
  800e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	ff 75 f4             	pushl  -0xc(%ebp)
  800e37:	50                   	push   %eax
  800e38:	ff 75 0c             	pushl  0xc(%ebp)
  800e3b:	ff 75 08             	pushl  0x8(%ebp)
  800e3e:	e8 89 ff ff ff       	call   800dcc <vsnprintf>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5b:	eb 06                	jmp    800e63 <strlen+0x15>
		n++;
  800e5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e60:	ff 45 08             	incl   0x8(%ebp)
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	75 f1                	jne    800e5d <strlen+0xf>
		n++;
	return n;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7e:	eb 09                	jmp    800e89 <strnlen+0x18>
		n++;
  800e80:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	ff 4d 0c             	decl   0xc(%ebp)
  800e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8d:	74 09                	je     800e98 <strnlen+0x27>
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	84 c0                	test   %al,%al
  800e96:	75 e8                	jne    800e80 <strnlen+0xf>
		n++;
	return n;
  800e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea9:	90                   	nop
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebc:	8a 12                	mov    (%edx),%dl
  800ebe:	88 10                	mov    %dl,(%eax)
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	84 c0                	test   %al,%al
  800ec4:	75 e4                	jne    800eaa <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ede:	eb 1f                	jmp    800eff <strncpy+0x34>
		*dst++ = *src;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8d 50 01             	lea    0x1(%eax),%edx
  800ee6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	74 03                	je     800efc <strncpy+0x31>
			src++;
  800ef9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efc:	ff 45 fc             	incl   -0x4(%ebp)
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f05:	72 d9                	jb     800ee0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1c:	74 30                	je     800f4e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1e:	eb 16                	jmp    800f36 <strlcpy+0x2a>
			*dst++ = *src++;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 08             	mov    %edx,0x8(%ebp)
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f32:	8a 12                	mov    (%edx),%dl
  800f34:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f36:	ff 4d 10             	decl   0x10(%ebp)
  800f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3d:	74 09                	je     800f48 <strlcpy+0x3c>
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	75 d8                	jne    800f20 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5d:	eb 06                	jmp    800f65 <strcmp+0xb>
		p++, q++;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	84 c0                	test   %al,%al
  800f6c:	74 0e                	je     800f7c <strcmp+0x22>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 10                	mov    (%eax),%dl
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	38 c2                	cmp    %al,%dl
  800f7a:	74 e3                	je     800f5f <strcmp+0x5>
		p++, q++;
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

00800f92 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f95:	eb 09                	jmp    800fa0 <strncmp+0xe>
		n--, p++, q++;
  800f97:	ff 4d 10             	decl   0x10(%ebp)
  800f9a:	ff 45 08             	incl   0x8(%ebp)
  800f9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 17                	je     800fbd <strncmp+0x2b>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	74 0e                	je     800fbd <strncmp+0x2b>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 10                	mov    (%eax),%dl
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	38 c2                	cmp    %al,%dl
  800fbb:	74 da                	je     800f97 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc1:	75 07                	jne    800fca <strncmp+0x38>
		return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc8:	eb 14                	jmp    800fde <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f b6 d0             	movzbl %al,%edx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f b6 c0             	movzbl %al,%eax
  800fda:	29 c2                	sub    %eax,%edx
  800fdc:	89 d0                	mov    %edx,%eax
}
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 04             	sub    $0x4,%esp
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fec:	eb 12                	jmp    801000 <strchr+0x20>
		if (*s == c)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff6:	75 05                	jne    800ffd <strchr+0x1d>
			return (char *) s;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	eb 11                	jmp    80100e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	75 e5                	jne    800fee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101c:	eb 0d                	jmp    80102b <strfind+0x1b>
		if (*s == c)
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801026:	74 0e                	je     801036 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801028:	ff 45 08             	incl   0x8(%ebp)
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	84 c0                	test   %al,%al
  801032:	75 ea                	jne    80101e <strfind+0xe>
  801034:	eb 01                	jmp    801037 <strfind+0x27>
		if (*s == c)
			break;
  801036:	90                   	nop
	return (char *) s;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801048:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80104c:	76 63                	jbe    8010b1 <memset+0x75>
		uint64 data_block = c;
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	99                   	cltd   
  801052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801055:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801062:	c1 e0 08             	shl    $0x8,%eax
  801065:	09 45 f0             	or     %eax,-0x10(%ebp)
  801068:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80106b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801071:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801075:	c1 e0 10             	shl    $0x10,%eax
  801078:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	89 c2                	mov    %eax,%edx
  801086:	b8 00 00 00 00       	mov    $0x0,%eax
  80108b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80108e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801091:	eb 18                	jmp    8010ab <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801093:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801096:	8d 41 08             	lea    0x8(%ecx),%eax
  801099:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a2:	89 01                	mov    %eax,(%ecx)
  8010a4:	89 51 04             	mov    %edx,0x4(%ecx)
  8010a7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010af:	77 e2                	ja     801093 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 23                	je     8010da <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010bd:	eb 0e                	jmp    8010cd <memset+0x91>
			*p8++ = (uint8)c;
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 e5                	jne    8010bf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010f1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f5:	76 24                	jbe    80111b <memcpy+0x3c>
		while(n >= 8){
  8010f7:	eb 1c                	jmp    801115 <memcpy+0x36>
			*d64 = *s64;
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	8b 50 04             	mov    0x4(%eax),%edx
  8010ff:	8b 00                	mov    (%eax),%eax
  801101:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801104:	89 01                	mov    %eax,(%ecx)
  801106:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801109:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80110d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801111:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801115:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801119:	77 de                	ja     8010f9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	74 31                	je     801152 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80112d:	eb 16                	jmp    801145 <memcpy+0x66>
			*d8++ = *s8++;
  80112f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801141:	8a 12                	mov    (%edx),%dl
  801143:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114b:	89 55 10             	mov    %edx,0x10(%ebp)
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 dd                	jne    80112f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116f:	73 50                	jae    8011c1 <memmove+0x6a>
  801171:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80117c:	76 43                	jbe    8011c1 <memmove+0x6a>
		s += n;
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80118a:	eb 10                	jmp    80119c <memmove+0x45>
			*--d = *--s;
  80118c:	ff 4d f8             	decl   -0x8(%ebp)
  80118f:	ff 4d fc             	decl   -0x4(%ebp)
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	8a 10                	mov    (%eax),%dl
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	75 e3                	jne    80118c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a9:	eb 23                	jmp    8011ce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	8d 50 01             	lea    0x1(%eax),%edx
  8011b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011bd:	8a 12                	mov    (%edx),%dl
  8011bf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	75 dd                	jne    8011ab <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011e5:	eb 2a                	jmp    801211 <memcmp+0x3e>
		if (*s1 != *s2)
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8a 10                	mov    (%eax),%dl
  8011ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	38 c2                	cmp    %al,%dl
  8011f3:	74 16                	je     80120b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f b6 d0             	movzbl %al,%edx
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f b6 c0             	movzbl %al,%eax
  801205:	29 c2                	sub    %eax,%edx
  801207:	89 d0                	mov    %edx,%eax
  801209:	eb 18                	jmp    801223 <memcmp+0x50>
		s1++, s2++;
  80120b:	ff 45 fc             	incl   -0x4(%ebp)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	8d 50 ff             	lea    -0x1(%eax),%edx
  801217:	89 55 10             	mov    %edx,0x10(%ebp)
  80121a:	85 c0                	test   %eax,%eax
  80121c:	75 c9                	jne    8011e7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	8b 45 10             	mov    0x10(%ebp),%eax
  801231:	01 d0                	add    %edx,%eax
  801233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801236:	eb 15                	jmp    80124d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f b6 d0             	movzbl %al,%edx
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	0f b6 c0             	movzbl %al,%eax
  801246:	39 c2                	cmp    %eax,%edx
  801248:	74 0d                	je     801257 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80124a:	ff 45 08             	incl   0x8(%ebp)
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801253:	72 e3                	jb     801238 <memfind+0x13>
  801255:	eb 01                	jmp    801258 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801257:	90                   	nop
	return (void *) s;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80126a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801271:	eb 03                	jmp    801276 <strtol+0x19>
		s++;
  801273:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 20                	cmp    $0x20,%al
  80127d:	74 f4                	je     801273 <strtol+0x16>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 09                	cmp    $0x9,%al
  801286:	74 eb                	je     801273 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 2b                	cmp    $0x2b,%al
  80128f:	75 05                	jne    801296 <strtol+0x39>
		s++;
  801291:	ff 45 08             	incl   0x8(%ebp)
  801294:	eb 13                	jmp    8012a9 <strtol+0x4c>
	else if (*s == '-')
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 2d                	cmp    $0x2d,%al
  80129d:	75 0a                	jne    8012a9 <strtol+0x4c>
		s++, neg = 1;
  80129f:	ff 45 08             	incl   0x8(%ebp)
  8012a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ad:	74 06                	je     8012b5 <strtol+0x58>
  8012af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012b3:	75 20                	jne    8012d5 <strtol+0x78>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 30                	cmp    $0x30,%al
  8012bc:	75 17                	jne    8012d5 <strtol+0x78>
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	40                   	inc    %eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 78                	cmp    $0x78,%al
  8012c6:	75 0d                	jne    8012d5 <strtol+0x78>
		s += 2, base = 16;
  8012c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012d3:	eb 28                	jmp    8012fd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d9:	75 15                	jne    8012f0 <strtol+0x93>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	3c 30                	cmp    $0x30,%al
  8012e2:	75 0c                	jne    8012f0 <strtol+0x93>
		s++, base = 8;
  8012e4:	ff 45 08             	incl   0x8(%ebp)
  8012e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ee:	eb 0d                	jmp    8012fd <strtol+0xa0>
	else if (base == 0)
  8012f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f4:	75 07                	jne    8012fd <strtol+0xa0>
		base = 10;
  8012f6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	3c 2f                	cmp    $0x2f,%al
  801304:	7e 19                	jle    80131f <strtol+0xc2>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3c 39                	cmp    $0x39,%al
  80130d:	7f 10                	jg     80131f <strtol+0xc2>
			dig = *s - '0';
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f be c0             	movsbl %al,%eax
  801317:	83 e8 30             	sub    $0x30,%eax
  80131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131d:	eb 42                	jmp    801361 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 60                	cmp    $0x60,%al
  801326:	7e 19                	jle    801341 <strtol+0xe4>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 7a                	cmp    $0x7a,%al
  80132f:	7f 10                	jg     801341 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f be c0             	movsbl %al,%eax
  801339:	83 e8 57             	sub    $0x57,%eax
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133f:	eb 20                	jmp    801361 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3c 40                	cmp    $0x40,%al
  801348:	7e 39                	jle    801383 <strtol+0x126>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3c 5a                	cmp    $0x5a,%al
  801351:	7f 30                	jg     801383 <strtol+0x126>
			dig = *s - 'A' + 10;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be c0             	movsbl %al,%eax
  80135b:	83 e8 37             	sub    $0x37,%eax
  80135e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	3b 45 10             	cmp    0x10(%ebp),%eax
  801367:	7d 19                	jge    801382 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801369:	ff 45 08             	incl   0x8(%ebp)
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80137d:	e9 7b ff ff ff       	jmp    8012fd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801382:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801383:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801387:	74 08                	je     801391 <strtol+0x134>
		*endptr = (char *) s;
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801391:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801395:	74 07                	je     80139e <strtol+0x141>
  801397:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139a:	f7 d8                	neg    %eax
  80139c:	eb 03                	jmp    8013a1 <strtol+0x144>
  80139e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bb:	79 13                	jns    8013d0 <ltostr+0x2d>
	{
		neg = 1;
  8013bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d8:	99                   	cltd   
  8013d9:	f7 f9                	idiv   %ecx
  8013db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e1:	8d 50 01             	lea    0x1(%eax),%edx
  8013e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e7:	89 c2                	mov    %eax,%edx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f1:	83 c2 30             	add    $0x30,%edx
  8013f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013fe:	f7 e9                	imul   %ecx
  801400:	c1 fa 02             	sar    $0x2,%edx
  801403:	89 c8                	mov    %ecx,%eax
  801405:	c1 f8 1f             	sar    $0x1f,%eax
  801408:	29 c2                	sub    %eax,%edx
  80140a:	89 d0                	mov    %edx,%eax
  80140c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80140f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801413:	75 bb                	jne    8013d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801415:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80141c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141f:	48                   	dec    %eax
  801420:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801423:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801427:	74 3d                	je     801466 <ltostr+0xc3>
		start = 1 ;
  801429:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801430:	eb 34                	jmp    801466 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80143f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	01 c2                	add    %eax,%edx
  80145b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80145e:	88 02                	mov    %al,(%edx)
		start++ ;
  801460:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801463:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801469:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80146c:	7c c4                	jl     801432 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80146e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	e8 c4 f9 ff ff       	call   800e4e <strlen>
  80148a:	83 c4 04             	add    $0x4,%esp
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	e8 b6 f9 ff ff       	call   800e4e <strlen>
  801498:	83 c4 04             	add    $0x4,%esp
  80149b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80149e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ac:	eb 17                	jmp    8014c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	01 c2                	add    %eax,%edx
  8014b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	01 c8                	add    %ecx,%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c2:	ff 45 fc             	incl   -0x4(%ebp)
  8014c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014cb:	7c e1                	jl     8014ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014db:	eb 1f                	jmp    8014fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e0:	8d 50 01             	lea    0x1(%eax),%edx
  8014e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014eb:	01 c2                	add    %eax,%edx
  8014ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	01 c8                	add    %ecx,%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f9:	ff 45 f8             	incl   -0x8(%ebp)
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801502:	7c d9                	jl     8014dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801504:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	c6 00 00             	movb   $0x0,(%eax)
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
  80152f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801535:	eb 0c                	jmp    801543 <strsplit+0x31>
			*string++ = 0;
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8d 50 01             	lea    0x1(%eax),%edx
  80153d:	89 55 08             	mov    %edx,0x8(%ebp)
  801540:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 18                	je     801564 <strsplit+0x52>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 83 fa ff ff       	call   800fe0 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	75 d3                	jne    801537 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	84 c0                	test   %al,%al
  80156b:	74 5a                	je     8015c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80156d:	8b 45 14             	mov    0x14(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	83 f8 0f             	cmp    $0xf,%eax
  801575:	75 07                	jne    80157e <strsplit+0x6c>
		{
			return 0;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
  80157c:	eb 66                	jmp    8015e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	8d 48 01             	lea    0x1(%eax),%ecx
  801586:	8b 55 14             	mov    0x14(%ebp),%edx
  801589:	89 0a                	mov    %ecx,(%edx)
  80158b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801592:	8b 45 10             	mov    0x10(%ebp),%eax
  801595:	01 c2                	add    %eax,%edx
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80159c:	eb 03                	jmp    8015a1 <strsplit+0x8f>
			string++;
  80159e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	84 c0                	test   %al,%al
  8015a8:	74 8b                	je     801535 <strsplit+0x23>
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	0f be c0             	movsbl %al,%eax
  8015b2:	50                   	push   %eax
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	e8 25 fa ff ff       	call   800fe0 <strchr>
  8015bb:	83 c4 08             	add    $0x8,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	74 dc                	je     80159e <strsplit+0x8c>
			string++;
	}
  8015c2:	e9 6e ff ff ff       	jmp    801535 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	8b 00                	mov    (%eax),%eax
  8015cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f9:	eb 4a                	jmp    801645 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	01 c2                	add    %eax,%edx
  801603:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	01 c8                	add    %ecx,%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	3c 40                	cmp    $0x40,%al
  80161b:	7e 25                	jle    801642 <str2lower+0x5c>
  80161d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	3c 5a                	cmp    $0x5a,%al
  801629:	7f 17                	jg     801642 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801636:	8b 55 08             	mov    0x8(%ebp),%edx
  801639:	01 ca                	add    %ecx,%edx
  80163b:	8a 12                	mov    (%edx),%dl
  80163d:	83 c2 20             	add    $0x20,%edx
  801640:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801642:	ff 45 fc             	incl   -0x4(%ebp)
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	e8 01 f8 ff ff       	call   800e4e <strlen>
  80164d:	83 c4 04             	add    $0x4,%esp
  801650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801653:	7f a6                	jg     8015fb <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801655:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801672:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801675:	cd 30                	int    $0x30
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	5b                   	pop    %ebx
  801681:	5e                   	pop    %esi
  801682:	5f                   	pop    %edi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    

00801685 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801691:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801694:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	51                   	push   %ecx
  80169e:	52                   	push   %edx
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	50                   	push   %eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	e8 b0 ff ff ff       	call   80165a <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	90                   	nop
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 02                	push   $0x2
  8016bf:	e8 96 ff ff ff       	call   80165a <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 03                	push   $0x3
  8016d8:	e8 7d ff ff ff       	call   80165a <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	90                   	nop
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 04                	push   $0x4
  8016f2:	e8 63 ff ff ff       	call   80165a <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 08                	push   $0x8
  801710:	e8 45 ff ff ff       	call   80165a <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80171f:	8b 75 18             	mov    0x18(%ebp),%esi
  801722:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801725:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	51                   	push   %ecx
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	6a 09                	push   $0x9
  801735:	e8 20 ff ff ff       	call   80165a <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801740:	5b                   	pop    %ebx
  801741:	5e                   	pop    %esi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	6a 0a                	push   $0xa
  801754:	e8 01 ff ff ff       	call   80165a <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	ff 75 08             	pushl  0x8(%ebp)
  80176d:	6a 0b                	push   $0xb
  80176f:	e8 e6 fe ff ff       	call   80165a <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 0c                	push   $0xc
  801788:	e8 cd fe ff ff       	call   80165a <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 0d                	push   $0xd
  8017a1:	e8 b4 fe ff ff       	call   80165a <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 0e                	push   $0xe
  8017ba:	e8 9b fe ff ff       	call   80165a <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 0f                	push   $0xf
  8017d3:	e8 82 fe ff ff       	call   80165a <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 10                	push   $0x10
  8017ed:	e8 68 fe ff ff       	call   80165a <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 11                	push   $0x11
  801806:	e8 4f fe ff ff       	call   80165a <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	90                   	nop
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_cputc>:

void
sys_cputc(const char c)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80181d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	50                   	push   %eax
  80182a:	6a 01                	push   $0x1
  80182c:	e8 29 fe ff ff       	call   80165a <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 14                	push   $0x14
  801846:	e8 0f fe ff ff       	call   80165a <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80185d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801860:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	51                   	push   %ecx
  80186a:	52                   	push   %edx
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	50                   	push   %eax
  80186f:	6a 15                	push   $0x15
  801871:	e8 e4 fd ff ff       	call   80165a <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	50                   	push   %eax
  80188c:	6a 16                	push   $0x16
  80188e:	e8 c7 fd ff ff       	call   80165a <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	51                   	push   %ecx
  8018a9:	52                   	push   %edx
  8018aa:	50                   	push   %eax
  8018ab:	6a 17                	push   $0x17
  8018ad:	e8 a8 fd ff ff       	call   80165a <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 18                	push   $0x18
  8018ca:	e8 8b fd ff ff       	call   80165a <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 14             	pushl  0x14(%ebp)
  8018df:	ff 75 10             	pushl  0x10(%ebp)
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	50                   	push   %eax
  8018e6:	6a 19                	push   $0x19
  8018e8:	e8 6d fd ff ff       	call   80165a <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	50                   	push   %eax
  801901:	6a 1a                	push   $0x1a
  801903:	e8 52 fd ff ff       	call   80165a <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	50                   	push   %eax
  80191d:	6a 1b                	push   $0x1b
  80191f:	e8 36 fd ff ff       	call   80165a <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 05                	push   $0x5
  801938:	e8 1d fd ff ff       	call   80165a <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 06                	push   $0x6
  801951:	e8 04 fd ff ff       	call   80165a <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 07                	push   $0x7
  80196a:	e8 eb fc ff ff       	call   80165a <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_exit_env>:


void sys_exit_env(void)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 1c                	push   $0x1c
  801983:	e8 d2 fc ff ff       	call   80165a <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801994:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801997:	8d 50 04             	lea    0x4(%eax),%edx
  80199a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	6a 1d                	push   $0x1d
  8019a7:	e8 ae fc ff ff       	call   80165a <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8019af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b8:	89 01                	mov    %eax,(%ecx)
  8019ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	c9                   	leave  
  8019c1:	c2 04 00             	ret    $0x4

008019c4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 10             	pushl  0x10(%ebp)
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 13                	push   $0x13
  8019d6:	e8 7f fc ff ff       	call   80165a <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
	return ;
  8019de:	90                   	nop
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 1e                	push   $0x1e
  8019f0:	e8 65 fc ff ff       	call   80165a <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a06:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	50                   	push   %eax
  801a13:	6a 1f                	push   $0x1f
  801a15:	e8 40 fc ff ff       	call   80165a <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <rsttst>:
void rsttst()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 21                	push   $0x21
  801a2f:	e8 26 fc ff ff       	call   80165a <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return ;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	8b 45 14             	mov    0x14(%ebp),%eax
  801a43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a46:	8b 55 18             	mov    0x18(%ebp),%edx
  801a49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 20                	push   $0x20
  801a5a:	e8 fb fb ff ff       	call   80165a <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a62:	90                   	nop
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <chktst>:
void chktst(uint32 n)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	6a 22                	push   $0x22
  801a75:	e8 e0 fb ff ff       	call   80165a <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7d:	90                   	nop
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <inctst>:

void inctst()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 23                	push   $0x23
  801a8f:	e8 c6 fb ff ff       	call   80165a <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
	return ;
  801a97:	90                   	nop
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <gettst>:
uint32 gettst()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 24                	push   $0x24
  801aa9:	e8 ac fb ff ff       	call   80165a <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 25                	push   $0x25
  801ac2:	e8 93 fb ff ff       	call   80165a <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
  801aca:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801acf:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	6a 26                	push   $0x26
  801aee:	e8 67 fb ff ff       	call   80165a <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
	return ;
  801af6:	90                   	nop
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801afd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	53                   	push   %ebx
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 27                	push   $0x27
  801b11:	e8 44 fb ff ff       	call   80165a <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 28                	push   $0x28
  801b31:	e8 24 fb ff ff       	call   80165a <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	51                   	push   %ecx
  801b4a:	ff 75 10             	pushl  0x10(%ebp)
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 29                	push   $0x29
  801b51:	e8 04 fb ff ff       	call   80165a <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 12                	push   $0x12
  801b6d:	e8 e8 fa ff ff       	call   80165a <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 2a                	push   $0x2a
  801b8b:	e8 ca fa ff ff       	call   80165a <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
	return;
  801b93:	90                   	nop
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 2b                	push   $0x2b
  801ba5:	e8 b0 fa ff ff       	call   80165a <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 2d                	push   $0x2d
  801bc0:	e8 95 fa ff ff       	call   80165a <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 2c                	push   $0x2c
  801bdc:	e8 79 fa ff ff       	call   80165a <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bed:	83 ec 04             	sub    $0x4,%esp
  801bf0:	68 a8 27 80 00       	push   $0x8027a8
  801bf5:	68 25 01 00 00       	push   $0x125
  801bfa:	68 db 27 80 00       	push   $0x8027db
  801bff:	e8 a3 e8 ff ff       	call   8004a7 <_panic>

00801c04 <__udivdi3>:
  801c04:	55                   	push   %ebp
  801c05:	57                   	push   %edi
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 1c             	sub    $0x1c,%esp
  801c0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c1b:	89 ca                	mov    %ecx,%edx
  801c1d:	89 f8                	mov    %edi,%eax
  801c1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c23:	85 f6                	test   %esi,%esi
  801c25:	75 2d                	jne    801c54 <__udivdi3+0x50>
  801c27:	39 cf                	cmp    %ecx,%edi
  801c29:	77 65                	ja     801c90 <__udivdi3+0x8c>
  801c2b:	89 fd                	mov    %edi,%ebp
  801c2d:	85 ff                	test   %edi,%edi
  801c2f:	75 0b                	jne    801c3c <__udivdi3+0x38>
  801c31:	b8 01 00 00 00       	mov    $0x1,%eax
  801c36:	31 d2                	xor    %edx,%edx
  801c38:	f7 f7                	div    %edi
  801c3a:	89 c5                	mov    %eax,%ebp
  801c3c:	31 d2                	xor    %edx,%edx
  801c3e:	89 c8                	mov    %ecx,%eax
  801c40:	f7 f5                	div    %ebp
  801c42:	89 c1                	mov    %eax,%ecx
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	f7 f5                	div    %ebp
  801c48:	89 cf                	mov    %ecx,%edi
  801c4a:	89 fa                	mov    %edi,%edx
  801c4c:	83 c4 1c             	add    $0x1c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
  801c54:	39 ce                	cmp    %ecx,%esi
  801c56:	77 28                	ja     801c80 <__udivdi3+0x7c>
  801c58:	0f bd fe             	bsr    %esi,%edi
  801c5b:	83 f7 1f             	xor    $0x1f,%edi
  801c5e:	75 40                	jne    801ca0 <__udivdi3+0x9c>
  801c60:	39 ce                	cmp    %ecx,%esi
  801c62:	72 0a                	jb     801c6e <__udivdi3+0x6a>
  801c64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c68:	0f 87 9e 00 00 00    	ja     801d0c <__udivdi3+0x108>
  801c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c73:	89 fa                	mov    %edi,%edx
  801c75:	83 c4 1c             	add    $0x1c,%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5f                   	pop    %edi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
  801c7d:	8d 76 00             	lea    0x0(%esi),%esi
  801c80:	31 ff                	xor    %edi,%edi
  801c82:	31 c0                	xor    %eax,%eax
  801c84:	89 fa                	mov    %edi,%edx
  801c86:	83 c4 1c             	add    $0x1c,%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	f7 f7                	div    %edi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	89 fa                	mov    %edi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ca5:	89 eb                	mov    %ebp,%ebx
  801ca7:	29 fb                	sub    %edi,%ebx
  801ca9:	89 f9                	mov    %edi,%ecx
  801cab:	d3 e6                	shl    %cl,%esi
  801cad:	89 c5                	mov    %eax,%ebp
  801caf:	88 d9                	mov    %bl,%cl
  801cb1:	d3 ed                	shr    %cl,%ebp
  801cb3:	89 e9                	mov    %ebp,%ecx
  801cb5:	09 f1                	or     %esi,%ecx
  801cb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cbb:	89 f9                	mov    %edi,%ecx
  801cbd:	d3 e0                	shl    %cl,%eax
  801cbf:	89 c5                	mov    %eax,%ebp
  801cc1:	89 d6                	mov    %edx,%esi
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 ee                	shr    %cl,%esi
  801cc7:	89 f9                	mov    %edi,%ecx
  801cc9:	d3 e2                	shl    %cl,%edx
  801ccb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ccf:	88 d9                	mov    %bl,%cl
  801cd1:	d3 e8                	shr    %cl,%eax
  801cd3:	09 c2                	or     %eax,%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	89 f2                	mov    %esi,%edx
  801cd9:	f7 74 24 0c          	divl   0xc(%esp)
  801cdd:	89 d6                	mov    %edx,%esi
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	f7 e5                	mul    %ebp
  801ce3:	39 d6                	cmp    %edx,%esi
  801ce5:	72 19                	jb     801d00 <__udivdi3+0xfc>
  801ce7:	74 0b                	je     801cf4 <__udivdi3+0xf0>
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	31 ff                	xor    %edi,%edi
  801ced:	e9 58 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cf8:	89 f9                	mov    %edi,%ecx
  801cfa:	d3 e2                	shl    %cl,%edx
  801cfc:	39 c2                	cmp    %eax,%edx
  801cfe:	73 e9                	jae    801ce9 <__udivdi3+0xe5>
  801d00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d03:	31 ff                	xor    %edi,%edi
  801d05:	e9 40 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	31 c0                	xor    %eax,%eax
  801d0e:	e9 37 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801d13:	90                   	nop

00801d14 <__umoddi3>:
  801d14:	55                   	push   %ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
  801d1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d33:	89 f3                	mov    %esi,%ebx
  801d35:	89 fa                	mov    %edi,%edx
  801d37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3b:	89 34 24             	mov    %esi,(%esp)
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	75 1a                	jne    801d5c <__umoddi3+0x48>
  801d42:	39 f7                	cmp    %esi,%edi
  801d44:	0f 86 a2 00 00 00    	jbe    801dec <__umoddi3+0xd8>
  801d4a:	89 c8                	mov    %ecx,%eax
  801d4c:	89 f2                	mov    %esi,%edx
  801d4e:	f7 f7                	div    %edi
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	31 d2                	xor    %edx,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	39 f0                	cmp    %esi,%eax
  801d5e:	0f 87 ac 00 00 00    	ja     801e10 <__umoddi3+0xfc>
  801d64:	0f bd e8             	bsr    %eax,%ebp
  801d67:	83 f5 1f             	xor    $0x1f,%ebp
  801d6a:	0f 84 ac 00 00 00    	je     801e1c <__umoddi3+0x108>
  801d70:	bf 20 00 00 00       	mov    $0x20,%edi
  801d75:	29 ef                	sub    %ebp,%edi
  801d77:	89 fe                	mov    %edi,%esi
  801d79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	d3 e0                	shl    %cl,%eax
  801d81:	89 d7                	mov    %edx,%edi
  801d83:	89 f1                	mov    %esi,%ecx
  801d85:	d3 ef                	shr    %cl,%edi
  801d87:	09 c7                	or     %eax,%edi
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	d3 e2                	shl    %cl,%edx
  801d8d:	89 14 24             	mov    %edx,(%esp)
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	d3 e0                	shl    %cl,%eax
  801d94:	89 c2                	mov    %eax,%edx
  801d96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d9a:	d3 e0                	shl    %cl,%eax
  801d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da4:	89 f1                	mov    %esi,%ecx
  801da6:	d3 e8                	shr    %cl,%eax
  801da8:	09 d0                	or     %edx,%eax
  801daa:	d3 eb                	shr    %cl,%ebx
  801dac:	89 da                	mov    %ebx,%edx
  801dae:	f7 f7                	div    %edi
  801db0:	89 d3                	mov    %edx,%ebx
  801db2:	f7 24 24             	mull   (%esp)
  801db5:	89 c6                	mov    %eax,%esi
  801db7:	89 d1                	mov    %edx,%ecx
  801db9:	39 d3                	cmp    %edx,%ebx
  801dbb:	0f 82 87 00 00 00    	jb     801e48 <__umoddi3+0x134>
  801dc1:	0f 84 91 00 00 00    	je     801e58 <__umoddi3+0x144>
  801dc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dcb:	29 f2                	sub    %esi,%edx
  801dcd:	19 cb                	sbb    %ecx,%ebx
  801dcf:	89 d8                	mov    %ebx,%eax
  801dd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dd5:	d3 e0                	shl    %cl,%eax
  801dd7:	89 e9                	mov    %ebp,%ecx
  801dd9:	d3 ea                	shr    %cl,%edx
  801ddb:	09 d0                	or     %edx,%eax
  801ddd:	89 e9                	mov    %ebp,%ecx
  801ddf:	d3 eb                	shr    %cl,%ebx
  801de1:	89 da                	mov    %ebx,%edx
  801de3:	83 c4 1c             	add    $0x1c,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5f                   	pop    %edi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    
  801deb:	90                   	nop
  801dec:	89 fd                	mov    %edi,%ebp
  801dee:	85 ff                	test   %edi,%edi
  801df0:	75 0b                	jne    801dfd <__umoddi3+0xe9>
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
  801df7:	31 d2                	xor    %edx,%edx
  801df9:	f7 f7                	div    %edi
  801dfb:	89 c5                	mov    %eax,%ebp
  801dfd:	89 f0                	mov    %esi,%eax
  801dff:	31 d2                	xor    %edx,%edx
  801e01:	f7 f5                	div    %ebp
  801e03:	89 c8                	mov    %ecx,%eax
  801e05:	f7 f5                	div    %ebp
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	e9 44 ff ff ff       	jmp    801d52 <__umoddi3+0x3e>
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	89 c8                	mov    %ecx,%eax
  801e12:	89 f2                	mov    %esi,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	3b 04 24             	cmp    (%esp),%eax
  801e1f:	72 06                	jb     801e27 <__umoddi3+0x113>
  801e21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e25:	77 0f                	ja     801e36 <__umoddi3+0x122>
  801e27:	89 f2                	mov    %esi,%edx
  801e29:	29 f9                	sub    %edi,%ecx
  801e2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e2f:	89 14 24             	mov    %edx,(%esp)
  801e32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e3a:	8b 14 24             	mov    (%esp),%edx
  801e3d:	83 c4 1c             	add    $0x1c,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    
  801e45:	8d 76 00             	lea    0x0(%esi),%esi
  801e48:	2b 04 24             	sub    (%esp),%eax
  801e4b:	19 fa                	sbb    %edi,%edx
  801e4d:	89 d1                	mov    %edx,%ecx
  801e4f:	89 c6                	mov    %eax,%esi
  801e51:	e9 71 ff ff ff       	jmp    801dc7 <__umoddi3+0xb3>
  801e56:	66 90                	xchg   %ax,%ax
  801e58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e5c:	72 ea                	jb     801e48 <__umoddi3+0x134>
  801e5e:	89 d9                	mov    %ebx,%ecx
  801e60:	e9 62 ff ff ff       	jmp    801dc7 <__umoddi3+0xb3>

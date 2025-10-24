
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 9c 02 00 00       	call   8002d2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 4: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 60 21 80 00       	push   $0x802160
  800050:	e8 05 17 00 00       	call   80175a <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 61 23 80 00       	mov    $0x802361,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 64 1c 00 00       	call   801d0a <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 5d 18 00 00       	call   80190b <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 a0 18 00 00       	call   801956 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 70 21 80 00       	push   $0x802170
  8000c4:	e8 87 06 00 00       	call   800750 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 a3 21 80 00       	push   $0x8021a3
  8000ed:	e8 74 19 00 00       	call   801a66 <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 30 80 00       	mov    0x803020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 ac 21 80 00       	push   $0x8021ac
  800119:	e8 48 19 00 00       	call   801a66 <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 55 19 00 00       	call   801a84 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  800132:	90                   	nop
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 01             	cmp    $0x1,%eax
  80013b:	75 f6                	jne    800133 <_main+0xfb>

	sys_run_env(envIdProcessB);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 d4             	pushl  -0x2c(%ebp)
  800143:	e8 3c 19 00 00       	call   801a84 <sys_run_env>
  800148:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80014b:	90                   	nop
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	8b 00                	mov    (%eax),%eax
  800151:	83 f8 02             	cmp    $0x2,%eax
  800154:	75 f6                	jne    80014c <_main+0x114>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800156:	e8 b0 17 00 00       	call   80190b <sys_calculate_free_frames>
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 b8 21 80 00       	push   $0x8021b8
  800164:	e8 e7 05 00 00       	call   800750 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80016c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 88 1b 00 00       	call   801d0a <sys_utilities>
  800182:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800185:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80018b:	bb c5 23 80 00       	mov    $0x8023c5,%ebx
  800190:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019d:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a3:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 4b 1b 00 00       	call   801d0a <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c8:	e8 d3 18 00 00       	call   801aa0 <sys_destroy_env>
  8001cd:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d6:	e8 c5 18 00 00       	call   801aa0 <sys_destroy_env>
  8001db:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	6a 01                	push   $0x1
  8001e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 1b 1b 00 00       	call   801d0a <sys_utilities>
  8001ef:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f2:	e8 14 17 00 00       	call   80190b <sys_calculate_free_frames>
  8001f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 57 17 00 00       	call   801956 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800202:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800209:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	48                   	dec    %eax
  800215:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800218:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	f7 75 c8             	divl   -0x38(%ebp)
  800223:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800226:	29 d0                	sub    %edx,%eax
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800231:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800237:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	48                   	dec    %eax
  80023d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800240:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 75 c0             	divl   -0x40(%ebp)
  80024b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024e:	29 d0                	sub    %edx,%eax
  800250:	29 c1                	sub    %eax,%ecx
  800252:	89 c8                	mov    %ecx,%eax
  800254:	c1 e8 0c             	shr    $0xc,%eax
  800257:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	68 ea 21 80 00       	push   $0x8021ea
  800265:	e8 e6 04 00 00       	call   800750 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800273:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800276:	74 2e                	je     8002a6 <_main+0x26e>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800278:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	50                   	push   %eax
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	68 fc 21 80 00       	push   $0x8021fc
  80028a:	e8 c1 04 00 00       	call   800750 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 6c 22 80 00       	push   $0x80226c
  80029a:	6a 38                	push   $0x38
  80029c:	68 a2 22 80 00       	push   $0x8022a2
  8002a1:	e8 dc 01 00 00       	call   800482 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ac:	68 b8 22 80 00       	push   $0x8022b8
  8002b1:	e8 9a 04 00 00       	call   800750 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 18 23 80 00       	push   $0x802318
  8002c1:	e8 8a 04 00 00       	call   800750 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	return;
  8002c9:	90                   	nop
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002db:	e8 f4 17 00 00       	call   801ad4 <sys_getenvindex>
  8002e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	89 d0                	mov    %edx,%eax
  8002e8:	c1 e0 02             	shl    $0x2,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e0 03             	shl    $0x3,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	c1 e0 02             	shl    $0x2,%eax
  8002fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800303:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800308:	a1 20 30 80 00       	mov    0x803020,%eax
  80030d:	8a 40 20             	mov    0x20(%eax),%al
  800310:	84 c0                	test   %al,%al
  800312:	74 0d                	je     800321 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800314:	a1 20 30 80 00       	mov    0x803020,%eax
  800319:	83 c0 20             	add    $0x20,%eax
  80031c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800325:	7e 0a                	jle    800331 <libmain+0x5f>
		binaryname = argv[0];
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	ff 75 0c             	pushl  0xc(%ebp)
  800337:	ff 75 08             	pushl  0x8(%ebp)
  80033a:	e8 f9 fc ff ff       	call   800038 <_main>
  80033f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800342:	a1 00 30 80 00       	mov    0x803000,%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	0f 84 01 01 00 00    	je     800450 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800355:	bb 24 25 80 00       	mov    $0x802524,%ebx
  80035a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800367:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036f:	b0 00                	mov    $0x0,%al
  800371:	89 d7                	mov    %edx,%edi
  800373:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800375:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80037c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	50                   	push   %eax
  800383:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	e8 7b 19 00 00       	call   801d0a <sys_utilities>
  80038f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800392:	e8 c4 14 00 00       	call   80185b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800397:	83 ec 0c             	sub    $0xc,%esp
  80039a:	68 44 24 80 00       	push   $0x802444
  80039f:	e8 ac 03 00 00       	call   800750 <cprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	74 18                	je     8003c6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ae:	e8 75 19 00 00       	call   801d28 <sys_get_optimal_num_faults>
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	50                   	push   %eax
  8003b7:	68 6c 24 80 00       	push   $0x80246c
  8003bc:	e8 8f 03 00 00       	call   800750 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	eb 59                	jmp    80041f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	68 90 24 80 00       	push   $0x802490
  8003e6:	e8 65 03 00 00       	call   800750 <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fe:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800404:	a1 20 30 80 00       	mov    0x803020,%eax
  800409:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80040f:	51                   	push   %ecx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	68 b8 24 80 00       	push   $0x8024b8
  800417:	e8 34 03 00 00       	call   800750 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041f:	a1 20 30 80 00       	mov    0x803020,%eax
  800424:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 10 25 80 00       	push   $0x802510
  800433:	e8 18 03 00 00       	call   800750 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	68 44 24 80 00       	push   $0x802444
  800443:	e8 08 03 00 00       	call   800750 <cprintf>
  800448:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80044b:	e8 25 14 00 00       	call   801875 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800450:	e8 1f 00 00 00       	call   800474 <exit>
}
  800455:	90                   	nop
  800456:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800459:	5b                   	pop    %ebx
  80045a:	5e                   	pop    %esi
  80045b:	5f                   	pop    %edi
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    

0080045e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	6a 00                	push   $0x0
  800469:	e8 32 16 00 00       	call   801aa0 <sys_destroy_env>
  80046e:	83 c4 10             	add    $0x10,%esp
}
  800471:	90                   	nop
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <exit>:

void
exit(void)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047a:	e8 87 16 00 00       	call   801b06 <sys_exit_env>
}
  80047f:	90                   	nop
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800488:	8d 45 10             	lea    0x10(%ebp),%eax
  80048b:	83 c0 04             	add    $0x4,%eax
  80048e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800491:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	74 16                	je     8004b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	50                   	push   %eax
  8004a3:	68 88 25 80 00       	push   $0x802588
  8004a8:	e8 a3 02 00 00       	call   800750 <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b5:	83 ec 0c             	sub    $0xc,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	ff 75 08             	pushl  0x8(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	68 90 25 80 00       	push   $0x802590
  8004c4:	6a 74                	push   $0x74
  8004c6:	e8 b2 02 00 00       	call   80077d <cprintf_colored>
  8004cb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	e8 04 02 00 00       	call   8006e1 <vcprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	6a 00                	push   $0x0
  8004e5:	68 b8 25 80 00       	push   $0x8025b8
  8004ea:	e8 f2 01 00 00       	call   8006e1 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f2:	e8 7d ff ff ff       	call   800474 <exit>

	// should not return here
	while (1) ;
  8004f7:	eb fe                	jmp    8004f7 <_panic+0x75>

008004f9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800504:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050d:	39 c2                	cmp    %eax,%edx
  80050f:	74 14                	je     800525 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800511:	83 ec 04             	sub    $0x4,%esp
  800514:	68 bc 25 80 00       	push   $0x8025bc
  800519:	6a 26                	push   $0x26
  80051b:	68 08 26 80 00       	push   $0x802608
  800520:	e8 5d ff ff ff       	call   800482 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80052c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800533:	e9 c5 00 00 00       	jmp    8005fd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	01 d0                	add    %edx,%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	85 c0                	test   %eax,%eax
  80054b:	75 08                	jne    800555 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80054d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800550:	e9 a5 00 00 00       	jmp    8005fa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800555:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800563:	eb 69                	jmp    8005ce <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 03             	shl    $0x3,%eax
  80057c:	01 c8                	add    %ecx,%eax
  80057e:	8a 40 04             	mov    0x4(%eax),%al
  800581:	84 c0                	test   %al,%al
  800583:	75 46                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800585:	a1 20 30 80 00       	mov    0x803020,%eax
  80058a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800590:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800593:	89 d0                	mov    %edx,%eax
  800595:	01 c0                	add    %eax,%eax
  800597:	01 d0                	add    %edx,%eax
  800599:	c1 e0 03             	shl    $0x3,%eax
  80059c:	01 c8                	add    %ecx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005be:	39 c2                	cmp    %eax,%edx
  8005c0:	75 09                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c9:	eb 15                	jmp    8005e0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cb:	ff 45 e8             	incl   -0x18(%ebp)
  8005ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dc:	39 c2                	cmp    %eax,%edx
  8005de:	77 85                	ja     800565 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e4:	75 14                	jne    8005fa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005e6:	83 ec 04             	sub    $0x4,%esp
  8005e9:	68 14 26 80 00       	push   $0x802614
  8005ee:	6a 3a                	push   $0x3a
  8005f0:	68 08 26 80 00       	push   $0x802608
  8005f5:	e8 88 fe ff ff       	call   800482 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005fa:	ff 45 f0             	incl   -0x10(%ebp)
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800600:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800603:	0f 8c 2f ff ff ff    	jl     800538 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800609:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800610:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800617:	eb 26                	jmp    80063f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800619:	a1 20 30 80 00       	mov    0x803020,%eax
  80061e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800624:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	01 c0                	add    %eax,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	c1 e0 03             	shl    $0x3,%eax
  800630:	01 c8                	add    %ecx,%eax
  800632:	8a 40 04             	mov    0x4(%eax),%al
  800635:	3c 01                	cmp    $0x1,%al
  800637:	75 03                	jne    80063c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800639:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063c:	ff 45 e0             	incl   -0x20(%ebp)
  80063f:	a1 20 30 80 00       	mov    0x803020,%eax
  800644:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	39 c2                	cmp    %eax,%edx
  80064f:	77 c8                	ja     800619 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800654:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800657:	74 14                	je     80066d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	68 68 26 80 00       	push   $0x802668
  800661:	6a 44                	push   $0x44
  800663:	68 08 26 80 00       	push   $0x802608
  800668:	e8 15 fe ff ff       	call   800482 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80066d:	90                   	nop
  80066e:	c9                   	leave  
  80066f:	c3                   	ret    

00800670 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	53                   	push   %ebx
  800674:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	8d 48 01             	lea    0x1(%eax),%ecx
  80067f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800682:	89 0a                	mov    %ecx,(%edx)
  800684:	8b 55 08             	mov    0x8(%ebp),%edx
  800687:	88 d1                	mov    %dl,%cl
  800689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800690:	8b 45 0c             	mov    0xc(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069a:	75 30                	jne    8006cc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80069c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006a2:	a0 44 30 80 00       	mov    0x803044,%al
  8006a7:	0f b6 c0             	movzbl %al,%eax
  8006aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ad:	8b 09                	mov    (%ecx),%ecx
  8006af:	89 cb                	mov    %ecx,%ebx
  8006b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b4:	83 c1 08             	add    $0x8,%ecx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	53                   	push   %ebx
  8006ba:	51                   	push   %ecx
  8006bb:	e8 57 11 00 00       	call   801817 <sys_cputs>
  8006c0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	8b 40 04             	mov    0x4(%eax),%eax
  8006d2:	8d 50 01             	lea    0x1(%eax),%edx
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006db:	90                   	nop
  8006dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f1:	00 00 00 
	b.cnt = 0;
  8006f4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	ff 75 08             	pushl  0x8(%ebp)
  800704:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	68 70 06 80 00       	push   $0x800670
  800710:	e8 5a 02 00 00       	call   80096f <vprintfmt>
  800715:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800718:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80071e:	a0 44 30 80 00       	mov    0x803044,%al
  800723:	0f b6 c0             	movzbl %al,%eax
  800726:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	51                   	push   %ecx
  80072f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800735:	83 c0 08             	add    $0x8,%eax
  800738:	50                   	push   %eax
  800739:	e8 d9 10 00 00       	call   801817 <sys_cputs>
  80073e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800741:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800748:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800756:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80075d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800760:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 f4             	pushl  -0xc(%ebp)
  80076c:	50                   	push   %eax
  80076d:	e8 6f ff ff ff       	call   8006e1 <vcprintf>
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800778:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800783:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	c1 e0 08             	shl    $0x8,%eax
  800790:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800795:	8d 45 0c             	lea    0xc(%ebp),%eax
  800798:	83 c0 04             	add    $0x4,%eax
  80079b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	e8 34 ff ff ff       	call   8006e1 <vcprintf>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b3:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007ba:	07 00 00 

	return cnt;
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c8:	e8 8e 10 00 00       	call   80185b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	e8 ff fe ff ff       	call   8006e1 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e8:	e8 88 10 00 00       	call   801875 <sys_unlock_cons>
	return cnt;
  8007ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 14             	sub    $0x14,%esp
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800805:	8b 45 18             	mov    0x18(%ebp),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800810:	77 55                	ja     800867 <printnum+0x75>
  800812:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800815:	72 05                	jb     80081c <printnum+0x2a>
  800817:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80081a:	77 4b                	ja     800867 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80081c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800822:	8b 45 18             	mov    0x18(%ebp),%eax
  800825:	ba 00 00 00 00       	mov    $0x0,%edx
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	ff 75 f4             	pushl  -0xc(%ebp)
  80082f:	ff 75 f0             	pushl  -0x10(%ebp)
  800832:	e8 a9 16 00 00       	call   801ee0 <__udivdi3>
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	ff 75 20             	pushl  0x20(%ebp)
  800840:	53                   	push   %ebx
  800841:	ff 75 18             	pushl  0x18(%ebp)
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	e8 a1 ff ff ff       	call   8007f2 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
  800854:	eb 1a                	jmp    800870 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 20             	pushl  0x20(%ebp)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800867:	ff 4d 1c             	decl   0x1c(%ebp)
  80086a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80086e:	7f e6                	jg     800856 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800870:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800873:	bb 00 00 00 00       	mov    $0x0,%ebx
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087e:	53                   	push   %ebx
  80087f:	51                   	push   %ecx
  800880:	52                   	push   %edx
  800881:	50                   	push   %eax
  800882:	e8 69 17 00 00       	call   801ff0 <__umoddi3>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	05 d4 28 80 00       	add    $0x8028d4,%eax
  80088f:	8a 00                	mov    (%eax),%al
  800891:	0f be c0             	movsbl %al,%eax
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	50                   	push   %eax
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
}
  8008a3:	90                   	nop
  8008a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b0:	7e 1c                	jle    8008ce <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	89 10                	mov    %edx,(%eax)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	83 e8 08             	sub    $0x8,%eax
  8008c7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	eb 40                	jmp    80090e <getuint+0x65>
	else if (lflag)
  8008ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d2:	74 1e                	je     8008f2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	8d 50 04             	lea    0x4(%eax),%edx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	89 10                	mov    %edx,(%eax)
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f0:	eb 1c                	jmp    80090e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	8d 50 04             	lea    0x4(%eax),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	89 10                	mov    %edx,(%eax)
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	83 e8 04             	sub    $0x4,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800913:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800917:	7e 1c                	jle    800935 <getint+0x25>
		return va_arg(*ap, long long);
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	8d 50 08             	lea    0x8(%eax),%edx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	89 10                	mov    %edx,(%eax)
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 e8 08             	sub    $0x8,%eax
  80092e:	8b 50 04             	mov    0x4(%eax),%edx
  800931:	8b 00                	mov    (%eax),%eax
  800933:	eb 38                	jmp    80096d <getint+0x5d>
	else if (lflag)
  800935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800939:	74 1a                	je     800955 <getint+0x45>
		return va_arg(*ap, long);
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	8d 50 04             	lea    0x4(%eax),%edx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	89 10                	mov    %edx,(%eax)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	99                   	cltd   
  800953:	eb 18                	jmp    80096d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	56                   	push   %esi
  800973:	53                   	push   %ebx
  800974:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800977:	eb 17                	jmp    800990 <vprintfmt+0x21>
			if (ch == '\0')
  800979:	85 db                	test   %ebx,%ebx
  80097b:	0f 84 c1 03 00 00    	je     800d42 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	ff d0                	call   *%eax
  80098d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800990:	8b 45 10             	mov    0x10(%ebp),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	89 55 10             	mov    %edx,0x10(%ebp)
  800999:	8a 00                	mov    (%eax),%al
  80099b:	0f b6 d8             	movzbl %al,%ebx
  80099e:	83 fb 25             	cmp    $0x25,%ebx
  8009a1:	75 d6                	jne    800979 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c6:	8d 50 01             	lea    0x1(%eax),%edx
  8009c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	0f b6 d8             	movzbl %al,%ebx
  8009d1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d4:	83 f8 5b             	cmp    $0x5b,%eax
  8009d7:	0f 87 3d 03 00 00    	ja     800d1a <vprintfmt+0x3ab>
  8009dd:	8b 04 85 f8 28 80 00 	mov    0x8028f8(,%eax,4),%eax
  8009e4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ea:	eb d7                	jmp    8009c3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f0:	eb d1                	jmp    8009c3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	c1 e0 02             	shl    $0x2,%eax
  800a01:	01 d0                	add    %edx,%eax
  800a03:	01 c0                	add    %eax,%eax
  800a05:	01 d8                	add    %ebx,%eax
  800a07:	83 e8 30             	sub    $0x30,%eax
  800a0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a15:	83 fb 2f             	cmp    $0x2f,%ebx
  800a18:	7e 3e                	jle    800a58 <vprintfmt+0xe9>
  800a1a:	83 fb 39             	cmp    $0x39,%ebx
  800a1d:	7f 39                	jg     800a58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a22:	eb d5                	jmp    8009f9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a38:	eb 1f                	jmp    800a59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	79 83                	jns    8009c3 <vprintfmt+0x54>
				width = 0;
  800a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a47:	e9 77 ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a53:	e9 6b ff ff ff       	jmp    8009c3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5d:	0f 89 60 ff ff ff    	jns    8009c3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a70:	e9 4e ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a78:	e9 46 ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 c0 04             	add    $0x4,%eax
  800a83:	89 45 14             	mov    %eax,0x14(%ebp)
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	83 e8 04             	sub    $0x4,%eax
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	50                   	push   %eax
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			break;
  800a9d:	e9 9b 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 c0 04             	add    $0x4,%eax
  800aa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab3:	85 db                	test   %ebx,%ebx
  800ab5:	79 02                	jns    800ab9 <vprintfmt+0x14a>
				err = -err;
  800ab7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab9:	83 fb 64             	cmp    $0x64,%ebx
  800abc:	7f 0b                	jg     800ac9 <vprintfmt+0x15a>
  800abe:	8b 34 9d 40 27 80 00 	mov    0x802740(,%ebx,4),%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	75 19                	jne    800ae2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac9:	53                   	push   %ebx
  800aca:	68 e5 28 80 00       	push   $0x8028e5
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 70 02 00 00       	call   800d4a <printfmt>
  800ada:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800add:	e9 5b 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae2:	56                   	push   %esi
  800ae3:	68 ee 28 80 00       	push   $0x8028ee
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	e8 57 02 00 00       	call   800d4a <printfmt>
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	e9 42 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 c0 04             	add    $0x4,%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 30                	mov    (%eax),%esi
  800b0c:	85 f6                	test   %esi,%esi
  800b0e:	75 05                	jne    800b15 <vprintfmt+0x1a6>
				p = "(null)";
  800b10:	be f1 28 80 00       	mov    $0x8028f1,%esi
			if (width > 0 && padc != '-')
  800b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b19:	7e 6d                	jle    800b88 <vprintfmt+0x219>
  800b1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1f:	74 67                	je     800b88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	50                   	push   %eax
  800b28:	56                   	push   %esi
  800b29:	e8 1e 03 00 00       	call   800e4c <strnlen>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b34:	eb 16                	jmp    800b4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	50                   	push   %eax
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b49:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b50:	7f e4                	jg     800b36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b52:	eb 34                	jmp    800b88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b58:	74 1c                	je     800b76 <vprintfmt+0x207>
  800b5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5d:	7e 05                	jle    800b64 <vprintfmt+0x1f5>
  800b5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b62:	7e 12                	jle    800b76 <vprintfmt+0x207>
					putch('?', putdat);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	6a 3f                	push   $0x3f
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	eb 0f                	jmp    800b85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	53                   	push   %ebx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b85:	ff 4d e4             	decl   -0x1c(%ebp)
  800b88:	89 f0                	mov    %esi,%eax
  800b8a:	8d 70 01             	lea    0x1(%eax),%esi
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f be d8             	movsbl %al,%ebx
  800b92:	85 db                	test   %ebx,%ebx
  800b94:	74 24                	je     800bba <vprintfmt+0x24b>
  800b96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9a:	78 b8                	js     800b54 <vprintfmt+0x1e5>
  800b9c:	ff 4d e0             	decl   -0x20(%ebp)
  800b9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba3:	79 af                	jns    800b54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba5:	eb 13                	jmp    800bba <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	6a 20                	push   $0x20
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	ff d0                	call   *%eax
  800bb4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbe:	7f e7                	jg     800ba7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc0:	e9 78 01 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bce:	50                   	push   %eax
  800bcf:	e8 3c fd ff ff       	call   800910 <getint>
  800bd4:	83 c4 10             	add    $0x10,%esp
  800bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be3:	85 d2                	test   %edx,%edx
  800be5:	79 23                	jns    800c0a <vprintfmt+0x29b>
				putch('-', putdat);
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	6a 2d                	push   $0x2d
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	ff d0                	call   *%eax
  800bf4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	f7 d8                	neg    %eax
  800bff:	83 d2 00             	adc    $0x0,%edx
  800c02:	f7 da                	neg    %edx
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c11:	e9 bc 00 00 00       	jmp    800cd2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1f:	50                   	push   %eax
  800c20:	e8 84 fc ff ff       	call   8008a9 <getuint>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c35:	e9 98 00 00 00       	jmp    800cd2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 58                	push   $0x58
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 58                	push   $0x58
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			break;
  800c6a:	e9 ce 00 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 30                	push   $0x30
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 78                	push   $0x78
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 14             	mov    %eax,0x14(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 e8 04             	sub    $0x4,%eax
  800c9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800caa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb1:	eb 1f                	jmp    800cd2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800cbc:	50                   	push   %eax
  800cbd:	e8 e7 fb ff ff       	call   8008a9 <getuint>
  800cc2:	83 c4 10             	add    $0x10,%esp
  800cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ccb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	52                   	push   %edx
  800cdd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce0:	50                   	push   %eax
  800ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	ff 75 08             	pushl  0x8(%ebp)
  800ced:	e8 00 fb ff ff       	call   8007f2 <printnum>
  800cf2:	83 c4 20             	add    $0x20,%esp
			break;
  800cf5:	eb 46                	jmp    800d3d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	53                   	push   %ebx
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			break;
  800d06:	eb 35                	jmp    800d3d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d08:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d0f:	eb 2c                	jmp    800d3d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d11:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d18:	eb 23                	jmp    800d3d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	6a 25                	push   $0x25
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2a:	ff 4d 10             	decl   0x10(%ebp)
  800d2d:	eb 03                	jmp    800d32 <vprintfmt+0x3c3>
  800d2f:	ff 4d 10             	decl   0x10(%ebp)
  800d32:	8b 45 10             	mov    0x10(%ebp),%eax
  800d35:	48                   	dec    %eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3c 25                	cmp    $0x25,%al
  800d3a:	75 f3                	jne    800d2f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d3c:	90                   	nop
		}
	}
  800d3d:	e9 35 fc ff ff       	jmp    800977 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d42:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d50:	8d 45 10             	lea    0x10(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5f:	50                   	push   %eax
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 04 fc ff ff       	call   80096f <vprintfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6e:	90                   	nop
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 40 08             	mov    0x8(%eax),%eax
  800d7a:	8d 50 01             	lea    0x1(%eax),%edx
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 10                	mov    (%eax),%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 40 04             	mov    0x4(%eax),%eax
  800d8e:	39 c2                	cmp    %eax,%edx
  800d90:	73 12                	jae    800da4 <sprintputch+0x33>
		*b->buf++ = ch;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	8d 48 01             	lea    0x1(%eax),%ecx
  800d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9d:	89 0a                	mov    %ecx,(%edx)
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	88 10                	mov    %dl,(%eax)
}
  800da4:	90                   	nop
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	01 d0                	add    %edx,%eax
  800dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcc:	74 06                	je     800dd4 <vsnprintf+0x2d>
  800dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd2:	7f 07                	jg     800ddb <vsnprintf+0x34>
		return -E_INVAL;
  800dd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd9:	eb 20                	jmp    800dfb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ddb:	ff 75 14             	pushl  0x14(%ebp)
  800dde:	ff 75 10             	pushl  0x10(%ebp)
  800de1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de4:	50                   	push   %eax
  800de5:	68 71 0d 80 00       	push   $0x800d71
  800dea:	e8 80 fb ff ff       	call   80096f <vprintfmt>
  800def:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e03:	8d 45 10             	lea    0x10(%ebp),%eax
  800e06:	83 c0 04             	add    $0x4,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e12:	50                   	push   %eax
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	ff 75 08             	pushl  0x8(%ebp)
  800e19:	e8 89 ff ff ff       	call   800da7 <vsnprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e36:	eb 06                	jmp    800e3e <strlen+0x15>
		n++;
  800e38:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 f1                	jne    800e38 <strlen+0xf>
		n++;
	return n;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e59:	eb 09                	jmp    800e64 <strnlen+0x18>
		n++;
  800e5b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	ff 4d 0c             	decl   0xc(%ebp)
  800e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e68:	74 09                	je     800e73 <strnlen+0x27>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 e8                	jne    800e5b <strnlen+0xf>
		n++;
	return n;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e84:	90                   	nop
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e4                	jne    800e85 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb9:	eb 1f                	jmp    800eda <strncpy+0x34>
		*dst++ = *src;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	84 c0                	test   %al,%al
  800ed2:	74 03                	je     800ed7 <strncpy+0x31>
			src++;
  800ed4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed7:	ff 45 fc             	incl   -0x4(%ebp)
  800eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee0:	72 d9                	jb     800ebb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 30                	je     800f29 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef9:	eb 16                	jmp    800f11 <strlcpy+0x2a>
			*dst++ = *src++;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8d 50 01             	lea    0x1(%eax),%edx
  800f01:	89 55 08             	mov    %edx,0x8(%ebp)
  800f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f07:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0d:	8a 12                	mov    (%edx),%dl
  800f0f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f18:	74 09                	je     800f23 <strlcpy+0x3c>
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	84 c0                	test   %al,%al
  800f21:	75 d8                	jne    800efb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f38:	eb 06                	jmp    800f40 <strcmp+0xb>
		p++, q++;
  800f3a:	ff 45 08             	incl   0x8(%ebp)
  800f3d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	84 c0                	test   %al,%al
  800f47:	74 0e                	je     800f57 <strcmp+0x22>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	38 c2                	cmp    %al,%dl
  800f55:	74 e3                	je     800f3a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	0f b6 d0             	movzbl %al,%edx
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	0f b6 c0             	movzbl %al,%eax
  800f67:	29 c2                	sub    %eax,%edx
  800f69:	89 d0                	mov    %edx,%eax
}
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f70:	eb 09                	jmp    800f7b <strncmp+0xe>
		n--, p++, q++;
  800f72:	ff 4d 10             	decl   0x10(%ebp)
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	74 17                	je     800f98 <strncmp+0x2b>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	74 0e                	je     800f98 <strncmp+0x2b>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 da                	je     800f72 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 07                	jne    800fa5 <strncmp+0x38>
		return 0;
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa3:	eb 14                	jmp    800fb9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 d0             	movzbl %al,%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 c0             	movzbl %al,%eax
  800fb5:	29 c2                	sub    %eax,%edx
  800fb7:	89 d0                	mov    %edx,%eax
}
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc7:	eb 12                	jmp    800fdb <strchr+0x20>
		if (*s == c)
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd1:	75 05                	jne    800fd8 <strchr+0x1d>
			return (char *) s;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	eb 11                	jmp    800fe9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd8:	ff 45 08             	incl   0x8(%ebp)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	84 c0                	test   %al,%al
  800fe2:	75 e5                	jne    800fc9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff7:	eb 0d                	jmp    801006 <strfind+0x1b>
		if (*s == c)
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801001:	74 0e                	je     801011 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801003:	ff 45 08             	incl   0x8(%ebp)
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	75 ea                	jne    800ff9 <strfind+0xe>
  80100f:	eb 01                	jmp    801012 <strfind+0x27>
		if (*s == c)
			break;
  801011:	90                   	nop
	return (char *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801023:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801027:	76 63                	jbe    80108c <memset+0x75>
		uint64 data_block = c;
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	99                   	cltd   
  80102d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801030:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80103d:	c1 e0 08             	shl    $0x8,%eax
  801040:	09 45 f0             	or     %eax,-0x10(%ebp)
  801043:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801050:	c1 e0 10             	shl    $0x10,%eax
  801053:	09 45 f0             	or     %eax,-0x10(%ebp)
  801056:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	89 c2                	mov    %eax,%edx
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	09 45 f0             	or     %eax,-0x10(%ebp)
  801069:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80106c:	eb 18                	jmp    801086 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80106e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801071:	8d 41 08             	lea    0x8(%ecx),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107d:	89 01                	mov    %eax,(%ecx)
  80107f:	89 51 04             	mov    %edx,0x4(%ecx)
  801082:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801086:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108a:	77 e2                	ja     80106e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	74 23                	je     8010b5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801095:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801098:	eb 0e                	jmp    8010a8 <memset+0x91>
			*p8++ = (uint8)c;
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109d:	8d 50 01             	lea    0x1(%eax),%edx
  8010a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	75 e5                	jne    80109a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010cc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d0:	76 24                	jbe    8010f6 <memcpy+0x3c>
		while(n >= 8){
  8010d2:	eb 1c                	jmp    8010f0 <memcpy+0x36>
			*d64 = *s64;
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8b 50 04             	mov    0x4(%eax),%edx
  8010da:	8b 00                	mov    (%eax),%eax
  8010dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010df:	89 01                	mov    %eax,(%ecx)
  8010e1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010e8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010ec:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f4:	77 de                	ja     8010d4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	74 31                	je     80112d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801105:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801108:	eb 16                	jmp    801120 <memcpy+0x66>
			*d8++ = *s8++;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	8d 50 01             	lea    0x1(%eax),%edx
  801110:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801116:	8d 4a 01             	lea    0x1(%edx),%ecx
  801119:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80111c:	8a 12                	mov    (%edx),%dl
  80111e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 dd                	jne    80110a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114a:	73 50                	jae    80119c <memmove+0x6a>
  80114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	76 43                	jbe    80119c <memmove+0x6a>
		s += n;
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801165:	eb 10                	jmp    801177 <memmove+0x45>
			*--d = *--s;
  801167:	ff 4d f8             	decl   -0x8(%ebp)
  80116a:	ff 4d fc             	decl   -0x4(%ebp)
  80116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801170:	8a 10                	mov    (%eax),%dl
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801177:	8b 45 10             	mov    0x10(%ebp),%eax
  80117a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117d:	89 55 10             	mov    %edx,0x10(%ebp)
  801180:	85 c0                	test   %eax,%eax
  801182:	75 e3                	jne    801167 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801184:	eb 23                	jmp    8011a9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801192:	8d 4a 01             	lea    0x1(%edx),%ecx
  801195:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801198:	8a 12                	mov    (%edx),%dl
  80119a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	75 dd                	jne    801186 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c0:	eb 2a                	jmp    8011ec <memcmp+0x3e>
		if (*s1 != *s2)
  8011c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c5:	8a 10                	mov    (%eax),%dl
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	38 c2                	cmp    %al,%dl
  8011ce:	74 16                	je     8011e6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
  8011e4:	eb 18                	jmp    8011fe <memcmp+0x50>
		s1++, s2++;
  8011e6:	ff 45 fc             	incl   -0x4(%ebp)
  8011e9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	75 c9                	jne    8011c2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801206:	8b 55 08             	mov    0x8(%ebp),%edx
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801211:	eb 15                	jmp    801228 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 d0             	movzbl %al,%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	0f b6 c0             	movzbl %al,%eax
  801221:	39 c2                	cmp    %eax,%edx
  801223:	74 0d                	je     801232 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801225:	ff 45 08             	incl   0x8(%ebp)
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122e:	72 e3                	jb     801213 <memfind+0x13>
  801230:	eb 01                	jmp    801233 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801232:	90                   	nop
	return (void *) s;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801245:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124c:	eb 03                	jmp    801251 <strtol+0x19>
		s++;
  80124e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 20                	cmp    $0x20,%al
  801258:	74 f4                	je     80124e <strtol+0x16>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 09                	cmp    $0x9,%al
  801261:	74 eb                	je     80124e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 2b                	cmp    $0x2b,%al
  80126a:	75 05                	jne    801271 <strtol+0x39>
		s++;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	eb 13                	jmp    801284 <strtol+0x4c>
	else if (*s == '-')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 2d                	cmp    $0x2d,%al
  801278:	75 0a                	jne    801284 <strtol+0x4c>
		s++, neg = 1;
  80127a:	ff 45 08             	incl   0x8(%ebp)
  80127d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801284:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801288:	74 06                	je     801290 <strtol+0x58>
  80128a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128e:	75 20                	jne    8012b0 <strtol+0x78>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 30                	cmp    $0x30,%al
  801297:	75 17                	jne    8012b0 <strtol+0x78>
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	40                   	inc    %eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 78                	cmp    $0x78,%al
  8012a1:	75 0d                	jne    8012b0 <strtol+0x78>
		s += 2, base = 16;
  8012a3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ae:	eb 28                	jmp    8012d8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b4:	75 15                	jne    8012cb <strtol+0x93>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 30                	cmp    $0x30,%al
  8012bd:	75 0c                	jne    8012cb <strtol+0x93>
		s++, base = 8;
  8012bf:	ff 45 08             	incl   0x8(%ebp)
  8012c2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c9:	eb 0d                	jmp    8012d8 <strtol+0xa0>
	else if (base == 0)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 07                	jne    8012d8 <strtol+0xa0>
		base = 10;
  8012d1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 2f                	cmp    $0x2f,%al
  8012df:	7e 19                	jle    8012fa <strtol+0xc2>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 39                	cmp    $0x39,%al
  8012e8:	7f 10                	jg     8012fa <strtol+0xc2>
			dig = *s - '0';
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	83 e8 30             	sub    $0x30,%eax
  8012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f8:	eb 42                	jmp    80133c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	3c 60                	cmp    $0x60,%al
  801301:	7e 19                	jle    80131c <strtol+0xe4>
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	3c 7a                	cmp    $0x7a,%al
  80130a:	7f 10                	jg     80131c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	0f be c0             	movsbl %al,%eax
  801314:	83 e8 57             	sub    $0x57,%eax
  801317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131a:	eb 20                	jmp    80133c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	3c 40                	cmp    $0x40,%al
  801323:	7e 39                	jle    80135e <strtol+0x126>
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3c 5a                	cmp    $0x5a,%al
  80132c:	7f 30                	jg     80135e <strtol+0x126>
			dig = *s - 'A' + 10;
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	0f be c0             	movsbl %al,%eax
  801336:	83 e8 37             	sub    $0x37,%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801342:	7d 19                	jge    80135d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801344:	ff 45 08             	incl   0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134e:	89 c2                	mov    %eax,%edx
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801358:	e9 7b ff ff ff       	jmp    8012d8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801362:	74 08                	je     80136c <strtol+0x134>
		*endptr = (char *) s;
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801370:	74 07                	je     801379 <strtol+0x141>
  801372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801375:	f7 d8                	neg    %eax
  801377:	eb 03                	jmp    80137c <strtol+0x144>
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <ltostr>:

void
ltostr(long value, char *str)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80138b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801396:	79 13                	jns    8013ab <ltostr+0x2d>
	{
		neg = 1;
  801398:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b3:	99                   	cltd   
  8013b4:	f7 f9                	idiv   %ecx
  8013b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013cc:	83 c2 30             	add    $0x30,%edx
  8013cf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d9:	f7 e9                	imul   %ecx
  8013db:	c1 fa 02             	sar    $0x2,%edx
  8013de:	89 c8                	mov    %ecx,%eax
  8013e0:	c1 f8 1f             	sar    $0x1f,%eax
  8013e3:	29 c2                	sub    %eax,%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ee:	75 bb                	jne    8013ab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fa:	48                   	dec    %eax
  8013fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801402:	74 3d                	je     801441 <ltostr+0xc3>
		start = 1 ;
  801404:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80140b:	eb 34                	jmp    801441 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 c2                	add    %eax,%edx
  801422:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 c8                	add    %ecx,%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80142e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 c2                	add    %eax,%edx
  801436:	8a 45 eb             	mov    -0x15(%ebp),%al
  801439:	88 02                	mov    %al,(%edx)
		start++ ;
  80143b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80143e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801447:	7c c4                	jl     80140d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801449:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	01 d0                	add    %edx,%eax
  801451:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80145d:	ff 75 08             	pushl  0x8(%ebp)
  801460:	e8 c4 f9 ff ff       	call   800e29 <strlen>
  801465:	83 c4 04             	add    $0x4,%esp
  801468:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80146b:	ff 75 0c             	pushl  0xc(%ebp)
  80146e:	e8 b6 f9 ff ff       	call   800e29 <strlen>
  801473:	83 c4 04             	add    $0x4,%esp
  801476:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801487:	eb 17                	jmp    8014a0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 c2                	add    %eax,%edx
  801491:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	01 c8                	add    %ecx,%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80149d:	ff 45 fc             	incl   -0x4(%ebp)
  8014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014a6:	7c e1                	jl     801489 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014b6:	eb 1f                	jmp    8014d7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 c2                	add    %eax,%edx
  8014c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ce:	01 c8                	add    %ecx,%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d4:	ff 45 f8             	incl   -0x8(%ebp)
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014dd:	7c d9                	jl     8014b8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e5:	01 d0                	add    %edx,%eax
  8014e7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ea:	90                   	nop
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801505:	8b 45 10             	mov    0x10(%ebp),%eax
  801508:	01 d0                	add    %edx,%eax
  80150a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801510:	eb 0c                	jmp    80151e <strsplit+0x31>
			*string++ = 0;
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 08             	mov    %edx,0x8(%ebp)
  80151b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	84 c0                	test   %al,%al
  801525:	74 18                	je     80153f <strsplit+0x52>
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	50                   	push   %eax
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	e8 83 fa ff ff       	call   800fbb <strchr>
  801538:	83 c4 08             	add    $0x8,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	75 d3                	jne    801512 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	84 c0                	test   %al,%al
  801546:	74 5a                	je     8015a2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801548:	8b 45 14             	mov    0x14(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	83 f8 0f             	cmp    $0xf,%eax
  801550:	75 07                	jne    801559 <strsplit+0x6c>
		{
			return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	eb 66                	jmp    8015bf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	8d 48 01             	lea    0x1(%eax),%ecx
  801561:	8b 55 14             	mov    0x14(%ebp),%edx
  801564:	89 0a                	mov    %ecx,(%edx)
  801566:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	01 c2                	add    %eax,%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801577:	eb 03                	jmp    80157c <strsplit+0x8f>
			string++;
  801579:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	84 c0                	test   %al,%al
  801583:	74 8b                	je     801510 <strsplit+0x23>
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	0f be c0             	movsbl %al,%eax
  80158d:	50                   	push   %eax
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	e8 25 fa ff ff       	call   800fbb <strchr>
  801596:	83 c4 08             	add    $0x8,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	74 dc                	je     801579 <strsplit+0x8c>
			string++;
	}
  80159d:	e9 6e ff ff ff       	jmp    801510 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d4:	eb 4a                	jmp    801620 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	01 c2                	add    %eax,%edx
  8015de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c8                	add    %ecx,%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	3c 40                	cmp    $0x40,%al
  8015f6:	7e 25                	jle    80161d <str2lower+0x5c>
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	3c 5a                	cmp    $0x5a,%al
  801604:	7f 17                	jg     80161d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801606:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
  801614:	01 ca                	add    %ecx,%edx
  801616:	8a 12                	mov    (%edx),%dl
  801618:	83 c2 20             	add    $0x20,%edx
  80161b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80161d:	ff 45 fc             	incl   -0x4(%ebp)
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	e8 01 f8 ff ff       	call   800e29 <strlen>
  801628:	83 c4 04             	add    $0x4,%esp
  80162b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80162e:	7f a6                	jg     8015d6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80163b:	a1 08 30 80 00       	mov    0x803008,%eax
  801640:	85 c0                	test   %eax,%eax
  801642:	74 42                	je     801686 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	68 00 00 00 82       	push   $0x82000000
  80164c:	68 00 00 00 80       	push   $0x80000000
  801651:	e8 8c 07 00 00       	call   801de2 <initialize_dynamic_allocator>
  801656:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801659:	e8 e7 05 00 00       	call   801c45 <sys_get_uheap_strategy>
  80165e:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801663:	a1 40 30 80 00       	mov    0x803040,%eax
  801668:	05 00 10 00 00       	add    $0x1000,%eax
  80166d:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801672:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801677:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  80167c:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801683:	00 00 00 
	}
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	68 06 04 00 00       	push   $0x406
  8016a5:	50                   	push   %eax
  8016a6:	e8 e4 01 00 00       	call   80188f <__sys_allocate_page>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b5:	79 14                	jns    8016cb <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 68 2a 80 00       	push   $0x802a68
  8016bf:	6a 1f                	push   $0x1f
  8016c1:	68 a4 2a 80 00       	push   $0x802aa4
  8016c6:	e8 b7 ed ff ff       	call   800482 <_panic>
	return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e6:	83 ec 0c             	sub    $0xc,%esp
  8016e9:	50                   	push   %eax
  8016ea:	e8 e7 01 00 00       	call   8018d6 <__sys_unmap_frame>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f9:	79 14                	jns    80170f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 b0 2a 80 00       	push   $0x802ab0
  801703:	6a 2a                	push   $0x2a
  801705:	68 a4 2a 80 00       	push   $0x802aa4
  80170a:	e8 73 ed ff ff       	call   800482 <_panic>
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801718:	e8 18 ff ff ff       	call   801635 <uheap_init>
	if (size == 0) return NULL ;
  80171d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801721:	75 07                	jne    80172a <malloc+0x18>
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	eb 14                	jmp    80173e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	68 f0 2a 80 00       	push   $0x802af0
  801732:	6a 3e                	push   $0x3e
  801734:	68 a4 2a 80 00       	push   $0x802aa4
  801739:	e8 44 ed ff ff       	call   800482 <_panic>
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 18 2b 80 00       	push   $0x802b18
  80174e:	6a 49                	push   $0x49
  801750:	68 a4 2a 80 00       	push   $0x802aa4
  801755:	e8 28 ed ff ff       	call   800482 <_panic>

0080175a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 18             	sub    $0x18,%esp
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801766:	e8 ca fe ff ff       	call   801635 <uheap_init>
	if (size == 0) return NULL ;
  80176b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176f:	75 07                	jne    801778 <smalloc+0x1e>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 14                	jmp    80178c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 3c 2b 80 00       	push   $0x802b3c
  801780:	6a 5a                	push   $0x5a
  801782:	68 a4 2a 80 00       	push   $0x802aa4
  801787:	e8 f6 ec ff ff       	call   800482 <_panic>
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801794:	e8 9c fe ff ff       	call   801635 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	68 64 2b 80 00       	push   $0x802b64
  8017a1:	6a 6a                	push   $0x6a
  8017a3:	68 a4 2a 80 00       	push   $0x802aa4
  8017a8:	e8 d5 ec ff ff       	call   800482 <_panic>

008017ad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017b3:	e8 7d fe ff ff       	call   801635 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 88 2b 80 00       	push   $0x802b88
  8017c0:	68 88 00 00 00       	push   $0x88
  8017c5:	68 a4 2a 80 00       	push   $0x802aa4
  8017ca:	e8 b3 ec ff ff       	call   800482 <_panic>

008017cf <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 b0 2b 80 00       	push   $0x802bb0
  8017dd:	68 9b 00 00 00       	push   $0x9b
  8017e2:	68 a4 2a 80 00       	push   $0x802aa4
  8017e7:	e8 96 ec ff ff       	call   800482 <_panic>

008017ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	57                   	push   %edi
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801801:	8b 7d 18             	mov    0x18(%ebp),%edi
  801804:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801807:	cd 30                	int    $0x30
  801809:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5f                   	pop    %edi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
  801820:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801823:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801826:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	51                   	push   %ecx
  801830:	52                   	push   %edx
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	50                   	push   %eax
  801835:	6a 00                	push   $0x0
  801837:	e8 b0 ff ff ff       	call   8017ec <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_cgetc>:

int
sys_cgetc(void)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 02                	push   $0x2
  801851:	e8 96 ff ff ff       	call   8017ec <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 03                	push   $0x3
  80186a:	e8 7d ff ff ff       	call   8017ec <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 04                	push   $0x4
  801884:	e8 63 ff ff ff       	call   8017ec <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	90                   	nop
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 08                	push   $0x8
  8018a2:	e8 45 ff ff ff       	call   8017ec <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	51                   	push   %ecx
  8018c3:	52                   	push   %edx
  8018c4:	50                   	push   %eax
  8018c5:	6a 09                	push   $0x9
  8018c7:	e8 20 ff ff ff       	call   8017ec <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	6a 0a                	push   $0xa
  8018e6:	e8 01 ff ff ff       	call   8017ec <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 0b                	push   $0xb
  801901:	e8 e6 fe ff ff       	call   8017ec <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 0c                	push   $0xc
  80191a:	e8 cd fe ff ff       	call   8017ec <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 0d                	push   $0xd
  801933:	e8 b4 fe ff ff       	call   8017ec <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 0e                	push   $0xe
  80194c:	e8 9b fe ff ff       	call   8017ec <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 0f                	push   $0xf
  801965:	e8 82 fe ff ff       	call   8017ec <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 10                	push   $0x10
  80197f:	e8 68 fe ff ff       	call   8017ec <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 11                	push   $0x11
  801998:	e8 4f fe ff ff       	call   8017ec <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	90                   	nop
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	50                   	push   %eax
  8019bc:	6a 01                	push   $0x1
  8019be:	e8 29 fe ff ff       	call   8017ec <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	90                   	nop
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 14                	push   $0x14
  8019d8:	e8 0f fe ff ff       	call   8017ec <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	51                   	push   %ecx
  8019fc:	52                   	push   %edx
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	50                   	push   %eax
  801a01:	6a 15                	push   $0x15
  801a03:	e8 e4 fd ff ff       	call   8017ec <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	6a 16                	push   $0x16
  801a20:	e8 c7 fd ff ff       	call   8017ec <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	51                   	push   %ecx
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	6a 17                	push   $0x17
  801a3f:	e8 a8 fd ff ff       	call   8017ec <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	52                   	push   %edx
  801a59:	50                   	push   %eax
  801a5a:	6a 18                	push   $0x18
  801a5c:	e8 8b fd ff ff       	call   8017ec <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 14             	pushl  0x14(%ebp)
  801a71:	ff 75 10             	pushl  0x10(%ebp)
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	6a 19                	push   $0x19
  801a7a:	e8 6d fd ff ff       	call   8017ec <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	50                   	push   %eax
  801a93:	6a 1a                	push   $0x1a
  801a95:	e8 52 fd ff ff       	call   8017ec <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	50                   	push   %eax
  801aaf:	6a 1b                	push   $0x1b
  801ab1:	e8 36 fd ff ff       	call   8017ec <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 05                	push   $0x5
  801aca:	e8 1d fd ff ff       	call   8017ec <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 06                	push   $0x6
  801ae3:	e8 04 fd ff ff       	call   8017ec <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 07                	push   $0x7
  801afc:	e8 eb fc ff ff       	call   8017ec <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_exit_env>:


void sys_exit_env(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 1c                	push   $0x1c
  801b15:	e8 d2 fc ff ff       	call   8017ec <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b26:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b29:	8d 50 04             	lea    0x4(%eax),%edx
  801b2c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 1d                	push   $0x1d
  801b39:	e8 ae fc ff ff       	call   8017ec <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4a:	89 01                	mov    %eax,(%ecx)
  801b4c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	c9                   	leave  
  801b53:	c2 04 00             	ret    $0x4

00801b56 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 10             	pushl  0x10(%ebp)
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	ff 75 08             	pushl  0x8(%ebp)
  801b66:	6a 13                	push   $0x13
  801b68:	e8 7f fc ff ff       	call   8017ec <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b70:	90                   	nop
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 1e                	push   $0x1e
  801b82:	e8 65 fc ff ff       	call   8017ec <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b98:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	50                   	push   %eax
  801ba5:	6a 1f                	push   $0x1f
  801ba7:	e8 40 fc ff ff       	call   8017ec <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <rsttst>:
void rsttst()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 21                	push   $0x21
  801bc1:	e8 26 fc ff ff       	call   8017ec <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc9:	90                   	nop
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bd8:	8b 55 18             	mov    0x18(%ebp),%edx
  801bdb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	ff 75 10             	pushl  0x10(%ebp)
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	6a 20                	push   $0x20
  801bec:	e8 fb fb ff ff       	call   8017ec <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf4:	90                   	nop
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <chktst>:
void chktst(uint32 n)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 22                	push   $0x22
  801c07:	e8 e0 fb ff ff       	call   8017ec <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <inctst>:

void inctst()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 23                	push   $0x23
  801c21:	e8 c6 fb ff ff       	call   8017ec <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <gettst>:
uint32 gettst()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 24                	push   $0x24
  801c3b:	e8 ac fb ff ff       	call   8017ec <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 25                	push   $0x25
  801c54:	e8 93 fb ff ff       	call   8017ec <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
  801c5c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c61:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	6a 26                	push   $0x26
  801c80:	e8 67 fb ff ff       	call   8017ec <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return ;
  801c88:	90                   	nop
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	53                   	push   %ebx
  801c9e:	51                   	push   %ecx
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	6a 27                	push   $0x27
  801ca3:	e8 44 fb ff ff       	call   8017ec <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	52                   	push   %edx
  801cc0:	50                   	push   %eax
  801cc1:	6a 28                	push   $0x28
  801cc3:	e8 24 fb ff ff       	call   8017ec <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cd0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	51                   	push   %ecx
  801cdc:	ff 75 10             	pushl  0x10(%ebp)
  801cdf:	52                   	push   %edx
  801ce0:	50                   	push   %eax
  801ce1:	6a 29                	push   $0x29
  801ce3:	e8 04 fb ff ff       	call   8017ec <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	ff 75 10             	pushl  0x10(%ebp)
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	ff 75 08             	pushl  0x8(%ebp)
  801cfd:	6a 12                	push   $0x12
  801cff:	e8 e8 fa ff ff       	call   8017ec <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	52                   	push   %edx
  801d1a:	50                   	push   %eax
  801d1b:	6a 2a                	push   $0x2a
  801d1d:	e8 ca fa ff ff       	call   8017ec <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 2b                	push   $0x2b
  801d37:	e8 b0 fa ff ff       	call   8017ec <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	6a 2d                	push   $0x2d
  801d52:	e8 95 fa ff ff       	call   8017ec <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 2c                	push   $0x2c
  801d6e:	e8 79 fa ff ff       	call   8017ec <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return ;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 d4 2b 80 00       	push   $0x802bd4
  801d87:	68 25 01 00 00       	push   $0x125
  801d8c:	68 07 2c 80 00       	push   $0x802c07
  801d91:	e8 ec e6 ff ff       	call   800482 <_panic>

00801d96 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	ba 60 30 80 00       	mov    $0x803060,%edx
  801da4:	29 d0                	sub    %edx,%eax
  801da6:	c1 f8 02             	sar    $0x2,%eax
  801da9:	89 c2                	mov    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	c1 e0 02             	shl    $0x2,%eax
  801db5:	01 d0                	add    %edx,%eax
  801db7:	c1 e0 02             	shl    $0x2,%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	89 c1                	mov    %eax,%ecx
  801dbe:	c1 e1 08             	shl    $0x8,%ecx
  801dc1:	01 c8                	add    %ecx,%eax
  801dc3:	89 c1                	mov    %eax,%ecx
  801dc5:	c1 e1 10             	shl    $0x10,%ecx
  801dc8:	01 c8                	add    %ecx,%eax
  801dca:	01 c0                	add    %eax,%eax
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd4:	c1 e0 0c             	shl    $0xc,%eax
  801dd7:	89 c2                	mov    %eax,%edx
  801dd9:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801dde:	01 d0                	add    %edx,%eax
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	05 00 00 00 02       	add    $0x2000000,%eax
  801df0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801df3:	73 16                	jae    801e0b <initialize_dynamic_allocator+0x29>
  801df5:	68 18 2c 80 00       	push   $0x802c18
  801dfa:	68 3e 2c 80 00       	push   $0x802c3e
  801dff:	6a 26                	push   $0x26
  801e01:	68 53 2c 80 00       	push   $0x802c53
  801e06:	e8 77 e6 ff ff       	call   800482 <_panic>
		is_initialized = 1;
  801e0b:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801e12:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	68 6c 2c 80 00       	push   $0x802c6c
  801e1d:	6a 2e                	push   $0x2e
  801e1f:	68 53 2c 80 00       	push   $0x802c53
  801e24:	e8 59 e6 ff ff       	call   800482 <_panic>

00801e29 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	68 a0 2c 80 00       	push   $0x802ca0
  801e37:	6a 3a                	push   $0x3a
  801e39:	68 53 2c 80 00       	push   $0x802c53
  801e3e:	e8 3f e6 ff ff       	call   800482 <_panic>

00801e43 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e49:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e50:	76 16                	jbe    801e68 <alloc_block+0x25>
  801e52:	68 c8 2c 80 00       	push   $0x802cc8
  801e57:	68 3e 2c 80 00       	push   $0x802c3e
  801e5c:	6a 46                	push   $0x46
  801e5e:	68 53 2c 80 00       	push   $0x802c53
  801e63:	e8 1a e6 ff ff       	call   800482 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	68 ec 2c 80 00       	push   $0x802cec
  801e70:	6a 4d                	push   $0x4d
  801e72:	68 53 2c 80 00       	push   $0x802c53
  801e77:	e8 06 e6 ff ff       	call   800482 <_panic>

00801e7c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e82:	8b 55 08             	mov    0x8(%ebp),%edx
  801e85:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e8a:	39 c2                	cmp    %eax,%edx
  801e8c:	72 0c                	jb     801e9a <free_block+0x1e>
  801e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e91:	a1 40 30 80 00       	mov    0x803040,%eax
  801e96:	39 c2                	cmp    %eax,%edx
  801e98:	72 16                	jb     801eb0 <free_block+0x34>
  801e9a:	68 10 2d 80 00       	push   $0x802d10
  801e9f:	68 3e 2c 80 00       	push   $0x802c3e
  801ea4:	6a 5b                	push   $0x5b
  801ea6:	68 53 2c 80 00       	push   $0x802c53
  801eab:	e8 d2 e5 ff ff       	call   800482 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	68 48 2d 80 00       	push   $0x802d48
  801eb8:	6a 63                	push   $0x63
  801eba:	68 53 2c 80 00       	push   $0x802c53
  801ebf:	e8 be e5 ff ff       	call   800482 <_panic>

00801ec4 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	68 6c 2d 80 00       	push   $0x802d6c
  801ed2:	6a 72                	push   $0x72
  801ed4:	68 53 2c 80 00       	push   $0x802c53
  801ed9:	e8 a4 e5 ff ff       	call   800482 <_panic>
  801ede:	66 90                	xchg   %ax,%ax

00801ee0 <__udivdi3>:
  801ee0:	55                   	push   %ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 1c             	sub    $0x1c,%esp
  801ee7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eeb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ef3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef7:	89 ca                	mov    %ecx,%edx
  801ef9:	89 f8                	mov    %edi,%eax
  801efb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801eff:	85 f6                	test   %esi,%esi
  801f01:	75 2d                	jne    801f30 <__udivdi3+0x50>
  801f03:	39 cf                	cmp    %ecx,%edi
  801f05:	77 65                	ja     801f6c <__udivdi3+0x8c>
  801f07:	89 fd                	mov    %edi,%ebp
  801f09:	85 ff                	test   %edi,%edi
  801f0b:	75 0b                	jne    801f18 <__udivdi3+0x38>
  801f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f12:	31 d2                	xor    %edx,%edx
  801f14:	f7 f7                	div    %edi
  801f16:	89 c5                	mov    %eax,%ebp
  801f18:	31 d2                	xor    %edx,%edx
  801f1a:	89 c8                	mov    %ecx,%eax
  801f1c:	f7 f5                	div    %ebp
  801f1e:	89 c1                	mov    %eax,%ecx
  801f20:	89 d8                	mov    %ebx,%eax
  801f22:	f7 f5                	div    %ebp
  801f24:	89 cf                	mov    %ecx,%edi
  801f26:	89 fa                	mov    %edi,%edx
  801f28:	83 c4 1c             	add    $0x1c,%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5f                   	pop    %edi
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    
  801f30:	39 ce                	cmp    %ecx,%esi
  801f32:	77 28                	ja     801f5c <__udivdi3+0x7c>
  801f34:	0f bd fe             	bsr    %esi,%edi
  801f37:	83 f7 1f             	xor    $0x1f,%edi
  801f3a:	75 40                	jne    801f7c <__udivdi3+0x9c>
  801f3c:	39 ce                	cmp    %ecx,%esi
  801f3e:	72 0a                	jb     801f4a <__udivdi3+0x6a>
  801f40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f44:	0f 87 9e 00 00 00    	ja     801fe8 <__udivdi3+0x108>
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	89 fa                	mov    %edi,%edx
  801f51:	83 c4 1c             	add    $0x1c,%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    
  801f59:	8d 76 00             	lea    0x0(%esi),%esi
  801f5c:	31 ff                	xor    %edi,%edi
  801f5e:	31 c0                	xor    %eax,%eax
  801f60:	89 fa                	mov    %edi,%edx
  801f62:	83 c4 1c             	add    $0x1c,%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5f                   	pop    %edi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    
  801f6a:	66 90                	xchg   %ax,%ax
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	f7 f7                	div    %edi
  801f70:	31 ff                	xor    %edi,%edi
  801f72:	89 fa                	mov    %edi,%edx
  801f74:	83 c4 1c             	add    $0x1c,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    
  801f7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f81:	89 eb                	mov    %ebp,%ebx
  801f83:	29 fb                	sub    %edi,%ebx
  801f85:	89 f9                	mov    %edi,%ecx
  801f87:	d3 e6                	shl    %cl,%esi
  801f89:	89 c5                	mov    %eax,%ebp
  801f8b:	88 d9                	mov    %bl,%cl
  801f8d:	d3 ed                	shr    %cl,%ebp
  801f8f:	89 e9                	mov    %ebp,%ecx
  801f91:	09 f1                	or     %esi,%ecx
  801f93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f97:	89 f9                	mov    %edi,%ecx
  801f99:	d3 e0                	shl    %cl,%eax
  801f9b:	89 c5                	mov    %eax,%ebp
  801f9d:	89 d6                	mov    %edx,%esi
  801f9f:	88 d9                	mov    %bl,%cl
  801fa1:	d3 ee                	shr    %cl,%esi
  801fa3:	89 f9                	mov    %edi,%ecx
  801fa5:	d3 e2                	shl    %cl,%edx
  801fa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fab:	88 d9                	mov    %bl,%cl
  801fad:	d3 e8                	shr    %cl,%eax
  801faf:	09 c2                	or     %eax,%edx
  801fb1:	89 d0                	mov    %edx,%eax
  801fb3:	89 f2                	mov    %esi,%edx
  801fb5:	f7 74 24 0c          	divl   0xc(%esp)
  801fb9:	89 d6                	mov    %edx,%esi
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	f7 e5                	mul    %ebp
  801fbf:	39 d6                	cmp    %edx,%esi
  801fc1:	72 19                	jb     801fdc <__udivdi3+0xfc>
  801fc3:	74 0b                	je     801fd0 <__udivdi3+0xf0>
  801fc5:	89 d8                	mov    %ebx,%eax
  801fc7:	31 ff                	xor    %edi,%edi
  801fc9:	e9 58 ff ff ff       	jmp    801f26 <__udivdi3+0x46>
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fd4:	89 f9                	mov    %edi,%ecx
  801fd6:	d3 e2                	shl    %cl,%edx
  801fd8:	39 c2                	cmp    %eax,%edx
  801fda:	73 e9                	jae    801fc5 <__udivdi3+0xe5>
  801fdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fdf:	31 ff                	xor    %edi,%edi
  801fe1:	e9 40 ff ff ff       	jmp    801f26 <__udivdi3+0x46>
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	31 c0                	xor    %eax,%eax
  801fea:	e9 37 ff ff ff       	jmp    801f26 <__udivdi3+0x46>
  801fef:	90                   	nop

00801ff0 <__umoddi3>:
  801ff0:	55                   	push   %ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 1c             	sub    $0x1c,%esp
  801ff7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ffb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802003:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802007:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80200b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80200f:	89 f3                	mov    %esi,%ebx
  802011:	89 fa                	mov    %edi,%edx
  802013:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802017:	89 34 24             	mov    %esi,(%esp)
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 1a                	jne    802038 <__umoddi3+0x48>
  80201e:	39 f7                	cmp    %esi,%edi
  802020:	0f 86 a2 00 00 00    	jbe    8020c8 <__umoddi3+0xd8>
  802026:	89 c8                	mov    %ecx,%eax
  802028:	89 f2                	mov    %esi,%edx
  80202a:	f7 f7                	div    %edi
  80202c:	89 d0                	mov    %edx,%eax
  80202e:	31 d2                	xor    %edx,%edx
  802030:	83 c4 1c             	add    $0x1c,%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5f                   	pop    %edi
  802036:	5d                   	pop    %ebp
  802037:	c3                   	ret    
  802038:	39 f0                	cmp    %esi,%eax
  80203a:	0f 87 ac 00 00 00    	ja     8020ec <__umoddi3+0xfc>
  802040:	0f bd e8             	bsr    %eax,%ebp
  802043:	83 f5 1f             	xor    $0x1f,%ebp
  802046:	0f 84 ac 00 00 00    	je     8020f8 <__umoddi3+0x108>
  80204c:	bf 20 00 00 00       	mov    $0x20,%edi
  802051:	29 ef                	sub    %ebp,%edi
  802053:	89 fe                	mov    %edi,%esi
  802055:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802059:	89 e9                	mov    %ebp,%ecx
  80205b:	d3 e0                	shl    %cl,%eax
  80205d:	89 d7                	mov    %edx,%edi
  80205f:	89 f1                	mov    %esi,%ecx
  802061:	d3 ef                	shr    %cl,%edi
  802063:	09 c7                	or     %eax,%edi
  802065:	89 e9                	mov    %ebp,%ecx
  802067:	d3 e2                	shl    %cl,%edx
  802069:	89 14 24             	mov    %edx,(%esp)
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	d3 e0                	shl    %cl,%eax
  802070:	89 c2                	mov    %eax,%edx
  802072:	8b 44 24 08          	mov    0x8(%esp),%eax
  802076:	d3 e0                	shl    %cl,%eax
  802078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802080:	89 f1                	mov    %esi,%ecx
  802082:	d3 e8                	shr    %cl,%eax
  802084:	09 d0                	or     %edx,%eax
  802086:	d3 eb                	shr    %cl,%ebx
  802088:	89 da                	mov    %ebx,%edx
  80208a:	f7 f7                	div    %edi
  80208c:	89 d3                	mov    %edx,%ebx
  80208e:	f7 24 24             	mull   (%esp)
  802091:	89 c6                	mov    %eax,%esi
  802093:	89 d1                	mov    %edx,%ecx
  802095:	39 d3                	cmp    %edx,%ebx
  802097:	0f 82 87 00 00 00    	jb     802124 <__umoddi3+0x134>
  80209d:	0f 84 91 00 00 00    	je     802134 <__umoddi3+0x144>
  8020a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020a7:	29 f2                	sub    %esi,%edx
  8020a9:	19 cb                	sbb    %ecx,%ebx
  8020ab:	89 d8                	mov    %ebx,%eax
  8020ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020b1:	d3 e0                	shl    %cl,%eax
  8020b3:	89 e9                	mov    %ebp,%ecx
  8020b5:	d3 ea                	shr    %cl,%edx
  8020b7:	09 d0                	or     %edx,%eax
  8020b9:	89 e9                	mov    %ebp,%ecx
  8020bb:	d3 eb                	shr    %cl,%ebx
  8020bd:	89 da                	mov    %ebx,%edx
  8020bf:	83 c4 1c             	add    $0x1c,%esp
  8020c2:	5b                   	pop    %ebx
  8020c3:	5e                   	pop    %esi
  8020c4:	5f                   	pop    %edi
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    
  8020c7:	90                   	nop
  8020c8:	89 fd                	mov    %edi,%ebp
  8020ca:	85 ff                	test   %edi,%edi
  8020cc:	75 0b                	jne    8020d9 <__umoddi3+0xe9>
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d3:	31 d2                	xor    %edx,%edx
  8020d5:	f7 f7                	div    %edi
  8020d7:	89 c5                	mov    %eax,%ebp
  8020d9:	89 f0                	mov    %esi,%eax
  8020db:	31 d2                	xor    %edx,%edx
  8020dd:	f7 f5                	div    %ebp
  8020df:	89 c8                	mov    %ecx,%eax
  8020e1:	f7 f5                	div    %ebp
  8020e3:	89 d0                	mov    %edx,%eax
  8020e5:	e9 44 ff ff ff       	jmp    80202e <__umoddi3+0x3e>
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	89 c8                	mov    %ecx,%eax
  8020ee:	89 f2                	mov    %esi,%edx
  8020f0:	83 c4 1c             	add    $0x1c,%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    
  8020f8:	3b 04 24             	cmp    (%esp),%eax
  8020fb:	72 06                	jb     802103 <__umoddi3+0x113>
  8020fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802101:	77 0f                	ja     802112 <__umoddi3+0x122>
  802103:	89 f2                	mov    %esi,%edx
  802105:	29 f9                	sub    %edi,%ecx
  802107:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80210b:	89 14 24             	mov    %edx,(%esp)
  80210e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802112:	8b 44 24 04          	mov    0x4(%esp),%eax
  802116:	8b 14 24             	mov    (%esp),%edx
  802119:	83 c4 1c             	add    $0x1c,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    
  802121:	8d 76 00             	lea    0x0(%esi),%esi
  802124:	2b 04 24             	sub    (%esp),%eax
  802127:	19 fa                	sbb    %edi,%edx
  802129:	89 d1                	mov    %edx,%ecx
  80212b:	89 c6                	mov    %eax,%esi
  80212d:	e9 71 ff ff ff       	jmp    8020a3 <__umoddi3+0xb3>
  802132:	66 90                	xchg   %ax,%ax
  802134:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802138:	72 ea                	jb     802124 <__umoddi3+0x134>
  80213a:	89 d9                	mov    %ebx,%ecx
  80213c:	e9 62 ff ff ff       	jmp    8020a3 <__umoddi3+0xb3>


obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 d5 03 00 00       	call   80040b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 00    	sub    $0xac,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800044:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80004b:	e8 f4 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800050:	89 45 e0             	mov    %eax,-0x20(%ebp)
	x = smalloc("x", 4, 0);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	6a 00                	push   $0x0
  800058:	6a 04                	push   $0x4
  80005a:	68 40 23 80 00       	push   $0x802340
  80005f:	e8 2f 18 00 00       	call   801893 <smalloc>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)pagealloc_start) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80006a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80006d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  800070:	74 14                	je     800086 <_main+0x4e>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 44 23 80 00       	push   $0x802344
  80007a:	6a 1a                	push   $0x1a
  80007c:	68 a7 23 80 00       	push   $0x8023a7
  800081:	e8 35 05 00 00       	call   8005bb <_panic>
	expected = 1+1 ; /*1page +1table*/
  800086:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80008d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800090:	e8 af 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800095:	29 c3                	sub    %eax,%ebx
  800097:	89 d8                	mov    %ebx,%eax
  800099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80009c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80009f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000a2:	7c 0b                	jl     8000af <_main+0x77>
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	83 c0 02             	add    $0x2,%eax
  8000aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000ad:	7d 24                	jge    8000d3 <_main+0x9b>
  8000af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000b2:	e8 8d 19 00 00       	call   801a44 <sys_calculate_free_frames>
  8000b7:	29 c3                	sub    %eax,%ebx
  8000b9:	89 d8                	mov    %ebx,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 d8             	pushl  -0x28(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	68 c8 23 80 00       	push   $0x8023c8
  8000c7:	6a 1d                	push   $0x1d
  8000c9:	68 a7 23 80 00       	push   $0x8023a7
  8000ce:	e8 e8 04 00 00       	call   8005bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000d3:	e8 6c 19 00 00       	call   801a44 <sys_calculate_free_frames>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	y = smalloc("y", 4, 0);
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 04                	push   $0x4
  8000e2:	68 60 24 80 00       	push   $0x802460
  8000e7:	e8 a7 17 00 00       	call   801893 <smalloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	05 00 10 00 00       	add    $0x1000,%eax
  8000fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 44 23 80 00       	push   $0x802344
  800107:	6a 22                	push   $0x22
  800109:	68 a7 23 80 00       	push   $0x8023a7
  80010e:	e8 a8 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  800113:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80011a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80011d:	e8 22 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80012f:	7c 0b                	jl     80013c <_main+0x104>
  800131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800134:	83 c0 02             	add    $0x2,%eax
  800137:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013a:	7d 24                	jge    800160 <_main+0x128>
  80013c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80013f:	e8 00 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800144:	29 c3                	sub    %eax,%ebx
  800146:	89 d8                	mov    %ebx,%eax
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	ff 75 d8             	pushl  -0x28(%ebp)
  80014e:	50                   	push   %eax
  80014f:	68 c8 23 80 00       	push   $0x8023c8
  800154:	6a 25                	push   $0x25
  800156:	68 a7 23 80 00       	push   $0x8023a7
  80015b:	e8 5b 04 00 00       	call   8005bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 df 18 00 00       	call   801a44 <sys_calculate_free_frames>
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 62 24 80 00       	push   $0x802462
  800174:	e8 1a 17 00 00       	call   801893 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800182:	05 00 20 00 00       	add    $0x2000,%eax
  800187:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 44 23 80 00       	push   $0x802344
  800194:	6a 2a                	push   $0x2a
  800196:	68 a7 23 80 00       	push   $0x8023a7
  80019b:	e8 1b 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  8001a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001aa:	e8 95 18 00 00       	call   801a44 <sys_calculate_free_frames>
  8001af:	29 c3                	sub    %eax,%ebx
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001bc:	7c 0b                	jl     8001c9 <_main+0x191>
  8001be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c1:	83 c0 02             	add    $0x2,%eax
  8001c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c7:	7d 24                	jge    8001ed <_main+0x1b5>
  8001c9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001cc:	e8 73 18 00 00       	call   801a44 <sys_calculate_free_frames>
  8001d1:	29 c3                	sub    %eax,%ebx
  8001d3:	89 d8                	mov    %ebx,%eax
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 c8 23 80 00       	push   $0x8023c8
  8001e1:	6a 2d                	push   $0x2d
  8001e3:	68 a7 23 80 00       	push   $0x8023a7
  8001e8:	e8 ce 03 00 00       	call   8005bb <_panic>

	*x = 10 ;
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f9:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800204:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	a1 20 30 80 00       	mov    0x803020,%eax
  800211:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800217:	6a 32                	push   $0x32
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 64 24 80 00       	push   $0x802464
  800220:	e8 7a 19 00 00       	call   801b9f <sys_create_env>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800243:	6a 32                	push   $0x32
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 64 24 80 00       	push   $0x802464
  80024c:	e8 4e 19 00 00       	call   801b9f <sys_create_env>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800262:	89 c2                	mov    %eax,%edx
  800264:	a1 20 30 80 00       	mov    0x803020,%eax
  800269:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80026f:	6a 32                	push   $0x32
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 64 24 80 00       	push   $0x802464
  800278:	e8 22 19 00 00       	call   801b9f <sys_create_env>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800283:	e8 63 1a 00 00       	call   801ceb <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	6a 01                	push   $0x1
  80028d:	6a 04                	push   $0x4
  80028f:	68 72 24 80 00       	push   $0x802472
  800294:	e8 fa 15 00 00       	call   801893 <smalloc>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 bc             	mov    %eax,-0x44(%ebp)

	sys_run_env(id1);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8002a5:	e8 13 19 00 00       	call   801bbd <sys_run_env>
  8002aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002b3:	e8 05 19 00 00       	call   801bbd <sys_run_env>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c1:	e8 f7 18 00 00       	call   801bbd <sys_run_env>
  8002c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	68 98 3a 00 00       	push   $0x3a98
  8002d1:	e8 41 1d 00 00       	call   802017 <env_sleep>
  8002d6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ; //panic("test failed");
  8002d9:	90                   	nop
  8002da:	e8 86 1a 00 00       	call   801d65 <gettst>
  8002df:	83 f8 03             	cmp    $0x3,%eax
  8002e2:	75 f6                	jne    8002da <_main+0x2a2>


	if (*z != 30)
  8002e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	83 f8 1e             	cmp    $0x1e,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 84 24 80 00       	push   $0x802484
  8002f6:	6a 47                	push   $0x47
  8002f8:	68 a7 23 80 00       	push   $0x8023a7
  8002fd:	e8 b9 02 00 00       	call   8005bb <_panic>
	else
		cprintf("test sharing 2 [Create & Get] is finished. Now, it'll destroy its children...\n\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 d4 24 80 00       	push   $0x8024d4
  80030a:	e8 7a 05 00 00       	call   800889 <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800312:	e8 0f 19 00 00       	call   801c26 <sys_getparentenvid>
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 8e e3 00 00 00    	jle    800402 <_main+0x3ca>
		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames

		char changeIntCmd[100] = "__changeInterruptStatus__";
  80031f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800325:	bb da 25 80 00       	mov    $0x8025da,%ebx
  80032a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 95 6e ff ff ff    	lea    -0x92(%ebp),%edx
  80033d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800342:	b0 00                	mov    $0x0,%al
  800344:	89 d7                	mov    %edx,%edi
  800346:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	6a 00                	push   $0x0
  80034d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	e8 ea 1a 00 00       	call   801e43 <sys_utilities>
  800359:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(id1);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 c8             	pushl  -0x38(%ebp)
  800362:	e8 72 18 00 00       	call   801bd9 <sys_destroy_env>
  800367:	83 c4 10             	add    $0x10,%esp
			cprintf("[1] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 24 25 80 00       	push   $0x802524
  800372:	e8 12 05 00 00       	call   800889 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id2);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	ff 75 c4             	pushl  -0x3c(%ebp)
  800380:	e8 54 18 00 00       	call   801bd9 <sys_destroy_env>
  800385:	83 c4 10             	add    $0x10,%esp
			cprintf("[2] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 5c 25 80 00       	push   $0x80255c
  800390:	e8 f4 04 00 00       	call   800889 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id3);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 36 18 00 00       	call   801bd9 <sys_destroy_env>
  8003a3:	83 c4 10             	add    $0x10,%esp
			cprintf("[3] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 94 25 80 00       	push   $0x802594
  8003ae:	e8 d6 04 00 00       	call   800889 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 7c 1a 00 00       	call   801e43 <sys_utilities>
  8003c7:	83 c4 10             	add    $0x10,%esp

		int *finishedCount = NULL;
  8003ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8003d1:	e8 50 18 00 00       	call   801c26 <sys_getparentenvid>
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	68 cc 25 80 00       	push   $0x8025cc
  8003de:	50                   	push   %eax
  8003df:	e8 e3 14 00 00       	call   8018c7 <sget>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		sys_lock_cons();
  8003ea:	e8 a5 15 00 00       	call   801994 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  8003ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8003fc:	e8 ad 15 00 00       	call   8019ae <sys_unlock_cons>
	}
	return;
  800401:	90                   	nop
  800402:	90                   	nop
}
  800403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800414:	e8 f4 17 00 00       	call   801c0d <sys_getenvindex>
  800419:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 02             	shl    $0x2,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	c1 e0 03             	shl    $0x3,%eax
  800429:	01 d0                	add    %edx,%eax
  80042b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800432:	01 d0                	add    %edx,%eax
  800434:	c1 e0 02             	shl    $0x2,%eax
  800437:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800441:	a1 20 30 80 00       	mov    0x803020,%eax
  800446:	8a 40 20             	mov    0x20(%eax),%al
  800449:	84 c0                	test   %al,%al
  80044b:	74 0d                	je     80045a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80044d:	a1 20 30 80 00       	mov    0x803020,%eax
  800452:	83 c0 20             	add    $0x20,%eax
  800455:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045e:	7e 0a                	jle    80046a <libmain+0x5f>
		binaryname = argv[0];
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	ff 75 08             	pushl  0x8(%ebp)
  800473:	e8 c0 fb ff ff       	call   800038 <_main>
  800478:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047b:	a1 00 30 80 00       	mov    0x803000,%eax
  800480:	85 c0                	test   %eax,%eax
  800482:	0f 84 01 01 00 00    	je     800589 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800488:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80048e:	bb 38 27 80 00       	mov    $0x802738,%ebx
  800493:	ba 0e 00 00 00       	mov    $0xe,%edx
  800498:	89 c7                	mov    %eax,%edi
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	89 d1                	mov    %edx,%ecx
  80049e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004a8:	b0 00                	mov    $0x0,%al
  8004aa:	89 d7                	mov    %edx,%edi
  8004ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	50                   	push   %eax
  8004bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 7b 19 00 00       	call   801e43 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004cb:	e8 c4 14 00 00       	call   801994 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 58 26 80 00       	push   $0x802658
  8004d8:	e8 ac 03 00 00       	call   800889 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	74 18                	je     8004ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004e7:	e8 75 19 00 00       	call   801e61 <sys_get_optimal_num_faults>
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	50                   	push   %eax
  8004f0:	68 80 26 80 00       	push   $0x802680
  8004f5:	e8 8f 03 00 00       	call   800889 <cprintf>
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb 59                	jmp    800558 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800504:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80050a:	a1 20 30 80 00       	mov    0x803020,%eax
  80050f:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	68 a4 26 80 00       	push   $0x8026a4
  80051f:	e8 65 03 00 00       	call   800889 <cprintf>
  800524:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800527:	a1 20 30 80 00       	mov    0x803020,%eax
  80052c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800532:	a1 20 30 80 00       	mov    0x803020,%eax
  800537:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80053d:	a1 20 30 80 00       	mov    0x803020,%eax
  800542:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800548:	51                   	push   %ecx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	68 cc 26 80 00       	push   $0x8026cc
  800550:	e8 34 03 00 00       	call   800889 <cprintf>
  800555:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800558:	a1 20 30 80 00       	mov    0x803020,%eax
  80055d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	68 24 27 80 00       	push   $0x802724
  80056c:	e8 18 03 00 00       	call   800889 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	68 58 26 80 00       	push   $0x802658
  80057c:	e8 08 03 00 00       	call   800889 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800584:	e8 25 14 00 00       	call   8019ae <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800589:	e8 1f 00 00 00       	call   8005ad <exit>
}
  80058e:	90                   	nop
  80058f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800592:	5b                   	pop    %ebx
  800593:	5e                   	pop    %esi
  800594:	5f                   	pop    %edi
  800595:	5d                   	pop    %ebp
  800596:	c3                   	ret    

00800597 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80059d:	83 ec 0c             	sub    $0xc,%esp
  8005a0:	6a 00                	push   $0x0
  8005a2:	e8 32 16 00 00       	call   801bd9 <sys_destroy_env>
  8005a7:	83 c4 10             	add    $0x10,%esp
}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <exit>:

void
exit(void)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b3:	e8 87 16 00 00       	call   801c3f <sys_exit_env>
}
  8005b8:	90                   	nop
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8005c4:	83 c0 04             	add    $0x4,%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005ca:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	74 16                	je     8005e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005d3:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	50                   	push   %eax
  8005dc:	68 9c 27 80 00       	push   $0x80279c
  8005e1:	e8 a3 02 00 00       	call   800889 <cprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 08             	pushl  0x8(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	68 a4 27 80 00       	push   $0x8027a4
  8005fd:	6a 74                	push   $0x74
  8005ff:	e8 b2 02 00 00       	call   8008b6 <cprintf_colored>
  800604:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800607:	8b 45 10             	mov    0x10(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 04 02 00 00       	call   80081a <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	6a 00                	push   $0x0
  80061e:	68 cc 27 80 00       	push   $0x8027cc
  800623:	e8 f2 01 00 00       	call   80081a <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062b:	e8 7d ff ff ff       	call   8005ad <exit>

	// should not return here
	while (1) ;
  800630:	eb fe                	jmp    800630 <_panic+0x75>

00800632 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800638:	a1 20 30 80 00       	mov    0x803020,%eax
  80063d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800643:	8b 45 0c             	mov    0xc(%ebp),%eax
  800646:	39 c2                	cmp    %eax,%edx
  800648:	74 14                	je     80065e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064a:	83 ec 04             	sub    $0x4,%esp
  80064d:	68 d0 27 80 00       	push   $0x8027d0
  800652:	6a 26                	push   $0x26
  800654:	68 1c 28 80 00       	push   $0x80281c
  800659:	e8 5d ff ff ff       	call   8005bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80065e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066c:	e9 c5 00 00 00       	jmp    800736 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	01 d0                	add    %edx,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	85 c0                	test   %eax,%eax
  800684:	75 08                	jne    80068e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800686:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800689:	e9 a5 00 00 00       	jmp    800733 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80068e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800695:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069c:	eb 69                	jmp    800707 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80069e:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ac:	89 d0                	mov    %edx,%eax
  8006ae:	01 c0                	add    %eax,%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	c1 e0 03             	shl    $0x3,%eax
  8006b5:	01 c8                	add    %ecx,%eax
  8006b7:	8a 40 04             	mov    0x4(%eax),%al
  8006ba:	84 c0                	test   %al,%al
  8006bc:	75 46                	jne    800704 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006be:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006cc:	89 d0                	mov    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d0                	add    %edx,%eax
  8006d2:	c1 e0 03             	shl    $0x3,%eax
  8006d5:	01 c8                	add    %ecx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	01 c8                	add    %ecx,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006f7:	39 c2                	cmp    %eax,%edx
  8006f9:	75 09                	jne    800704 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800702:	eb 15                	jmp    800719 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800704:	ff 45 e8             	incl   -0x18(%ebp)
  800707:	a1 20 30 80 00       	mov    0x803020,%eax
  80070c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800715:	39 c2                	cmp    %eax,%edx
  800717:	77 85                	ja     80069e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800719:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80071d:	75 14                	jne    800733 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80071f:	83 ec 04             	sub    $0x4,%esp
  800722:	68 28 28 80 00       	push   $0x802828
  800727:	6a 3a                	push   $0x3a
  800729:	68 1c 28 80 00       	push   $0x80281c
  80072e:	e8 88 fe ff ff       	call   8005bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800733:	ff 45 f0             	incl   -0x10(%ebp)
  800736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800739:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073c:	0f 8c 2f ff ff ff    	jl     800671 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800742:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800749:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800750:	eb 26                	jmp    800778 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800752:	a1 20 30 80 00       	mov    0x803020,%eax
  800757:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80075d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800760:	89 d0                	mov    %edx,%eax
  800762:	01 c0                	add    %eax,%eax
  800764:	01 d0                	add    %edx,%eax
  800766:	c1 e0 03             	shl    $0x3,%eax
  800769:	01 c8                	add    %ecx,%eax
  80076b:	8a 40 04             	mov    0x4(%eax),%al
  80076e:	3c 01                	cmp    $0x1,%al
  800770:	75 03                	jne    800775 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800772:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800775:	ff 45 e0             	incl   -0x20(%ebp)
  800778:	a1 20 30 80 00       	mov    0x803020,%eax
  80077d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	77 c8                	ja     800752 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800790:	74 14                	je     8007a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	68 7c 28 80 00       	push   $0x80287c
  80079a:	6a 44                	push   $0x44
  80079c:	68 1c 28 80 00       	push   $0x80281c
  8007a1:	e8 15 fe ff ff       	call   8005bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007a6:	90                   	nop
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bb:	89 0a                	mov    %ecx,(%edx)
  8007bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c0:	88 d1                	mov    %dl,%cl
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d3:	75 30                	jne    800805 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007d5:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8007db:	a0 44 30 80 00       	mov    0x803044,%al
  8007e0:	0f b6 c0             	movzbl %al,%eax
  8007e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e6:	8b 09                	mov    (%ecx),%ecx
  8007e8:	89 cb                	mov    %ecx,%ebx
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	83 c1 08             	add    $0x8,%ecx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	53                   	push   %ebx
  8007f3:	51                   	push   %ecx
  8007f4:	e8 57 11 00 00       	call   801950 <sys_cputs>
  8007f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	8b 40 04             	mov    0x4(%eax),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 50 04             	mov    %edx,0x4(%eax)
}
  800814:	90                   	nop
  800815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800823:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80082a:	00 00 00 
	b.cnt = 0;
  80082d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800834:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	ff 75 08             	pushl  0x8(%ebp)
  80083d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800843:	50                   	push   %eax
  800844:	68 a9 07 80 00       	push   $0x8007a9
  800849:	e8 5a 02 00 00       	call   800aa8 <vprintfmt>
  80084e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800851:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800857:	a0 44 30 80 00       	mov    0x803044,%al
  80085c:	0f b6 c0             	movzbl %al,%eax
  80085f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800865:	52                   	push   %edx
  800866:	50                   	push   %eax
  800867:	51                   	push   %ecx
  800868:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80086e:	83 c0 08             	add    $0x8,%eax
  800871:	50                   	push   %eax
  800872:	e8 d9 10 00 00       	call   801950 <sys_cputs>
  800877:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80087a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800881:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80088f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800896:	8d 45 0c             	lea    0xc(%ebp),%eax
  800899:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	e8 6f ff ff ff       	call   80081a <vcprintf>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    

008008b6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008bc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	c1 e0 08             	shl    $0x8,%eax
  8008c9:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8008ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e0:	50                   	push   %eax
  8008e1:	e8 34 ff ff ff       	call   80081a <vcprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008ec:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8008f3:	07 00 00 

	return cnt;
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    

008008fb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800901:	e8 8e 10 00 00       	call   801994 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800906:	8d 45 0c             	lea    0xc(%ebp),%eax
  800909:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 f4             	pushl  -0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	e8 ff fe ff ff       	call   80081a <vcprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800921:	e8 88 10 00 00       	call   8019ae <sys_unlock_cons>
	return cnt;
  800926:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	83 ec 14             	sub    $0x14,%esp
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80093e:	8b 45 18             	mov    0x18(%ebp),%eax
  800941:	ba 00 00 00 00       	mov    $0x0,%edx
  800946:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800949:	77 55                	ja     8009a0 <printnum+0x75>
  80094b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80094e:	72 05                	jb     800955 <printnum+0x2a>
  800950:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800953:	77 4b                	ja     8009a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800955:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800958:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80095b:	8b 45 18             	mov    0x18(%ebp),%eax
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	52                   	push   %edx
  800964:	50                   	push   %eax
  800965:	ff 75 f4             	pushl  -0xc(%ebp)
  800968:	ff 75 f0             	pushl  -0x10(%ebp)
  80096b:	e8 68 17 00 00       	call   8020d8 <__udivdi3>
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	83 ec 04             	sub    $0x4,%esp
  800976:	ff 75 20             	pushl  0x20(%ebp)
  800979:	53                   	push   %ebx
  80097a:	ff 75 18             	pushl  0x18(%ebp)
  80097d:	52                   	push   %edx
  80097e:	50                   	push   %eax
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 a1 ff ff ff       	call   80092b <printnum>
  80098a:	83 c4 20             	add    $0x20,%esp
  80098d:	eb 1a                	jmp    8009a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 20             	pushl  0x20(%ebp)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8009a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009a7:	7f e6                	jg     80098f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	53                   	push   %ebx
  8009b8:	51                   	push   %ecx
  8009b9:	52                   	push   %edx
  8009ba:	50                   	push   %eax
  8009bb:	e8 28 18 00 00       	call   8021e8 <__umoddi3>
  8009c0:	83 c4 10             	add    $0x10,%esp
  8009c3:	05 f4 2a 80 00       	add    $0x802af4,%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be c0             	movsbl %al,%eax
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	50                   	push   %eax
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	ff d0                	call   *%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
}
  8009dc:	90                   	nop
  8009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e9:	7e 1c                	jle    800a07 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	8d 50 08             	lea    0x8(%eax),%edx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	89 10                	mov    %edx,(%eax)
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	83 e8 08             	sub    $0x8,%eax
  800a00:	8b 50 04             	mov    0x4(%eax),%edx
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	eb 40                	jmp    800a47 <getuint+0x65>
	else if (lflag)
  800a07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0b:	74 1e                	je     800a2b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	8d 50 04             	lea    0x4(%eax),%edx
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	89 10                	mov    %edx,(%eax)
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	83 e8 04             	sub    $0x4,%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	ba 00 00 00 00       	mov    $0x0,%edx
  800a29:	eb 1c                	jmp    800a47 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 00                	mov    (%eax),%eax
  800a30:	8d 50 04             	lea    0x4(%eax),%edx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	89 10                	mov    %edx,(%eax)
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	83 e8 04             	sub    $0x4,%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a50:	7e 1c                	jle    800a6e <getint+0x25>
		return va_arg(*ap, long long);
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	8d 50 08             	lea    0x8(%eax),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	89 10                	mov    %edx,(%eax)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	83 e8 08             	sub    $0x8,%eax
  800a67:	8b 50 04             	mov    0x4(%eax),%edx
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	eb 38                	jmp    800aa6 <getint+0x5d>
	else if (lflag)
  800a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a72:	74 1a                	je     800a8e <getint+0x45>
		return va_arg(*ap, long);
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 00                	mov    (%eax),%eax
  800a79:	8d 50 04             	lea    0x4(%eax),%edx
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	89 10                	mov    %edx,(%eax)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 00                	mov    (%eax),%eax
  800a86:	83 e8 04             	sub    $0x4,%eax
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	99                   	cltd   
  800a8c:	eb 18                	jmp    800aa6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	8d 50 04             	lea    0x4(%eax),%edx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 10                	mov    %edx,(%eax)
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	83 e8 04             	sub    $0x4,%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	99                   	cltd   
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab0:	eb 17                	jmp    800ac9 <vprintfmt+0x21>
			if (ch == '\0')
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	0f 84 c1 03 00 00    	je     800e7b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	53                   	push   %ebx
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	8d 50 01             	lea    0x1(%eax),%edx
  800acf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	0f b6 d8             	movzbl %al,%ebx
  800ad7:	83 fb 25             	cmp    $0x25,%ebx
  800ada:	75 d6                	jne    800ab2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800adc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ae7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800aee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800af5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	8d 50 01             	lea    0x1(%eax),%edx
  800b02:	89 55 10             	mov    %edx,0x10(%ebp)
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f b6 d8             	movzbl %al,%ebx
  800b0a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b0d:	83 f8 5b             	cmp    $0x5b,%eax
  800b10:	0f 87 3d 03 00 00    	ja     800e53 <vprintfmt+0x3ab>
  800b16:	8b 04 85 18 2b 80 00 	mov    0x802b18(,%eax,4),%eax
  800b1d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b1f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b23:	eb d7                	jmp    800afc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b25:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b29:	eb d1                	jmp    800afc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b35:	89 d0                	mov    %edx,%eax
  800b37:	c1 e0 02             	shl    $0x2,%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	01 c0                	add    %eax,%eax
  800b3e:	01 d8                	add    %ebx,%eax
  800b40:	83 e8 30             	sub    $0x30,%eax
  800b43:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b46:	8b 45 10             	mov    0x10(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b4e:	83 fb 2f             	cmp    $0x2f,%ebx
  800b51:	7e 3e                	jle    800b91 <vprintfmt+0xe9>
  800b53:	83 fb 39             	cmp    $0x39,%ebx
  800b56:	7f 39                	jg     800b91 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b58:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b5b:	eb d5                	jmp    800b32 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 c0 04             	add    $0x4,%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	83 e8 04             	sub    $0x4,%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b71:	eb 1f                	jmp    800b92 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b77:	79 83                	jns    800afc <vprintfmt+0x54>
				width = 0;
  800b79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b80:	e9 77 ff ff ff       	jmp    800afc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b85:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b8c:	e9 6b ff ff ff       	jmp    800afc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b91:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b96:	0f 89 60 ff ff ff    	jns    800afc <vprintfmt+0x54>
				width = precision, precision = -1;
  800b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ba9:	e9 4e ff ff ff       	jmp    800afc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bb1:	e9 46 ff ff ff       	jmp    800afc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 e8 04             	sub    $0x4,%eax
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	50                   	push   %eax
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
			break;
  800bd6:	e9 9b 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 14             	mov    %eax,0x14(%ebp)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	83 e8 04             	sub    $0x4,%eax
  800bea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bec:	85 db                	test   %ebx,%ebx
  800bee:	79 02                	jns    800bf2 <vprintfmt+0x14a>
				err = -err;
  800bf0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bf2:	83 fb 64             	cmp    $0x64,%ebx
  800bf5:	7f 0b                	jg     800c02 <vprintfmt+0x15a>
  800bf7:	8b 34 9d 60 29 80 00 	mov    0x802960(,%ebx,4),%esi
  800bfe:	85 f6                	test   %esi,%esi
  800c00:	75 19                	jne    800c1b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c02:	53                   	push   %ebx
  800c03:	68 05 2b 80 00       	push   $0x802b05
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	e8 70 02 00 00       	call   800e83 <printfmt>
  800c13:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c16:	e9 5b 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1b:	56                   	push   %esi
  800c1c:	68 0e 2b 80 00       	push   $0x802b0e
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 57 02 00 00       	call   800e83 <printfmt>
  800c2c:	83 c4 10             	add    $0x10,%esp
			break;
  800c2f:	e9 42 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	83 c0 04             	add    $0x4,%eax
  800c3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	83 e8 04             	sub    $0x4,%eax
  800c43:	8b 30                	mov    (%eax),%esi
  800c45:	85 f6                	test   %esi,%esi
  800c47:	75 05                	jne    800c4e <vprintfmt+0x1a6>
				p = "(null)";
  800c49:	be 11 2b 80 00       	mov    $0x802b11,%esi
			if (width > 0 && padc != '-')
  800c4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c52:	7e 6d                	jle    800cc1 <vprintfmt+0x219>
  800c54:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c58:	74 67                	je     800cc1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	50                   	push   %eax
  800c61:	56                   	push   %esi
  800c62:	e8 1e 03 00 00       	call   800f85 <strnlen>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c6d:	eb 16                	jmp    800c85 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c6f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	50                   	push   %eax
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c82:	ff 4d e4             	decl   -0x1c(%ebp)
  800c85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c89:	7f e4                	jg     800c6f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8b:	eb 34                	jmp    800cc1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c91:	74 1c                	je     800caf <vprintfmt+0x207>
  800c93:	83 fb 1f             	cmp    $0x1f,%ebx
  800c96:	7e 05                	jle    800c9d <vprintfmt+0x1f5>
  800c98:	83 fb 7e             	cmp    $0x7e,%ebx
  800c9b:	7e 12                	jle    800caf <vprintfmt+0x207>
					putch('?', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 3f                	push   $0x3f
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	eb 0f                	jmp    800cbe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc1:	89 f0                	mov    %esi,%eax
  800cc3:	8d 70 01             	lea    0x1(%eax),%esi
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	0f be d8             	movsbl %al,%ebx
  800ccb:	85 db                	test   %ebx,%ebx
  800ccd:	74 24                	je     800cf3 <vprintfmt+0x24b>
  800ccf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cd3:	78 b8                	js     800c8d <vprintfmt+0x1e5>
  800cd5:	ff 4d e0             	decl   -0x20(%ebp)
  800cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cdc:	79 af                	jns    800c8d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cde:	eb 13                	jmp    800cf3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	ff 75 0c             	pushl  0xc(%ebp)
  800ce6:	6a 20                	push   $0x20
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	ff d0                	call   *%eax
  800ced:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf7:	7f e7                	jg     800ce0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cf9:	e9 78 01 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 e8             	pushl  -0x18(%ebp)
  800d04:	8d 45 14             	lea    0x14(%ebp),%eax
  800d07:	50                   	push   %eax
  800d08:	e8 3c fd ff ff       	call   800a49 <getint>
  800d0d:	83 c4 10             	add    $0x10,%esp
  800d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1c:	85 d2                	test   %edx,%edx
  800d1e:	79 23                	jns    800d43 <vprintfmt+0x29b>
				putch('-', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 2d                	push   $0x2d
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d36:	f7 d8                	neg    %eax
  800d38:	83 d2 00             	adc    $0x0,%edx
  800d3b:	f7 da                	neg    %edx
  800d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d4a:	e9 bc 00 00 00       	jmp    800e0b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 e8             	pushl  -0x18(%ebp)
  800d55:	8d 45 14             	lea    0x14(%ebp),%eax
  800d58:	50                   	push   %eax
  800d59:	e8 84 fc ff ff       	call   8009e2 <getuint>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d6e:	e9 98 00 00 00       	jmp    800e0b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	6a 58                	push   $0x58
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d83:	83 ec 08             	sub    $0x8,%esp
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	6a 58                	push   $0x58
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	ff d0                	call   *%eax
  800d90:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	6a 58                	push   $0x58
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
			break;
  800da3:	e9 ce 00 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	6a 30                	push   $0x30
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	6a 78                	push   $0x78
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	ff d0                	call   *%eax
  800dc5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 c0 04             	add    $0x4,%eax
  800dce:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 e8 04             	sub    $0x4,%eax
  800dd7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800de3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dea:	eb 1f                	jmp    800e0b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 e8             	pushl  -0x18(%ebp)
  800df2:	8d 45 14             	lea    0x14(%ebp),%eax
  800df5:	50                   	push   %eax
  800df6:	e8 e7 fb ff ff       	call   8009e2 <getuint>
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	52                   	push   %edx
  800e16:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	ff 75 08             	pushl  0x8(%ebp)
  800e26:	e8 00 fb ff ff       	call   80092b <printnum>
  800e2b:	83 c4 20             	add    $0x20,%esp
			break;
  800e2e:	eb 46                	jmp    800e76 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			break;
  800e3f:	eb 35                	jmp    800e76 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e41:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800e48:	eb 2c                	jmp    800e76 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e4a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800e51:	eb 23                	jmp    800e76 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 0c             	pushl  0xc(%ebp)
  800e59:	6a 25                	push   $0x25
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	ff d0                	call   *%eax
  800e60:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e63:	ff 4d 10             	decl   0x10(%ebp)
  800e66:	eb 03                	jmp    800e6b <vprintfmt+0x3c3>
  800e68:	ff 4d 10             	decl   0x10(%ebp)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	48                   	dec    %eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 25                	cmp    $0x25,%al
  800e73:	75 f3                	jne    800e68 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e75:	90                   	nop
		}
	}
  800e76:	e9 35 fc ff ff       	jmp    800ab0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e7b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e89:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8c:	83 c0 04             	add    $0x4,%eax
  800e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	ff 75 f4             	pushl  -0xc(%ebp)
  800e98:	50                   	push   %eax
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	ff 75 08             	pushl  0x8(%ebp)
  800e9f:	e8 04 fc ff ff       	call   800aa8 <vprintfmt>
  800ea4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ea7:	90                   	nop
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	8b 40 08             	mov    0x8(%eax),%eax
  800eb3:	8d 50 01             	lea    0x1(%eax),%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	8b 10                	mov    (%eax),%edx
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8b 40 04             	mov    0x4(%eax),%eax
  800ec7:	39 c2                	cmp    %eax,%edx
  800ec9:	73 12                	jae    800edd <sprintputch+0x33>
		*b->buf++ = ch;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8b 00                	mov    (%eax),%eax
  800ed0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	89 0a                	mov    %ecx,(%edx)
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	88 10                	mov    %dl,(%eax)
}
  800edd:	90                   	nop
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f05:	74 06                	je     800f0d <vsnprintf+0x2d>
  800f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0b:	7f 07                	jg     800f14 <vsnprintf+0x34>
		return -E_INVAL;
  800f0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f12:	eb 20                	jmp    800f34 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f14:	ff 75 14             	pushl  0x14(%ebp)
  800f17:	ff 75 10             	pushl  0x10(%ebp)
  800f1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	68 aa 0e 80 00       	push   $0x800eaa
  800f23:	e8 80 fb ff ff       	call   800aa8 <vprintfmt>
  800f28:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	e8 89 ff ff ff       	call   800ee0 <vsnprintf>
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f6f:	eb 06                	jmp    800f77 <strlen+0x15>
		n++;
  800f71:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	84 c0                	test   %al,%al
  800f7e:	75 f1                	jne    800f71 <strlen+0xf>
		n++;
	return n;
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f92:	eb 09                	jmp    800f9d <strnlen+0x18>
		n++;
  800f94:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	ff 4d 0c             	decl   0xc(%ebp)
  800f9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa1:	74 09                	je     800fac <strnlen+0x27>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e8                	jne    800f94 <strnlen+0xf>
		n++;
	return n;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fbd:	90                   	nop
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8d 50 01             	lea    0x1(%eax),%edx
  800fc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd0:	8a 12                	mov    (%edx),%dl
  800fd2:	88 10                	mov    %dl,(%eax)
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 e4                	jne    800fbe <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800feb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff2:	eb 1f                	jmp    801013 <strncpy+0x34>
		*dst++ = *src;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8d 50 01             	lea    0x1(%eax),%edx
  800ffa:	89 55 08             	mov    %edx,0x8(%ebp)
  800ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801000:	8a 12                	mov    (%edx),%dl
  801002:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	74 03                	je     801010 <strncpy+0x31>
			src++;
  80100d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801010:	ff 45 fc             	incl   -0x4(%ebp)
  801013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801016:	3b 45 10             	cmp    0x10(%ebp),%eax
  801019:	72 d9                	jb     800ff4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80102c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801030:	74 30                	je     801062 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801032:	eb 16                	jmp    80104a <strlcpy+0x2a>
			*dst++ = *src++;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8d 50 01             	lea    0x1(%eax),%edx
  80103a:	89 55 08             	mov    %edx,0x8(%ebp)
  80103d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801040:	8d 4a 01             	lea    0x1(%edx),%ecx
  801043:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801046:	8a 12                	mov    (%edx),%dl
  801048:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80104a:	ff 4d 10             	decl   0x10(%ebp)
  80104d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801051:	74 09                	je     80105c <strlcpy+0x3c>
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	84 c0                	test   %al,%al
  80105a:	75 d8                	jne    801034 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801068:	29 c2                	sub    %eax,%edx
  80106a:	89 d0                	mov    %edx,%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801071:	eb 06                	jmp    801079 <strcmp+0xb>
		p++, q++;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	74 0e                	je     801090 <strcmp+0x22>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 10                	mov    (%eax),%dl
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	38 c2                	cmp    %al,%dl
  80108e:	74 e3                	je     801073 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f b6 d0             	movzbl %al,%edx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	0f b6 c0             	movzbl %al,%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010a9:	eb 09                	jmp    8010b4 <strncmp+0xe>
		n--, p++, q++;
  8010ab:	ff 4d 10             	decl   0x10(%ebp)
  8010ae:	ff 45 08             	incl   0x8(%ebp)
  8010b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	74 17                	je     8010d1 <strncmp+0x2b>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	84 c0                	test   %al,%al
  8010c1:	74 0e                	je     8010d1 <strncmp+0x2b>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 10                	mov    (%eax),%dl
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	38 c2                	cmp    %al,%dl
  8010cf:	74 da                	je     8010ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d5:	75 07                	jne    8010de <strncmp+0x38>
		return 0;
  8010d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dc:	eb 14                	jmp    8010f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f b6 d0             	movzbl %al,%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f b6 c0             	movzbl %al,%eax
  8010ee:	29 c2                	sub    %eax,%edx
  8010f0:	89 d0                	mov    %edx,%eax
}
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801100:	eb 12                	jmp    801114 <strchr+0x20>
		if (*s == c)
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110a:	75 05                	jne    801111 <strchr+0x1d>
			return (char *) s;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	eb 11                	jmp    801122 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	84 c0                	test   %al,%al
  80111b:	75 e5                	jne    801102 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801130:	eb 0d                	jmp    80113f <strfind+0x1b>
		if (*s == c)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80113a:	74 0e                	je     80114a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80113c:	ff 45 08             	incl   0x8(%ebp)
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	84 c0                	test   %al,%al
  801146:	75 ea                	jne    801132 <strfind+0xe>
  801148:	eb 01                	jmp    80114b <strfind+0x27>
		if (*s == c)
			break;
  80114a:	90                   	nop
	return (char *) s;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80115c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801160:	76 63                	jbe    8011c5 <memset+0x75>
		uint64 data_block = c;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	99                   	cltd   
  801166:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801169:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80116c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801172:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801176:	c1 e0 08             	shl    $0x8,%eax
  801179:	09 45 f0             	or     %eax,-0x10(%ebp)
  80117c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80117f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801185:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801189:	c1 e0 10             	shl    $0x10,%eax
  80118c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80118f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801198:	89 c2                	mov    %eax,%edx
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011a2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011a5:	eb 18                	jmp    8011bf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011aa:	8d 41 08             	lea    0x8(%ecx),%eax
  8011ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b6:	89 01                	mov    %eax,(%ecx)
  8011b8:	89 51 04             	mov    %edx,0x4(%ecx)
  8011bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011bf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011c3:	77 e2                	ja     8011a7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c9:	74 23                	je     8011ee <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d1:	eb 0e                	jmp    8011e1 <memset+0x91>
			*p8++ = (uint8)c;
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	8d 50 01             	lea    0x1(%eax),%edx
  8011d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011df:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	75 e5                	jne    8011d3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801205:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801209:	76 24                	jbe    80122f <memcpy+0x3c>
		while(n >= 8){
  80120b:	eb 1c                	jmp    801229 <memcpy+0x36>
			*d64 = *s64;
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	8b 50 04             	mov    0x4(%eax),%edx
  801213:	8b 00                	mov    (%eax),%eax
  801215:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801218:	89 01                	mov    %eax,(%ecx)
  80121a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80121d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801221:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801225:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801229:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80122d:	77 de                	ja     80120d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801233:	74 31                	je     801266 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801238:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801241:	eb 16                	jmp    801259 <memcpy+0x66>
			*d8++ = *s8++;
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801252:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801255:	8a 12                	mov    (%edx),%dl
  801257:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125f:	89 55 10             	mov    %edx,0x10(%ebp)
  801262:	85 c0                	test   %eax,%eax
  801264:	75 dd                	jne    801243 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801283:	73 50                	jae    8012d5 <memmove+0x6a>
  801285:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801290:	76 43                	jbe    8012d5 <memmove+0x6a>
		s += n;
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80129e:	eb 10                	jmp    8012b0 <memmove+0x45>
			*--d = *--s;
  8012a0:	ff 4d f8             	decl   -0x8(%ebp)
  8012a3:	ff 4d fc             	decl   -0x4(%ebp)
  8012a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a9:	8a 10                	mov    (%eax),%dl
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	75 e3                	jne    8012a0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012bd:	eb 23                	jmp    8012e2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	8d 50 01             	lea    0x1(%eax),%edx
  8012c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d1:	8a 12                	mov    (%edx),%dl
  8012d3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 dd                	jne    8012bf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012f9:	eb 2a                	jmp    801325 <memcmp+0x3e>
		if (*s1 != *s2)
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	8a 10                	mov    (%eax),%dl
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	38 c2                	cmp    %al,%dl
  801307:	74 16                	je     80131f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f b6 c0             	movzbl %al,%eax
  801319:	29 c2                	sub    %eax,%edx
  80131b:	89 d0                	mov    %edx,%eax
  80131d:	eb 18                	jmp    801337 <memcmp+0x50>
		s1++, s2++;
  80131f:	ff 45 fc             	incl   -0x4(%ebp)
  801322:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132b:	89 55 10             	mov    %edx,0x10(%ebp)
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 c9                	jne    8012fb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80133f:	8b 55 08             	mov    0x8(%ebp),%edx
  801342:	8b 45 10             	mov    0x10(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80134a:	eb 15                	jmp    801361 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	0f b6 c0             	movzbl %al,%eax
  80135a:	39 c2                	cmp    %eax,%edx
  80135c:	74 0d                	je     80136b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80135e:	ff 45 08             	incl   0x8(%ebp)
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801367:	72 e3                	jb     80134c <memfind+0x13>
  801369:	eb 01                	jmp    80136c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80136b:	90                   	nop
	return (void *) s;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801377:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80137e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801385:	eb 03                	jmp    80138a <strtol+0x19>
		s++;
  801387:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	3c 20                	cmp    $0x20,%al
  801391:	74 f4                	je     801387 <strtol+0x16>
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	3c 09                	cmp    $0x9,%al
  80139a:	74 eb                	je     801387 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 2b                	cmp    $0x2b,%al
  8013a3:	75 05                	jne    8013aa <strtol+0x39>
		s++;
  8013a5:	ff 45 08             	incl   0x8(%ebp)
  8013a8:	eb 13                	jmp    8013bd <strtol+0x4c>
	else if (*s == '-')
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	3c 2d                	cmp    $0x2d,%al
  8013b1:	75 0a                	jne    8013bd <strtol+0x4c>
		s++, neg = 1;
  8013b3:	ff 45 08             	incl   0x8(%ebp)
  8013b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c1:	74 06                	je     8013c9 <strtol+0x58>
  8013c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013c7:	75 20                	jne    8013e9 <strtol+0x78>
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3c 30                	cmp    $0x30,%al
  8013d0:	75 17                	jne    8013e9 <strtol+0x78>
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	40                   	inc    %eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	3c 78                	cmp    $0x78,%al
  8013da:	75 0d                	jne    8013e9 <strtol+0x78>
		s += 2, base = 16;
  8013dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013e7:	eb 28                	jmp    801411 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ed:	75 15                	jne    801404 <strtol+0x93>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	3c 30                	cmp    $0x30,%al
  8013f6:	75 0c                	jne    801404 <strtol+0x93>
		s++, base = 8;
  8013f8:	ff 45 08             	incl   0x8(%ebp)
  8013fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801402:	eb 0d                	jmp    801411 <strtol+0xa0>
	else if (base == 0)
  801404:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801408:	75 07                	jne    801411 <strtol+0xa0>
		base = 10;
  80140a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 2f                	cmp    $0x2f,%al
  801418:	7e 19                	jle    801433 <strtol+0xc2>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 39                	cmp    $0x39,%al
  801421:	7f 10                	jg     801433 <strtol+0xc2>
			dig = *s - '0';
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f be c0             	movsbl %al,%eax
  80142b:	83 e8 30             	sub    $0x30,%eax
  80142e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801431:	eb 42                	jmp    801475 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	3c 60                	cmp    $0x60,%al
  80143a:	7e 19                	jle    801455 <strtol+0xe4>
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 7a                	cmp    $0x7a,%al
  801443:	7f 10                	jg     801455 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	83 e8 57             	sub    $0x57,%eax
  801450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801453:	eb 20                	jmp    801475 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 40                	cmp    $0x40,%al
  80145c:	7e 39                	jle    801497 <strtol+0x126>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 5a                	cmp    $0x5a,%al
  801465:	7f 30                	jg     801497 <strtol+0x126>
			dig = *s - 'A' + 10;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	0f be c0             	movsbl %al,%eax
  80146f:	83 e8 37             	sub    $0x37,%eax
  801472:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801478:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147b:	7d 19                	jge    801496 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80147d:	ff 45 08             	incl   0x8(%ebp)
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801483:	0f af 45 10          	imul   0x10(%ebp),%eax
  801487:	89 c2                	mov    %eax,%edx
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801491:	e9 7b ff ff ff       	jmp    801411 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801496:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801497:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80149b:	74 08                	je     8014a5 <strtol+0x134>
		*endptr = (char *) s;
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014a9:	74 07                	je     8014b2 <strtol+0x141>
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ae:	f7 d8                	neg    %eax
  8014b0:	eb 03                	jmp    8014b5 <strtol+0x144>
  8014b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cf:	79 13                	jns    8014e4 <ltostr+0x2d>
	{
		neg = 1;
  8014d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ec:	99                   	cltd   
  8014ed:	f7 f9                	idiv   %ecx
  8014ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801505:	83 c2 30             	add    $0x30,%edx
  801508:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80150a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801512:	f7 e9                	imul   %ecx
  801514:	c1 fa 02             	sar    $0x2,%edx
  801517:	89 c8                	mov    %ecx,%eax
  801519:	c1 f8 1f             	sar    $0x1f,%eax
  80151c:	29 c2                	sub    %eax,%edx
  80151e:	89 d0                	mov    %edx,%eax
  801520:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801527:	75 bb                	jne    8014e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801533:	48                   	dec    %eax
  801534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801537:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153b:	74 3d                	je     80157a <ltostr+0xc3>
		start = 1 ;
  80153d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801544:	eb 34                	jmp    80157a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	01 c2                	add    %eax,%edx
  80155b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	01 c8                	add    %ecx,%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801567:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	01 c2                	add    %eax,%edx
  80156f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801572:	88 02                	mov    %al,(%edx)
		start++ ;
  801574:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801577:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801580:	7c c4                	jl     801546 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801582:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158d:	90                   	nop
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	e8 c4 f9 ff ff       	call   800f62 <strlen>
  80159e:	83 c4 04             	add    $0x4,%esp
  8015a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	e8 b6 f9 ff ff       	call   800f62 <strlen>
  8015ac:	83 c4 04             	add    $0x4,%esp
  8015af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c0:	eb 17                	jmp    8015d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	01 c2                	add    %eax,%edx
  8015ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	01 c8                	add    %ecx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d6:	ff 45 fc             	incl   -0x4(%ebp)
  8015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015df:	7c e1                	jl     8015c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ef:	eb 1f                	jmp    801610 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f4:	8d 50 01             	lea    0x1(%eax),%edx
  8015f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	01 c8                	add    %ecx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160d:	ff 45 f8             	incl   -0x8(%ebp)
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801613:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801616:	7c d9                	jl     8015f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	c6 00 00             	movb   $0x0,(%eax)
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	8b 00                	mov    (%eax),%eax
  801637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801649:	eb 0c                	jmp    801657 <strsplit+0x31>
			*string++ = 0;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8d 50 01             	lea    0x1(%eax),%edx
  801651:	89 55 08             	mov    %edx,0x8(%ebp)
  801654:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	84 c0                	test   %al,%al
  80165e:	74 18                	je     801678 <strsplit+0x52>
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	0f be c0             	movsbl %al,%eax
  801668:	50                   	push   %eax
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	e8 83 fa ff ff       	call   8010f4 <strchr>
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	75 d3                	jne    80164b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	84 c0                	test   %al,%al
  80167f:	74 5a                	je     8016db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801681:	8b 45 14             	mov    0x14(%ebp),%eax
  801684:	8b 00                	mov    (%eax),%eax
  801686:	83 f8 0f             	cmp    $0xf,%eax
  801689:	75 07                	jne    801692 <strsplit+0x6c>
		{
			return 0;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
  801690:	eb 66                	jmp    8016f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801692:	8b 45 14             	mov    0x14(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 14             	mov    0x14(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	01 c2                	add    %eax,%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b0:	eb 03                	jmp    8016b5 <strsplit+0x8f>
			string++;
  8016b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	84 c0                	test   %al,%al
  8016bc:	74 8b                	je     801649 <strsplit+0x23>
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	0f be c0             	movsbl %al,%eax
  8016c6:	50                   	push   %eax
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	e8 25 fa ff ff       	call   8010f4 <strchr>
  8016cf:	83 c4 08             	add    $0x8,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	74 dc                	je     8016b2 <strsplit+0x8c>
			string++;
	}
  8016d6:	e9 6e ff ff ff       	jmp    801649 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	01 d0                	add    %edx,%eax
  8016ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80170d:	eb 4a                	jmp    801759 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80170f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	01 c2                	add    %eax,%edx
  801717:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	01 c8                	add    %ecx,%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801723:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	8a 00                	mov    (%eax),%al
  80172d:	3c 40                	cmp    $0x40,%al
  80172f:	7e 25                	jle    801756 <str2lower+0x5c>
  801731:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	3c 5a                	cmp    $0x5a,%al
  80173d:	7f 17                	jg     801756 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80173f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80174a:	8b 55 08             	mov    0x8(%ebp),%edx
  80174d:	01 ca                	add    %ecx,%edx
  80174f:	8a 12                	mov    (%edx),%dl
  801751:	83 c2 20             	add    $0x20,%edx
  801754:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801756:	ff 45 fc             	incl   -0x4(%ebp)
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	e8 01 f8 ff ff       	call   800f62 <strlen>
  801761:	83 c4 04             	add    $0x4,%esp
  801764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801767:	7f a6                	jg     80170f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801769:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801774:	a1 08 30 80 00       	mov    0x803008,%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	74 42                	je     8017bf <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80177d:	83 ec 08             	sub    $0x8,%esp
  801780:	68 00 00 00 82       	push   $0x82000000
  801785:	68 00 00 00 80       	push   $0x80000000
  80178a:	e8 8c 07 00 00       	call   801f1b <initialize_dynamic_allocator>
  80178f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801792:	e8 e7 05 00 00       	call   801d7e <sys_get_uheap_strategy>
  801797:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80179c:	a1 40 30 80 00       	mov    0x803040,%eax
  8017a1:	05 00 10 00 00       	add    $0x1000,%eax
  8017a6:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8017ab:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8017b0:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8017b5:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8017bc:	00 00 00 
	}
}
  8017bf:	90                   	nop
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	68 06 04 00 00       	push   $0x406
  8017de:	50                   	push   %eax
  8017df:	e8 e4 01 00 00       	call   8019c8 <__sys_allocate_page>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ee:	79 14                	jns    801804 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 88 2c 80 00       	push   $0x802c88
  8017f8:	6a 1f                	push   $0x1f
  8017fa:	68 c4 2c 80 00       	push   $0x802cc4
  8017ff:	e8 b7 ed ff ff       	call   8005bb <_panic>
	return 0;
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	50                   	push   %eax
  801823:	e8 e7 01 00 00       	call   801a0f <__sys_unmap_frame>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80182e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801832:	79 14                	jns    801848 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 d0 2c 80 00       	push   $0x802cd0
  80183c:	6a 2a                	push   $0x2a
  80183e:	68 c4 2c 80 00       	push   $0x802cc4
  801843:	e8 73 ed ff ff       	call   8005bb <_panic>
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801851:	e8 18 ff ff ff       	call   80176e <uheap_init>
	if (size == 0) return NULL ;
  801856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185a:	75 07                	jne    801863 <malloc+0x18>
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	eb 14                	jmp    801877 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 10 2d 80 00       	push   $0x802d10
  80186b:	6a 3e                	push   $0x3e
  80186d:	68 c4 2c 80 00       	push   $0x802cc4
  801872:	e8 44 ed ff ff       	call   8005bb <_panic>
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	68 38 2d 80 00       	push   $0x802d38
  801887:	6a 49                	push   $0x49
  801889:	68 c4 2c 80 00       	push   $0x802cc4
  80188e:	e8 28 ed ff ff       	call   8005bb <_panic>

00801893 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 18             	sub    $0x18,%esp
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80189f:	e8 ca fe ff ff       	call   80176e <uheap_init>
	if (size == 0) return NULL ;
  8018a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a8:	75 07                	jne    8018b1 <smalloc+0x1e>
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018af:	eb 14                	jmp    8018c5 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 5c 2d 80 00       	push   $0x802d5c
  8018b9:	6a 5a                	push   $0x5a
  8018bb:	68 c4 2c 80 00       	push   $0x802cc4
  8018c0:	e8 f6 ec ff ff       	call   8005bb <_panic>
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018cd:	e8 9c fe ff ff       	call   80176e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 84 2d 80 00       	push   $0x802d84
  8018da:	6a 6a                	push   $0x6a
  8018dc:	68 c4 2c 80 00       	push   $0x802cc4
  8018e1:	e8 d5 ec ff ff       	call   8005bb <_panic>

008018e6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018ec:	e8 7d fe ff ff       	call   80176e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 a8 2d 80 00       	push   $0x802da8
  8018f9:	68 88 00 00 00       	push   $0x88
  8018fe:	68 c4 2c 80 00       	push   $0x802cc4
  801903:	e8 b3 ec ff ff       	call   8005bb <_panic>

00801908 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	68 d0 2d 80 00       	push   $0x802dd0
  801916:	68 9b 00 00 00       	push   $0x9b
  80191b:	68 c4 2c 80 00       	push   $0x802cc4
  801920:	e8 96 ec ff ff       	call   8005bb <_panic>

00801925 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	57                   	push   %edi
  801929:	56                   	push   %esi
  80192a:	53                   	push   %ebx
  80192b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801937:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801940:	cd 30                	int    $0x30
  801942:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801945:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80195c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80195f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	50                   	push   %eax
  80196e:	6a 00                	push   $0x0
  801970:	e8 b0 ff ff ff       	call   801925 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_cgetc>:

int
sys_cgetc(void)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 02                	push   $0x2
  80198a:	e8 96 ff ff ff       	call   801925 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 03                	push   $0x3
  8019a3:	e8 7d ff ff ff       	call   801925 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 04                	push   $0x4
  8019bd:	e8 63 ff ff ff       	call   801925 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	52                   	push   %edx
  8019d8:	50                   	push   %eax
  8019d9:	6a 08                	push   $0x8
  8019db:	e8 45 ff ff ff       	call   801925 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	56                   	push   %esi
  8019e9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ea:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	56                   	push   %esi
  8019fa:	53                   	push   %ebx
  8019fb:	51                   	push   %ecx
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 09                	push   $0x9
  801a00:	e8 20 ff ff ff       	call   801925 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	6a 0a                	push   $0xa
  801a1f:	e8 01 ff ff ff       	call   801925 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	ff 75 08             	pushl  0x8(%ebp)
  801a38:	6a 0b                	push   $0xb
  801a3a:	e8 e6 fe ff ff       	call   801925 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 0c                	push   $0xc
  801a53:	e8 cd fe ff ff       	call   801925 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 0d                	push   $0xd
  801a6c:	e8 b4 fe ff ff       	call   801925 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0e                	push   $0xe
  801a85:	e8 9b fe ff ff       	call   801925 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 0f                	push   $0xf
  801a9e:	e8 82 fe ff ff       	call   801925 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	6a 10                	push   $0x10
  801ab8:	e8 68 fe ff ff       	call   801925 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 11                	push   $0x11
  801ad1:	e8 4f fe ff ff       	call   801925 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_cputc>:

void
sys_cputc(const char c)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	50                   	push   %eax
  801af5:	6a 01                	push   $0x1
  801af7:	e8 29 fe ff ff       	call   801925 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 14                	push   $0x14
  801b11:	e8 0f fe ff ff       	call   801925 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	90                   	nop
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	8b 45 10             	mov    0x10(%ebp),%eax
  801b25:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	6a 00                	push   $0x0
  801b34:	51                   	push   %ecx
  801b35:	52                   	push   %edx
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	50                   	push   %eax
  801b3a:	6a 15                	push   $0x15
  801b3c:	e8 e4 fd ff ff       	call   801925 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 16                	push   $0x16
  801b59:	e8 c7 fd ff ff       	call   801925 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	51                   	push   %ecx
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 17                	push   $0x17
  801b78:	e8 a8 fd ff ff       	call   801925 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	6a 18                	push   $0x18
  801b95:	e8 8b fd ff ff       	call   801925 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	ff 75 14             	pushl  0x14(%ebp)
  801baa:	ff 75 10             	pushl  0x10(%ebp)
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	50                   	push   %eax
  801bb1:	6a 19                	push   $0x19
  801bb3:	e8 6d fd ff ff       	call   801925 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	50                   	push   %eax
  801bcc:	6a 1a                	push   $0x1a
  801bce:	e8 52 fd ff ff       	call   801925 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	50                   	push   %eax
  801be8:	6a 1b                	push   $0x1b
  801bea:	e8 36 fd ff ff       	call   801925 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 05                	push   $0x5
  801c03:	e8 1d fd ff ff       	call   801925 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 06                	push   $0x6
  801c1c:	e8 04 fd ff ff       	call   801925 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 07                	push   $0x7
  801c35:	e8 eb fc ff ff       	call   801925 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_exit_env>:


void sys_exit_env(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 1c                	push   $0x1c
  801c4e:	e8 d2 fc ff ff       	call   801925 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	90                   	nop
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c62:	8d 50 04             	lea    0x4(%eax),%edx
  801c65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 1d                	push   $0x1d
  801c72:	e8 ae fc ff ff       	call   801925 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return result;
  801c7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c83:	89 01                	mov    %eax,(%ecx)
  801c85:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	c9                   	leave  
  801c8c:	c2 04 00             	ret    $0x4

00801c8f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 10             	pushl  0x10(%ebp)
  801c99:	ff 75 0c             	pushl  0xc(%ebp)
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	6a 13                	push   $0x13
  801ca1:	e8 7f fc ff ff       	call   801925 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_rcr2>:
uint32 sys_rcr2()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 1e                	push   $0x1e
  801cbb:	e8 65 fc ff ff       	call   801925 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	50                   	push   %eax
  801cde:	6a 1f                	push   $0x1f
  801ce0:	e8 40 fc ff ff       	call   801925 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce8:	90                   	nop
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <rsttst>:
void rsttst()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 21                	push   $0x21
  801cfa:	e8 26 fc ff ff       	call   801925 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
	return ;
  801d02:	90                   	nop
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d11:	8b 55 18             	mov    0x18(%ebp),%edx
  801d14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d18:	52                   	push   %edx
  801d19:	50                   	push   %eax
  801d1a:	ff 75 10             	pushl  0x10(%ebp)
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	6a 20                	push   $0x20
  801d25:	e8 fb fb ff ff       	call   801925 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2d:	90                   	nop
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <chktst>:
void chktst(uint32 n)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 08             	pushl  0x8(%ebp)
  801d3e:	6a 22                	push   $0x22
  801d40:	e8 e0 fb ff ff       	call   801925 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
	return ;
  801d48:	90                   	nop
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <inctst>:

void inctst()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 23                	push   $0x23
  801d5a:	e8 c6 fb ff ff       	call   801925 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <gettst>:
uint32 gettst()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 24                	push   $0x24
  801d74:	e8 ac fb ff ff       	call   801925 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 25                	push   $0x25
  801d8d:	e8 93 fb ff ff       	call   801925 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
  801d95:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801d9a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	ff 75 08             	pushl  0x8(%ebp)
  801db7:	6a 26                	push   $0x26
  801db9:	e8 67 fb ff ff       	call   801925 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc1:	90                   	nop
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	53                   	push   %ebx
  801dd7:	51                   	push   %ecx
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 27                	push   $0x27
  801ddc:	e8 44 fb ff ff       	call   801925 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	6a 28                	push   $0x28
  801dfc:	e8 24 fb ff ff       	call   801925 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	6a 00                	push   $0x0
  801e14:	51                   	push   %ecx
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	52                   	push   %edx
  801e19:	50                   	push   %eax
  801e1a:	6a 29                	push   $0x29
  801e1c:	e8 04 fb ff ff       	call   801925 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 10             	pushl  0x10(%ebp)
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	6a 12                	push   $0x12
  801e38:	e8 e8 fa ff ff       	call   801925 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e40:	90                   	nop
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	52                   	push   %edx
  801e53:	50                   	push   %eax
  801e54:	6a 2a                	push   $0x2a
  801e56:	e8 ca fa ff ff       	call   801925 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
	return;
  801e5e:	90                   	nop
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 2b                	push   $0x2b
  801e70:	e8 b0 fa ff ff       	call   801925 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	ff 75 0c             	pushl  0xc(%ebp)
  801e86:	ff 75 08             	pushl  0x8(%ebp)
  801e89:	6a 2d                	push   $0x2d
  801e8b:	e8 95 fa ff ff       	call   801925 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
	return;
  801e93:	90                   	nop
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	6a 2c                	push   $0x2c
  801ea7:	e8 79 fa ff ff       	call   801925 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 f4 2d 80 00       	push   $0x802df4
  801ec0:	68 25 01 00 00       	push   $0x125
  801ec5:	68 27 2e 80 00       	push   $0x802e27
  801eca:	e8 ec e6 ff ff       	call   8005bb <_panic>

00801ecf <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	ba 60 30 80 00       	mov    $0x803060,%edx
  801edd:	29 d0                	sub    %edx,%eax
  801edf:	c1 f8 02             	sar    $0x2,%eax
  801ee2:	89 c2                	mov    %eax,%edx
  801ee4:	89 d0                	mov    %edx,%eax
  801ee6:	c1 e0 02             	shl    $0x2,%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	c1 e0 02             	shl    $0x2,%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	c1 e0 02             	shl    $0x2,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	89 c1                	mov    %eax,%ecx
  801ef7:	c1 e1 08             	shl    $0x8,%ecx
  801efa:	01 c8                	add    %ecx,%eax
  801efc:	89 c1                	mov    %eax,%ecx
  801efe:	c1 e1 10             	shl    $0x10,%ecx
  801f01:	01 c8                	add    %ecx,%eax
  801f03:	01 c0                	add    %eax,%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0d:	c1 e0 0c             	shl    $0xc,%eax
  801f10:	89 c2                	mov    %eax,%edx
  801f12:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801f17:	01 d0                	add    %edx,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	05 00 00 00 02       	add    $0x2000000,%eax
  801f29:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f2c:	73 16                	jae    801f44 <initialize_dynamic_allocator+0x29>
  801f2e:	68 38 2e 80 00       	push   $0x802e38
  801f33:	68 5e 2e 80 00       	push   $0x802e5e
  801f38:	6a 26                	push   $0x26
  801f3a:	68 73 2e 80 00       	push   $0x802e73
  801f3f:	e8 77 e6 ff ff       	call   8005bb <_panic>
		is_initialized = 1;
  801f44:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801f4b:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	68 8c 2e 80 00       	push   $0x802e8c
  801f56:	6a 2e                	push   $0x2e
  801f58:	68 73 2e 80 00       	push   $0x802e73
  801f5d:	e8 59 e6 ff ff       	call   8005bb <_panic>

00801f62 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 c0 2e 80 00       	push   $0x802ec0
  801f70:	6a 3a                	push   $0x3a
  801f72:	68 73 2e 80 00       	push   $0x802e73
  801f77:	e8 3f e6 ff ff       	call   8005bb <_panic>

00801f7c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f82:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f89:	76 16                	jbe    801fa1 <alloc_block+0x25>
  801f8b:	68 e8 2e 80 00       	push   $0x802ee8
  801f90:	68 5e 2e 80 00       	push   $0x802e5e
  801f95:	6a 46                	push   $0x46
  801f97:	68 73 2e 80 00       	push   $0x802e73
  801f9c:	e8 1a e6 ff ff       	call   8005bb <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 0c 2f 80 00       	push   $0x802f0c
  801fa9:	6a 4d                	push   $0x4d
  801fab:	68 73 2e 80 00       	push   $0x802e73
  801fb0:	e8 06 e6 ff ff       	call   8005bb <_panic>

00801fb5 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbe:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801fc3:	39 c2                	cmp    %eax,%edx
  801fc5:	72 0c                	jb     801fd3 <free_block+0x1e>
  801fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fca:	a1 40 30 80 00       	mov    0x803040,%eax
  801fcf:	39 c2                	cmp    %eax,%edx
  801fd1:	72 16                	jb     801fe9 <free_block+0x34>
  801fd3:	68 30 2f 80 00       	push   $0x802f30
  801fd8:	68 5e 2e 80 00       	push   $0x802e5e
  801fdd:	6a 5b                	push   $0x5b
  801fdf:	68 73 2e 80 00       	push   $0x802e73
  801fe4:	e8 d2 e5 ff ff       	call   8005bb <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 68 2f 80 00       	push   $0x802f68
  801ff1:	6a 63                	push   $0x63
  801ff3:	68 73 2e 80 00       	push   $0x802e73
  801ff8:	e8 be e5 ff ff       	call   8005bb <_panic>

00801ffd <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	68 8c 2f 80 00       	push   $0x802f8c
  80200b:	6a 72                	push   $0x72
  80200d:	68 73 2e 80 00       	push   $0x802e73
  802012:	e8 a4 e5 ff ff       	call   8005bb <_panic>

00802017 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80201d:	8b 55 08             	mov    0x8(%ebp),%edx
  802020:	89 d0                	mov    %edx,%eax
  802022:	c1 e0 02             	shl    $0x2,%eax
  802025:	01 d0                	add    %edx,%eax
  802027:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80202e:	01 d0                	add    %edx,%eax
  802030:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802037:	01 d0                	add    %edx,%eax
  802039:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802040:	01 d0                	add    %edx,%eax
  802042:	c1 e0 04             	shl    $0x4,%eax
  802045:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80204f:	0f 31                	rdtsc  
  802051:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802054:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80205d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802060:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802063:	eb 46                	jmp    8020ab <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802065:	0f 31                	rdtsc  
  802067:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80206a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80206d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802070:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802073:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802076:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802079:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	29 c2                	sub    %eax,%edx
  802081:	89 d0                	mov    %edx,%eax
  802083:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802086:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	89 d1                	mov    %edx,%ecx
  80208e:	29 c1                	sub    %eax,%ecx
  802090:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802096:	39 c2                	cmp    %eax,%edx
  802098:	0f 97 c0             	seta   %al
  80209b:	0f b6 c0             	movzbl %al,%eax
  80209e:	29 c1                	sub    %eax,%ecx
  8020a0:	89 c8                	mov    %ecx,%eax
  8020a2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8020a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8020ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8020b1:	72 b2                	jb     802065 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8020bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8020c3:	eb 03                	jmp    8020c8 <busy_wait+0x12>
  8020c5:	ff 45 fc             	incl   -0x4(%ebp)
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ce:	72 f5                	jb     8020c5 <busy_wait+0xf>
	return i;
  8020d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    
  8020d5:	66 90                	xchg   %ax,%ax
  8020d7:	90                   	nop

008020d8 <__udivdi3>:
  8020d8:	55                   	push   %ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ef:	89 ca                	mov    %ecx,%edx
  8020f1:	89 f8                	mov    %edi,%eax
  8020f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020f7:	85 f6                	test   %esi,%esi
  8020f9:	75 2d                	jne    802128 <__udivdi3+0x50>
  8020fb:	39 cf                	cmp    %ecx,%edi
  8020fd:	77 65                	ja     802164 <__udivdi3+0x8c>
  8020ff:	89 fd                	mov    %edi,%ebp
  802101:	85 ff                	test   %edi,%edi
  802103:	75 0b                	jne    802110 <__udivdi3+0x38>
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	31 d2                	xor    %edx,%edx
  80210c:	f7 f7                	div    %edi
  80210e:	89 c5                	mov    %eax,%ebp
  802110:	31 d2                	xor    %edx,%edx
  802112:	89 c8                	mov    %ecx,%eax
  802114:	f7 f5                	div    %ebp
  802116:	89 c1                	mov    %eax,%ecx
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	f7 f5                	div    %ebp
  80211c:	89 cf                	mov    %ecx,%edi
  80211e:	89 fa                	mov    %edi,%edx
  802120:	83 c4 1c             	add    $0x1c,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5f                   	pop    %edi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
  802128:	39 ce                	cmp    %ecx,%esi
  80212a:	77 28                	ja     802154 <__udivdi3+0x7c>
  80212c:	0f bd fe             	bsr    %esi,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 40                	jne    802174 <__udivdi3+0x9c>
  802134:	39 ce                	cmp    %ecx,%esi
  802136:	72 0a                	jb     802142 <__udivdi3+0x6a>
  802138:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80213c:	0f 87 9e 00 00 00    	ja     8021e0 <__udivdi3+0x108>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	89 fa                	mov    %edi,%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d 76 00             	lea    0x0(%esi),%esi
  802154:	31 ff                	xor    %edi,%edi
  802156:	31 c0                	xor    %eax,%eax
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	66 90                	xchg   %ax,%ax
  802164:	89 d8                	mov    %ebx,%eax
  802166:	f7 f7                	div    %edi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	89 fa                	mov    %edi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	bd 20 00 00 00       	mov    $0x20,%ebp
  802179:	89 eb                	mov    %ebp,%ebx
  80217b:	29 fb                	sub    %edi,%ebx
  80217d:	89 f9                	mov    %edi,%ecx
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 c5                	mov    %eax,%ebp
  802183:	88 d9                	mov    %bl,%cl
  802185:	d3 ed                	shr    %cl,%ebp
  802187:	89 e9                	mov    %ebp,%ecx
  802189:	09 f1                	or     %esi,%ecx
  80218b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e0                	shl    %cl,%eax
  802193:	89 c5                	mov    %eax,%ebp
  802195:	89 d6                	mov    %edx,%esi
  802197:	88 d9                	mov    %bl,%cl
  802199:	d3 ee                	shr    %cl,%esi
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e2                	shl    %cl,%edx
  80219f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c2                	or     %eax,%edx
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	f7 74 24 0c          	divl   0xc(%esp)
  8021b1:	89 d6                	mov    %edx,%esi
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	f7 e5                	mul    %ebp
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 19                	jb     8021d4 <__udivdi3+0xfc>
  8021bb:	74 0b                	je     8021c8 <__udivdi3+0xf0>
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	31 ff                	xor    %edi,%edi
  8021c1:	e9 58 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cc:	89 f9                	mov    %edi,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	39 c2                	cmp    %eax,%edx
  8021d2:	73 e9                	jae    8021bd <__udivdi3+0xe5>
  8021d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d7:	31 ff                	xor    %edi,%edi
  8021d9:	e9 40 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 c0                	xor    %eax,%eax
  8021e2:	e9 37 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021e7:	90                   	nop

008021e8 <__umoddi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802207:	89 f3                	mov    %esi,%ebx
  802209:	89 fa                	mov    %edi,%edx
  80220b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80220f:	89 34 24             	mov    %esi,(%esp)
  802212:	85 c0                	test   %eax,%eax
  802214:	75 1a                	jne    802230 <__umoddi3+0x48>
  802216:	39 f7                	cmp    %esi,%edi
  802218:	0f 86 a2 00 00 00    	jbe    8022c0 <__umoddi3+0xd8>
  80221e:	89 c8                	mov    %ecx,%eax
  802220:	89 f2                	mov    %esi,%edx
  802222:	f7 f7                	div    %edi
  802224:	89 d0                	mov    %edx,%eax
  802226:	31 d2                	xor    %edx,%edx
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	39 f0                	cmp    %esi,%eax
  802232:	0f 87 ac 00 00 00    	ja     8022e4 <__umoddi3+0xfc>
  802238:	0f bd e8             	bsr    %eax,%ebp
  80223b:	83 f5 1f             	xor    $0x1f,%ebp
  80223e:	0f 84 ac 00 00 00    	je     8022f0 <__umoddi3+0x108>
  802244:	bf 20 00 00 00       	mov    $0x20,%edi
  802249:	29 ef                	sub    %ebp,%edi
  80224b:	89 fe                	mov    %edi,%esi
  80224d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e0                	shl    %cl,%eax
  802255:	89 d7                	mov    %edx,%edi
  802257:	89 f1                	mov    %esi,%ecx
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	09 c7                	or     %eax,%edi
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 14 24             	mov    %edx,(%esp)
  802264:	89 d8                	mov    %ebx,%eax
  802266:	d3 e0                	shl    %cl,%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226e:	d3 e0                	shl    %cl,%eax
  802270:	89 44 24 04          	mov    %eax,0x4(%esp)
  802274:	8b 44 24 08          	mov    0x8(%esp),%eax
  802278:	89 f1                	mov    %esi,%ecx
  80227a:	d3 e8                	shr    %cl,%eax
  80227c:	09 d0                	or     %edx,%eax
  80227e:	d3 eb                	shr    %cl,%ebx
  802280:	89 da                	mov    %ebx,%edx
  802282:	f7 f7                	div    %edi
  802284:	89 d3                	mov    %edx,%ebx
  802286:	f7 24 24             	mull   (%esp)
  802289:	89 c6                	mov    %eax,%esi
  80228b:	89 d1                	mov    %edx,%ecx
  80228d:	39 d3                	cmp    %edx,%ebx
  80228f:	0f 82 87 00 00 00    	jb     80231c <__umoddi3+0x134>
  802295:	0f 84 91 00 00 00    	je     80232c <__umoddi3+0x144>
  80229b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80229f:	29 f2                	sub    %esi,%edx
  8022a1:	19 cb                	sbb    %ecx,%ebx
  8022a3:	89 d8                	mov    %ebx,%eax
  8022a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022a9:	d3 e0                	shl    %cl,%eax
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	d3 ea                	shr    %cl,%edx
  8022af:	09 d0                	or     %edx,%eax
  8022b1:	89 e9                	mov    %ebp,%ecx
  8022b3:	d3 eb                	shr    %cl,%ebx
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	83 c4 1c             	add    $0x1c,%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5f                   	pop    %edi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
  8022bf:	90                   	nop
  8022c0:	89 fd                	mov    %edi,%ebp
  8022c2:	85 ff                	test   %edi,%edi
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0xe9>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f7                	div    %edi
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	89 f0                	mov    %esi,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f5                	div    %ebp
  8022d7:	89 c8                	mov    %ecx,%eax
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 d0                	mov    %edx,%eax
  8022dd:	e9 44 ff ff ff       	jmp    802226 <__umoddi3+0x3e>
  8022e2:	66 90                	xchg   %ax,%ax
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	89 f2                	mov    %esi,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	3b 04 24             	cmp    (%esp),%eax
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x113>
  8022f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022f9:	77 0f                	ja     80230a <__umoddi3+0x122>
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	29 f9                	sub    %edi,%ecx
  8022ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802303:	89 14 24             	mov    %edx,(%esp)
  802306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80230e:	8b 14 24             	mov    (%esp),%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d 76 00             	lea    0x0(%esi),%esi
  80231c:	2b 04 24             	sub    (%esp),%eax
  80231f:	19 fa                	sbb    %edi,%edx
  802321:	89 d1                	mov    %edx,%ecx
  802323:	89 c6                	mov    %eax,%esi
  802325:	e9 71 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802330:	72 ea                	jb     80231c <__umoddi3+0x134>
  802332:	89 d9                	mov    %ebx,%ecx
  802334:	e9 62 ff ff ff       	jmp    80229b <__umoddi3+0xb3>

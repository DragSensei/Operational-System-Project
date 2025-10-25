
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d6 04 00 00       	call   80050c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800044:	a1 20 40 80 00       	mov    0x804020,%eax
  800049:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005a:	39 c2                	cmp    %eax,%edx
  80005c:	72 14                	jb     800072 <_main+0x3a>
			panic("Please increase the WS size");
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 40 24 80 00       	push   $0x802440
  800066:	6a 0b                	push   $0xb
  800068:	68 5c 24 80 00       	push   $0x80245c
  80006d:	e8 4a 06 00 00       	call   8006bc <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800072:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	68 7c 24 80 00       	push   $0x80247c
  800081:	e8 04 09 00 00       	call   80098a <cprintf>
  800086:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	68 b0 24 80 00       	push   $0x8024b0
  800091:	e8 f4 08 00 00       	call   80098a <cprintf>
  800096:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 0c 25 80 00       	push   $0x80250c
  8000a1:	e8 e4 08 00 00       	call   80098a <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a9:	e8 47 1c 00 00       	call   801cf5 <sys_getenvid>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 40 25 80 00       	push   $0x802540
  8000b9:	e8 cc 08 00 00       	call   80098a <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000cc:	89 c2                	mov    %eax,%edx
  8000ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d9:	6a 32                	push   $0x32
  8000db:	52                   	push   %edx
  8000dc:	50                   	push   %eax
  8000dd:	68 81 25 80 00       	push   $0x802581
  8000e2:	e8 b9 1b 00 00       	call   801ca0 <sys_create_env>
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8000f2:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800105:	6a 32                	push   $0x32
  800107:	52                   	push   %edx
  800108:	50                   	push   %eax
  800109:	68 81 25 80 00       	push   $0x802581
  80010e:	e8 8d 1b 00 00       	call   801ca0 <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800119:	e8 27 1a 00 00       	call   801b45 <sys_calculate_free_frames>
  80011e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	6a 01                	push   $0x1
  800126:	68 00 10 00 00       	push   $0x1000
  80012b:	68 8f 25 80 00       	push   $0x80258f
  800130:	e8 5f 18 00 00       	call   801994 <smalloc>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 d0             	mov    %eax,-0x30(%ebp)
		cprintf("Master env created x (1 page) \n");
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	68 94 25 80 00       	push   $0x802594
  800143:	e8 42 08 00 00       	call   80098a <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80014b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 b4 25 80 00       	push   $0x8025b4
  80015b:	6a 27                	push   $0x27
  80015d:	68 5c 24 80 00       	push   $0x80245c
  800162:	e8 55 05 00 00       	call   8006bc <_panic>
		expected = 1+1 ; /*1page +1table*/
  800167:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80016e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800171:	e8 cf 19 00 00       	call   801b45 <sys_calculate_free_frames>
  800176:	29 c3                	sub    %eax,%ebx
  800178:	89 d8                	mov    %ebx,%eax
  80017a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80017d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800180:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800183:	7c 0b                	jl     800190 <_main+0x158>
  800185:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800188:	83 c0 02             	add    $0x2,%eax
  80018b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80018e:	7d 24                	jge    8001b4 <_main+0x17c>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800190:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800193:	e8 ad 19 00 00       	call   801b45 <sys_calculate_free_frames>
  800198:	29 c3                	sub    %eax,%ebx
  80019a:	89 d8                	mov    %ebx,%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 cc             	pushl  -0x34(%ebp)
  8001a2:	50                   	push   %eax
  8001a3:	68 20 26 80 00       	push   $0x802620
  8001a8:	6a 2b                	push   $0x2b
  8001aa:	68 5c 24 80 00       	push   $0x80245c
  8001af:	e8 08 05 00 00       	call   8006bc <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001b4:	e8 33 1c 00 00       	call   801dec <rsttst>

		sys_run_env(envIdSlave1);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bf:	e8 fa 1a 00 00       	call   801cbe <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 ec 1a 00 00       	call   801cbe <sys_run_env>
  8001d2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 26 80 00       	push   $0x8026b8
  8001dd:	e8 a8 07 00 00       	call   80098a <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 b8 0b 00 00       	push   $0xbb8
  8001ed:	e8 26 1f 00 00       	call   802118 <env_sleep>
  8001f2:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  8001f5:	90                   	nop
  8001f6:	e8 6b 1c 00 00       	call   801e66 <gettst>
  8001fb:	83 f8 02             	cmp    $0x2,%eax
  8001fe:	75 f6                	jne    8001f6 <_main+0x1be>

		freeFrames = sys_calculate_free_frames() ;
  800200:	e8 40 19 00 00       	call   801b45 <sys_calculate_free_frames>
  800205:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		sfree(x);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 d0             	pushl  -0x30(%ebp)
  80020e:	e8 f6 17 00 00       	call   801a09 <sfree>
  800213:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 d0 26 80 00       	push   $0x8026d0
  80021e:	e8 67 07 00 00       	call   80098a <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		int diff2 = (sys_calculate_free_frames() - freeFrames);
  800226:	e8 1a 19 00 00       	call   801b45 <sys_calculate_free_frames>
  80022b:	89 c2                	mov    %eax,%edx
  80022d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800230:	29 c2                	sub    %eax,%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		expected = 1+1; /*1page+1table*/
  800237:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		if (diff2 != expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff2, expected);
  80023e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800241:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800244:	74 1a                	je     800260 <_main+0x228>
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 cc             	pushl  -0x34(%ebp)
  80024c:	ff 75 c4             	pushl  -0x3c(%ebp)
  80024f:	68 f0 26 80 00       	push   $0x8026f0
  800254:	6a 3e                	push   $0x3e
  800256:	68 5c 24 80 00       	push   $0x80245c
  80025b:	e8 5c 04 00 00       	call   8006bc <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 37 27 80 00       	push   $0x802737
  800268:	e8 1d 07 00 00       	call   80098a <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 50 27 80 00       	push   $0x802750
  800278:	e8 0d 07 00 00       	call   80098a <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800280:	a1 20 40 80 00       	mov    0x804020,%eax
  800285:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80028b:	89 c2                	mov    %eax,%edx
  80028d:	a1 20 40 80 00       	mov    0x804020,%eax
  800292:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800298:	6a 32                	push   $0x32
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	68 80 27 80 00       	push   $0x802780
  8002a1:	e8 fa 19 00 00       	call   801ca0 <sys_create_env>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  8002ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002c4:	6a 32                	push   $0x32
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	68 90 27 80 00       	push   $0x802790
  8002cd:	e8 ce 19 00 00       	call   801ca0 <sys_create_env>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 bc             	mov    %eax,-0x44(%ebp)

		z = smalloc("z", PAGE_SIZE+1, 1);
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	6a 01                	push   $0x1
  8002dd:	68 01 10 00 00       	push   $0x1001
  8002e2:	68 a0 27 80 00       	push   $0x8027a0
  8002e7:	e8 a8 16 00 00       	call   801994 <smalloc>
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	89 45 b8             	mov    %eax,-0x48(%ebp)
		cprintf("Master env created z (2 pages) \n");
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	68 a4 27 80 00       	push   $0x8027a4
  8002fa:	e8 8b 06 00 00       	call   80098a <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE+1024, 1);
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	6a 01                	push   $0x1
  800307:	68 00 14 00 00       	push   $0x1400
  80030c:	68 8f 25 80 00       	push   $0x80258f
  800311:	e8 7e 16 00 00       	call   801994 <smalloc>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		cprintf("Master env created x (2 pages) \n");
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	68 c8 27 80 00       	push   $0x8027c8
  800324:	e8 61 06 00 00       	call   80098a <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80032c:	e8 bb 1a 00 00       	call   801dec <rsttst>

		sys_run_env(envIdSlaveB1);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 c0             	pushl  -0x40(%ebp)
  800337:	e8 82 19 00 00       	call   801cbe <sys_run_env>
  80033c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 bc             	pushl  -0x44(%ebp)
  800345:	e8 74 19 00 00       	call   801cbe <sys_run_env>
  80034a:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
			//			env_sleep(4000);
			while (gettst()!=2) ;
  80034d:	90                   	nop
  80034e:	e8 13 1b 00 00       	call   801e66 <gettst>
  800353:	83 f8 02             	cmp    $0x2,%eax
  800356:	75 f6                	jne    80034e <_main+0x316>
		}

		int freeFrames = sys_calculate_free_frames() ;
  800358:	e8 e8 17 00 00       	call   801b45 <sys_calculate_free_frames>
  80035d:	89 45 b0             	mov    %eax,-0x50(%ebp)

		sfree(z);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 b8             	pushl  -0x48(%ebp)
  800366:	e8 9e 16 00 00       	call   801a09 <sfree>
  80036b:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 e9 27 80 00       	push   $0x8027e9
  800376:	e8 0f 06 00 00       	call   80098a <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	ff 75 b4             	pushl  -0x4c(%ebp)
  800384:	e8 80 16 00 00       	call   801a09 <sfree>
  800389:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 ff 27 80 00       	push   $0x8027ff
  800394:	e8 f1 05 00 00       	call   80098a <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

		inctst(); //finish the free's
  80039c:	e8 ab 1a 00 00       	call   801e4c <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003a1:	e8 9f 17 00 00       	call   801b45 <sys_calculate_free_frames>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003ab:	29 c2                	sub    %eax,%edx
  8003ad:	89 d0                	mov    %edx,%eax
  8003af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		expected = 1 /*table*/;
  8003b2:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003b9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003bc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003bf:	74 14                	je     8003d5 <_main+0x39d>
  8003c1:	83 ec 04             	sub    $0x4,%esp
  8003c4:	68 18 28 80 00       	push   $0x802818
  8003c9:	6a 65                	push   $0x65
  8003cb:	68 5c 24 80 00       	push   $0x80245c
  8003d0:	e8 e7 02 00 00       	call   8006bc <_panic>

		inctst();	// finish checking
  8003d5:	e8 72 1a 00 00       	call   801e4c <inctst>

		//to ensure that the other environments completed successfully
		while (gettst()!=6) ;// panic("test failed");
  8003da:	90                   	nop
  8003db:	e8 86 1a 00 00       	call   801e66 <gettst>
  8003e0:	83 f8 06             	cmp    $0x6,%eax
  8003e3:	75 f6                	jne    8003db <_main+0x3a3>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	6a 01                	push   $0x1
  8003ea:	6a 04                	push   $0x4
  8003ec:	68 bd 28 80 00       	push   $0x8028bd
  8003f1:	e8 9e 15 00 00       	call   801994 <smalloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		*finish_children = 0;
  8003fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		//To indicate that it create the finish_children & completed successfully
		cprintf("Master is completed.\n");
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	68 cd 28 80 00       	push   $0x8028cd
  80040d:	e8 78 05 00 00       	call   80098a <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
		inctst();
  800415:	e8 32 1a 00 00       	call   801e4c <inctst>

		if (sys_getparentenvid() > 0) {
  80041a:	e8 08 19 00 00       	call   801d27 <sys_getparentenvid>
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 8e dc 00 00 00    	jle    800503 <_main+0x4cb>
			while(*finish_children != 1);
  800427:	90                   	nop
  800428:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 f8 01             	cmp    $0x1,%eax
  800430:	75 f6                	jne    800428 <_main+0x3f0>
			cprintf("done\n");
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 e3 28 80 00       	push   $0x8028e3
  80043a:	e8 4b 05 00 00       	call   80098a <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp

			//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
			//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
			//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
			//	2. changing the # free frames
			char changeIntCmd[100] = "__changeInterruptStatus__";
  800442:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800448:	bb f7 28 80 00       	mov    $0x8028f7,%ebx
  80044d:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800452:	89 c7                	mov    %eax,%edi
  800454:	89 de                	mov    %ebx,%esi
  800456:	89 d1                	mov    %edx,%ecx
  800458:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80045a:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800460:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800465:	b0 00                	mov    $0x0,%al
  800467:	89 d7                	mov    %edx,%edi
  800469:	f3 aa                	rep stos %al,%es:(%edi)
			sys_utilities(changeIntCmd, 0);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	6a 00                	push   $0x0
  800470:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	e8 c8 1a 00 00       	call   801f44 <sys_utilities>
  80047c:	83 c4 10             	add    $0x10,%esp
			{
				sys_destroy_env(envIdSlave1);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	ff 75 dc             	pushl  -0x24(%ebp)
  800485:	e8 50 18 00 00       	call   801cda <sys_destroy_env>
  80048a:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlave2);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 42 18 00 00       	call   801cda <sys_destroy_env>
  800498:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB1);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a1:	e8 34 18 00 00       	call   801cda <sys_destroy_env>
  8004a6:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB2);
  8004a9:	83 ec 0c             	sub    $0xc,%esp
  8004ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8004af:	e8 26 18 00 00       	call   801cda <sys_destroy_env>
  8004b4:	83 c4 10             	add    $0x10,%esp
			}
			sys_utilities(changeIntCmd, 1);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 01                	push   $0x1
  8004bc:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 7c 1a 00 00       	call   801f44 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  8004cb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8004d2:	e8 50 18 00 00       	call   801d27 <sys_getparentenvid>
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	68 e9 28 80 00       	push   $0x8028e9
  8004df:	50                   	push   %eax
  8004e0:	e8 e3 14 00 00       	call   8019c8 <sget>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 45 a4             	mov    %eax,-0x5c(%ebp)

			//Critical section to protect the shared variable
			sys_lock_cons();
  8004eb:	e8 a5 15 00 00       	call   801a95 <sys_lock_cons>
			{
				(*finishedCount)++ ;
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
			}
			sys_unlock_cons();
  8004fd:	e8 ad 15 00 00       	call   801aaf <sys_unlock_cons>
		}
	}


	return;
  800502:	90                   	nop
  800503:	90                   	nop
}
  800504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800507:	5b                   	pop    %ebx
  800508:	5e                   	pop    %esi
  800509:	5f                   	pop    %edi
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	57                   	push   %edi
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800515:	e8 f4 17 00 00       	call   801d0e <sys_getenvindex>
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80051d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	c1 e0 02             	shl    $0x2,%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	c1 e0 03             	shl    $0x3,%eax
  80052a:	01 d0                	add    %edx,%eax
  80052c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800533:	01 d0                	add    %edx,%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80053d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8a 40 20             	mov    0x20(%eax),%al
  80054a:	84 c0                	test   %al,%al
  80054c:	74 0d                	je     80055b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	83 c0 20             	add    $0x20,%eax
  800556:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80055f:	7e 0a                	jle    80056b <libmain+0x5f>
		binaryname = argv[0];
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	e8 bf fa ff ff       	call   800038 <_main>
  800579:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80057c:	a1 00 40 80 00       	mov    0x804000,%eax
  800581:	85 c0                	test   %eax,%eax
  800583:	0f 84 01 01 00 00    	je     80068a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800589:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80058f:	bb 54 2a 80 00       	mov    $0x802a54,%ebx
  800594:	ba 0e 00 00 00       	mov    $0xe,%edx
  800599:	89 c7                	mov    %eax,%edi
  80059b:	89 de                	mov    %ebx,%esi
  80059d:	89 d1                	mov    %edx,%ecx
  80059f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005a9:	b0 00                	mov    $0x0,%al
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	50                   	push   %eax
  8005bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005c3:	50                   	push   %eax
  8005c4:	e8 7b 19 00 00       	call   801f44 <sys_utilities>
  8005c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005cc:	e8 c4 14 00 00       	call   801a95 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	68 74 29 80 00       	push   $0x802974
  8005d9:	e8 ac 03 00 00       	call   80098a <cprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	74 18                	je     800600 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005e8:	e8 75 19 00 00       	call   801f62 <sys_get_optimal_num_faults>
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	50                   	push   %eax
  8005f1:	68 9c 29 80 00       	push   $0x80299c
  8005f6:	e8 8f 03 00 00       	call   80098a <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb 59                	jmp    800659 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800600:	a1 20 40 80 00       	mov    0x804020,%eax
  800605:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80060b:	a1 20 40 80 00       	mov    0x804020,%eax
  800610:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	68 c0 29 80 00       	push   $0x8029c0
  800620:	e8 65 03 00 00       	call   80098a <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800628:	a1 20 40 80 00       	mov    0x804020,%eax
  80062d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80063e:	a1 20 40 80 00       	mov    0x804020,%eax
  800643:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800649:	51                   	push   %ecx
  80064a:	52                   	push   %edx
  80064b:	50                   	push   %eax
  80064c:	68 e8 29 80 00       	push   $0x8029e8
  800651:	e8 34 03 00 00       	call   80098a <cprintf>
  800656:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	50                   	push   %eax
  800668:	68 40 2a 80 00       	push   $0x802a40
  80066d:	e8 18 03 00 00       	call   80098a <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	68 74 29 80 00       	push   $0x802974
  80067d:	e8 08 03 00 00       	call   80098a <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800685:	e8 25 14 00 00       	call   801aaf <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80068a:	e8 1f 00 00 00       	call   8006ae <exit>
}
  80068f:	90                   	nop
  800690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5f                   	pop    %edi
  800696:	5d                   	pop    %ebp
  800697:	c3                   	ret    

00800698 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	6a 00                	push   $0x0
  8006a3:	e8 32 16 00 00       	call   801cda <sys_destroy_env>
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <exit>:

void
exit(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006b4:	e8 87 16 00 00       	call   801d40 <sys_exit_env>
}
  8006b9:	90                   	nop
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c5:	83 c0 04             	add    $0x4,%eax
  8006c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006cb:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8006d0:	85 c0                	test   %eax,%eax
  8006d2:	74 16                	je     8006ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d4:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	50                   	push   %eax
  8006dd:	68 b8 2a 80 00       	push   $0x802ab8
  8006e2:	e8 a3 02 00 00       	call   80098a <cprintf>
  8006e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8006ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8006ef:	83 ec 0c             	sub    $0xc,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	68 c0 2a 80 00       	push   $0x802ac0
  8006fe:	6a 74                	push   $0x74
  800700:	e8 b2 02 00 00       	call   8009b7 <cprintf_colored>
  800705:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800708:	8b 45 10             	mov    0x10(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 f4             	pushl  -0xc(%ebp)
  800711:	50                   	push   %eax
  800712:	e8 04 02 00 00       	call   80091b <vcprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	6a 00                	push   $0x0
  80071f:	68 e8 2a 80 00       	push   $0x802ae8
  800724:	e8 f2 01 00 00       	call   80091b <vcprintf>
  800729:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80072c:	e8 7d ff ff ff       	call   8006ae <exit>

	// should not return here
	while (1) ;
  800731:	eb fe                	jmp    800731 <_panic+0x75>

00800733 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800739:	a1 20 40 80 00       	mov    0x804020,%eax
  80073e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	39 c2                	cmp    %eax,%edx
  800749:	74 14                	je     80075f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	68 ec 2a 80 00       	push   $0x802aec
  800753:	6a 26                	push   $0x26
  800755:	68 38 2b 80 00       	push   $0x802b38
  80075a:	e8 5d ff ff ff       	call   8006bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80075f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800766:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076d:	e9 c5 00 00 00       	jmp    800837 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	01 d0                	add    %edx,%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	85 c0                	test   %eax,%eax
  800785:	75 08                	jne    80078f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800787:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80078a:	e9 a5 00 00 00       	jmp    800834 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80078f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800796:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80079d:	eb 69                	jmp    800808 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80079f:	a1 20 40 80 00       	mov    0x804020,%eax
  8007a4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ad:	89 d0                	mov    %edx,%eax
  8007af:	01 c0                	add    %eax,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	c1 e0 03             	shl    $0x3,%eax
  8007b6:	01 c8                	add    %ecx,%eax
  8007b8:	8a 40 04             	mov    0x4(%eax),%al
  8007bb:	84 c0                	test   %al,%al
  8007bd:	75 46                	jne    800805 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	c1 e0 03             	shl    $0x3,%eax
  8007d6:	01 c8                	add    %ecx,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	01 c8                	add    %ecx,%eax
  8007f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007f8:	39 c2                	cmp    %eax,%edx
  8007fa:	75 09                	jne    800805 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800803:	eb 15                	jmp    80081a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800805:	ff 45 e8             	incl   -0x18(%ebp)
  800808:	a1 20 40 80 00       	mov    0x804020,%eax
  80080d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800816:	39 c2                	cmp    %eax,%edx
  800818:	77 85                	ja     80079f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80081a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80081e:	75 14                	jne    800834 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	68 44 2b 80 00       	push   $0x802b44
  800828:	6a 3a                	push   $0x3a
  80082a:	68 38 2b 80 00       	push   $0x802b38
  80082f:	e8 88 fe ff ff       	call   8006bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800834:	ff 45 f0             	incl   -0x10(%ebp)
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80083d:	0f 8c 2f ff ff ff    	jl     800772 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800843:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800851:	eb 26                	jmp    800879 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800853:	a1 20 40 80 00       	mov    0x804020,%eax
  800858:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80085e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800861:	89 d0                	mov    %edx,%eax
  800863:	01 c0                	add    %eax,%eax
  800865:	01 d0                	add    %edx,%eax
  800867:	c1 e0 03             	shl    $0x3,%eax
  80086a:	01 c8                	add    %ecx,%eax
  80086c:	8a 40 04             	mov    0x4(%eax),%al
  80086f:	3c 01                	cmp    $0x1,%al
  800871:	75 03                	jne    800876 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800873:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800876:	ff 45 e0             	incl   -0x20(%ebp)
  800879:	a1 20 40 80 00       	mov    0x804020,%eax
  80087e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800884:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800887:	39 c2                	cmp    %eax,%edx
  800889:	77 c8                	ja     800853 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800891:	74 14                	je     8008a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800893:	83 ec 04             	sub    $0x4,%esp
  800896:	68 98 2b 80 00       	push   $0x802b98
  80089b:	6a 44                	push   $0x44
  80089d:	68 38 2b 80 00       	push   $0x802b38
  8008a2:	e8 15 fe ff ff       	call   8006bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008a7:	90                   	nop
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	53                   	push   %ebx
  8008ae:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 0a                	mov    %ecx,(%edx)
  8008be:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c1:	88 d1                	mov    %dl,%cl
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d4:	75 30                	jne    800906 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8008d6:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8008dc:	a0 44 40 80 00       	mov    0x804044,%al
  8008e1:	0f b6 c0             	movzbl %al,%eax
  8008e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e7:	8b 09                	mov    (%ecx),%ecx
  8008e9:	89 cb                	mov    %ecx,%ebx
  8008eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ee:	83 c1 08             	add    $0x8,%ecx
  8008f1:	52                   	push   %edx
  8008f2:	50                   	push   %eax
  8008f3:	53                   	push   %ebx
  8008f4:	51                   	push   %ecx
  8008f5:	e8 57 11 00 00       	call   801a51 <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800924:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80092b:	00 00 00 
	b.cnt = 0;
  80092e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800935:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	ff 75 08             	pushl  0x8(%ebp)
  80093e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	68 aa 08 80 00       	push   $0x8008aa
  80094a:	e8 5a 02 00 00       	call   800ba9 <vprintfmt>
  80094f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800952:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800958:	a0 44 40 80 00       	mov    0x804044,%al
  80095d:	0f b6 c0             	movzbl %al,%eax
  800960:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800966:	52                   	push   %edx
  800967:	50                   	push   %eax
  800968:	51                   	push   %ecx
  800969:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80096f:	83 c0 08             	add    $0x8,%eax
  800972:	50                   	push   %eax
  800973:	e8 d9 10 00 00       	call   801a51 <sys_cputs>
  800978:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80097b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800982:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800990:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800997:	8d 45 0c             	lea    0xc(%ebp),%eax
  80099a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	e8 6f ff ff ff       	call   80091b <vcprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	c1 e0 08             	shl    $0x8,%eax
  8009ca:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  8009cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d2:	83 c0 04             	add    $0x4,%eax
  8009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e1:	50                   	push   %eax
  8009e2:	e8 34 ff ff ff       	call   80091b <vcprintf>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8009ed:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8009f4:	07 00 00 

	return cnt;
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a02:	e8 8e 10 00 00       	call   801a95 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	e8 ff fe ff ff       	call   80091b <vcprintf>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a22:	e8 88 10 00 00       	call   801aaf <sys_unlock_cons>
	return cnt;
  800a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	83 ec 14             	sub    $0x14,%esp
  800a33:	8b 45 10             	mov    0x10(%ebp),%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
  800a47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4a:	77 55                	ja     800aa1 <printnum+0x75>
  800a4c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4f:	72 05                	jb     800a56 <printnum+0x2a>
  800a51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a54:	77 4b                	ja     800aa1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a56:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a59:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a64:	52                   	push   %edx
  800a65:	50                   	push   %eax
  800a66:	ff 75 f4             	pushl  -0xc(%ebp)
  800a69:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6c:	e8 67 17 00 00       	call   8021d8 <__udivdi3>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	83 ec 04             	sub    $0x4,%esp
  800a77:	ff 75 20             	pushl  0x20(%ebp)
  800a7a:	53                   	push   %ebx
  800a7b:	ff 75 18             	pushl  0x18(%ebp)
  800a7e:	52                   	push   %edx
  800a7f:	50                   	push   %eax
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 a1 ff ff ff       	call   800a2c <printnum>
  800a8b:	83 c4 20             	add    $0x20,%esp
  800a8e:	eb 1a                	jmp    800aaa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 20             	pushl  0x20(%ebp)
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa1:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aa8:	7f e6                	jg     800a90 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aaa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab8:	53                   	push   %ebx
  800ab9:	51                   	push   %ecx
  800aba:	52                   	push   %edx
  800abb:	50                   	push   %eax
  800abc:	e8 27 18 00 00       	call   8022e8 <__umoddi3>
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	05 14 2e 80 00       	add    $0x802e14,%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	0f be c0             	movsbl %al,%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
}
  800add:	90                   	nop
  800ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aea:	7e 1c                	jle    800b08 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	8d 50 08             	lea    0x8(%eax),%edx
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	89 10                	mov    %edx,(%eax)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	83 e8 08             	sub    $0x8,%eax
  800b01:	8b 50 04             	mov    0x4(%eax),%edx
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	eb 40                	jmp    800b48 <getuint+0x65>
	else if (lflag)
  800b08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0c:	74 1e                	je     800b2c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	8d 50 04             	lea    0x4(%eax),%edx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	89 10                	mov    %edx,(%eax)
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	83 e8 04             	sub    $0x4,%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	eb 1c                	jmp    800b48 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	8d 50 04             	lea    0x4(%eax),%edx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 10                	mov    %edx,(%eax)
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	83 e8 04             	sub    $0x4,%eax
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b51:	7e 1c                	jle    800b6f <getint+0x25>
		return va_arg(*ap, long long);
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	8d 50 08             	lea    0x8(%eax),%edx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 10                	mov    %edx,(%eax)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	83 e8 08             	sub    $0x8,%eax
  800b68:	8b 50 04             	mov    0x4(%eax),%edx
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	eb 38                	jmp    800ba7 <getint+0x5d>
	else if (lflag)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 1a                	je     800b8f <getint+0x45>
		return va_arg(*ap, long);
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	8d 50 04             	lea    0x4(%eax),%edx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 10                	mov    %edx,(%eax)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	83 e8 04             	sub    $0x4,%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	99                   	cltd   
  800b8d:	eb 18                	jmp    800ba7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	8d 50 04             	lea    0x4(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	89 10                	mov    %edx,(%eax)
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	83 e8 04             	sub    $0x4,%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	99                   	cltd   
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb1:	eb 17                	jmp    800bca <vprintfmt+0x21>
			if (ch == '\0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	0f 84 c1 03 00 00    	je     800f7c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	8d 50 01             	lea    0x1(%eax),%edx
  800bd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	0f b6 d8             	movzbl %al,%ebx
  800bd8:	83 fb 25             	cmp    $0x25,%ebx
  800bdb:	75 d6                	jne    800bb3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bdd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800be8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 10             	mov    %edx,0x10(%ebp)
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	0f b6 d8             	movzbl %al,%ebx
  800c0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c0e:	83 f8 5b             	cmp    $0x5b,%eax
  800c11:	0f 87 3d 03 00 00    	ja     800f54 <vprintfmt+0x3ab>
  800c17:	8b 04 85 38 2e 80 00 	mov    0x802e38(,%eax,4),%eax
  800c1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c24:	eb d7                	jmp    800bfd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2a:	eb d1                	jmp    800bfd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c36:	89 d0                	mov    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	01 c0                	add    %eax,%eax
  800c3f:	01 d8                	add    %ebx,%eax
  800c41:	83 e8 30             	sub    $0x30,%eax
  800c44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c52:	7e 3e                	jle    800c92 <vprintfmt+0xe9>
  800c54:	83 fb 39             	cmp    $0x39,%ebx
  800c57:	7f 39                	jg     800c92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5c:	eb d5                	jmp    800c33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 c0 04             	add    $0x4,%eax
  800c64:	89 45 14             	mov    %eax,0x14(%ebp)
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 e8 04             	sub    $0x4,%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c72:	eb 1f                	jmp    800c93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c78:	79 83                	jns    800bfd <vprintfmt+0x54>
				width = 0;
  800c7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c81:	e9 77 ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c8d:	e9 6b ff ff ff       	jmp    800bfd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c97:	0f 89 60 ff ff ff    	jns    800bfd <vprintfmt+0x54>
				width = precision, precision = -1;
  800c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800caa:	e9 4e ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800caf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb2:	e9 46 ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	83 c0 04             	add    $0x4,%eax
  800cbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 e8 04             	sub    $0x4,%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	50                   	push   %eax
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	ff d0                	call   *%eax
  800cd4:	83 c4 10             	add    $0x10,%esp
			break;
  800cd7:	e9 9b 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 c0 04             	add    $0x4,%eax
  800ce2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 e8 04             	sub    $0x4,%eax
  800ceb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ced:	85 db                	test   %ebx,%ebx
  800cef:	79 02                	jns    800cf3 <vprintfmt+0x14a>
				err = -err;
  800cf1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf3:	83 fb 64             	cmp    $0x64,%ebx
  800cf6:	7f 0b                	jg     800d03 <vprintfmt+0x15a>
  800cf8:	8b 34 9d 80 2c 80 00 	mov    0x802c80(,%ebx,4),%esi
  800cff:	85 f6                	test   %esi,%esi
  800d01:	75 19                	jne    800d1c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d03:	53                   	push   %ebx
  800d04:	68 25 2e 80 00       	push   $0x802e25
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 70 02 00 00       	call   800f84 <printfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d17:	e9 5b 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1c:	56                   	push   %esi
  800d1d:	68 2e 2e 80 00       	push   $0x802e2e
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	ff 75 08             	pushl  0x8(%ebp)
  800d28:	e8 57 02 00 00       	call   800f84 <printfmt>
  800d2d:	83 c4 10             	add    $0x10,%esp
			break;
  800d30:	e9 42 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d35:	8b 45 14             	mov    0x14(%ebp),%eax
  800d38:	83 c0 04             	add    $0x4,%eax
  800d3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 e8 04             	sub    $0x4,%eax
  800d44:	8b 30                	mov    (%eax),%esi
  800d46:	85 f6                	test   %esi,%esi
  800d48:	75 05                	jne    800d4f <vprintfmt+0x1a6>
				p = "(null)";
  800d4a:	be 31 2e 80 00       	mov    $0x802e31,%esi
			if (width > 0 && padc != '-')
  800d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d53:	7e 6d                	jle    800dc2 <vprintfmt+0x219>
  800d55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d59:	74 67                	je     800dc2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d5e:	83 ec 08             	sub    $0x8,%esp
  800d61:	50                   	push   %eax
  800d62:	56                   	push   %esi
  800d63:	e8 1e 03 00 00       	call   801086 <strnlen>
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d6e:	eb 16                	jmp    800d86 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d83:	ff 4d e4             	decl   -0x1c(%ebp)
  800d86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8a:	7f e4                	jg     800d70 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8c:	eb 34                	jmp    800dc2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d92:	74 1c                	je     800db0 <vprintfmt+0x207>
  800d94:	83 fb 1f             	cmp    $0x1f,%ebx
  800d97:	7e 05                	jle    800d9e <vprintfmt+0x1f5>
  800d99:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9c:	7e 12                	jle    800db0 <vprintfmt+0x207>
					putch('?', putdat);
  800d9e:	83 ec 08             	sub    $0x8,%esp
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	6a 3f                	push   $0x3f
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	ff d0                	call   *%eax
  800dab:	83 c4 10             	add    $0x10,%esp
  800dae:	eb 0f                	jmp    800dbf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	53                   	push   %ebx
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	ff d0                	call   *%eax
  800dbc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc2:	89 f0                	mov    %esi,%eax
  800dc4:	8d 70 01             	lea    0x1(%eax),%esi
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f be d8             	movsbl %al,%ebx
  800dcc:	85 db                	test   %ebx,%ebx
  800dce:	74 24                	je     800df4 <vprintfmt+0x24b>
  800dd0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd4:	78 b8                	js     800d8e <vprintfmt+0x1e5>
  800dd6:	ff 4d e0             	decl   -0x20(%ebp)
  800dd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddd:	79 af                	jns    800d8e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ddf:	eb 13                	jmp    800df4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	6a 20                	push   $0x20
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	ff d0                	call   *%eax
  800dee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df1:	ff 4d e4             	decl   -0x1c(%ebp)
  800df4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df8:	7f e7                	jg     800de1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfa:	e9 78 01 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 e8             	pushl  -0x18(%ebp)
  800e05:	8d 45 14             	lea    0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 3c fd ff ff       	call   800b4a <getint>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1d:	85 d2                	test   %edx,%edx
  800e1f:	79 23                	jns    800e44 <vprintfmt+0x29b>
				putch('-', putdat);
  800e21:	83 ec 08             	sub    $0x8,%esp
  800e24:	ff 75 0c             	pushl  0xc(%ebp)
  800e27:	6a 2d                	push   $0x2d
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	ff d0                	call   *%eax
  800e2e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e37:	f7 d8                	neg    %eax
  800e39:	83 d2 00             	adc    $0x0,%edx
  800e3c:	f7 da                	neg    %edx
  800e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4b:	e9 bc 00 00 00       	jmp    800f0c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 e8             	pushl  -0x18(%ebp)
  800e56:	8d 45 14             	lea    0x14(%ebp),%eax
  800e59:	50                   	push   %eax
  800e5a:	e8 84 fc ff ff       	call   800ae3 <getuint>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e6f:	e9 98 00 00 00       	jmp    800f0c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	6a 58                	push   $0x58
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	ff d0                	call   *%eax
  800e81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	6a 58                	push   $0x58
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	ff d0                	call   *%eax
  800e91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	6a 58                	push   $0x58
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	ff d0                	call   *%eax
  800ea1:	83 c4 10             	add    $0x10,%esp
			break;
  800ea4:	e9 ce 00 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 30                	push   $0x30
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	6a 78                	push   $0x78
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	ff d0                	call   *%eax
  800ec6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecc:	83 c0 04             	add    $0x4,%eax
  800ecf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 e8 04             	sub    $0x4,%eax
  800ed8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eeb:	eb 1f                	jmp    800f0c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef6:	50                   	push   %eax
  800ef7:	e8 e7 fb ff ff       	call   800ae3 <getuint>
  800efc:	83 c4 10             	add    $0x10,%esp
  800eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	52                   	push   %edx
  800f17:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1a:	50                   	push   %eax
  800f1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1e:	ff 75 f0             	pushl  -0x10(%ebp)
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	ff 75 08             	pushl  0x8(%ebp)
  800f27:	e8 00 fb ff ff       	call   800a2c <printnum>
  800f2c:	83 c4 20             	add    $0x20,%esp
			break;
  800f2f:	eb 46                	jmp    800f77 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f31:	83 ec 08             	sub    $0x8,%esp
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	53                   	push   %ebx
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			break;
  800f40:	eb 35                	jmp    800f77 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f42:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800f49:	eb 2c                	jmp    800f77 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f4b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800f52:	eb 23                	jmp    800f77 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 0c             	pushl  0xc(%ebp)
  800f5a:	6a 25                	push   $0x25
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f64:	ff 4d 10             	decl   0x10(%ebp)
  800f67:	eb 03                	jmp    800f6c <vprintfmt+0x3c3>
  800f69:	ff 4d 10             	decl   0x10(%ebp)
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	48                   	dec    %eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 25                	cmp    $0x25,%al
  800f74:	75 f3                	jne    800f69 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f76:	90                   	nop
		}
	}
  800f77:	e9 35 fc ff ff       	jmp    800bb1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f7c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800f8d:	83 c0 04             	add    $0x4,%eax
  800f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	ff 75 f4             	pushl  -0xc(%ebp)
  800f99:	50                   	push   %eax
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	ff 75 08             	pushl  0x8(%ebp)
  800fa0:	e8 04 fc ff ff       	call   800ba9 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa8:	90                   	nop
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 40 08             	mov    0x8(%eax),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 10                	mov    (%eax),%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8b 40 04             	mov    0x4(%eax),%eax
  800fc8:	39 c2                	cmp    %eax,%edx
  800fca:	73 12                	jae    800fde <sprintputch+0x33>
		*b->buf++ = ch;
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	8b 00                	mov    (%eax),%eax
  800fd1:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd7:	89 0a                	mov    %ecx,(%edx)
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	88 10                	mov    %dl,(%eax)
}
  800fde:	90                   	nop
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801006:	74 06                	je     80100e <vsnprintf+0x2d>
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	7f 07                	jg     801015 <vsnprintf+0x34>
		return -E_INVAL;
  80100e:	b8 03 00 00 00       	mov    $0x3,%eax
  801013:	eb 20                	jmp    801035 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801015:	ff 75 14             	pushl  0x14(%ebp)
  801018:	ff 75 10             	pushl  0x10(%ebp)
  80101b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	68 ab 0f 80 00       	push   $0x800fab
  801024:	e8 80 fb ff ff       	call   800ba9 <vprintfmt>
  801029:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80102c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80102f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801032:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80103d:	8d 45 10             	lea    0x10(%ebp),%eax
  801040:	83 c0 04             	add    $0x4,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	ff 75 f4             	pushl  -0xc(%ebp)
  80104c:	50                   	push   %eax
  80104d:	ff 75 0c             	pushl  0xc(%ebp)
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	e8 89 ff ff ff       	call   800fe1 <vsnprintf>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80105e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801070:	eb 06                	jmp    801078 <strlen+0x15>
		n++;
  801072:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	84 c0                	test   %al,%al
  80107f:	75 f1                	jne    801072 <strlen+0xf>
		n++;
	return n;
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801093:	eb 09                	jmp    80109e <strnlen+0x18>
		n++;
  801095:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	ff 4d 0c             	decl   0xc(%ebp)
  80109e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a2:	74 09                	je     8010ad <strnlen+0x27>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 e8                	jne    801095 <strnlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010be:	90                   	nop
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d1:	8a 12                	mov    (%edx),%dl
  8010d3:	88 10                	mov    %dl,(%eax)
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 e4                	jne    8010bf <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f3:	eb 1f                	jmp    801114 <strncpy+0x34>
		*dst++ = *src;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8d 50 01             	lea    0x1(%eax),%edx
  8010fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8010fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801101:	8a 12                	mov    (%edx),%dl
  801103:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	84 c0                	test   %al,%al
  80110c:	74 03                	je     801111 <strncpy+0x31>
			src++;
  80110e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801111:	ff 45 fc             	incl   -0x4(%ebp)
  801114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801117:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111a:	72 d9                	jb     8010f5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801131:	74 30                	je     801163 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801133:	eb 16                	jmp    80114b <strlcpy+0x2a>
			*dst++ = *src++;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801141:	8d 4a 01             	lea    0x1(%edx),%ecx
  801144:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801147:	8a 12                	mov    (%edx),%dl
  801149:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80114b:	ff 4d 10             	decl   0x10(%ebp)
  80114e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801152:	74 09                	je     80115d <strlcpy+0x3c>
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	84 c0                	test   %al,%al
  80115b:	75 d8                	jne    801135 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801169:	29 c2                	sub    %eax,%edx
  80116b:	89 d0                	mov    %edx,%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801172:	eb 06                	jmp    80117a <strcmp+0xb>
		p++, q++;
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	84 c0                	test   %al,%al
  801181:	74 0e                	je     801191 <strcmp+0x22>
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 10                	mov    (%eax),%dl
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	38 c2                	cmp    %al,%dl
  80118f:	74 e3                	je     801174 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	0f b6 d0             	movzbl %al,%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	29 c2                	sub    %eax,%edx
  8011a3:	89 d0                	mov    %edx,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011aa:	eb 09                	jmp    8011b5 <strncmp+0xe>
		n--, p++, q++;
  8011ac:	ff 4d 10             	decl   0x10(%ebp)
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	74 17                	je     8011d2 <strncmp+0x2b>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	74 0e                	je     8011d2 <strncmp+0x2b>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 10                	mov    (%eax),%dl
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	38 c2                	cmp    %al,%dl
  8011d0:	74 da                	je     8011ac <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d6:	75 07                	jne    8011df <strncmp+0x38>
		return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dd:	eb 14                	jmp    8011f3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 d0             	movzbl %al,%edx
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f b6 c0             	movzbl %al,%eax
  8011ef:	29 c2                	sub    %eax,%edx
  8011f1:	89 d0                	mov    %edx,%eax
}
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801201:	eb 12                	jmp    801215 <strchr+0x20>
		if (*s == c)
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80120b:	75 05                	jne    801212 <strchr+0x1d>
			return (char *) s;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	eb 11                	jmp    801223 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	84 c0                	test   %al,%al
  80121c:	75 e5                	jne    801203 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801231:	eb 0d                	jmp    801240 <strfind+0x1b>
		if (*s == c)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80123b:	74 0e                	je     80124b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80123d:	ff 45 08             	incl   0x8(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	84 c0                	test   %al,%al
  801247:	75 ea                	jne    801233 <strfind+0xe>
  801249:	eb 01                	jmp    80124c <strfind+0x27>
		if (*s == c)
			break;
  80124b:	90                   	nop
	return (char *) s;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80125d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801261:	76 63                	jbe    8012c6 <memset+0x75>
		uint64 data_block = c;
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	99                   	cltd   
  801267:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801273:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801277:	c1 e0 08             	shl    $0x8,%eax
  80127a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80127d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80128a:	c1 e0 10             	shl    $0x10,%eax
  80128d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801290:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801299:	89 c2                	mov    %eax,%edx
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012a3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012a6:	eb 18                	jmp    8012c0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ab:	8d 41 08             	lea    0x8(%ecx),%eax
  8012ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	89 01                	mov    %eax,(%ecx)
  8012b9:	89 51 04             	mov    %edx,0x4(%ecx)
  8012bc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012c0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012c4:	77 e2                	ja     8012a8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ca:	74 23                	je     8012ef <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d2:	eb 0e                	jmp    8012e2 <memset+0x91>
			*p8++ = (uint8)c;
  8012d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	75 e5                	jne    8012d4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801306:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80130a:	76 24                	jbe    801330 <memcpy+0x3c>
		while(n >= 8){
  80130c:	eb 1c                	jmp    80132a <memcpy+0x36>
			*d64 = *s64;
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801311:	8b 50 04             	mov    0x4(%eax),%edx
  801314:	8b 00                	mov    (%eax),%eax
  801316:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801319:	89 01                	mov    %eax,(%ecx)
  80131b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80131e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801322:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801326:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80132a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80132e:	77 de                	ja     80130e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801334:	74 31                	je     801367 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801336:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80133c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801342:	eb 16                	jmp    80135a <memcpy+0x66>
			*d8++ = *s8++;
  801344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80134d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801350:	8d 4a 01             	lea    0x1(%edx),%ecx
  801353:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801356:	8a 12                	mov    (%edx),%dl
  801358:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801360:	89 55 10             	mov    %edx,0x10(%ebp)
  801363:	85 c0                	test   %eax,%eax
  801365:	75 dd                	jne    801344 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801384:	73 50                	jae    8013d6 <memmove+0x6a>
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801391:	76 43                	jbe    8013d6 <memmove+0x6a>
		s += n;
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
  80139c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80139f:	eb 10                	jmp    8013b1 <memmove+0x45>
			*--d = *--s;
  8013a1:	ff 4d f8             	decl   -0x8(%ebp)
  8013a4:	ff 4d fc             	decl   -0x4(%ebp)
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013aa:	8a 10                	mov    (%eax),%dl
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	75 e3                	jne    8013a1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013be:	eb 23                	jmp    8013e3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013d2:	8a 12                	mov    (%edx),%dl
  8013d4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	75 dd                	jne    8013c0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013fa:	eb 2a                	jmp    801426 <memcmp+0x3e>
		if (*s1 != *s2)
  8013fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ff:	8a 10                	mov    (%eax),%dl
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	38 c2                	cmp    %al,%dl
  801408:	74 16                	je     801420 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f b6 d0             	movzbl %al,%edx
  801412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	29 c2                	sub    %eax,%edx
  80141c:	89 d0                	mov    %edx,%eax
  80141e:	eb 18                	jmp    801438 <memcmp+0x50>
		s1++, s2++;
  801420:	ff 45 fc             	incl   -0x4(%ebp)
  801423:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	8d 50 ff             	lea    -0x1(%eax),%edx
  80142c:	89 55 10             	mov    %edx,0x10(%ebp)
  80142f:	85 c0                	test   %eax,%eax
  801431:	75 c9                	jne    8013fc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801440:	8b 55 08             	mov    0x8(%ebp),%edx
  801443:	8b 45 10             	mov    0x10(%ebp),%eax
  801446:	01 d0                	add    %edx,%eax
  801448:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80144b:	eb 15                	jmp    801462 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	0f b6 c0             	movzbl %al,%eax
  80145b:	39 c2                	cmp    %eax,%edx
  80145d:	74 0d                	je     80146c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80145f:	ff 45 08             	incl   0x8(%ebp)
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801468:	72 e3                	jb     80144d <memfind+0x13>
  80146a:	eb 01                	jmp    80146d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80146c:	90                   	nop
	return (void *) s;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80147f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801486:	eb 03                	jmp    80148b <strtol+0x19>
		s++;
  801488:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 20                	cmp    $0x20,%al
  801492:	74 f4                	je     801488 <strtol+0x16>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3c 09                	cmp    $0x9,%al
  80149b:	74 eb                	je     801488 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 2b                	cmp    $0x2b,%al
  8014a4:	75 05                	jne    8014ab <strtol+0x39>
		s++;
  8014a6:	ff 45 08             	incl   0x8(%ebp)
  8014a9:	eb 13                	jmp    8014be <strtol+0x4c>
	else if (*s == '-')
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 2d                	cmp    $0x2d,%al
  8014b2:	75 0a                	jne    8014be <strtol+0x4c>
		s++, neg = 1;
  8014b4:	ff 45 08             	incl   0x8(%ebp)
  8014b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c2:	74 06                	je     8014ca <strtol+0x58>
  8014c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014c8:	75 20                	jne    8014ea <strtol+0x78>
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	3c 30                	cmp    $0x30,%al
  8014d1:	75 17                	jne    8014ea <strtol+0x78>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	40                   	inc    %eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	3c 78                	cmp    $0x78,%al
  8014db:	75 0d                	jne    8014ea <strtol+0x78>
		s += 2, base = 16;
  8014dd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014e1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014e8:	eb 28                	jmp    801512 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ee:	75 15                	jne    801505 <strtol+0x93>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	3c 30                	cmp    $0x30,%al
  8014f7:	75 0c                	jne    801505 <strtol+0x93>
		s++, base = 8;
  8014f9:	ff 45 08             	incl   0x8(%ebp)
  8014fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801503:	eb 0d                	jmp    801512 <strtol+0xa0>
	else if (base == 0)
  801505:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801509:	75 07                	jne    801512 <strtol+0xa0>
		base = 10;
  80150b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3c 2f                	cmp    $0x2f,%al
  801519:	7e 19                	jle    801534 <strtol+0xc2>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	3c 39                	cmp    $0x39,%al
  801522:	7f 10                	jg     801534 <strtol+0xc2>
			dig = *s - '0';
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	83 e8 30             	sub    $0x30,%eax
  80152f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801532:	eb 42                	jmp    801576 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	3c 60                	cmp    $0x60,%al
  80153b:	7e 19                	jle    801556 <strtol+0xe4>
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	3c 7a                	cmp    $0x7a,%al
  801544:	7f 10                	jg     801556 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	0f be c0             	movsbl %al,%eax
  80154e:	83 e8 57             	sub    $0x57,%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801554:	eb 20                	jmp    801576 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8a 00                	mov    (%eax),%al
  80155b:	3c 40                	cmp    $0x40,%al
  80155d:	7e 39                	jle    801598 <strtol+0x126>
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8a 00                	mov    (%eax),%al
  801564:	3c 5a                	cmp    $0x5a,%al
  801566:	7f 30                	jg     801598 <strtol+0x126>
			dig = *s - 'A' + 10;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	0f be c0             	movsbl %al,%eax
  801570:	83 e8 37             	sub    $0x37,%eax
  801573:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	3b 45 10             	cmp    0x10(%ebp),%eax
  80157c:	7d 19                	jge    801597 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80157e:	ff 45 08             	incl   0x8(%ebp)
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	0f af 45 10          	imul   0x10(%ebp),%eax
  801588:	89 c2                	mov    %eax,%edx
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	01 d0                	add    %edx,%eax
  80158f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801592:	e9 7b ff ff ff       	jmp    801512 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801597:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80159c:	74 08                	je     8015a6 <strtol+0x134>
		*endptr = (char *) s;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015aa:	74 07                	je     8015b3 <strtol+0x141>
  8015ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015af:	f7 d8                	neg    %eax
  8015b1:	eb 03                	jmp    8015b6 <strtol+0x144>
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <ltostr>:

void
ltostr(long value, char *str)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d0:	79 13                	jns    8015e5 <ltostr+0x2d>
	{
		neg = 1;
  8015d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015df:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015e2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ed:	99                   	cltd   
  8015ee:	f7 f9                	idiv   %ecx
  8015f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f6:	8d 50 01             	lea    0x1(%eax),%edx
  8015f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015fc:	89 c2                	mov    %eax,%edx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801606:	83 c2 30             	add    $0x30,%edx
  801609:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80160b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801613:	f7 e9                	imul   %ecx
  801615:	c1 fa 02             	sar    $0x2,%edx
  801618:	89 c8                	mov    %ecx,%eax
  80161a:	c1 f8 1f             	sar    $0x1f,%eax
  80161d:	29 c2                	sub    %eax,%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801624:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801628:	75 bb                	jne    8015e5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801634:	48                   	dec    %eax
  801635:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801638:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163c:	74 3d                	je     80167b <ltostr+0xc3>
		start = 1 ;
  80163e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801645:	eb 34                	jmp    80167b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	01 d0                	add    %edx,%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	01 c2                	add    %eax,%edx
  80165c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	01 c8                	add    %ecx,%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	01 c2                	add    %eax,%edx
  801670:	8a 45 eb             	mov    -0x15(%ebp),%al
  801673:	88 02                	mov    %al,(%edx)
		start++ ;
  801675:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801678:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801681:	7c c4                	jl     801647 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801683:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168e:	90                   	nop
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 c4 f9 ff ff       	call   801063 <strlen>
  80169f:	83 c4 04             	add    $0x4,%esp
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	e8 b6 f9 ff ff       	call   801063 <strlen>
  8016ad:	83 c4 04             	add    $0x4,%esp
  8016b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c1:	eb 17                	jmp    8016da <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	01 c2                	add    %eax,%edx
  8016cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	01 c8                	add    %ecx,%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d7:	ff 45 fc             	incl   -0x4(%ebp)
  8016da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e0:	7c e1                	jl     8016c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016f0:	eb 1f                	jmp    801711 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f5:	8d 50 01             	lea    0x1(%eax),%edx
  8016f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fb:	89 c2                	mov    %eax,%edx
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	01 c2                	add    %eax,%edx
  801702:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	01 c8                	add    %ecx,%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170e:	ff 45 f8             	incl   -0x8(%ebp)
  801711:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801714:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801717:	7c d9                	jl     8016f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	c6 00 00             	movb   $0x0,(%eax)
}
  801724:	90                   	nop
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80172a:	8b 45 14             	mov    0x14(%ebp),%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80174a:	eb 0c                	jmp    801758 <strsplit+0x31>
			*string++ = 0;
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8d 50 01             	lea    0x1(%eax),%edx
  801752:	89 55 08             	mov    %edx,0x8(%ebp)
  801755:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8a 00                	mov    (%eax),%al
  80175d:	84 c0                	test   %al,%al
  80175f:	74 18                	je     801779 <strsplit+0x52>
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	0f be c0             	movsbl %al,%eax
  801769:	50                   	push   %eax
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	e8 83 fa ff ff       	call   8011f5 <strchr>
  801772:	83 c4 08             	add    $0x8,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	75 d3                	jne    80174c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	84 c0                	test   %al,%al
  801780:	74 5a                	je     8017dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801782:	8b 45 14             	mov    0x14(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	83 f8 0f             	cmp    $0xf,%eax
  80178a:	75 07                	jne    801793 <strsplit+0x6c>
		{
			return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 66                	jmp    8017f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	8b 00                	mov    (%eax),%eax
  801798:	8d 48 01             	lea    0x1(%eax),%ecx
  80179b:	8b 55 14             	mov    0x14(%ebp),%edx
  80179e:	89 0a                	mov    %ecx,(%edx)
  8017a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	01 c2                	add    %eax,%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b1:	eb 03                	jmp    8017b6 <strsplit+0x8f>
			string++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 8b                	je     80174a <strsplit+0x23>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	0f be c0             	movsbl %al,%eax
  8017c7:	50                   	push   %eax
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	e8 25 fa ff ff       	call   8011f5 <strchr>
  8017d0:	83 c4 08             	add    $0x8,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 dc                	je     8017b3 <strsplit+0x8c>
			string++;
	}
  8017d7:	e9 6e ff ff ff       	jmp    80174a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ec:	01 d0                	add    %edx,%eax
  8017ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80180e:	eb 4a                	jmp    80185a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801810:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	01 c2                	add    %eax,%edx
  801818:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	01 c8                	add    %ecx,%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801824:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	01 d0                	add    %edx,%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	3c 40                	cmp    $0x40,%al
  801830:	7e 25                	jle    801857 <str2lower+0x5c>
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 0c             	mov    0xc(%ebp),%eax
  801838:	01 d0                	add    %edx,%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 5a                	cmp    $0x5a,%al
  80183e:	7f 17                	jg     801857 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801840:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	01 d0                	add    %edx,%eax
  801848:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80184b:	8b 55 08             	mov    0x8(%ebp),%edx
  80184e:	01 ca                	add    %ecx,%edx
  801850:	8a 12                	mov    (%edx),%dl
  801852:	83 c2 20             	add    $0x20,%edx
  801855:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801857:	ff 45 fc             	incl   -0x4(%ebp)
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	e8 01 f8 ff ff       	call   801063 <strlen>
  801862:	83 c4 04             	add    $0x4,%esp
  801865:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801868:	7f a6                	jg     801810 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801875:	a1 08 40 80 00       	mov    0x804008,%eax
  80187a:	85 c0                	test   %eax,%eax
  80187c:	74 42                	je     8018c0 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	68 00 00 00 82       	push   $0x82000000
  801886:	68 00 00 00 80       	push   $0x80000000
  80188b:	e8 8c 07 00 00       	call   80201c <initialize_dynamic_allocator>
  801890:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801893:	e8 e7 05 00 00       	call   801e7f <sys_get_uheap_strategy>
  801898:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80189d:	a1 40 40 80 00       	mov    0x804040,%eax
  8018a2:	05 00 10 00 00       	add    $0x1000,%eax
  8018a7:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8018ac:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8018b1:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8018b6:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8018bd:	00 00 00 
	}
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	68 06 04 00 00       	push   $0x406
  8018df:	50                   	push   %eax
  8018e0:	e8 e4 01 00 00       	call   801ac9 <__sys_allocate_page>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018ef:	79 14                	jns    801905 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 a8 2f 80 00       	push   $0x802fa8
  8018f9:	6a 1f                	push   $0x1f
  8018fb:	68 e4 2f 80 00       	push   $0x802fe4
  801900:	e8 b7 ed ff ff       	call   8006bc <_panic>
	return 0;
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801920:	83 ec 0c             	sub    $0xc,%esp
  801923:	50                   	push   %eax
  801924:	e8 e7 01 00 00       	call   801b10 <__sys_unmap_frame>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80192f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801933:	79 14                	jns    801949 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 f0 2f 80 00       	push   $0x802ff0
  80193d:	6a 2a                	push   $0x2a
  80193f:	68 e4 2f 80 00       	push   $0x802fe4
  801944:	e8 73 ed ff ff       	call   8006bc <_panic>
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801952:	e8 18 ff ff ff       	call   80186f <uheap_init>
	if (size == 0) return NULL ;
  801957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80195b:	75 07                	jne    801964 <malloc+0x18>
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	eb 14                	jmp    801978 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	68 30 30 80 00       	push   $0x803030
  80196c:	6a 3e                	push   $0x3e
  80196e:	68 e4 2f 80 00       	push   $0x802fe4
  801973:	e8 44 ed ff ff       	call   8006bc <_panic>
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	68 58 30 80 00       	push   $0x803058
  801988:	6a 49                	push   $0x49
  80198a:	68 e4 2f 80 00       	push   $0x802fe4
  80198f:	e8 28 ed ff ff       	call   8006bc <_panic>

00801994 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 18             	sub    $0x18,%esp
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8019a0:	e8 ca fe ff ff       	call   80186f <uheap_init>
	if (size == 0) return NULL ;
  8019a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019a9:	75 07                	jne    8019b2 <smalloc+0x1e>
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	eb 14                	jmp    8019c6 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	68 7c 30 80 00       	push   $0x80307c
  8019ba:	6a 5a                	push   $0x5a
  8019bc:	68 e4 2f 80 00       	push   $0x802fe4
  8019c1:	e8 f6 ec ff ff       	call   8006bc <_panic>
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8019ce:	e8 9c fe ff ff       	call   80186f <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 a4 30 80 00       	push   $0x8030a4
  8019db:	6a 6a                	push   $0x6a
  8019dd:	68 e4 2f 80 00       	push   $0x802fe4
  8019e2:	e8 d5 ec ff ff       	call   8006bc <_panic>

008019e7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8019ed:	e8 7d fe ff ff       	call   80186f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 c8 30 80 00       	push   $0x8030c8
  8019fa:	68 88 00 00 00       	push   $0x88
  8019ff:	68 e4 2f 80 00       	push   $0x802fe4
  801a04:	e8 b3 ec ff ff       	call   8006bc <_panic>

00801a09 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 f0 30 80 00       	push   $0x8030f0
  801a17:	68 9b 00 00 00       	push   $0x9b
  801a1c:	68 e4 2f 80 00       	push   $0x802fe4
  801a21:	e8 96 ec ff ff       	call   8006bc <_panic>

00801a26 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	57                   	push   %edi
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a3e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a41:	cd 30                	int    $0x30
  801a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801a5d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	51                   	push   %ecx
  801a6a:	52                   	push   %edx
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	6a 00                	push   $0x0
  801a71:	e8 b0 ff ff ff       	call   801a26 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 02                	push   $0x2
  801a8b:	e8 96 ff ff ff       	call   801a26 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 03                	push   $0x3
  801aa4:	e8 7d ff ff ff       	call   801a26 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 04                	push   $0x4
  801abe:	e8 63 ff ff ff       	call   801a26 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 08                	push   $0x8
  801adc:	e8 45 ff ff ff       	call   801a26 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aeb:	8b 75 18             	mov    0x18(%ebp),%esi
  801aee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	51                   	push   %ecx
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 09                	push   $0x9
  801b01:	e8 20 ff ff ff       	call   801a26 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	6a 0a                	push   $0xa
  801b20:	e8 01 ff ff ff       	call   801a26 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 0b                	push   $0xb
  801b3b:	e8 e6 fe ff ff       	call   801a26 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 0c                	push   $0xc
  801b54:	e8 cd fe ff ff       	call   801a26 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 0d                	push   $0xd
  801b6d:	e8 b4 fe ff ff       	call   801a26 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 0e                	push   $0xe
  801b86:	e8 9b fe ff ff       	call   801a26 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 0f                	push   $0xf
  801b9f:	e8 82 fe ff ff       	call   801a26 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 10                	push   $0x10
  801bb9:	e8 68 fe ff ff       	call   801a26 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 11                	push   $0x11
  801bd2:	e8 4f fe ff ff       	call   801a26 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	90                   	nop
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_cputc>:

void
sys_cputc(const char c)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801be9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	50                   	push   %eax
  801bf6:	6a 01                	push   $0x1
  801bf8:	e8 29 fe ff ff       	call   801a26 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	90                   	nop
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 14                	push   $0x14
  801c12:	e8 0f fe ff ff       	call   801a26 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	8b 45 10             	mov    0x10(%ebp),%eax
  801c26:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c29:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c2c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	51                   	push   %ecx
  801c36:	52                   	push   %edx
  801c37:	ff 75 0c             	pushl  0xc(%ebp)
  801c3a:	50                   	push   %eax
  801c3b:	6a 15                	push   $0x15
  801c3d:	e8 e4 fd ff ff       	call   801a26 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 16                	push   $0x16
  801c5a:	e8 c7 fd ff ff       	call   801a26 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	51                   	push   %ecx
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	6a 17                	push   $0x17
  801c79:	e8 a8 fd ff ff       	call   801a26 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 18                	push   $0x18
  801c96:	e8 8b fd ff ff       	call   801a26 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	6a 00                	push   $0x0
  801ca8:	ff 75 14             	pushl  0x14(%ebp)
  801cab:	ff 75 10             	pushl  0x10(%ebp)
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	50                   	push   %eax
  801cb2:	6a 19                	push   $0x19
  801cb4:	e8 6d fd ff ff       	call   801a26 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	50                   	push   %eax
  801ccd:	6a 1a                	push   $0x1a
  801ccf:	e8 52 fd ff ff       	call   801a26 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	50                   	push   %eax
  801ce9:	6a 1b                	push   $0x1b
  801ceb:	e8 36 fd ff ff       	call   801a26 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 05                	push   $0x5
  801d04:	e8 1d fd ff ff       	call   801a26 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 06                	push   $0x6
  801d1d:	e8 04 fd ff ff       	call   801a26 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 07                	push   $0x7
  801d36:	e8 eb fc ff ff       	call   801a26 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_exit_env>:


void sys_exit_env(void)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 1c                	push   $0x1c
  801d4f:	e8 d2 fc ff ff       	call   801a26 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	90                   	nop
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d63:	8d 50 04             	lea    0x4(%eax),%edx
  801d66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	52                   	push   %edx
  801d70:	50                   	push   %eax
  801d71:	6a 1d                	push   $0x1d
  801d73:	e8 ae fc ff ff       	call   801a26 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return result;
  801d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d84:	89 01                	mov    %eax,(%ecx)
  801d86:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	c9                   	leave  
  801d8d:	c2 04 00             	ret    $0x4

00801d90 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 10             	pushl  0x10(%ebp)
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	ff 75 08             	pushl  0x8(%ebp)
  801da0:	6a 13                	push   $0x13
  801da2:	e8 7f fc ff ff       	call   801a26 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
	return ;
  801daa:	90                   	nop
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_rcr2>:
uint32 sys_rcr2()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 1e                	push   $0x1e
  801dbc:	e8 65 fc ff ff       	call   801a26 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	50                   	push   %eax
  801ddf:	6a 1f                	push   $0x1f
  801de1:	e8 40 fc ff ff       	call   801a26 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
	return ;
  801de9:	90                   	nop
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <rsttst>:
void rsttst()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 21                	push   $0x21
  801dfb:	e8 26 fc ff ff       	call   801a26 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
	return ;
  801e03:	90                   	nop
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e12:	8b 55 18             	mov    0x18(%ebp),%edx
  801e15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e19:	52                   	push   %edx
  801e1a:	50                   	push   %eax
  801e1b:	ff 75 10             	pushl  0x10(%ebp)
  801e1e:	ff 75 0c             	pushl  0xc(%ebp)
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	6a 20                	push   $0x20
  801e26:	e8 fb fb ff ff       	call   801a26 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2e:	90                   	nop
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <chktst>:
void chktst(uint32 n)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	6a 22                	push   $0x22
  801e41:	e8 e0 fb ff ff       	call   801a26 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
	return ;
  801e49:	90                   	nop
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <inctst>:

void inctst()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 23                	push   $0x23
  801e5b:	e8 c6 fb ff ff       	call   801a26 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return ;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <gettst>:
uint32 gettst()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 24                	push   $0x24
  801e75:	e8 ac fb ff ff       	call   801a26 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 25                	push   $0x25
  801e8e:	e8 93 fb ff ff       	call   801a26 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
  801e96:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801e9b:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	6a 26                	push   $0x26
  801eba:	e8 67 fb ff ff       	call   801a26 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ecc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	53                   	push   %ebx
  801ed8:	51                   	push   %ecx
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	6a 27                	push   $0x27
  801edd:	e8 44 fb ff ff       	call   801a26 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	52                   	push   %edx
  801efa:	50                   	push   %eax
  801efb:	6a 28                	push   $0x28
  801efd:	e8 24 fb ff ff       	call   801a26 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	51                   	push   %ecx
  801f16:	ff 75 10             	pushl  0x10(%ebp)
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 29                	push   $0x29
  801f1d:	e8 04 fb ff ff       	call   801a26 <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	6a 12                	push   $0x12
  801f39:	e8 e8 fa ff ff       	call   801a26 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 2a                	push   $0x2a
  801f57:	e8 ca fa ff ff       	call   801a26 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 2b                	push   $0x2b
  801f71:	e8 b0 fa ff ff       	call   801a26 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	6a 2d                	push   $0x2d
  801f8c:	e8 95 fa ff ff       	call   801a26 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
	return;
  801f94:	90                   	nop
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	ff 75 08             	pushl  0x8(%ebp)
  801fa6:	6a 2c                	push   $0x2c
  801fa8:	e8 79 fa ff ff       	call   801a26 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb0:	90                   	nop
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 14 31 80 00       	push   $0x803114
  801fc1:	68 25 01 00 00       	push   $0x125
  801fc6:	68 47 31 80 00       	push   $0x803147
  801fcb:	e8 ec e6 ff ff       	call   8006bc <_panic>

00801fd0 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	ba 60 40 80 00       	mov    $0x804060,%edx
  801fde:	29 d0                	sub    %edx,%eax
  801fe0:	c1 f8 02             	sar    $0x2,%eax
  801fe3:	89 c2                	mov    %eax,%edx
  801fe5:	89 d0                	mov    %edx,%eax
  801fe7:	c1 e0 02             	shl    $0x2,%eax
  801fea:	01 d0                	add    %edx,%eax
  801fec:	c1 e0 02             	shl    $0x2,%eax
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	c1 e0 02             	shl    $0x2,%eax
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	89 c1                	mov    %eax,%ecx
  801ff8:	c1 e1 08             	shl    $0x8,%ecx
  801ffb:	01 c8                	add    %ecx,%eax
  801ffd:	89 c1                	mov    %eax,%ecx
  801fff:	c1 e1 10             	shl    $0x10,%ecx
  802002:	01 c8                	add    %ecx,%eax
  802004:	01 c0                	add    %eax,%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80200b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200e:	c1 e0 0c             	shl    $0xc,%eax
  802011:	89 c2                	mov    %eax,%edx
  802013:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802018:	01 d0                	add    %edx,%eax
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	05 00 00 00 02       	add    $0x2000000,%eax
  80202a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80202d:	73 16                	jae    802045 <initialize_dynamic_allocator+0x29>
  80202f:	68 58 31 80 00       	push   $0x803158
  802034:	68 7e 31 80 00       	push   $0x80317e
  802039:	6a 26                	push   $0x26
  80203b:	68 93 31 80 00       	push   $0x803193
  802040:	e8 77 e6 ff ff       	call   8006bc <_panic>
		is_initialized = 1;
  802045:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  80204c:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 ac 31 80 00       	push   $0x8031ac
  802057:	6a 2e                	push   $0x2e
  802059:	68 93 31 80 00       	push   $0x803193
  80205e:	e8 59 e6 ff ff       	call   8006bc <_panic>

00802063 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	68 e0 31 80 00       	push   $0x8031e0
  802071:	6a 3a                	push   $0x3a
  802073:	68 93 31 80 00       	push   $0x803193
  802078:	e8 3f e6 ff ff       	call   8006bc <_panic>

0080207d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802083:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80208a:	76 16                	jbe    8020a2 <alloc_block+0x25>
  80208c:	68 08 32 80 00       	push   $0x803208
  802091:	68 7e 31 80 00       	push   $0x80317e
  802096:	6a 46                	push   $0x46
  802098:	68 93 31 80 00       	push   $0x803193
  80209d:	e8 1a e6 ff ff       	call   8006bc <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	68 2c 32 80 00       	push   $0x80322c
  8020aa:	6a 4d                	push   $0x4d
  8020ac:	68 93 31 80 00       	push   $0x803193
  8020b1:	e8 06 e6 ff ff       	call   8006bc <_panic>

008020b6 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8020bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bf:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8020c4:	39 c2                	cmp    %eax,%edx
  8020c6:	72 0c                	jb     8020d4 <free_block+0x1e>
  8020c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d0:	39 c2                	cmp    %eax,%edx
  8020d2:	72 16                	jb     8020ea <free_block+0x34>
  8020d4:	68 50 32 80 00       	push   $0x803250
  8020d9:	68 7e 31 80 00       	push   $0x80317e
  8020de:	6a 5b                	push   $0x5b
  8020e0:	68 93 31 80 00       	push   $0x803193
  8020e5:	e8 d2 e5 ff ff       	call   8006bc <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	68 88 32 80 00       	push   $0x803288
  8020f2:	6a 63                	push   $0x63
  8020f4:	68 93 31 80 00       	push   $0x803193
  8020f9:	e8 be e5 ff ff       	call   8006bc <_panic>

008020fe <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	68 ac 32 80 00       	push   $0x8032ac
  80210c:	6a 72                	push   $0x72
  80210e:	68 93 31 80 00       	push   $0x803193
  802113:	e8 a4 e5 ff ff       	call   8006bc <_panic>

00802118 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80211e:	8b 55 08             	mov    0x8(%ebp),%edx
  802121:	89 d0                	mov    %edx,%eax
  802123:	c1 e0 02             	shl    $0x2,%eax
  802126:	01 d0                	add    %edx,%eax
  802128:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80212f:	01 d0                	add    %edx,%eax
  802131:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802138:	01 d0                	add    %edx,%eax
  80213a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802141:	01 d0                	add    %edx,%eax
  802143:	c1 e0 04             	shl    $0x4,%eax
  802146:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802150:	0f 31                	rdtsc  
  802152:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802155:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802161:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802164:	eb 46                	jmp    8021ac <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802166:	0f 31                	rdtsc  
  802168:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80216b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80216e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802171:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802174:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802177:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80217a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	29 c2                	sub    %eax,%edx
  802182:	89 d0                	mov    %edx,%eax
  802184:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802187:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	89 d1                	mov    %edx,%ecx
  80218f:	29 c1                	sub    %eax,%ecx
  802191:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802197:	39 c2                	cmp    %eax,%edx
  802199:	0f 97 c0             	seta   %al
  80219c:	0f b6 c0             	movzbl %al,%eax
  80219f:	29 c1                	sub    %eax,%ecx
  8021a1:	89 c8                	mov    %ecx,%eax
  8021a3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8021a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8021ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021b2:	72 b2                	jb     802166 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8021bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8021c4:	eb 03                	jmp    8021c9 <busy_wait+0x12>
  8021c6:	ff 45 fc             	incl   -0x4(%ebp)
  8021c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021cf:	72 f5                	jb     8021c6 <busy_wait+0xf>
	return i;
  8021d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    
  8021d6:	66 90                	xchg   %ax,%ax

008021d8 <__udivdi3>:
  8021d8:	55                   	push   %ebp
  8021d9:	57                   	push   %edi
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	83 ec 1c             	sub    $0x1c,%esp
  8021df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ef:	89 ca                	mov    %ecx,%edx
  8021f1:	89 f8                	mov    %edi,%eax
  8021f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021f7:	85 f6                	test   %esi,%esi
  8021f9:	75 2d                	jne    802228 <__udivdi3+0x50>
  8021fb:	39 cf                	cmp    %ecx,%edi
  8021fd:	77 65                	ja     802264 <__udivdi3+0x8c>
  8021ff:	89 fd                	mov    %edi,%ebp
  802201:	85 ff                	test   %edi,%edi
  802203:	75 0b                	jne    802210 <__udivdi3+0x38>
  802205:	b8 01 00 00 00       	mov    $0x1,%eax
  80220a:	31 d2                	xor    %edx,%edx
  80220c:	f7 f7                	div    %edi
  80220e:	89 c5                	mov    %eax,%ebp
  802210:	31 d2                	xor    %edx,%edx
  802212:	89 c8                	mov    %ecx,%eax
  802214:	f7 f5                	div    %ebp
  802216:	89 c1                	mov    %eax,%ecx
  802218:	89 d8                	mov    %ebx,%eax
  80221a:	f7 f5                	div    %ebp
  80221c:	89 cf                	mov    %ecx,%edi
  80221e:	89 fa                	mov    %edi,%edx
  802220:	83 c4 1c             	add    $0x1c,%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5f                   	pop    %edi
  802226:	5d                   	pop    %ebp
  802227:	c3                   	ret    
  802228:	39 ce                	cmp    %ecx,%esi
  80222a:	77 28                	ja     802254 <__udivdi3+0x7c>
  80222c:	0f bd fe             	bsr    %esi,%edi
  80222f:	83 f7 1f             	xor    $0x1f,%edi
  802232:	75 40                	jne    802274 <__udivdi3+0x9c>
  802234:	39 ce                	cmp    %ecx,%esi
  802236:	72 0a                	jb     802242 <__udivdi3+0x6a>
  802238:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80223c:	0f 87 9e 00 00 00    	ja     8022e0 <__udivdi3+0x108>
  802242:	b8 01 00 00 00       	mov    $0x1,%eax
  802247:	89 fa                	mov    %edi,%edx
  802249:	83 c4 1c             	add    $0x1c,%esp
  80224c:	5b                   	pop    %ebx
  80224d:	5e                   	pop    %esi
  80224e:	5f                   	pop    %edi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    
  802251:	8d 76 00             	lea    0x0(%esi),%esi
  802254:	31 ff                	xor    %edi,%edi
  802256:	31 c0                	xor    %eax,%eax
  802258:	89 fa                	mov    %edi,%edx
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	66 90                	xchg   %ax,%ax
  802264:	89 d8                	mov    %ebx,%eax
  802266:	f7 f7                	div    %edi
  802268:	31 ff                	xor    %edi,%edi
  80226a:	89 fa                	mov    %edi,%edx
  80226c:	83 c4 1c             	add    $0x1c,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    
  802274:	bd 20 00 00 00       	mov    $0x20,%ebp
  802279:	89 eb                	mov    %ebp,%ebx
  80227b:	29 fb                	sub    %edi,%ebx
  80227d:	89 f9                	mov    %edi,%ecx
  80227f:	d3 e6                	shl    %cl,%esi
  802281:	89 c5                	mov    %eax,%ebp
  802283:	88 d9                	mov    %bl,%cl
  802285:	d3 ed                	shr    %cl,%ebp
  802287:	89 e9                	mov    %ebp,%ecx
  802289:	09 f1                	or     %esi,%ecx
  80228b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80228f:	89 f9                	mov    %edi,%ecx
  802291:	d3 e0                	shl    %cl,%eax
  802293:	89 c5                	mov    %eax,%ebp
  802295:	89 d6                	mov    %edx,%esi
  802297:	88 d9                	mov    %bl,%cl
  802299:	d3 ee                	shr    %cl,%esi
  80229b:	89 f9                	mov    %edi,%ecx
  80229d:	d3 e2                	shl    %cl,%edx
  80229f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022a3:	88 d9                	mov    %bl,%cl
  8022a5:	d3 e8                	shr    %cl,%eax
  8022a7:	09 c2                	or     %eax,%edx
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	89 f2                	mov    %esi,%edx
  8022ad:	f7 74 24 0c          	divl   0xc(%esp)
  8022b1:	89 d6                	mov    %edx,%esi
  8022b3:	89 c3                	mov    %eax,%ebx
  8022b5:	f7 e5                	mul    %ebp
  8022b7:	39 d6                	cmp    %edx,%esi
  8022b9:	72 19                	jb     8022d4 <__udivdi3+0xfc>
  8022bb:	74 0b                	je     8022c8 <__udivdi3+0xf0>
  8022bd:	89 d8                	mov    %ebx,%eax
  8022bf:	31 ff                	xor    %edi,%edi
  8022c1:	e9 58 ff ff ff       	jmp    80221e <__udivdi3+0x46>
  8022c6:	66 90                	xchg   %ax,%ax
  8022c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022cc:	89 f9                	mov    %edi,%ecx
  8022ce:	d3 e2                	shl    %cl,%edx
  8022d0:	39 c2                	cmp    %eax,%edx
  8022d2:	73 e9                	jae    8022bd <__udivdi3+0xe5>
  8022d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022d7:	31 ff                	xor    %edi,%edi
  8022d9:	e9 40 ff ff ff       	jmp    80221e <__udivdi3+0x46>
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	31 c0                	xor    %eax,%eax
  8022e2:	e9 37 ff ff ff       	jmp    80221e <__udivdi3+0x46>
  8022e7:	90                   	nop

008022e8 <__umoddi3>:
  8022e8:	55                   	push   %ebp
  8022e9:	57                   	push   %edi
  8022ea:	56                   	push   %esi
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 1c             	sub    $0x1c,%esp
  8022ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802307:	89 f3                	mov    %esi,%ebx
  802309:	89 fa                	mov    %edi,%edx
  80230b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230f:	89 34 24             	mov    %esi,(%esp)
  802312:	85 c0                	test   %eax,%eax
  802314:	75 1a                	jne    802330 <__umoddi3+0x48>
  802316:	39 f7                	cmp    %esi,%edi
  802318:	0f 86 a2 00 00 00    	jbe    8023c0 <__umoddi3+0xd8>
  80231e:	89 c8                	mov    %ecx,%eax
  802320:	89 f2                	mov    %esi,%edx
  802322:	f7 f7                	div    %edi
  802324:	89 d0                	mov    %edx,%eax
  802326:	31 d2                	xor    %edx,%edx
  802328:	83 c4 1c             	add    $0x1c,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5f                   	pop    %edi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
  802330:	39 f0                	cmp    %esi,%eax
  802332:	0f 87 ac 00 00 00    	ja     8023e4 <__umoddi3+0xfc>
  802338:	0f bd e8             	bsr    %eax,%ebp
  80233b:	83 f5 1f             	xor    $0x1f,%ebp
  80233e:	0f 84 ac 00 00 00    	je     8023f0 <__umoddi3+0x108>
  802344:	bf 20 00 00 00       	mov    $0x20,%edi
  802349:	29 ef                	sub    %ebp,%edi
  80234b:	89 fe                	mov    %edi,%esi
  80234d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802351:	89 e9                	mov    %ebp,%ecx
  802353:	d3 e0                	shl    %cl,%eax
  802355:	89 d7                	mov    %edx,%edi
  802357:	89 f1                	mov    %esi,%ecx
  802359:	d3 ef                	shr    %cl,%edi
  80235b:	09 c7                	or     %eax,%edi
  80235d:	89 e9                	mov    %ebp,%ecx
  80235f:	d3 e2                	shl    %cl,%edx
  802361:	89 14 24             	mov    %edx,(%esp)
  802364:	89 d8                	mov    %ebx,%eax
  802366:	d3 e0                	shl    %cl,%eax
  802368:	89 c2                	mov    %eax,%edx
  80236a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80236e:	d3 e0                	shl    %cl,%eax
  802370:	89 44 24 04          	mov    %eax,0x4(%esp)
  802374:	8b 44 24 08          	mov    0x8(%esp),%eax
  802378:	89 f1                	mov    %esi,%ecx
  80237a:	d3 e8                	shr    %cl,%eax
  80237c:	09 d0                	or     %edx,%eax
  80237e:	d3 eb                	shr    %cl,%ebx
  802380:	89 da                	mov    %ebx,%edx
  802382:	f7 f7                	div    %edi
  802384:	89 d3                	mov    %edx,%ebx
  802386:	f7 24 24             	mull   (%esp)
  802389:	89 c6                	mov    %eax,%esi
  80238b:	89 d1                	mov    %edx,%ecx
  80238d:	39 d3                	cmp    %edx,%ebx
  80238f:	0f 82 87 00 00 00    	jb     80241c <__umoddi3+0x134>
  802395:	0f 84 91 00 00 00    	je     80242c <__umoddi3+0x144>
  80239b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80239f:	29 f2                	sub    %esi,%edx
  8023a1:	19 cb                	sbb    %ecx,%ebx
  8023a3:	89 d8                	mov    %ebx,%eax
  8023a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023a9:	d3 e0                	shl    %cl,%eax
  8023ab:	89 e9                	mov    %ebp,%ecx
  8023ad:	d3 ea                	shr    %cl,%edx
  8023af:	09 d0                	or     %edx,%eax
  8023b1:	89 e9                	mov    %ebp,%ecx
  8023b3:	d3 eb                	shr    %cl,%ebx
  8023b5:	89 da                	mov    %ebx,%edx
  8023b7:	83 c4 1c             	add    $0x1c,%esp
  8023ba:	5b                   	pop    %ebx
  8023bb:	5e                   	pop    %esi
  8023bc:	5f                   	pop    %edi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    
  8023bf:	90                   	nop
  8023c0:	89 fd                	mov    %edi,%ebp
  8023c2:	85 ff                	test   %edi,%edi
  8023c4:	75 0b                	jne    8023d1 <__umoddi3+0xe9>
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f7                	div    %edi
  8023cf:	89 c5                	mov    %eax,%ebp
  8023d1:	89 f0                	mov    %esi,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f5                	div    %ebp
  8023d7:	89 c8                	mov    %ecx,%eax
  8023d9:	f7 f5                	div    %ebp
  8023db:	89 d0                	mov    %edx,%eax
  8023dd:	e9 44 ff ff ff       	jmp    802326 <__umoddi3+0x3e>
  8023e2:	66 90                	xchg   %ax,%ax
  8023e4:	89 c8                	mov    %ecx,%eax
  8023e6:	89 f2                	mov    %esi,%edx
  8023e8:	83 c4 1c             	add    $0x1c,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5e                   	pop    %esi
  8023ed:	5f                   	pop    %edi
  8023ee:	5d                   	pop    %ebp
  8023ef:	c3                   	ret    
  8023f0:	3b 04 24             	cmp    (%esp),%eax
  8023f3:	72 06                	jb     8023fb <__umoddi3+0x113>
  8023f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023f9:	77 0f                	ja     80240a <__umoddi3+0x122>
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	29 f9                	sub    %edi,%ecx
  8023ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802403:	89 14 24             	mov    %edx,(%esp)
  802406:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80240a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80240e:	8b 14 24             	mov    (%esp),%edx
  802411:	83 c4 1c             	add    $0x1c,%esp
  802414:	5b                   	pop    %ebx
  802415:	5e                   	pop    %esi
  802416:	5f                   	pop    %edi
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    
  802419:	8d 76 00             	lea    0x0(%esi),%esi
  80241c:	2b 04 24             	sub    (%esp),%eax
  80241f:	19 fa                	sbb    %edi,%edx
  802421:	89 d1                	mov    %edx,%ecx
  802423:	89 c6                	mov    %eax,%esi
  802425:	e9 71 ff ff ff       	jmp    80239b <__umoddi3+0xb3>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802430:	72 ea                	jb     80241c <__umoddi3+0x134>
  802432:	89 d9                	mov    %ebx,%ecx
  802434:	e9 62 ff ff ff       	jmp    80239b <__umoddi3+0xb3>

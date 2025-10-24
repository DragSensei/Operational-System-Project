
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 12 02 00 00       	call   800248 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 1d 16 00 00       	call   801688 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 0c 16 00 00       	call   801688 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 45 18 00 00       	call   8018cc <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 c5 15 00 00       	call   8016b6 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 b7 15 00 00       	call   8016b6 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 7a 17 00 00       	call   801881 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 73 15 00 00       	call   801688 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb bc 21 80 00       	mov    $0x8021bc,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	e9 81 00 00 00       	jmp    8001f1 <_main+0x1b9>
		{
			int found = 0 ;
  800170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800177:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017e:	eb 3d                	jmp    8001bd <_main+0x185>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800183:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800187:	a1 20 30 80 00       	mov    0x803020,%eax
  80018c:	8b 98 90 05 00 00    	mov    0x590(%eax),%ebx
  800192:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800195:	89 d0                	mov    %edx,%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c1 e0 03             	shl    $0x3,%eax
  80019e:	01 d8                	add    %ebx,%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	39 c1                	cmp    %eax,%ecx
  8001af:	75 09                	jne    8001ba <_main+0x182>
				{
					found = 1 ;
  8001b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b8:	eb 15                	jmp    8001cf <_main+0x197>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001ba:	ff 45 e0             	incl   -0x20(%ebp)
  8001bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8001c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cb:	39 c2                	cmp    %eax,%edx
  8001cd:	77 b1                	ja     800180 <_main+0x148>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d3:	75 19                	jne    8001ee <_main+0x1b6>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d8:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 c0 20 80 00       	push   $0x8020c0
  8001e2:	6a 4c                	push   $0x4c
  8001e4:	68 21 21 80 00       	push   $0x802121
  8001e9:	e8 0a 02 00 00       	call   8003f8 <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001ee:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f1:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001f5:	0f 8e 75 ff ff ff    	jle    800170 <_main+0x138>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001fb:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001fe:	e8 7e 16 00 00       	call   801881 <sys_calculate_free_frames>
  800203:	29 c3                	sub    %eax,%ebx
  800205:	89 d8                	mov    %ebx,%eax
  800207:	83 f8 06             	cmp    $0x6,%eax
  80020a:	74 23                	je     80022f <_main+0x1f7>
  80020c:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  80020f:	e8 6d 16 00 00       	call   801881 <sys_calculate_free_frames>
  800214:	29 c3                	sub    %eax,%ebx
  800216:	89 d8                	mov    %ebx,%eax
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 08                	push   $0x8
  80021d:	50                   	push   %eax
  80021e:	68 38 21 80 00       	push   $0x802138
  800223:	6a 4f                	push   $0x4f
  800225:	68 21 21 80 00       	push   $0x802121
  80022a:	e8 c9 01 00 00       	call   8003f8 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 7c 21 80 00       	push   $0x80217c
  800237:	e8 8a 04 00 00       	call   8006c6 <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp


	return;
  80023f:	90                   	nop
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    

00800248 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800251:	e8 f4 17 00 00       	call   801a4a <sys_getenvindex>
  800256:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800259:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80025c:	89 d0                	mov    %edx,%eax
  80025e:	c1 e0 02             	shl    $0x2,%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	c1 e0 03             	shl    $0x3,%eax
  800266:	01 d0                	add    %edx,%eax
  800268:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80026f:	01 d0                	add    %edx,%eax
  800271:	c1 e0 02             	shl    $0x2,%eax
  800274:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800279:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027e:	a1 20 30 80 00       	mov    0x803020,%eax
  800283:	8a 40 20             	mov    0x20(%eax),%al
  800286:	84 c0                	test   %al,%al
  800288:	74 0d                	je     800297 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80028a:	a1 20 30 80 00       	mov    0x803020,%eax
  80028f:	83 c0 20             	add    $0x20,%eax
  800292:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029b:	7e 0a                	jle    8002a7 <libmain+0x5f>
		binaryname = argv[0];
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	e8 83 fd ff ff       	call   800038 <_main>
  8002b5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002b8:	a1 00 30 80 00       	mov    0x803000,%eax
  8002bd:	85 c0                	test   %eax,%eax
  8002bf:	0f 84 01 01 00 00    	je     8003c6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002cb:	bb d0 22 80 00       	mov    $0x8022d0,%ebx
  8002d0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002d5:	89 c7                	mov    %eax,%edi
  8002d7:	89 de                	mov    %ebx,%esi
  8002d9:	89 d1                	mov    %edx,%ecx
  8002db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002dd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002e0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002e5:	b0 00                	mov    $0x0,%al
  8002e7:	89 d7                	mov    %edx,%edi
  8002e9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	50                   	push   %eax
  8002f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 7b 19 00 00       	call   801c80 <sys_utilities>
  800305:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800308:	e8 c4 14 00 00       	call   8017d1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 f0 21 80 00       	push   $0x8021f0
  800315:	e8 ac 03 00 00       	call   8006c6 <cprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80031d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800320:	85 c0                	test   %eax,%eax
  800322:	74 18                	je     80033c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800324:	e8 75 19 00 00       	call   801c9e <sys_get_optimal_num_faults>
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	50                   	push   %eax
  80032d:	68 18 22 80 00       	push   $0x802218
  800332:	e8 8f 03 00 00       	call   8006c6 <cprintf>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	eb 59                	jmp    800395 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033c:	a1 20 30 80 00       	mov    0x803020,%eax
  800341:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800347:	a1 20 30 80 00       	mov    0x803020,%eax
  80034c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	68 3c 22 80 00       	push   $0x80223c
  80035c:	e8 65 03 00 00       	call   8006c6 <cprintf>
  800361:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80036f:	a1 20 30 80 00       	mov    0x803020,%eax
  800374:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800385:	51                   	push   %ecx
  800386:	52                   	push   %edx
  800387:	50                   	push   %eax
  800388:	68 64 22 80 00       	push   $0x802264
  80038d:	e8 34 03 00 00       	call   8006c6 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800395:	a1 20 30 80 00       	mov    0x803020,%eax
  80039a:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	50                   	push   %eax
  8003a4:	68 bc 22 80 00       	push   $0x8022bc
  8003a9:	e8 18 03 00 00       	call   8006c6 <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 f0 21 80 00       	push   $0x8021f0
  8003b9:	e8 08 03 00 00       	call   8006c6 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003c1:	e8 25 14 00 00       	call   8017eb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003c6:	e8 1f 00 00 00       	call   8003ea <exit>
}
  8003cb:	90                   	nop
  8003cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	6a 00                	push   $0x0
  8003df:	e8 32 16 00 00       	call   801a16 <sys_destroy_env>
  8003e4:	83 c4 10             	add    $0x10,%esp
}
  8003e7:	90                   	nop
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

008003ea <exit>:

void
exit(void)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f0:	e8 87 16 00 00       	call   801a7c <sys_exit_env>
}
  8003f5:	90                   	nop
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800401:	83 c0 04             	add    $0x4,%eax
  800404:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800407:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80040c:	85 c0                	test   %eax,%eax
  80040e:	74 16                	je     800426 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800410:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	50                   	push   %eax
  800419:	68 34 23 80 00       	push   $0x802334
  80041e:	e8 a3 02 00 00       	call   8006c6 <cprintf>
  800423:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800426:	a1 04 30 80 00       	mov    0x803004,%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	ff 75 0c             	pushl  0xc(%ebp)
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	50                   	push   %eax
  800435:	68 3c 23 80 00       	push   $0x80233c
  80043a:	6a 74                	push   $0x74
  80043c:	e8 b2 02 00 00       	call   8006f3 <cprintf_colored>
  800441:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800444:	8b 45 10             	mov    0x10(%ebp),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 f4             	pushl  -0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	e8 04 02 00 00       	call   800657 <vcprintf>
  800453:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	6a 00                	push   $0x0
  80045b:	68 64 23 80 00       	push   $0x802364
  800460:	e8 f2 01 00 00       	call   800657 <vcprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800468:	e8 7d ff ff ff       	call   8003ea <exit>

	// should not return here
	while (1) ;
  80046d:	eb fe                	jmp    80046d <_panic+0x75>

0080046f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800475:	a1 20 30 80 00       	mov    0x803020,%eax
  80047a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
  800483:	39 c2                	cmp    %eax,%edx
  800485:	74 14                	je     80049b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 68 23 80 00       	push   $0x802368
  80048f:	6a 26                	push   $0x26
  800491:	68 b4 23 80 00       	push   $0x8023b4
  800496:	e8 5d ff ff ff       	call   8003f8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80049b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a9:	e9 c5 00 00 00       	jmp    800573 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	75 08                	jne    8004cb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c6:	e9 a5 00 00 00       	jmp    800570 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d9:	eb 69                	jmp    800544 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004db:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	01 c0                	add    %eax,%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	c1 e0 03             	shl    $0x3,%eax
  8004f2:	01 c8                	add    %ecx,%eax
  8004f4:	8a 40 04             	mov    0x4(%eax),%al
  8004f7:	84 c0                	test   %al,%al
  8004f9:	75 46                	jne    800541 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800500:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800506:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800509:	89 d0                	mov    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	c1 e0 03             	shl    $0x3,%eax
  800512:	01 c8                	add    %ecx,%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800519:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800521:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800526:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800534:	39 c2                	cmp    %eax,%edx
  800536:	75 09                	jne    800541 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800538:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053f:	eb 15                	jmp    800556 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800541:	ff 45 e8             	incl   -0x18(%ebp)
  800544:	a1 20 30 80 00       	mov    0x803020,%eax
  800549:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800552:	39 c2                	cmp    %eax,%edx
  800554:	77 85                	ja     8004db <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800556:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80055a:	75 14                	jne    800570 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	68 c0 23 80 00       	push   $0x8023c0
  800564:	6a 3a                	push   $0x3a
  800566:	68 b4 23 80 00       	push   $0x8023b4
  80056b:	e8 88 fe ff ff       	call   8003f8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800570:	ff 45 f0             	incl   -0x10(%ebp)
  800573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800576:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800579:	0f 8c 2f ff ff ff    	jl     8004ae <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80057f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800586:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80058d:	eb 26                	jmp    8005b5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80058f:	a1 20 30 80 00       	mov    0x803020,%eax
  800594:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80059a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059d:	89 d0                	mov    %edx,%eax
  80059f:	01 c0                	add    %eax,%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	c1 e0 03             	shl    $0x3,%eax
  8005a6:	01 c8                	add    %ecx,%eax
  8005a8:	8a 40 04             	mov    0x4(%eax),%al
  8005ab:	3c 01                	cmp    $0x1,%al
  8005ad:	75 03                	jne    8005b2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b2:	ff 45 e0             	incl   -0x20(%ebp)
  8005b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	77 c8                	ja     80058f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005cd:	74 14                	je     8005e3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 14 24 80 00       	push   $0x802414
  8005d7:	6a 44                	push   $0x44
  8005d9:	68 b4 23 80 00       	push   $0x8023b4
  8005de:	e8 15 fe ff ff       	call   8003f8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	53                   	push   %ebx
  8005ea:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f8:	89 0a                	mov    %ecx,(%edx)
  8005fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fd:	88 d1                	mov    %dl,%cl
  8005ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800602:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800610:	75 30                	jne    800642 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800612:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800618:	a0 44 30 80 00       	mov    0x803044,%al
  80061d:	0f b6 c0             	movzbl %al,%eax
  800620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800623:	8b 09                	mov    (%ecx),%ecx
  800625:	89 cb                	mov    %ecx,%ebx
  800627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062a:	83 c1 08             	add    $0x8,%ecx
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	53                   	push   %ebx
  800630:	51                   	push   %ecx
  800631:	e8 57 11 00 00       	call   80178d <sys_cputs>
  800636:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	8b 40 04             	mov    0x4(%eax),%eax
  800648:	8d 50 01             	lea    0x1(%eax),%edx
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800651:	90                   	nop
  800652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800660:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800667:	00 00 00 
	b.cnt = 0;
  80066a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800671:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 08             	pushl  0x8(%ebp)
  80067a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800680:	50                   	push   %eax
  800681:	68 e6 05 80 00       	push   $0x8005e6
  800686:	e8 5a 02 00 00       	call   8008e5 <vprintfmt>
  80068b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80068e:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800694:	a0 44 30 80 00       	mov    0x803044,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006a2:	52                   	push   %edx
  8006a3:	50                   	push   %eax
  8006a4:	51                   	push   %ecx
  8006a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ab:	83 c0 08             	add    $0x8,%eax
  8006ae:	50                   	push   %eax
  8006af:	e8 d9 10 00 00       	call   80178d <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c4:	c9                   	leave  
  8006c5:	c3                   	ret    

008006c6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006cc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e2:	50                   	push   %eax
  8006e3:	e8 6f ff ff ff       	call   800657 <vcprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	c1 e0 08             	shl    $0x8,%eax
  800706:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80070b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80070e:	83 c0 04             	add    $0x4,%eax
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	50                   	push   %eax
  80071e:	e8 34 ff ff ff       	call   800657 <vcprintf>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800729:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800730:	07 00 00 

	return cnt;
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80073e:	e8 8e 10 00 00       	call   8017d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800743:	8d 45 0c             	lea    0xc(%ebp),%eax
  800746:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 f4             	pushl  -0xc(%ebp)
  800752:	50                   	push   %eax
  800753:	e8 ff fe ff ff       	call   800657 <vcprintf>
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80075e:	e8 88 10 00 00       	call   8017eb <sys_unlock_cons>
	return cnt;
  800763:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800766:	c9                   	leave  
  800767:	c3                   	ret    

00800768 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	53                   	push   %ebx
  80076c:	83 ec 14             	sub    $0x14,%esp
  80076f:	8b 45 10             	mov    0x10(%ebp),%eax
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80077b:	8b 45 18             	mov    0x18(%ebp),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800786:	77 55                	ja     8007dd <printnum+0x75>
  800788:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80078b:	72 05                	jb     800792 <printnum+0x2a>
  80078d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800790:	77 4b                	ja     8007dd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800792:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800795:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800798:	8b 45 18             	mov    0x18(%ebp),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	52                   	push   %edx
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a8:	e8 a7 16 00 00       	call   801e54 <__udivdi3>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	83 ec 04             	sub    $0x4,%esp
  8007b3:	ff 75 20             	pushl  0x20(%ebp)
  8007b6:	53                   	push   %ebx
  8007b7:	ff 75 18             	pushl  0x18(%ebp)
  8007ba:	52                   	push   %edx
  8007bb:	50                   	push   %eax
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 a1 ff ff ff       	call   800768 <printnum>
  8007c7:	83 c4 20             	add    $0x20,%esp
  8007ca:	eb 1a                	jmp    8007e6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	ff 75 20             	pushl  0x20(%ebp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007dd:	ff 4d 1c             	decl   0x1c(%ebp)
  8007e0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007e4:	7f e6                	jg     8007cc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f4:	53                   	push   %ebx
  8007f5:	51                   	push   %ecx
  8007f6:	52                   	push   %edx
  8007f7:	50                   	push   %eax
  8007f8:	e8 67 17 00 00       	call   801f64 <__umoddi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	05 74 26 80 00       	add    $0x802674,%eax
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f be c0             	movsbl %al,%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
}
  800819:	90                   	nop
  80081a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081d:	c9                   	leave  
  80081e:	c3                   	ret    

0080081f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800822:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800826:	7e 1c                	jle    800844 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	8d 50 08             	lea    0x8(%eax),%edx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 10                	mov    %edx,(%eax)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	83 e8 08             	sub    $0x8,%eax
  80083d:	8b 50 04             	mov    0x4(%eax),%edx
  800840:	8b 00                	mov    (%eax),%eax
  800842:	eb 40                	jmp    800884 <getuint+0x65>
	else if (lflag)
  800844:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800848:	74 1e                	je     800868 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	8d 50 04             	lea    0x4(%eax),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	89 10                	mov    %edx,(%eax)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	eb 1c                	jmp    800884 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800889:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088d:	7e 1c                	jle    8008ab <getint+0x25>
		return va_arg(*ap, long long);
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	8d 50 08             	lea    0x8(%eax),%edx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	89 10                	mov    %edx,(%eax)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	83 e8 08             	sub    $0x8,%eax
  8008a4:	8b 50 04             	mov    0x4(%eax),%edx
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	eb 38                	jmp    8008e3 <getint+0x5d>
	else if (lflag)
  8008ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008af:	74 1a                	je     8008cb <getint+0x45>
		return va_arg(*ap, long);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 50 04             	lea    0x4(%eax),%edx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	89 10                	mov    %edx,(%eax)
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 e8 04             	sub    $0x4,%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	99                   	cltd   
  8008c9:	eb 18                	jmp    8008e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 50 04             	lea    0x4(%eax),%edx
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	89 10                	mov    %edx,(%eax)
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	99                   	cltd   
}
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ed:	eb 17                	jmp    800906 <vprintfmt+0x21>
			if (ch == '\0')
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	0f 84 c1 03 00 00    	je     800cb8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	ff d0                	call   *%eax
  800903:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	8d 50 01             	lea    0x1(%eax),%edx
  80090c:	89 55 10             	mov    %edx,0x10(%ebp)
  80090f:	8a 00                	mov    (%eax),%al
  800911:	0f b6 d8             	movzbl %al,%ebx
  800914:	83 fb 25             	cmp    $0x25,%ebx
  800917:	75 d6                	jne    8008ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800919:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80091d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800924:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80092b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800932:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	8d 50 01             	lea    0x1(%eax),%edx
  80093f:	89 55 10             	mov    %edx,0x10(%ebp)
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80094a:	83 f8 5b             	cmp    $0x5b,%eax
  80094d:	0f 87 3d 03 00 00    	ja     800c90 <vprintfmt+0x3ab>
  800953:	8b 04 85 98 26 80 00 	mov    0x802698(,%eax,4),%eax
  80095a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80095c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800960:	eb d7                	jmp    800939 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800962:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800966:	eb d1                	jmp    800939 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800968:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80096f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800972:	89 d0                	mov    %edx,%eax
  800974:	c1 e0 02             	shl    $0x2,%eax
  800977:	01 d0                	add    %edx,%eax
  800979:	01 c0                	add    %eax,%eax
  80097b:	01 d8                	add    %ebx,%eax
  80097d:	83 e8 30             	sub    $0x30,%eax
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80098b:	83 fb 2f             	cmp    $0x2f,%ebx
  80098e:	7e 3e                	jle    8009ce <vprintfmt+0xe9>
  800990:	83 fb 39             	cmp    $0x39,%ebx
  800993:	7f 39                	jg     8009ce <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800995:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800998:	eb d5                	jmp    80096f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	83 c0 04             	add    $0x4,%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 e8 04             	sub    $0x4,%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009ae:	eb 1f                	jmp    8009cf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b4:	79 83                	jns    800939 <vprintfmt+0x54>
				width = 0;
  8009b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009bd:	e9 77 ff ff ff       	jmp    800939 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009c9:	e9 6b ff ff ff       	jmp    800939 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d3:	0f 89 60 ff ff ff    	jns    800939 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009e6:	e9 4e ff ff ff       	jmp    800939 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009eb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ee:	e9 46 ff ff ff       	jmp    800939 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 c0 04             	add    $0x4,%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	83 e8 04             	sub    $0x4,%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			break;
  800a13:	e9 9b 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 c0 04             	add    $0x4,%eax
  800a1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	79 02                	jns    800a2f <vprintfmt+0x14a>
				err = -err;
  800a2d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a2f:	83 fb 64             	cmp    $0x64,%ebx
  800a32:	7f 0b                	jg     800a3f <vprintfmt+0x15a>
  800a34:	8b 34 9d e0 24 80 00 	mov    0x8024e0(,%ebx,4),%esi
  800a3b:	85 f6                	test   %esi,%esi
  800a3d:	75 19                	jne    800a58 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a3f:	53                   	push   %ebx
  800a40:	68 85 26 80 00       	push   $0x802685
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	ff 75 08             	pushl  0x8(%ebp)
  800a4b:	e8 70 02 00 00       	call   800cc0 <printfmt>
  800a50:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a53:	e9 5b 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a58:	56                   	push   %esi
  800a59:	68 8e 26 80 00       	push   $0x80268e
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	ff 75 08             	pushl  0x8(%ebp)
  800a64:	e8 57 02 00 00       	call   800cc0 <printfmt>
  800a69:	83 c4 10             	add    $0x10,%esp
			break;
  800a6c:	e9 42 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 30                	mov    (%eax),%esi
  800a82:	85 f6                	test   %esi,%esi
  800a84:	75 05                	jne    800a8b <vprintfmt+0x1a6>
				p = "(null)";
  800a86:	be 91 26 80 00       	mov    $0x802691,%esi
			if (width > 0 && padc != '-')
  800a8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8f:	7e 6d                	jle    800afe <vprintfmt+0x219>
  800a91:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a95:	74 67                	je     800afe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	50                   	push   %eax
  800a9e:	56                   	push   %esi
  800a9f:	e8 1e 03 00 00       	call   800dc2 <strnlen>
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aaa:	eb 16                	jmp    800ac2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	50                   	push   %eax
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800abf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	7f e4                	jg     800aac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac8:	eb 34                	jmp    800afe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ace:	74 1c                	je     800aec <vprintfmt+0x207>
  800ad0:	83 fb 1f             	cmp    $0x1f,%ebx
  800ad3:	7e 05                	jle    800ada <vprintfmt+0x1f5>
  800ad5:	83 fb 7e             	cmp    $0x7e,%ebx
  800ad8:	7e 12                	jle    800aec <vprintfmt+0x207>
					putch('?', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 3f                	push   $0x3f
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	eb 0f                	jmp    800afb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	53                   	push   %ebx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afb:	ff 4d e4             	decl   -0x1c(%ebp)
  800afe:	89 f0                	mov    %esi,%eax
  800b00:	8d 70 01             	lea    0x1(%eax),%esi
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f be d8             	movsbl %al,%ebx
  800b08:	85 db                	test   %ebx,%ebx
  800b0a:	74 24                	je     800b30 <vprintfmt+0x24b>
  800b0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b10:	78 b8                	js     800aca <vprintfmt+0x1e5>
  800b12:	ff 4d e0             	decl   -0x20(%ebp)
  800b15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b19:	79 af                	jns    800aca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1b:	eb 13                	jmp    800b30 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	6a 20                	push   $0x20
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7f e7                	jg     800b1d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b36:	e9 78 01 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b41:	8d 45 14             	lea    0x14(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	e8 3c fd ff ff       	call   800886 <getint>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	85 d2                	test   %edx,%edx
  800b5b:	79 23                	jns    800b80 <vprintfmt+0x29b>
				putch('-', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 2d                	push   $0x2d
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b73:	f7 d8                	neg    %eax
  800b75:	83 d2 00             	adc    $0x0,%edx
  800b78:	f7 da                	neg    %edx
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b87:	e9 bc 00 00 00       	jmp    800c48 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b92:	8d 45 14             	lea    0x14(%ebp),%eax
  800b95:	50                   	push   %eax
  800b96:	e8 84 fc ff ff       	call   80081f <getuint>
  800b9b:	83 c4 10             	add    $0x10,%esp
  800b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ba4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bab:	e9 98 00 00 00       	jmp    800c48 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	6a 58                	push   $0x58
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	ff d0                	call   *%eax
  800bbd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	6a 58                	push   $0x58
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	ff d0                	call   *%eax
  800bcd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	6a 58                	push   $0x58
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
			break;
  800be0:	e9 ce 00 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	6a 30                	push   $0x30
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 78                	push   $0x78
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	83 c0 04             	add    $0x4,%eax
  800c0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c11:	83 e8 04             	sub    $0x4,%eax
  800c14:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c27:	eb 1f                	jmp    800c48 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c32:	50                   	push   %eax
  800c33:	e8 e7 fb ff ff       	call   80081f <getuint>
  800c38:	83 c4 10             	add    $0x10,%esp
  800c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4f:	83 ec 04             	sub    $0x4,%esp
  800c52:	52                   	push   %edx
  800c53:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 00 fb ff ff       	call   800768 <printnum>
  800c68:	83 c4 20             	add    $0x20,%esp
			break;
  800c6b:	eb 46                	jmp    800cb3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	53                   	push   %ebx
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			break;
  800c7c:	eb 35                	jmp    800cb3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c7e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c85:	eb 2c                	jmp    800cb3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c87:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c8e:	eb 23                	jmp    800cb3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 25                	push   $0x25
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	eb 03                	jmp    800ca8 <vprintfmt+0x3c3>
  800ca5:	ff 4d 10             	decl   0x10(%ebp)
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	48                   	dec    %eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	3c 25                	cmp    $0x25,%al
  800cb0:	75 f3                	jne    800ca5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cb2:	90                   	nop
		}
	}
  800cb3:	e9 35 fc ff ff       	jmp    8008ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cb8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc9:	83 c0 04             	add    $0x4,%eax
  800ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 04 fc ff ff       	call   8008e5 <vprintfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ce4:	90                   	nop
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8b 40 08             	mov    0x8(%eax),%eax
  800cf0:	8d 50 01             	lea    0x1(%eax),%edx
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	8b 10                	mov    (%eax),%edx
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8b 40 04             	mov    0x4(%eax),%eax
  800d04:	39 c2                	cmp    %eax,%edx
  800d06:	73 12                	jae    800d1a <sprintputch+0x33>
		*b->buf++ = ch;
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d13:	89 0a                	mov    %ecx,(%edx)
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	88 10                	mov    %dl,(%eax)
}
  800d1a:	90                   	nop
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d42:	74 06                	je     800d4a <vsnprintf+0x2d>
  800d44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d48:	7f 07                	jg     800d51 <vsnprintf+0x34>
		return -E_INVAL;
  800d4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4f:	eb 20                	jmp    800d71 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d51:	ff 75 14             	pushl  0x14(%ebp)
  800d54:	ff 75 10             	pushl  0x10(%ebp)
  800d57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d5a:	50                   	push   %eax
  800d5b:	68 e7 0c 80 00       	push   $0x800ce7
  800d60:	e8 80 fb ff ff       	call   8008e5 <vprintfmt>
  800d65:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d79:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7c:	83 c0 04             	add    $0x4,%eax
  800d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	ff 75 f4             	pushl  -0xc(%ebp)
  800d88:	50                   	push   %eax
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 89 ff ff ff       	call   800d1d <vsnprintf>
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800da5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dac:	eb 06                	jmp    800db4 <strlen+0x15>
		n++;
  800dae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 f1                	jne    800dae <strlen+0xf>
		n++;
	return n;
  800dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcf:	eb 09                	jmp    800dda <strnlen+0x18>
		n++;
  800dd1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd4:	ff 45 08             	incl   0x8(%ebp)
  800dd7:	ff 4d 0c             	decl   0xc(%ebp)
  800dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dde:	74 09                	je     800de9 <strnlen+0x27>
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	84 c0                	test   %al,%al
  800de7:	75 e8                	jne    800dd1 <strnlen+0xf>
		n++;
	return n;
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dfa:	90                   	nop
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8d 50 01             	lea    0x1(%eax),%edx
  800e01:	89 55 08             	mov    %edx,0x8(%ebp)
  800e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e07:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0d:	8a 12                	mov    (%edx),%dl
  800e0f:	88 10                	mov    %dl,(%eax)
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e4                	jne    800dfb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

00800e1c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2f:	eb 1f                	jmp    800e50 <strncpy+0x34>
		*dst++ = *src;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8d 50 01             	lea    0x1(%eax),%edx
  800e37:	89 55 08             	mov    %edx,0x8(%ebp)
  800e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 03                	je     800e4d <strncpy+0x31>
			src++;
  800e4a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e4d:	ff 45 fc             	incl   -0x4(%ebp)
  800e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e53:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e56:	72 d9                	jb     800e31 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6d:	74 30                	je     800e9f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e6f:	eb 16                	jmp    800e87 <strlcpy+0x2a>
			*dst++ = *src++;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8d 50 01             	lea    0x1(%eax),%edx
  800e77:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e87:	ff 4d 10             	decl   0x10(%ebp)
  800e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8e:	74 09                	je     800e99 <strlcpy+0x3c>
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	75 d8                	jne    800e71 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	29 c2                	sub    %eax,%edx
  800ea7:	89 d0                	mov    %edx,%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eae:	eb 06                	jmp    800eb6 <strcmp+0xb>
		p++, q++;
  800eb0:	ff 45 08             	incl   0x8(%ebp)
  800eb3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	84 c0                	test   %al,%al
  800ebd:	74 0e                	je     800ecd <strcmp+0x22>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 10                	mov    (%eax),%dl
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	38 c2                	cmp    %al,%dl
  800ecb:	74 e3                	je     800eb0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	0f b6 d0             	movzbl %al,%edx
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	0f b6 c0             	movzbl %al,%eax
  800edd:	29 c2                	sub    %eax,%edx
  800edf:	89 d0                	mov    %edx,%eax
}
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ee6:	eb 09                	jmp    800ef1 <strncmp+0xe>
		n--, p++, q++;
  800ee8:	ff 4d 10             	decl   0x10(%ebp)
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ef1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef5:	74 17                	je     800f0e <strncmp+0x2b>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	84 c0                	test   %al,%al
  800efe:	74 0e                	je     800f0e <strncmp+0x2b>
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	38 c2                	cmp    %al,%dl
  800f0c:	74 da                	je     800ee8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f12:	75 07                	jne    800f1b <strncmp+0x38>
		return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	eb 14                	jmp    800f2f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	0f b6 d0             	movzbl %al,%edx
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 c0             	movzbl %al,%eax
  800f2b:	29 c2                	sub    %eax,%edx
  800f2d:	89 d0                	mov    %edx,%eax
}
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 04             	sub    $0x4,%esp
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f3d:	eb 12                	jmp    800f51 <strchr+0x20>
		if (*s == c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f47:	75 05                	jne    800f4e <strchr+0x1d>
			return (char *) s;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	eb 11                	jmp    800f5f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f4e:	ff 45 08             	incl   0x8(%ebp)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	84 c0                	test   %al,%al
  800f58:	75 e5                	jne    800f3f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 0d                	jmp    800f7c <strfind+0x1b>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	74 0e                	je     800f87 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	84 c0                	test   %al,%al
  800f83:	75 ea                	jne    800f6f <strfind+0xe>
  800f85:	eb 01                	jmp    800f88 <strfind+0x27>
		if (*s == c)
			break;
  800f87:	90                   	nop
	return (char *) s;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f99:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9d:	76 63                	jbe    801002 <memset+0x75>
		uint64 data_block = c;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	99                   	cltd   
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800faf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fb3:	c1 e0 08             	shl    $0x8,%eax
  800fb6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fb9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fc6:	c1 e0 10             	shl    $0x10,%eax
  800fc9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fcc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	89 c2                	mov    %eax,%edx
  800fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fdf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fe2:	eb 18                	jmp    800ffc <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fe4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe7:	8d 41 08             	lea    0x8(%ecx),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	89 01                	mov    %eax,(%ecx)
  800ff5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ff8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ffc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801000:	77 e2                	ja     800fe4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801002:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801006:	74 23                	je     80102b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80100e:	eb 0e                	jmp    80101e <memset+0x91>
			*p8++ = (uint8)c;
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	8d 50 01             	lea    0x1(%eax),%edx
  801016:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	8d 50 ff             	lea    -0x1(%eax),%edx
  801024:	89 55 10             	mov    %edx,0x10(%ebp)
  801027:	85 c0                	test   %eax,%eax
  801029:	75 e5                	jne    801010 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801042:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801046:	76 24                	jbe    80106c <memcpy+0x3c>
		while(n >= 8){
  801048:	eb 1c                	jmp    801066 <memcpy+0x36>
			*d64 = *s64;
  80104a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104d:	8b 50 04             	mov    0x4(%eax),%edx
  801050:	8b 00                	mov    (%eax),%eax
  801052:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801055:	89 01                	mov    %eax,(%ecx)
  801057:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80105a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80105e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801062:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801066:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106a:	77 de                	ja     80104a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 31                	je     8010a3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80107e:	eb 16                	jmp    801096 <memcpy+0x66>
			*d8++ = *s8++;
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801083:	8d 50 01             	lea    0x1(%eax),%edx
  801086:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801092:	8a 12                	mov    (%edx),%dl
  801094:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109c:	89 55 10             	mov    %edx,0x10(%ebp)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 dd                	jne    801080 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c0:	73 50                	jae    801112 <memmove+0x6a>
  8010c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
  8010ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010cd:	76 43                	jbe    801112 <memmove+0x6a>
		s += n;
  8010cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010db:	eb 10                	jmp    8010ed <memmove+0x45>
			*--d = *--s;
  8010dd:	ff 4d f8             	decl   -0x8(%ebp)
  8010e0:	ff 4d fc             	decl   -0x4(%ebp)
  8010e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e6:	8a 10                	mov    (%eax),%dl
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	75 e3                	jne    8010dd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010fa:	eb 23                	jmp    80111f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801108:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110e:	8a 12                	mov    (%edx),%dl
  801110:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	8d 50 ff             	lea    -0x1(%eax),%edx
  801118:	89 55 10             	mov    %edx,0x10(%ebp)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	75 dd                	jne    8010fc <memmove+0x54>
			*d++ = *s++;

	return dst;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801136:	eb 2a                	jmp    801162 <memcmp+0x3e>
		if (*s1 != *s2)
  801138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113b:	8a 10                	mov    (%eax),%dl
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	38 c2                	cmp    %al,%dl
  801144:	74 16                	je     80115c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801146:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f b6 d0             	movzbl %al,%edx
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f b6 c0             	movzbl %al,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	eb 18                	jmp    801174 <memcmp+0x50>
		s1++, s2++;
  80115c:	ff 45 fc             	incl   -0x4(%ebp)
  80115f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	8d 50 ff             	lea    -0x1(%eax),%edx
  801168:	89 55 10             	mov    %edx,0x10(%ebp)
  80116b:	85 c0                	test   %eax,%eax
  80116d:	75 c9                	jne    801138 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801187:	eb 15                	jmp    80119e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 d0             	movzbl %al,%edx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	0f b6 c0             	movzbl %al,%eax
  801197:	39 c2                	cmp    %eax,%edx
  801199:	74 0d                	je     8011a8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119b:	ff 45 08             	incl   0x8(%ebp)
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a4:	72 e3                	jb     801189 <memfind+0x13>
  8011a6:	eb 01                	jmp    8011a9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a8:	90                   	nop
	return (void *) s;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c2:	eb 03                	jmp    8011c7 <strtol+0x19>
		s++;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 20                	cmp    $0x20,%al
  8011ce:	74 f4                	je     8011c4 <strtol+0x16>
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 09                	cmp    $0x9,%al
  8011d7:	74 eb                	je     8011c4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 2b                	cmp    $0x2b,%al
  8011e0:	75 05                	jne    8011e7 <strtol+0x39>
		s++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	eb 13                	jmp    8011fa <strtol+0x4c>
	else if (*s == '-')
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3c 2d                	cmp    $0x2d,%al
  8011ee:	75 0a                	jne    8011fa <strtol+0x4c>
		s++, neg = 1;
  8011f0:	ff 45 08             	incl   0x8(%ebp)
  8011f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fe:	74 06                	je     801206 <strtol+0x58>
  801200:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801204:	75 20                	jne    801226 <strtol+0x78>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 17                	jne    801226 <strtol+0x78>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	40                   	inc    %eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 78                	cmp    $0x78,%al
  801217:	75 0d                	jne    801226 <strtol+0x78>
		s += 2, base = 16;
  801219:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801224:	eb 28                	jmp    80124e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122a:	75 15                	jne    801241 <strtol+0x93>
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	3c 30                	cmp    $0x30,%al
  801233:	75 0c                	jne    801241 <strtol+0x93>
		s++, base = 8;
  801235:	ff 45 08             	incl   0x8(%ebp)
  801238:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80123f:	eb 0d                	jmp    80124e <strtol+0xa0>
	else if (base == 0)
  801241:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801245:	75 07                	jne    80124e <strtol+0xa0>
		base = 10;
  801247:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 2f                	cmp    $0x2f,%al
  801255:	7e 19                	jle    801270 <strtol+0xc2>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 39                	cmp    $0x39,%al
  80125e:	7f 10                	jg     801270 <strtol+0xc2>
			dig = *s - '0';
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f be c0             	movsbl %al,%eax
  801268:	83 e8 30             	sub    $0x30,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126e:	eb 42                	jmp    8012b2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 60                	cmp    $0x60,%al
  801277:	7e 19                	jle    801292 <strtol+0xe4>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 7a                	cmp    $0x7a,%al
  801280:	7f 10                	jg     801292 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	0f be c0             	movsbl %al,%eax
  80128a:	83 e8 57             	sub    $0x57,%eax
  80128d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801290:	eb 20                	jmp    8012b2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 40                	cmp    $0x40,%al
  801299:	7e 39                	jle    8012d4 <strtol+0x126>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 5a                	cmp    $0x5a,%al
  8012a2:	7f 30                	jg     8012d4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	0f be c0             	movsbl %al,%eax
  8012ac:	83 e8 37             	sub    $0x37,%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b8:	7d 19                	jge    8012d3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ba:	ff 45 08             	incl   0x8(%ebp)
  8012bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c9:	01 d0                	add    %edx,%eax
  8012cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012ce:	e9 7b ff ff ff       	jmp    80124e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d8:	74 08                	je     8012e2 <strtol+0x134>
		*endptr = (char *) s;
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e6:	74 07                	je     8012ef <strtol+0x141>
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012eb:	f7 d8                	neg    %eax
  8012ed:	eb 03                	jmp    8012f2 <strtol+0x144>
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130c:	79 13                	jns    801321 <ltostr+0x2d>
	{
		neg = 1;
  80130e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80131e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801329:	99                   	cltd   
  80132a:	f7 f9                	idiv   %ecx
  80132c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801342:	83 c2 30             	add    $0x30,%edx
  801345:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134f:	f7 e9                	imul   %ecx
  801351:	c1 fa 02             	sar    $0x2,%edx
  801354:	89 c8                	mov    %ecx,%eax
  801356:	c1 f8 1f             	sar    $0x1f,%eax
  801359:	29 c2                	sub    %eax,%edx
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801360:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801364:	75 bb                	jne    801321 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801370:	48                   	dec    %eax
  801371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801374:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801378:	74 3d                	je     8013b7 <ltostr+0xc3>
		start = 1 ;
  80137a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801381:	eb 34                	jmp    8013b7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	01 c2                	add    %eax,%edx
  801398:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 c8                	add    %ecx,%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 c2                	add    %eax,%edx
  8013ac:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013af:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013bd:	7c c4                	jl     801383 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ca:	90                   	nop
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	e8 c4 f9 ff ff       	call   800d9f <strlen>
  8013db:	83 c4 04             	add    $0x4,%esp
  8013de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	e8 b6 f9 ff ff       	call   800d9f <strlen>
  8013e9:	83 c4 04             	add    $0x4,%esp
  8013ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fd:	eb 17                	jmp    801416 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 c2                	add    %eax,%edx
  801407:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	01 c8                	add    %ecx,%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801413:	ff 45 fc             	incl   -0x4(%ebp)
  801416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801419:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141c:	7c e1                	jl     8013ff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801425:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142c:	eb 1f                	jmp    80144d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80142e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801431:	8d 50 01             	lea    0x1(%eax),%edx
  801434:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801437:	89 c2                	mov    %eax,%edx
  801439:	8b 45 10             	mov    0x10(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c8                	add    %ecx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80144a:	ff 45 f8             	incl   -0x8(%ebp)
  80144d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801453:	7c d9                	jl     80142e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801455:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c6 00 00             	movb   $0x0,(%eax)
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 d0                	add    %edx,%eax
  801480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801486:	eb 0c                	jmp    801494 <strsplit+0x31>
			*string++ = 0;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8d 50 01             	lea    0x1(%eax),%edx
  80148e:	89 55 08             	mov    %edx,0x8(%ebp)
  801491:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	84 c0                	test   %al,%al
  80149b:	74 18                	je     8014b5 <strsplit+0x52>
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	0f be c0             	movsbl %al,%eax
  8014a5:	50                   	push   %eax
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	e8 83 fa ff ff       	call   800f31 <strchr>
  8014ae:	83 c4 08             	add    $0x8,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	75 d3                	jne    801488 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 5a                	je     801518 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014be:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	83 f8 0f             	cmp    $0xf,%eax
  8014c6:	75 07                	jne    8014cf <strsplit+0x6c>
		{
			return 0;
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cd:	eb 66                	jmp    801535 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014da:	89 0a                	mov    %ecx,(%edx)
  8014dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 c2                	add    %eax,%edx
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ed:	eb 03                	jmp    8014f2 <strsplit+0x8f>
			string++;
  8014ef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	84 c0                	test   %al,%al
  8014f9:	74 8b                	je     801486 <strsplit+0x23>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	0f be c0             	movsbl %al,%eax
  801503:	50                   	push   %eax
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	e8 25 fa ff ff       	call   800f31 <strchr>
  80150c:	83 c4 08             	add    $0x8,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 dc                	je     8014ef <strsplit+0x8c>
			string++;
	}
  801513:	e9 6e ff ff ff       	jmp    801486 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801518:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801530:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801543:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80154a:	eb 4a                	jmp    801596 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80154c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	01 c2                	add    %eax,%edx
  801554:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	01 c8                	add    %ecx,%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801560:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 40                	cmp    $0x40,%al
  80156c:	7e 25                	jle    801593 <str2lower+0x5c>
  80156e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 d0                	add    %edx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	3c 5a                	cmp    $0x5a,%al
  80157a:	7f 17                	jg     801593 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80157c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	01 d0                	add    %edx,%eax
  801584:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801587:	8b 55 08             	mov    0x8(%ebp),%edx
  80158a:	01 ca                	add    %ecx,%edx
  80158c:	8a 12                	mov    (%edx),%dl
  80158e:	83 c2 20             	add    $0x20,%edx
  801591:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801593:	ff 45 fc             	incl   -0x4(%ebp)
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	e8 01 f8 ff ff       	call   800d9f <strlen>
  80159e:	83 c4 04             	add    $0x4,%esp
  8015a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015a4:	7f a6                	jg     80154c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015b1:	a1 08 30 80 00       	mov    0x803008,%eax
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 42                	je     8015fc <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	68 00 00 00 82       	push   $0x82000000
  8015c2:	68 00 00 00 80       	push   $0x80000000
  8015c7:	e8 8c 07 00 00       	call   801d58 <initialize_dynamic_allocator>
  8015cc:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015cf:	e8 e7 05 00 00       	call   801bbb <sys_get_uheap_strategy>
  8015d4:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015d9:	a1 40 30 80 00       	mov    0x803040,%eax
  8015de:	05 00 10 00 00       	add    $0x1000,%eax
  8015e3:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8015e8:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8015ed:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8015f2:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8015f9:	00 00 00 
	}
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	68 06 04 00 00       	push   $0x406
  80161b:	50                   	push   %eax
  80161c:	e8 e4 01 00 00       	call   801805 <__sys_allocate_page>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80162b:	79 14                	jns    801641 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	68 08 28 80 00       	push   $0x802808
  801635:	6a 1f                	push   $0x1f
  801637:	68 44 28 80 00       	push   $0x802844
  80163c:	e8 b7 ed ff ff       	call   8003f8 <_panic>
	return 0;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801657:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	50                   	push   %eax
  801660:	e8 e7 01 00 00       	call   80184c <__sys_unmap_frame>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80166b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80166f:	79 14                	jns    801685 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 50 28 80 00       	push   $0x802850
  801679:	6a 2a                	push   $0x2a
  80167b:	68 44 28 80 00       	push   $0x802844
  801680:	e8 73 ed ff ff       	call   8003f8 <_panic>
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80168e:	e8 18 ff ff ff       	call   8015ab <uheap_init>
	if (size == 0) return NULL ;
  801693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801697:	75 07                	jne    8016a0 <malloc+0x18>
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	eb 14                	jmp    8016b4 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	68 90 28 80 00       	push   $0x802890
  8016a8:	6a 3e                	push   $0x3e
  8016aa:	68 44 28 80 00       	push   $0x802844
  8016af:	e8 44 ed ff ff       	call   8003f8 <_panic>
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	68 b8 28 80 00       	push   $0x8028b8
  8016c4:	6a 49                	push   $0x49
  8016c6:	68 44 28 80 00       	push   $0x802844
  8016cb:	e8 28 ed ff ff       	call   8003f8 <_panic>

008016d0 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 18             	sub    $0x18,%esp
  8016d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d9:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016dc:	e8 ca fe ff ff       	call   8015ab <uheap_init>
	if (size == 0) return NULL ;
  8016e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e5:	75 07                	jne    8016ee <smalloc+0x1e>
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ec:	eb 14                	jmp    801702 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	68 dc 28 80 00       	push   $0x8028dc
  8016f6:	6a 5a                	push   $0x5a
  8016f8:	68 44 28 80 00       	push   $0x802844
  8016fd:	e8 f6 ec ff ff       	call   8003f8 <_panic>
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80170a:	e8 9c fe ff ff       	call   8015ab <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 04 29 80 00       	push   $0x802904
  801717:	6a 6a                	push   $0x6a
  801719:	68 44 28 80 00       	push   $0x802844
  80171e:	e8 d5 ec ff ff       	call   8003f8 <_panic>

00801723 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801729:	e8 7d fe ff ff       	call   8015ab <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 28 29 80 00       	push   $0x802928
  801736:	68 88 00 00 00       	push   $0x88
  80173b:	68 44 28 80 00       	push   $0x802844
  801740:	e8 b3 ec ff ff       	call   8003f8 <_panic>

00801745 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 50 29 80 00       	push   $0x802950
  801753:	68 9b 00 00 00       	push   $0x9b
  801758:	68 44 28 80 00       	push   $0x802844
  80175d:	e8 96 ec ff ff       	call   8003f8 <_panic>

00801762 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	57                   	push   %edi
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801774:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801777:	8b 7d 18             	mov    0x18(%ebp),%edi
  80177a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80177d:	cd 30                	int    $0x30
  80177f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801799:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80179c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	51                   	push   %ecx
  8017a6:	52                   	push   %edx
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	e8 b0 ff ff ff       	call   801762 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	90                   	nop
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 02                	push   $0x2
  8017c7:	e8 96 ff ff ff       	call   801762 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 03                	push   $0x3
  8017e0:	e8 7d ff ff ff       	call   801762 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 04                	push   $0x4
  8017fa:	e8 63 ff ff ff       	call   801762 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	52                   	push   %edx
  801815:	50                   	push   %eax
  801816:	6a 08                	push   $0x8
  801818:	e8 45 ff ff ff       	call   801762 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801827:	8b 75 18             	mov    0x18(%ebp),%esi
  80182a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	51                   	push   %ecx
  801839:	52                   	push   %edx
  80183a:	50                   	push   %eax
  80183b:	6a 09                	push   $0x9
  80183d:	e8 20 ff ff ff       	call   801762 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	6a 0a                	push   $0xa
  80185c:	e8 01 ff ff ff       	call   801762 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	6a 0b                	push   $0xb
  801877:	e8 e6 fe ff ff       	call   801762 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 0c                	push   $0xc
  801890:	e8 cd fe ff ff       	call   801762 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 0d                	push   $0xd
  8018a9:	e8 b4 fe ff ff       	call   801762 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 0e                	push   $0xe
  8018c2:	e8 9b fe ff ff       	call   801762 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 0f                	push   $0xf
  8018db:	e8 82 fe ff ff       	call   801762 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	6a 10                	push   $0x10
  8018f5:	e8 68 fe ff ff       	call   801762 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 11                	push   $0x11
  80190e:	e8 4f fe ff ff       	call   801762 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_cputc>:

void
sys_cputc(const char c)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801925:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 01                	push   $0x1
  801934:	e8 29 fe ff ff       	call   801762 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 14                	push   $0x14
  80194e:	e8 0f fe ff ff       	call   801762 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	8b 45 10             	mov    0x10(%ebp),%eax
  801962:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801965:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801968:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	51                   	push   %ecx
  801972:	52                   	push   %edx
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	50                   	push   %eax
  801977:	6a 15                	push   $0x15
  801979:	e8 e4 fd ff ff       	call   801762 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 16                	push   $0x16
  801996:	e8 c7 fd ff ff       	call   801762 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	51                   	push   %ecx
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 17                	push   $0x17
  8019b5:	e8 a8 fd ff ff       	call   801762 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	52                   	push   %edx
  8019cf:	50                   	push   %eax
  8019d0:	6a 18                	push   $0x18
  8019d2:	e8 8b fd ff ff       	call   801762 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 14             	pushl  0x14(%ebp)
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	6a 19                	push   $0x19
  8019f0:	e8 6d fd ff ff       	call   801762 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	50                   	push   %eax
  801a09:	6a 1a                	push   $0x1a
  801a0b:	e8 52 fd ff ff       	call   801762 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	50                   	push   %eax
  801a25:	6a 1b                	push   $0x1b
  801a27:	e8 36 fd ff ff       	call   801762 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 05                	push   $0x5
  801a40:	e8 1d fd ff ff       	call   801762 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 06                	push   $0x6
  801a59:	e8 04 fd ff ff       	call   801762 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 07                	push   $0x7
  801a72:	e8 eb fc ff ff       	call   801762 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_exit_env>:


void sys_exit_env(void)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 1c                	push   $0x1c
  801a8b:	e8 d2 fc ff ff       	call   801762 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a9c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a9f:	8d 50 04             	lea    0x4(%eax),%edx
  801aa2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	52                   	push   %edx
  801aac:	50                   	push   %eax
  801aad:	6a 1d                	push   $0x1d
  801aaf:	e8 ae fc ff ff       	call   801762 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac0:	89 01                	mov    %eax,(%ecx)
  801ac2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	c9                   	leave  
  801ac9:	c2 04 00             	ret    $0x4

00801acc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 10             	pushl  0x10(%ebp)
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	6a 13                	push   $0x13
  801ade:	e8 7f fc ff ff       	call   801762 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae6:	90                   	nop
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 1e                	push   $0x1e
  801af8:	e8 65 fc ff ff       	call   801762 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b0e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	50                   	push   %eax
  801b1b:	6a 1f                	push   $0x1f
  801b1d:	e8 40 fc ff ff       	call   801762 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
	return ;
  801b25:	90                   	nop
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <rsttst>:
void rsttst()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 21                	push   $0x21
  801b37:	e8 26 fc ff ff       	call   801762 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3f:	90                   	nop
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b4e:	8b 55 18             	mov    0x18(%ebp),%edx
  801b51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	ff 75 10             	pushl  0x10(%ebp)
  801b5a:	ff 75 0c             	pushl  0xc(%ebp)
  801b5d:	ff 75 08             	pushl  0x8(%ebp)
  801b60:	6a 20                	push   $0x20
  801b62:	e8 fb fb ff ff       	call   801762 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6a:	90                   	nop
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <chktst>:
void chktst(uint32 n)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 22                	push   $0x22
  801b7d:	e8 e0 fb ff ff       	call   801762 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <inctst>:

void inctst()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 23                	push   $0x23
  801b97:	e8 c6 fb ff ff       	call   801762 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <gettst>:
uint32 gettst()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 24                	push   $0x24
  801bb1:	e8 ac fb ff ff       	call   801762 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 25                	push   $0x25
  801bca:	e8 93 fb ff ff       	call   801762 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
  801bd2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801bd7:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 26                	push   $0x26
  801bf6:	e8 67 fb ff ff       	call   801762 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	53                   	push   %ebx
  801c14:	51                   	push   %ecx
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	6a 27                	push   $0x27
  801c19:	e8 44 fb ff ff       	call   801762 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 28                	push   $0x28
  801c39:	e8 24 fb ff ff       	call   801762 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	51                   	push   %ecx
  801c52:	ff 75 10             	pushl  0x10(%ebp)
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 29                	push   $0x29
  801c59:	e8 04 fb ff ff       	call   801762 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 10             	pushl  0x10(%ebp)
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	6a 12                	push   $0x12
  801c75:	e8 e8 fa ff ff       	call   801762 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7d:	90                   	nop
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	52                   	push   %edx
  801c90:	50                   	push   %eax
  801c91:	6a 2a                	push   $0x2a
  801c93:	e8 ca fa ff ff       	call   801762 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 2b                	push   $0x2b
  801cad:	e8 b0 fa ff ff       	call   801762 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 2d                	push   $0x2d
  801cc8:	e8 95 fa ff ff       	call   801762 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 2c                	push   $0x2c
  801ce4:	e8 79 fa ff ff       	call   801762 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	68 74 29 80 00       	push   $0x802974
  801cfd:	68 25 01 00 00       	push   $0x125
  801d02:	68 a7 29 80 00       	push   $0x8029a7
  801d07:	e8 ec e6 ff ff       	call   8003f8 <_panic>

00801d0c <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d1a:	29 d0                	sub    %edx,%eax
  801d1c:	c1 f8 02             	sar    $0x2,%eax
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	c1 e0 02             	shl    $0x2,%eax
  801d26:	01 d0                	add    %edx,%eax
  801d28:	c1 e0 02             	shl    $0x2,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c1 e0 02             	shl    $0x2,%eax
  801d30:	01 d0                	add    %edx,%eax
  801d32:	89 c1                	mov    %eax,%ecx
  801d34:	c1 e1 08             	shl    $0x8,%ecx
  801d37:	01 c8                	add    %ecx,%eax
  801d39:	89 c1                	mov    %eax,%ecx
  801d3b:	c1 e1 10             	shl    $0x10,%ecx
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	01 c0                	add    %eax,%eax
  801d42:	01 d0                	add    %edx,%eax
  801d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d4a:	c1 e0 0c             	shl    $0xc,%eax
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d54:	01 d0                	add    %edx,%eax
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	05 00 00 00 02       	add    $0x2000000,%eax
  801d66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d69:	73 16                	jae    801d81 <initialize_dynamic_allocator+0x29>
  801d6b:	68 b8 29 80 00       	push   $0x8029b8
  801d70:	68 de 29 80 00       	push   $0x8029de
  801d75:	6a 26                	push   $0x26
  801d77:	68 f3 29 80 00       	push   $0x8029f3
  801d7c:	e8 77 e6 ff ff       	call   8003f8 <_panic>
		is_initialized = 1;
  801d81:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801d88:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	68 0c 2a 80 00       	push   $0x802a0c
  801d93:	6a 2e                	push   $0x2e
  801d95:	68 f3 29 80 00       	push   $0x8029f3
  801d9a:	e8 59 e6 ff ff       	call   8003f8 <_panic>

00801d9f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	68 40 2a 80 00       	push   $0x802a40
  801dad:	6a 3a                	push   $0x3a
  801daf:	68 f3 29 80 00       	push   $0x8029f3
  801db4:	e8 3f e6 ff ff       	call   8003f8 <_panic>

00801db9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801dbf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dc6:	76 16                	jbe    801dde <alloc_block+0x25>
  801dc8:	68 68 2a 80 00       	push   $0x802a68
  801dcd:	68 de 29 80 00       	push   $0x8029de
  801dd2:	6a 46                	push   $0x46
  801dd4:	68 f3 29 80 00       	push   $0x8029f3
  801dd9:	e8 1a e6 ff ff       	call   8003f8 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801dde:	83 ec 04             	sub    $0x4,%esp
  801de1:	68 8c 2a 80 00       	push   $0x802a8c
  801de6:	6a 4d                	push   $0x4d
  801de8:	68 f3 29 80 00       	push   $0x8029f3
  801ded:	e8 06 e6 ff ff       	call   8003f8 <_panic>

00801df2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801df8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfb:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e00:	39 c2                	cmp    %eax,%edx
  801e02:	72 0c                	jb     801e10 <free_block+0x1e>
  801e04:	8b 55 08             	mov    0x8(%ebp),%edx
  801e07:	a1 40 30 80 00       	mov    0x803040,%eax
  801e0c:	39 c2                	cmp    %eax,%edx
  801e0e:	72 16                	jb     801e26 <free_block+0x34>
  801e10:	68 b0 2a 80 00       	push   $0x802ab0
  801e15:	68 de 29 80 00       	push   $0x8029de
  801e1a:	6a 5b                	push   $0x5b
  801e1c:	68 f3 29 80 00       	push   $0x8029f3
  801e21:	e8 d2 e5 ff ff       	call   8003f8 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 e8 2a 80 00       	push   $0x802ae8
  801e2e:	6a 63                	push   $0x63
  801e30:	68 f3 29 80 00       	push   $0x8029f3
  801e35:	e8 be e5 ff ff       	call   8003f8 <_panic>

00801e3a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	68 0c 2b 80 00       	push   $0x802b0c
  801e48:	6a 72                	push   $0x72
  801e4a:	68 f3 29 80 00       	push   $0x8029f3
  801e4f:	e8 a4 e5 ff ff       	call   8003f8 <_panic>

00801e54 <__udivdi3>:
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e6b:	89 ca                	mov    %ecx,%edx
  801e6d:	89 f8                	mov    %edi,%eax
  801e6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e73:	85 f6                	test   %esi,%esi
  801e75:	75 2d                	jne    801ea4 <__udivdi3+0x50>
  801e77:	39 cf                	cmp    %ecx,%edi
  801e79:	77 65                	ja     801ee0 <__udivdi3+0x8c>
  801e7b:	89 fd                	mov    %edi,%ebp
  801e7d:	85 ff                	test   %edi,%edi
  801e7f:	75 0b                	jne    801e8c <__udivdi3+0x38>
  801e81:	b8 01 00 00 00       	mov    $0x1,%eax
  801e86:	31 d2                	xor    %edx,%edx
  801e88:	f7 f7                	div    %edi
  801e8a:	89 c5                	mov    %eax,%ebp
  801e8c:	31 d2                	xor    %edx,%edx
  801e8e:	89 c8                	mov    %ecx,%eax
  801e90:	f7 f5                	div    %ebp
  801e92:	89 c1                	mov    %eax,%ecx
  801e94:	89 d8                	mov    %ebx,%eax
  801e96:	f7 f5                	div    %ebp
  801e98:	89 cf                	mov    %ecx,%edi
  801e9a:	89 fa                	mov    %edi,%edx
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
  801ea4:	39 ce                	cmp    %ecx,%esi
  801ea6:	77 28                	ja     801ed0 <__udivdi3+0x7c>
  801ea8:	0f bd fe             	bsr    %esi,%edi
  801eab:	83 f7 1f             	xor    $0x1f,%edi
  801eae:	75 40                	jne    801ef0 <__udivdi3+0x9c>
  801eb0:	39 ce                	cmp    %ecx,%esi
  801eb2:	72 0a                	jb     801ebe <__udivdi3+0x6a>
  801eb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801eb8:	0f 87 9e 00 00 00    	ja     801f5c <__udivdi3+0x108>
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec3:	89 fa                	mov    %edi,%edx
  801ec5:	83 c4 1c             	add    $0x1c,%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	31 ff                	xor    %edi,%edi
  801ed2:	31 c0                	xor    %eax,%eax
  801ed4:	89 fa                	mov    %edi,%edx
  801ed6:	83 c4 1c             	add    $0x1c,%esp
  801ed9:	5b                   	pop    %ebx
  801eda:	5e                   	pop    %esi
  801edb:	5f                   	pop    %edi
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
  801ede:	66 90                	xchg   %ax,%ax
  801ee0:	89 d8                	mov    %ebx,%eax
  801ee2:	f7 f7                	div    %edi
  801ee4:	31 ff                	xor    %edi,%edi
  801ee6:	89 fa                	mov    %edi,%edx
  801ee8:	83 c4 1c             	add    $0x1c,%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
  801ef0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ef5:	89 eb                	mov    %ebp,%ebx
  801ef7:	29 fb                	sub    %edi,%ebx
  801ef9:	89 f9                	mov    %edi,%ecx
  801efb:	d3 e6                	shl    %cl,%esi
  801efd:	89 c5                	mov    %eax,%ebp
  801eff:	88 d9                	mov    %bl,%cl
  801f01:	d3 ed                	shr    %cl,%ebp
  801f03:	89 e9                	mov    %ebp,%ecx
  801f05:	09 f1                	or     %esi,%ecx
  801f07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f0b:	89 f9                	mov    %edi,%ecx
  801f0d:	d3 e0                	shl    %cl,%eax
  801f0f:	89 c5                	mov    %eax,%ebp
  801f11:	89 d6                	mov    %edx,%esi
  801f13:	88 d9                	mov    %bl,%cl
  801f15:	d3 ee                	shr    %cl,%esi
  801f17:	89 f9                	mov    %edi,%ecx
  801f19:	d3 e2                	shl    %cl,%edx
  801f1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f1f:	88 d9                	mov    %bl,%cl
  801f21:	d3 e8                	shr    %cl,%eax
  801f23:	09 c2                	or     %eax,%edx
  801f25:	89 d0                	mov    %edx,%eax
  801f27:	89 f2                	mov    %esi,%edx
  801f29:	f7 74 24 0c          	divl   0xc(%esp)
  801f2d:	89 d6                	mov    %edx,%esi
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	f7 e5                	mul    %ebp
  801f33:	39 d6                	cmp    %edx,%esi
  801f35:	72 19                	jb     801f50 <__udivdi3+0xfc>
  801f37:	74 0b                	je     801f44 <__udivdi3+0xf0>
  801f39:	89 d8                	mov    %ebx,%eax
  801f3b:	31 ff                	xor    %edi,%edi
  801f3d:	e9 58 ff ff ff       	jmp    801e9a <__udivdi3+0x46>
  801f42:	66 90                	xchg   %ax,%ax
  801f44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f48:	89 f9                	mov    %edi,%ecx
  801f4a:	d3 e2                	shl    %cl,%edx
  801f4c:	39 c2                	cmp    %eax,%edx
  801f4e:	73 e9                	jae    801f39 <__udivdi3+0xe5>
  801f50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f53:	31 ff                	xor    %edi,%edi
  801f55:	e9 40 ff ff ff       	jmp    801e9a <__udivdi3+0x46>
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	31 c0                	xor    %eax,%eax
  801f5e:	e9 37 ff ff ff       	jmp    801e9a <__udivdi3+0x46>
  801f63:	90                   	nop

00801f64 <__umoddi3>:
  801f64:	55                   	push   %ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 1c             	sub    $0x1c,%esp
  801f6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f83:	89 f3                	mov    %esi,%ebx
  801f85:	89 fa                	mov    %edi,%edx
  801f87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f8b:	89 34 24             	mov    %esi,(%esp)
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	75 1a                	jne    801fac <__umoddi3+0x48>
  801f92:	39 f7                	cmp    %esi,%edi
  801f94:	0f 86 a2 00 00 00    	jbe    80203c <__umoddi3+0xd8>
  801f9a:	89 c8                	mov    %ecx,%eax
  801f9c:	89 f2                	mov    %esi,%edx
  801f9e:	f7 f7                	div    %edi
  801fa0:	89 d0                	mov    %edx,%eax
  801fa2:	31 d2                	xor    %edx,%edx
  801fa4:	83 c4 1c             	add    $0x1c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	39 f0                	cmp    %esi,%eax
  801fae:	0f 87 ac 00 00 00    	ja     802060 <__umoddi3+0xfc>
  801fb4:	0f bd e8             	bsr    %eax,%ebp
  801fb7:	83 f5 1f             	xor    $0x1f,%ebp
  801fba:	0f 84 ac 00 00 00    	je     80206c <__umoddi3+0x108>
  801fc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801fc5:	29 ef                	sub    %ebp,%edi
  801fc7:	89 fe                	mov    %edi,%esi
  801fc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fcd:	89 e9                	mov    %ebp,%ecx
  801fcf:	d3 e0                	shl    %cl,%eax
  801fd1:	89 d7                	mov    %edx,%edi
  801fd3:	89 f1                	mov    %esi,%ecx
  801fd5:	d3 ef                	shr    %cl,%edi
  801fd7:	09 c7                	or     %eax,%edi
  801fd9:	89 e9                	mov    %ebp,%ecx
  801fdb:	d3 e2                	shl    %cl,%edx
  801fdd:	89 14 24             	mov    %edx,(%esp)
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	d3 e0                	shl    %cl,%eax
  801fe4:	89 c2                	mov    %eax,%edx
  801fe6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fea:	d3 e0                	shl    %cl,%eax
  801fec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff4:	89 f1                	mov    %esi,%ecx
  801ff6:	d3 e8                	shr    %cl,%eax
  801ff8:	09 d0                	or     %edx,%eax
  801ffa:	d3 eb                	shr    %cl,%ebx
  801ffc:	89 da                	mov    %ebx,%edx
  801ffe:	f7 f7                	div    %edi
  802000:	89 d3                	mov    %edx,%ebx
  802002:	f7 24 24             	mull   (%esp)
  802005:	89 c6                	mov    %eax,%esi
  802007:	89 d1                	mov    %edx,%ecx
  802009:	39 d3                	cmp    %edx,%ebx
  80200b:	0f 82 87 00 00 00    	jb     802098 <__umoddi3+0x134>
  802011:	0f 84 91 00 00 00    	je     8020a8 <__umoddi3+0x144>
  802017:	8b 54 24 04          	mov    0x4(%esp),%edx
  80201b:	29 f2                	sub    %esi,%edx
  80201d:	19 cb                	sbb    %ecx,%ebx
  80201f:	89 d8                	mov    %ebx,%eax
  802021:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802025:	d3 e0                	shl    %cl,%eax
  802027:	89 e9                	mov    %ebp,%ecx
  802029:	d3 ea                	shr    %cl,%edx
  80202b:	09 d0                	or     %edx,%eax
  80202d:	89 e9                	mov    %ebp,%ecx
  80202f:	d3 eb                	shr    %cl,%ebx
  802031:	89 da                	mov    %ebx,%edx
  802033:	83 c4 1c             	add    $0x1c,%esp
  802036:	5b                   	pop    %ebx
  802037:	5e                   	pop    %esi
  802038:	5f                   	pop    %edi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    
  80203b:	90                   	nop
  80203c:	89 fd                	mov    %edi,%ebp
  80203e:	85 ff                	test   %edi,%edi
  802040:	75 0b                	jne    80204d <__umoddi3+0xe9>
  802042:	b8 01 00 00 00       	mov    $0x1,%eax
  802047:	31 d2                	xor    %edx,%edx
  802049:	f7 f7                	div    %edi
  80204b:	89 c5                	mov    %eax,%ebp
  80204d:	89 f0                	mov    %esi,%eax
  80204f:	31 d2                	xor    %edx,%edx
  802051:	f7 f5                	div    %ebp
  802053:	89 c8                	mov    %ecx,%eax
  802055:	f7 f5                	div    %ebp
  802057:	89 d0                	mov    %edx,%eax
  802059:	e9 44 ff ff ff       	jmp    801fa2 <__umoddi3+0x3e>
  80205e:	66 90                	xchg   %ax,%ax
  802060:	89 c8                	mov    %ecx,%eax
  802062:	89 f2                	mov    %esi,%edx
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
  80206c:	3b 04 24             	cmp    (%esp),%eax
  80206f:	72 06                	jb     802077 <__umoddi3+0x113>
  802071:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802075:	77 0f                	ja     802086 <__umoddi3+0x122>
  802077:	89 f2                	mov    %esi,%edx
  802079:	29 f9                	sub    %edi,%ecx
  80207b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80207f:	89 14 24             	mov    %edx,(%esp)
  802082:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802086:	8b 44 24 04          	mov    0x4(%esp),%eax
  80208a:	8b 14 24             	mov    (%esp),%edx
  80208d:	83 c4 1c             	add    $0x1c,%esp
  802090:	5b                   	pop    %ebx
  802091:	5e                   	pop    %esi
  802092:	5f                   	pop    %edi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	2b 04 24             	sub    (%esp),%eax
  80209b:	19 fa                	sbb    %edi,%edx
  80209d:	89 d1                	mov    %edx,%ecx
  80209f:	89 c6                	mov    %eax,%esi
  8020a1:	e9 71 ff ff ff       	jmp    802017 <__umoddi3+0xb3>
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020ac:	72 ea                	jb     802098 <__umoddi3+0x134>
  8020ae:	89 d9                	mov    %ebx,%ecx
  8020b0:	e9 62 ff ff ff       	jmp    802017 <__umoddi3+0xb3>

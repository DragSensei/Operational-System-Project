
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 fd 01 00 00       	call   800233 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int eval = 0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	cprintf("PART I: Test the Pointer Validation inside fault_handler(): [70%]\n");
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	68 80 1e 80 00       	push   $0x801e80
  80004d:	e8 71 04 00 00       	call   8004c3 <cprintf>
  800052:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================\n");
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	68 c4 1e 80 00       	push   $0x801ec4
  80005d:	e8 61 04 00 00       	call   8004c3 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800065:	e8 04 17 00 00       	call   80176e <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 20 30 80 00       	mov    0x803020,%eax
  80006f:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
  80007a:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008d:	52                   	push   %edx
  80008e:	51                   	push   %ecx
  80008f:	50                   	push   %eax
  800090:	68 07 1f 80 00       	push   $0x801f07
  800095:	e8 88 15 00 00       	call   801622 <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a6:	e8 95 15 00 00       	call   801640 <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b3:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000c4:	89 c1                	mov    %eax,%ecx
  8000c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d1:	52                   	push   %edx
  8000d2:	51                   	push   %ecx
  8000d3:	50                   	push   %eax
  8000d4:	68 12 1f 80 00       	push   $0x801f12
  8000d9:	e8 44 15 00 00       	call   801622 <sys_create_env>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ea:	e8 51 15 00 00       	call   801640 <sys_run_env>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800102:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 20 30 80 00       	mov    0x803020,%eax
  80010f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 1d 1f 80 00       	push   $0x801f1d
  80011d:	e8 00 15 00 00       	call   801622 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e8             	pushl  -0x18(%ebp)
  80012e:	e8 0d 15 00 00       	call   801640 <sys_run_env>
  800133:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 10 27 00 00       	push   $0x2710
  80013e:	e8 0f 18 00 00       	call   801952 <env_sleep>
  800143:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800146:	e8 9d 16 00 00       	call   8017e8 <gettst>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 12                	je     800161 <_main+0x129>
		cprintf("\nPART I... Failed.\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 28 1f 80 00       	push   $0x801f28
  800157:	e8 67 03 00 00       	call   8004c3 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 14                	jmp    800175 <_main+0x13d>
	else
	{
		cprintf("\nPART I... completed successfully\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 3c 1f 80 00       	push   $0x801f3c
  800169:	e8 55 03 00 00       	call   8004c3 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800171:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 60 1f 80 00       	push   $0x801f60
  80017d:	e8 41 03 00 00       	call   8004c3 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================================================\n");
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	68 c4 1f 80 00       	push   $0x801fc4
  80018d:	e8 31 03 00 00       	call   8004c3 <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	rsttst();
  800195:	e8 d4 15 00 00       	call   80176e <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001aa:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8001b0:	89 c1                	mov    %eax,%ecx
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001bd:	52                   	push   %edx
  8001be:	51                   	push   %ecx
  8001bf:	50                   	push   %eax
  8001c0:	68 27 20 80 00       	push   $0x802027
  8001c5:	e8 58 14 00 00       	call   801622 <sys_create_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	e8 65 14 00 00       	call   801640 <sys_run_env>
  8001db:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 10 27 00 00       	push   $0x2710
  8001e6:	e8 67 17 00 00       	call   801952 <env_sleep>
  8001eb:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001ee:	e8 f5 15 00 00       	call   8017e8 <gettst>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 12                	je     800209 <_main+0x1d1>
		cprintf("\nPART II... Failed.\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 32 20 80 00       	push   $0x802032
  8001ff:	e8 bf 02 00 00       	call   8004c3 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	eb 14                	jmp    80021d <_main+0x1e5>
	else
	{
		cprintf("\nPART II... completed successfully\n\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 48 20 80 00       	push   $0x802048
  800211:	e8 ad 02 00 00       	call   8004c3 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800219:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest invalid access completed. Eval = %d\n\n", eval);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	68 70 20 80 00       	push   $0x802070
  800228:	e8 96 02 00 00       	call   8004c3 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp

}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	57                   	push   %edi
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80023c:	e8 4f 14 00 00       	call   801690 <sys_getenvindex>
  800241:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800244:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800247:	89 d0                	mov    %edx,%eax
  800249:	c1 e0 02             	shl    $0x2,%eax
  80024c:	01 d0                	add    %edx,%eax
  80024e:	c1 e0 03             	shl    $0x3,%eax
  800251:	01 d0                	add    %edx,%eax
  800253:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	c1 e0 02             	shl    $0x2,%eax
  80025f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800264:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800269:	a1 20 30 80 00       	mov    0x803020,%eax
  80026e:	8a 40 20             	mov    0x20(%eax),%al
  800271:	84 c0                	test   %al,%al
  800273:	74 0d                	je     800282 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	83 c0 20             	add    $0x20,%eax
  80027d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800286:	7e 0a                	jle    800292 <libmain+0x5f>
		binaryname = argv[0];
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	e8 98 fd ff ff       	call   800038 <_main>
  8002a0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002a3:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 84 01 01 00 00    	je     8003b1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002b6:	bb 98 21 80 00       	mov    $0x802198,%ebx
  8002bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002c0:	89 c7                	mov    %eax,%edi
  8002c2:	89 de                	mov    %ebx,%esi
  8002c4:	89 d1                	mov    %edx,%ecx
  8002c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002c8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002cb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002d0:	b0 00                	mov    $0x0,%al
  8002d2:	89 d7                	mov    %edx,%edi
  8002d4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	50                   	push   %eax
  8002e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ea:	50                   	push   %eax
  8002eb:	e8 d6 15 00 00       	call   8018c6 <sys_utilities>
  8002f0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002f3:	e8 1f 11 00 00       	call   801417 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 b8 20 80 00       	push   $0x8020b8
  800300:	e8 be 01 00 00       	call   8004c3 <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030b:	85 c0                	test   %eax,%eax
  80030d:	74 18                	je     800327 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80030f:	e8 d0 15 00 00       	call   8018e4 <sys_get_optimal_num_faults>
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 e0 20 80 00       	push   $0x8020e0
  80031d:	e8 a1 01 00 00       	call   8004c3 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	eb 59                	jmp    800380 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800327:	a1 20 30 80 00       	mov    0x803020,%eax
  80032c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800332:	a1 20 30 80 00       	mov    0x803020,%eax
  800337:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	52                   	push   %edx
  800341:	50                   	push   %eax
  800342:	68 04 21 80 00       	push   $0x802104
  800347:	e8 77 01 00 00       	call   8004c3 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80034f:	a1 20 30 80 00       	mov    0x803020,%eax
  800354:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80035a:	a1 20 30 80 00       	mov    0x803020,%eax
  80035f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800365:	a1 20 30 80 00       	mov    0x803020,%eax
  80036a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800370:	51                   	push   %ecx
  800371:	52                   	push   %edx
  800372:	50                   	push   %eax
  800373:	68 2c 21 80 00       	push   $0x80212c
  800378:	e8 46 01 00 00       	call   8004c3 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800380:	a1 20 30 80 00       	mov    0x803020,%eax
  800385:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	50                   	push   %eax
  80038f:	68 84 21 80 00       	push   $0x802184
  800394:	e8 2a 01 00 00       	call   8004c3 <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	68 b8 20 80 00       	push   $0x8020b8
  8003a4:	e8 1a 01 00 00       	call   8004c3 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003ac:	e8 80 10 00 00       	call   801431 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003b1:	e8 1f 00 00 00       	call   8003d5 <exit>
}
  8003b6:	90                   	nop
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003c5:	83 ec 0c             	sub    $0xc,%esp
  8003c8:	6a 00                	push   $0x0
  8003ca:	e8 8d 12 00 00       	call   80165c <sys_destroy_env>
  8003cf:	83 c4 10             	add    $0x10,%esp
}
  8003d2:	90                   	nop
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <exit>:

void
exit(void)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003db:	e8 e2 12 00 00       	call   8016c2 <sys_exit_env>
}
  8003e0:	90                   	nop
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	53                   	push   %ebx
  8003e7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8003f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f5:	89 0a                	mov    %ecx,(%edx)
  8003f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003fa:	88 d1                	mov    %dl,%cl
  8003fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ff:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	3d ff 00 00 00       	cmp    $0xff,%eax
  80040d:	75 30                	jne    80043f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80040f:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800415:	a0 44 30 80 00       	mov    0x803044,%al
  80041a:	0f b6 c0             	movzbl %al,%eax
  80041d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800420:	8b 09                	mov    (%ecx),%ecx
  800422:	89 cb                	mov    %ecx,%ebx
  800424:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800427:	83 c1 08             	add    $0x8,%ecx
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	53                   	push   %ebx
  80042d:	51                   	push   %ecx
  80042e:	e8 a0 0f 00 00       	call   8013d3 <sys_cputs>
  800433:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
  800439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80043f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800442:	8b 40 04             	mov    0x4(%eax),%eax
  800445:	8d 50 01             	lea    0x1(%eax),%edx
  800448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80044e:	90                   	nop
  80044f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80045d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800464:	00 00 00 
	b.cnt = 0;
  800467:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80046e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80047d:	50                   	push   %eax
  80047e:	68 e3 03 80 00       	push   $0x8003e3
  800483:	e8 5a 02 00 00       	call   8006e2 <vprintfmt>
  800488:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80048b:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800491:	a0 44 30 80 00       	mov    0x803044,%al
  800496:	0f b6 c0             	movzbl %al,%eax
  800499:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80049f:	52                   	push   %edx
  8004a0:	50                   	push   %eax
  8004a1:	51                   	push   %ecx
  8004a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a8:	83 c0 08             	add    $0x8,%eax
  8004ab:	50                   	push   %eax
  8004ac:	e8 22 0f 00 00       	call   8013d3 <sys_cputs>
  8004b1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004b4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004c1:	c9                   	leave  
  8004c2:	c3                   	ret    

008004c3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004c9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8004df:	50                   	push   %eax
  8004e0:	e8 6f ff ff ff       	call   800454 <vcprintf>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	c1 e0 08             	shl    $0x8,%eax
  800503:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800508:	8d 45 0c             	lea    0xc(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	ff 75 f4             	pushl  -0xc(%ebp)
  80051a:	50                   	push   %eax
  80051b:	e8 34 ff ff ff       	call   800454 <vcprintf>
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800526:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80052d:	07 00 00 

	return cnt;
  800530:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800533:	c9                   	leave  
  800534:	c3                   	ret    

00800535 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80053b:	e8 d7 0e 00 00       	call   801417 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 ff fe ff ff       	call   800454 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80055b:	e8 d1 0e 00 00       	call   801431 <sys_unlock_cons>
	return cnt;
  800560:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	53                   	push   %ebx
  800569:	83 ec 14             	sub    $0x14,%esp
  80056c:	8b 45 10             	mov    0x10(%ebp),%eax
  80056f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800578:	8b 45 18             	mov    0x18(%ebp),%eax
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800583:	77 55                	ja     8005da <printnum+0x75>
  800585:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800588:	72 05                	jb     80058f <printnum+0x2a>
  80058a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058d:	77 4b                	ja     8005da <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800592:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	52                   	push   %edx
  80059e:	50                   	push   %eax
  80059f:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a5:	e8 56 16 00 00       	call   801c00 <__udivdi3>
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	83 ec 04             	sub    $0x4,%esp
  8005b0:	ff 75 20             	pushl  0x20(%ebp)
  8005b3:	53                   	push   %ebx
  8005b4:	ff 75 18             	pushl  0x18(%ebp)
  8005b7:	52                   	push   %edx
  8005b8:	50                   	push   %eax
  8005b9:	ff 75 0c             	pushl  0xc(%ebp)
  8005bc:	ff 75 08             	pushl  0x8(%ebp)
  8005bf:	e8 a1 ff ff ff       	call   800565 <printnum>
  8005c4:	83 c4 20             	add    $0x20,%esp
  8005c7:	eb 1a                	jmp    8005e3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	ff 75 20             	pushl  0x20(%ebp)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	ff d0                	call   *%eax
  8005d7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005da:	ff 4d 1c             	decl   0x1c(%ebp)
  8005dd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e1:	7f e6                	jg     8005c9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f1:	53                   	push   %ebx
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	e8 16 17 00 00       	call   801d10 <__umoddi3>
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	05 14 24 80 00       	add    $0x802414,%eax
  800602:	8a 00                	mov    (%eax),%al
  800604:	0f be c0             	movsbl %al,%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
}
  800616:	90                   	nop
  800617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061a:	c9                   	leave  
  80061b:	c3                   	ret    

0080061c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061c:	55                   	push   %ebp
  80061d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80061f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800623:	7e 1c                	jle    800641 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 08             	lea    0x8(%eax),%edx
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	83 e8 08             	sub    $0x8,%eax
  80063a:	8b 50 04             	mov    0x4(%eax),%edx
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	eb 40                	jmp    800681 <getuint+0x65>
	else if (lflag)
  800641:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800645:	74 1e                	je     800665 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	8d 50 04             	lea    0x4(%eax),%edx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	89 10                	mov    %edx,(%eax)
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	83 e8 04             	sub    $0x4,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	ba 00 00 00 00       	mov    $0x0,%edx
  800663:	eb 1c                	jmp    800681 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	8d 50 04             	lea    0x4(%eax),%edx
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	89 10                	mov    %edx,(%eax)
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	83 e8 04             	sub    $0x4,%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800681:	5d                   	pop    %ebp
  800682:	c3                   	ret    

00800683 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800686:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068a:	7e 1c                	jle    8006a8 <getint+0x25>
		return va_arg(*ap, long long);
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	8d 50 08             	lea    0x8(%eax),%edx
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	89 10                	mov    %edx,(%eax)
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	83 e8 08             	sub    $0x8,%eax
  8006a1:	8b 50 04             	mov    0x4(%eax),%edx
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	eb 38                	jmp    8006e0 <getint+0x5d>
	else if (lflag)
  8006a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ac:	74 1a                	je     8006c8 <getint+0x45>
		return va_arg(*ap, long);
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	8d 50 04             	lea    0x4(%eax),%edx
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	89 10                	mov    %edx,(%eax)
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	83 e8 04             	sub    $0x4,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	99                   	cltd   
  8006c6:	eb 18                	jmp    8006e0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 04             	lea    0x4(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 04             	sub    $0x4,%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	99                   	cltd   
}
  8006e0:	5d                   	pop    %ebp
  8006e1:	c3                   	ret    

008006e2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	56                   	push   %esi
  8006e6:	53                   	push   %ebx
  8006e7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	eb 17                	jmp    800703 <vprintfmt+0x21>
			if (ch == '\0')
  8006ec:	85 db                	test   %ebx,%ebx
  8006ee:	0f 84 c1 03 00 00    	je     800ab5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	53                   	push   %ebx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	8b 45 10             	mov    0x10(%ebp),%eax
  800706:	8d 50 01             	lea    0x1(%eax),%edx
  800709:	89 55 10             	mov    %edx,0x10(%ebp)
  80070c:	8a 00                	mov    (%eax),%al
  80070e:	0f b6 d8             	movzbl %al,%ebx
  800711:	83 fb 25             	cmp    $0x25,%ebx
  800714:	75 d6                	jne    8006ec <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800716:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80071a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800721:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800728:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80072f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800736:	8b 45 10             	mov    0x10(%ebp),%eax
  800739:	8d 50 01             	lea    0x1(%eax),%edx
  80073c:	89 55 10             	mov    %edx,0x10(%ebp)
  80073f:	8a 00                	mov    (%eax),%al
  800741:	0f b6 d8             	movzbl %al,%ebx
  800744:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800747:	83 f8 5b             	cmp    $0x5b,%eax
  80074a:	0f 87 3d 03 00 00    	ja     800a8d <vprintfmt+0x3ab>
  800750:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  800757:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800759:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80075d:	eb d7                	jmp    800736 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80075f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800763:	eb d1                	jmp    800736 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800765:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80076c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80076f:	89 d0                	mov    %edx,%eax
  800771:	c1 e0 02             	shl    $0x2,%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	01 c0                	add    %eax,%eax
  800778:	01 d8                	add    %ebx,%eax
  80077a:	83 e8 30             	sub    $0x30,%eax
  80077d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8a 00                	mov    (%eax),%al
  800785:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800788:	83 fb 2f             	cmp    $0x2f,%ebx
  80078b:	7e 3e                	jle    8007cb <vprintfmt+0xe9>
  80078d:	83 fb 39             	cmp    $0x39,%ebx
  800790:	7f 39                	jg     8007cb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800792:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800795:	eb d5                	jmp    80076c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ab:	eb 1f                	jmp    8007cc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b1:	79 83                	jns    800736 <vprintfmt+0x54>
				width = 0;
  8007b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ba:	e9 77 ff ff ff       	jmp    800736 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007bf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007c6:	e9 6b ff ff ff       	jmp    800736 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007cb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d0:	0f 89 60 ff ff ff    	jns    800736 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007e3:	e9 4e ff ff ff       	jmp    800736 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007eb:	e9 46 ff ff ff       	jmp    800736 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	83 c0 04             	add    $0x4,%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	50                   	push   %eax
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
			break;
  800810:	e9 9b 02 00 00       	jmp    800ab0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 c0 04             	add    $0x4,%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 e8 04             	sub    $0x4,%eax
  800824:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800826:	85 db                	test   %ebx,%ebx
  800828:	79 02                	jns    80082c <vprintfmt+0x14a>
				err = -err;
  80082a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80082c:	83 fb 64             	cmp    $0x64,%ebx
  80082f:	7f 0b                	jg     80083c <vprintfmt+0x15a>
  800831:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  800838:	85 f6                	test   %esi,%esi
  80083a:	75 19                	jne    800855 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80083c:	53                   	push   %ebx
  80083d:	68 25 24 80 00       	push   $0x802425
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	ff 75 08             	pushl  0x8(%ebp)
  800848:	e8 70 02 00 00       	call   800abd <printfmt>
  80084d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800850:	e9 5b 02 00 00       	jmp    800ab0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800855:	56                   	push   %esi
  800856:	68 2e 24 80 00       	push   $0x80242e
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	ff 75 08             	pushl  0x8(%ebp)
  800861:	e8 57 02 00 00       	call   800abd <printfmt>
  800866:	83 c4 10             	add    $0x10,%esp
			break;
  800869:	e9 42 02 00 00       	jmp    800ab0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 c0 04             	add    $0x4,%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 30                	mov    (%eax),%esi
  80087f:	85 f6                	test   %esi,%esi
  800881:	75 05                	jne    800888 <vprintfmt+0x1a6>
				p = "(null)";
  800883:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	7e 6d                	jle    8008fb <vprintfmt+0x219>
  80088e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800892:	74 67                	je     8008fb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	50                   	push   %eax
  80089b:	56                   	push   %esi
  80089c:	e8 1e 03 00 00       	call   800bbf <strnlen>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008a7:	eb 16                	jmp    8008bf <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008a9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	50                   	push   %eax
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bc:	ff 4d e4             	decl   -0x1c(%ebp)
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	7f e4                	jg     8008a9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c5:	eb 34                	jmp    8008fb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008cb:	74 1c                	je     8008e9 <vprintfmt+0x207>
  8008cd:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d0:	7e 05                	jle    8008d7 <vprintfmt+0x1f5>
  8008d2:	83 fb 7e             	cmp    $0x7e,%ebx
  8008d5:	7e 12                	jle    8008e9 <vprintfmt+0x207>
					putch('?', putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	6a 3f                	push   $0x3f
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	eb 0f                	jmp    8008f8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	53                   	push   %ebx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	89 f0                	mov    %esi,%eax
  8008fd:	8d 70 01             	lea    0x1(%eax),%esi
  800900:	8a 00                	mov    (%eax),%al
  800902:	0f be d8             	movsbl %al,%ebx
  800905:	85 db                	test   %ebx,%ebx
  800907:	74 24                	je     80092d <vprintfmt+0x24b>
  800909:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090d:	78 b8                	js     8008c7 <vprintfmt+0x1e5>
  80090f:	ff 4d e0             	decl   -0x20(%ebp)
  800912:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800916:	79 af                	jns    8008c7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800918:	eb 13                	jmp    80092d <vprintfmt+0x24b>
				putch(' ', putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	6a 20                	push   $0x20
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092a:	ff 4d e4             	decl   -0x1c(%ebp)
  80092d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800931:	7f e7                	jg     80091a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800933:	e9 78 01 00 00       	jmp    800ab0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 e8             	pushl  -0x18(%ebp)
  80093e:	8d 45 14             	lea    0x14(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	e8 3c fd ff ff       	call   800683 <getint>
  800947:	83 c4 10             	add    $0x10,%esp
  80094a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800956:	85 d2                	test   %edx,%edx
  800958:	79 23                	jns    80097d <vprintfmt+0x29b>
				putch('-', putdat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	6a 2d                	push   $0x2d
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80096a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800970:	f7 d8                	neg    %eax
  800972:	83 d2 00             	adc    $0x0,%edx
  800975:	f7 da                	neg    %edx
  800977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80097d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800984:	e9 bc 00 00 00       	jmp    800a45 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 e8             	pushl  -0x18(%ebp)
  80098f:	8d 45 14             	lea    0x14(%ebp),%eax
  800992:	50                   	push   %eax
  800993:	e8 84 fc ff ff       	call   80061c <getuint>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a8:	e9 98 00 00 00       	jmp    800a45 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	6a 58                	push   $0x58
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	6a 58                	push   $0x58
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 58                	push   $0x58
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			break;
  8009dd:	e9 ce 00 00 00       	jmp    800ab0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	6a 30                	push   $0x30
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	6a 78                	push   $0x78
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	83 c0 04             	add    $0x4,%eax
  800a08:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	83 e8 04             	sub    $0x4,%eax
  800a11:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a24:	eb 1f                	jmp    800a45 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2f:	50                   	push   %eax
  800a30:	e8 e7 fb ff ff       	call   80061c <getuint>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	52                   	push   %edx
  800a50:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a53:	50                   	push   %eax
  800a54:	ff 75 f4             	pushl  -0xc(%ebp)
  800a57:	ff 75 f0             	pushl  -0x10(%ebp)
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	e8 00 fb ff ff       	call   800565 <printnum>
  800a65:	83 c4 20             	add    $0x20,%esp
			break;
  800a68:	eb 46                	jmp    800ab0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	53                   	push   %ebx
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			break;
  800a79:	eb 35                	jmp    800ab0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a7b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a82:	eb 2c                	jmp    800ab0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a84:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800a8b:	eb 23                	jmp    800ab0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	6a 25                	push   $0x25
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a9d:	ff 4d 10             	decl   0x10(%ebp)
  800aa0:	eb 03                	jmp    800aa5 <vprintfmt+0x3c3>
  800aa2:	ff 4d 10             	decl   0x10(%ebp)
  800aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa8:	48                   	dec    %eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	3c 25                	cmp    $0x25,%al
  800aad:	75 f3                	jne    800aa2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aaf:	90                   	nop
		}
	}
  800ab0:	e9 35 fc ff ff       	jmp    8006ea <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ab5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad2:	50                   	push   %eax
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	ff 75 08             	pushl  0x8(%ebp)
  800ad9:	e8 04 fc ff ff       	call   8006e2 <vprintfmt>
  800ade:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae1:	90                   	nop
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 40 08             	mov    0x8(%eax),%eax
  800aed:	8d 50 01             	lea    0x1(%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	8b 10                	mov    (%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 40 04             	mov    0x4(%eax),%eax
  800b01:	39 c2                	cmp    %eax,%edx
  800b03:	73 12                	jae    800b17 <sprintputch+0x33>
		*b->buf++ = ch;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	89 0a                	mov    %ecx,(%edx)
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	88 10                	mov    %dl,(%eax)
}
  800b17:	90                   	nop
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	01 d0                	add    %edx,%eax
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b3f:	74 06                	je     800b47 <vsnprintf+0x2d>
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	7f 07                	jg     800b4e <vsnprintf+0x34>
		return -E_INVAL;
  800b47:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4c:	eb 20                	jmp    800b6e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b4e:	ff 75 14             	pushl  0x14(%ebp)
  800b51:	ff 75 10             	pushl  0x10(%ebp)
  800b54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b57:	50                   	push   %eax
  800b58:	68 e4 0a 80 00       	push   $0x800ae4
  800b5d:	e8 80 fb ff ff       	call   8006e2 <vprintfmt>
  800b62:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b76:	8d 45 10             	lea    0x10(%ebp),%eax
  800b79:	83 c0 04             	add    $0x4,%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	50                   	push   %eax
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	ff 75 08             	pushl  0x8(%ebp)
  800b8c:	e8 89 ff ff ff       	call   800b1a <vsnprintf>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba9:	eb 06                	jmp    800bb1 <strlen+0x15>
		n++;
  800bab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bae:	ff 45 08             	incl   0x8(%ebp)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8a 00                	mov    (%eax),%al
  800bb6:	84 c0                	test   %al,%al
  800bb8:	75 f1                	jne    800bab <strlen+0xf>
		n++;
	return n;
  800bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcc:	eb 09                	jmp    800bd7 <strnlen+0x18>
		n++;
  800bce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd1:	ff 45 08             	incl   0x8(%ebp)
  800bd4:	ff 4d 0c             	decl   0xc(%ebp)
  800bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdb:	74 09                	je     800be6 <strnlen+0x27>
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e8                	jne    800bce <strnlen+0xf>
		n++;
	return n;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf7:	90                   	nop
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0a:	8a 12                	mov    (%edx),%dl
  800c0c:	88 10                	mov    %dl,(%eax)
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	84 c0                	test   %al,%al
  800c12:	75 e4                	jne    800bf8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 1f                	jmp    800c4d <strncpy+0x34>
		*dst++ = *src;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 08             	mov    %edx,0x8(%ebp)
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	8a 12                	mov    (%edx),%dl
  800c3c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	74 03                	je     800c4a <strncpy+0x31>
			src++;
  800c47:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4a:	ff 45 fc             	incl   -0x4(%ebp)
  800c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c50:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c53:	72 d9                	jb     800c2e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	74 30                	je     800c9c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c6c:	eb 16                	jmp    800c84 <strlcpy+0x2a>
			*dst++ = *src++;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 08             	mov    %edx,0x8(%ebp)
  800c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c80:	8a 12                	mov    (%edx),%dl
  800c82:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c84:	ff 4d 10             	decl   0x10(%ebp)
  800c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8b:	74 09                	je     800c96 <strlcpy+0x3c>
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 d8                	jne    800c6e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	29 c2                	sub    %eax,%edx
  800ca4:	89 d0                	mov    %edx,%eax
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cab:	eb 06                	jmp    800cb3 <strcmp+0xb>
		p++, q++;
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	74 0e                	je     800cca <strcmp+0x22>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 10                	mov    (%eax),%dl
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	38 c2                	cmp    %al,%dl
  800cc8:	74 e3                	je     800cad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 d0             	movzbl %al,%edx
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	29 c2                	sub    %eax,%edx
  800cdc:	89 d0                	mov    %edx,%eax
}
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce3:	eb 09                	jmp    800cee <strncmp+0xe>
		n--, p++, q++;
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf2:	74 17                	je     800d0b <strncmp+0x2b>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	84 c0                	test   %al,%al
  800cfb:	74 0e                	je     800d0b <strncmp+0x2b>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 10                	mov    (%eax),%dl
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	38 c2                	cmp    %al,%dl
  800d09:	74 da                	je     800ce5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0f:	75 07                	jne    800d18 <strncmp+0x38>
		return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	eb 14                	jmp    800d2c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	29 c2                	sub    %eax,%edx
  800d2a:	89 d0                	mov    %edx,%eax
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3a:	eb 12                	jmp    800d4e <strchr+0x20>
		if (*s == c)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d44:	75 05                	jne    800d4b <strchr+0x1d>
			return (char *) s;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	eb 11                	jmp    800d5c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	75 e5                	jne    800d3c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6a:	eb 0d                	jmp    800d79 <strfind+0x1b>
		if (*s == c)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d74:	74 0e                	je     800d84 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 ea                	jne    800d6c <strfind+0xe>
  800d82:	eb 01                	jmp    800d85 <strfind+0x27>
		if (*s == c)
			break;
  800d84:	90                   	nop
	return (char *) s;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800d96:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d9a:	76 63                	jbe    800dff <memset+0x75>
		uint64 data_block = c;
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	99                   	cltd   
  800da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dac:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800db0:	c1 e0 08             	shl    $0x8,%eax
  800db3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800db6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbf:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dc3:	c1 e0 10             	shl    $0x10,%eax
  800dc6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dc9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd2:	89 c2                	mov    %eax,%edx
  800dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ddc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ddf:	eb 18                	jmp    800df9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800de1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800de4:	8d 41 08             	lea    0x8(%ecx),%eax
  800de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df0:	89 01                	mov    %eax,(%ecx)
  800df2:	89 51 04             	mov    %edx,0x4(%ecx)
  800df5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800df9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfd:	77 e2                	ja     800de1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e03:	74 23                	je     800e28 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e08:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e0b:	eb 0e                	jmp    800e1b <memset+0x91>
			*p8++ = (uint8)c;
  800e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e10:	8d 50 01             	lea    0x1(%eax),%edx
  800e13:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e19:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e21:	89 55 10             	mov    %edx,0x10(%ebp)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	75 e5                	jne    800e0d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e3f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e43:	76 24                	jbe    800e69 <memcpy+0x3c>
		while(n >= 8){
  800e45:	eb 1c                	jmp    800e63 <memcpy+0x36>
			*d64 = *s64;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4a:	8b 50 04             	mov    0x4(%eax),%edx
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e52:	89 01                	mov    %eax,(%ecx)
  800e54:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e57:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e5b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e5f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e63:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e67:	77 de                	ja     800e47 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6d:	74 31                	je     800ea0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x66>
			*d8++ = *s8++;
  800e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80115d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801161:	75 bb                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801163:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116d:	48                   	dec    %eax
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801171:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801175:	74 3d                	je     8011b4 <ltostr+0xc3>
		start = 1 ;
  801177:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80117e:	eb 34                	jmp    8011b4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 d0                	add    %edx,%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 c8                	add    %ecx,%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	01 c2                	add    %eax,%edx
  8011a9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011ac:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ae:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011b1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ba:	7c c4                	jl     801180 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011c7:	90                   	nop
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011d0:	ff 75 08             	pushl  0x8(%ebp)
  8011d3:	e8 c4 f9 ff ff       	call   800b9c <strlen>
  8011d8:	83 c4 04             	add    $0x4,%esp
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	e8 b6 f9 ff ff       	call   800b9c <strlen>
  8011e6:	83 c4 04             	add    $0x4,%esp
  8011e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011fa:	eb 17                	jmp    801213 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	01 c2                	add    %eax,%edx
  801204:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	01 c8                	add    %ecx,%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801210:	ff 45 fc             	incl   -0x4(%ebp)
  801213:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801216:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801219:	7c e1                	jl     8011fc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80121b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801222:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801229:	eb 1f                	jmp    80124a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80122b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801234:	89 c2                	mov    %eax,%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c8                	add    %ecx,%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801247:	ff 45 f8             	incl   -0x8(%ebp)
  80124a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801250:	7c d9                	jl     80122b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	c6 00 00             	movb   $0x0,(%eax)
}
  80125d:	90                   	nop
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801283:	eb 0c                	jmp    801291 <strsplit+0x31>
			*string++ = 0;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	84 c0                	test   %al,%al
  801298:	74 18                	je     8012b2 <strsplit+0x52>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	0f be c0             	movsbl %al,%eax
  8012a2:	50                   	push   %eax
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	e8 83 fa ff ff       	call   800d2e <strchr>
  8012ab:	83 c4 08             	add    $0x8,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	75 d3                	jne    801285 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	84 c0                	test   %al,%al
  8012b9:	74 5a                	je     801315 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012be:	8b 00                	mov    (%eax),%eax
  8012c0:	83 f8 0f             	cmp    $0xf,%eax
  8012c3:	75 07                	jne    8012cc <strsplit+0x6c>
		{
			return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ca:	eb 66                	jmp    801332 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d4:	8b 55 14             	mov    0x14(%ebp),%edx
  8012d7:	89 0a                	mov    %ecx,(%edx)
  8012d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 c2                	add    %eax,%edx
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ea:	eb 03                	jmp    8012ef <strsplit+0x8f>
			string++;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	84 c0                	test   %al,%al
  8012f6:	74 8b                	je     801283 <strsplit+0x23>
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f be c0             	movsbl %al,%eax
  801300:	50                   	push   %eax
  801301:	ff 75 0c             	pushl  0xc(%ebp)
  801304:	e8 25 fa ff ff       	call   800d2e <strchr>
  801309:	83 c4 08             	add    $0x8,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	74 dc                	je     8012ec <strsplit+0x8c>
			string++;
	}
  801310:	e9 6e ff ff ff       	jmp    801283 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801315:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801316:	8b 45 14             	mov    0x14(%ebp),%eax
  801319:	8b 00                	mov    (%eax),%eax
  80131b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80132d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801347:	eb 4a                	jmp    801393 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801349:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	01 c2                	add    %eax,%edx
  801351:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	01 c8                	add    %ecx,%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80135d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 40                	cmp    $0x40,%al
  801369:	7e 25                	jle    801390 <str2lower+0x5c>
  80136b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	3c 5a                	cmp    $0x5a,%al
  801377:	7f 17                	jg     801390 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801379:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
  801387:	01 ca                	add    %ecx,%edx
  801389:	8a 12                	mov    (%edx),%dl
  80138b:	83 c2 20             	add    $0x20,%edx
  80138e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801390:	ff 45 fc             	incl   -0x4(%ebp)
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	e8 01 f8 ff ff       	call   800b9c <strlen>
  80139b:	83 c4 04             	add    $0x4,%esp
  80139e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013a1:	7f a6                	jg     801349 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013c3:	cd 30                	int    $0x30
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	5b                   	pop    %ebx
  8013cf:	5e                   	pop    %esi
  8013d0:	5f                   	pop    %edi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	6a 00                	push   $0x0
  8013eb:	51                   	push   %ecx
  8013ec:	52                   	push   %edx
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	50                   	push   %eax
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 b0 ff ff ff       	call   8013a8 <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
}
  8013fb:	90                   	nop
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 02                	push   $0x2
  80140d:	e8 96 ff ff ff       	call   8013a8 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 03                	push   $0x3
  801426:	e8 7d ff ff ff       	call   8013a8 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	90                   	nop
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 04                	push   $0x4
  801440:	e8 63 ff ff ff       	call   8013a8 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	90                   	nop
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80144e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	52                   	push   %edx
  80145b:	50                   	push   %eax
  80145c:	6a 08                	push   $0x8
  80145e:	e8 45 ff ff ff       	call   8013a8 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	56                   	push   %esi
  80146c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80146d:	8b 75 18             	mov    0x18(%ebp),%esi
  801470:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801473:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801476:	8b 55 0c             	mov    0xc(%ebp),%edx
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	56                   	push   %esi
  80147d:	53                   	push   %ebx
  80147e:	51                   	push   %ecx
  80147f:	52                   	push   %edx
  801480:	50                   	push   %eax
  801481:	6a 09                	push   $0x9
  801483:	e8 20 ff ff ff       	call   8013a8 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    

00801492 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	ff 75 08             	pushl  0x8(%ebp)
  8014a0:	6a 0a                	push   $0xa
  8014a2:	e8 01 ff ff ff       	call   8013a8 <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	6a 0b                	push   $0xb
  8014bd:	e8 e6 fe ff ff       	call   8013a8 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 0c                	push   $0xc
  8014d6:	e8 cd fe ff ff       	call   8013a8 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 0d                	push   $0xd
  8014ef:	e8 b4 fe ff ff       	call   8013a8 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 0e                	push   $0xe
  801508:	e8 9b fe ff ff       	call   8013a8 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 0f                	push   $0xf
  801521:	e8 82 fe ff ff       	call   8013a8 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	6a 10                	push   $0x10
  80153b:	e8 68 fe ff ff       	call   8013a8 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 11                	push   $0x11
  801554:	e8 4f fe ff ff       	call   8013a8 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_cputc>:

void
sys_cputc(const char c)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80156b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	50                   	push   %eax
  801578:	6a 01                	push   $0x1
  80157a:	e8 29 fe ff ff       	call   8013a8 <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
}
  801582:	90                   	nop
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 14                	push   $0x14
  801594:	e8 0f fe ff ff       	call   8013a8 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	90                   	nop
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	6a 00                	push   $0x0
  8015b7:	51                   	push   %ecx
  8015b8:	52                   	push   %edx
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	50                   	push   %eax
  8015bd:	6a 15                	push   $0x15
  8015bf:	e8 e4 fd ff ff       	call   8013a8 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	6a 16                	push   $0x16
  8015dc:	e8 c7 fd ff ff       	call   8013a8 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	51                   	push   %ecx
  8015f7:	52                   	push   %edx
  8015f8:	50                   	push   %eax
  8015f9:	6a 17                	push   $0x17
  8015fb:	e8 a8 fd ff ff       	call   8013a8 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	52                   	push   %edx
  801615:	50                   	push   %eax
  801616:	6a 18                	push   $0x18
  801618:	e8 8b fd ff ff       	call   8013a8 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	6a 00                	push   $0x0
  80162a:	ff 75 14             	pushl  0x14(%ebp)
  80162d:	ff 75 10             	pushl  0x10(%ebp)
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	50                   	push   %eax
  801634:	6a 19                	push   $0x19
  801636:	e8 6d fd ff ff       	call   8013a8 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	50                   	push   %eax
  80164f:	6a 1a                	push   $0x1a
  801651:	e8 52 fd ff ff       	call   8013a8 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	50                   	push   %eax
  80166b:	6a 1b                	push   $0x1b
  80166d:	e8 36 fd ff ff       	call   8013a8 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 05                	push   $0x5
  801686:	e8 1d fd ff ff       	call   8013a8 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 06                	push   $0x6
  80169f:	e8 04 fd ff ff       	call   8013a8 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 07                	push   $0x7
  8016b8:	e8 eb fc ff ff       	call   8013a8 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_exit_env>:


void sys_exit_env(void)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 1c                	push   $0x1c
  8016d1:	e8 d2 fc ff ff       	call   8013a8 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	90                   	nop
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016e5:	8d 50 04             	lea    0x4(%eax),%edx
  8016e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	52                   	push   %edx
  8016f2:	50                   	push   %eax
  8016f3:	6a 1d                	push   $0x1d
  8016f5:	e8 ae fc ff ff       	call   8013a8 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return result;
  8016fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801700:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801703:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801706:	89 01                	mov    %eax,(%ecx)
  801708:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	c9                   	leave  
  80170f:	c2 04 00             	ret    $0x4

00801712 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	ff 75 10             	pushl  0x10(%ebp)
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	6a 13                	push   $0x13
  801724:	e8 7f fc ff ff       	call   8013a8 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return ;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_rcr2>:
uint32 sys_rcr2()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 1e                	push   $0x1e
  80173e:	e8 65 fc ff ff       	call   8013a8 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801754:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	50                   	push   %eax
  801761:	6a 1f                	push   $0x1f
  801763:	e8 40 fc ff ff       	call   8013a8 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
	return ;
  80176b:	90                   	nop
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <rsttst>:
void rsttst()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 21                	push   $0x21
  80177d:	e8 26 fc ff ff       	call   8013a8 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return ;
  801785:	90                   	nop
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	8b 45 14             	mov    0x14(%ebp),%eax
  801791:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801794:	8b 55 18             	mov    0x18(%ebp),%edx
  801797:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	ff 75 10             	pushl  0x10(%ebp)
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	6a 20                	push   $0x20
  8017a8:	e8 fb fb ff ff       	call   8013a8 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <chktst>:
void chktst(uint32 n)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	6a 22                	push   $0x22
  8017c3:	e8 e0 fb ff ff       	call   8013a8 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cb:	90                   	nop
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <inctst>:

void inctst()
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 23                	push   $0x23
  8017dd:	e8 c6 fb ff ff       	call   8013a8 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e5:	90                   	nop
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <gettst>:
uint32 gettst()
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 24                	push   $0x24
  8017f7:	e8 ac fb ff ff       	call   8013a8 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 25                	push   $0x25
  801810:	e8 93 fb ff ff       	call   8013a8 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
  801818:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80181d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	6a 26                	push   $0x26
  80183c:	e8 67 fb ff ff       	call   8013a8 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
	return ;
  801844:	90                   	nop
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80184b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	53                   	push   %ebx
  80185a:	51                   	push   %ecx
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 27                	push   $0x27
  80185f:	e8 44 fb ff ff       	call   8013a8 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 28                	push   $0x28
  80187f:	e8 24 fb ff ff       	call   8013a8 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80188c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	51                   	push   %ecx
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 29                	push   $0x29
  80189f:	e8 04 fb ff ff       	call   8013a8 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	6a 12                	push   $0x12
  8018bb:	e8 e8 fa ff ff       	call   8013a8 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c3:	90                   	nop
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 2a                	push   $0x2a
  8018d9:	e8 ca fa ff ff       	call   8013a8 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
	return;
  8018e1:	90                   	nop
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 2b                	push   $0x2b
  8018f3:	e8 b0 fa ff ff       	call   8013a8 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 2d                	push   $0x2d
  80190e:	e8 95 fa ff ff       	call   8013a8 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 2c                	push   $0x2c
  80192a:	e8 79 fa ff ff       	call   8013a8 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 a8 25 80 00       	push   $0x8025a8
  801943:	68 25 01 00 00       	push   $0x125
  801948:	68 db 25 80 00       	push   $0x8025db
  80194d:	e8 be 00 00 00       	call   801a10 <_panic>

00801952 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801958:	8b 55 08             	mov    0x8(%ebp),%edx
  80195b:	89 d0                	mov    %edx,%eax
  80195d:	c1 e0 02             	shl    $0x2,%eax
  801960:	01 d0                	add    %edx,%eax
  801962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801969:	01 d0                	add    %edx,%eax
  80196b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801972:	01 d0                	add    %edx,%eax
  801974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197b:	01 d0                	add    %edx,%eax
  80197d:	c1 e0 04             	shl    $0x4,%eax
  801980:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801983:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80198a:	0f 31                	rdtsc  
  80198c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80198f:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801995:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801998:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80199b:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80199e:	eb 46                	jmp    8019e6 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019a0:	0f 31                	rdtsc  
  8019a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8019a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	29 c2                	sub    %eax,%edx
  8019bc:	89 d0                	mov    %edx,%eax
  8019be:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	89 d1                	mov    %edx,%ecx
  8019c9:	29 c1                	sub    %eax,%ecx
  8019cb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d1:	39 c2                	cmp    %eax,%edx
  8019d3:	0f 97 c0             	seta   %al
  8019d6:	0f b6 c0             	movzbl %al,%eax
  8019d9:	29 c1                	sub    %eax,%ecx
  8019db:	89 c8                	mov    %ecx,%eax
  8019dd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019ec:	72 b2                	jb     8019a0 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019fe:	eb 03                	jmp    801a03 <busy_wait+0x12>
  801a00:	ff 45 fc             	incl   -0x4(%ebp)
  801a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a09:	72 f5                	jb     801a00 <busy_wait+0xf>
	return i;
  801a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a16:	8d 45 10             	lea    0x10(%ebp),%eax
  801a19:	83 c0 04             	add    $0x4,%eax
  801a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a1f:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 16                	je     801a3e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a28:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	50                   	push   %eax
  801a31:	68 ec 25 80 00       	push   $0x8025ec
  801a36:	e8 88 ea ff ff       	call   8004c3 <cprintf>
  801a3b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a3e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	68 f4 25 80 00       	push   $0x8025f4
  801a52:	6a 74                	push   $0x74
  801a54:	e8 97 ea ff ff       	call   8004f0 <cprintf_colored>
  801a59:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	ff 75 f4             	pushl  -0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	e8 e9 e9 ff ff       	call   800454 <vcprintf>
  801a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a6e:	83 ec 08             	sub    $0x8,%esp
  801a71:	6a 00                	push   $0x0
  801a73:	68 1c 26 80 00       	push   $0x80261c
  801a78:	e8 d7 e9 ff ff       	call   800454 <vcprintf>
  801a7d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a80:	e8 50 e9 ff ff       	call   8003d5 <exit>

	// should not return here
	while (1) ;
  801a85:	eb fe                	jmp    801a85 <_panic+0x75>

00801a87 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a8d:	a1 20 30 80 00       	mov    0x803020,%eax
  801a92:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9b:	39 c2                	cmp    %eax,%edx
  801a9d:	74 14                	je     801ab3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	68 20 26 80 00       	push   $0x802620
  801aa7:	6a 26                	push   $0x26
  801aa9:	68 6c 26 80 00       	push   $0x80266c
  801aae:	e8 5d ff ff ff       	call   801a10 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801aba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ac1:	e9 c5 00 00 00       	jmp    801b8b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	75 08                	jne    801ae3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801adb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ade:	e9 a5 00 00 00       	jmp    801b88 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801ae3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801af1:	eb 69                	jmp    801b5c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801af3:	a1 20 30 80 00       	mov    0x803020,%eax
  801af8:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801afe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b01:	89 d0                	mov    %edx,%eax
  801b03:	01 c0                	add    %eax,%eax
  801b05:	01 d0                	add    %edx,%eax
  801b07:	c1 e0 03             	shl    $0x3,%eax
  801b0a:	01 c8                	add    %ecx,%eax
  801b0c:	8a 40 04             	mov    0x4(%eax),%al
  801b0f:	84 c0                	test   %al,%al
  801b11:	75 46                	jne    801b59 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b13:	a1 20 30 80 00       	mov    0x803020,%eax
  801b18:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b21:	89 d0                	mov    %edx,%eax
  801b23:	01 c0                	add    %eax,%eax
  801b25:	01 d0                	add    %edx,%eax
  801b27:	c1 e0 03             	shl    $0x3,%eax
  801b2a:	01 c8                	add    %ecx,%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b39:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	01 c8                	add    %ecx,%eax
  801b4a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b4c:	39 c2                	cmp    %eax,%edx
  801b4e:	75 09                	jne    801b59 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b50:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b57:	eb 15                	jmp    801b6e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b59:	ff 45 e8             	incl   -0x18(%ebp)
  801b5c:	a1 20 30 80 00       	mov    0x803020,%eax
  801b61:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b6a:	39 c2                	cmp    %eax,%edx
  801b6c:	77 85                	ja     801af3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b72:	75 14                	jne    801b88 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	68 78 26 80 00       	push   $0x802678
  801b7c:	6a 3a                	push   $0x3a
  801b7e:	68 6c 26 80 00       	push   $0x80266c
  801b83:	e8 88 fe ff ff       	call   801a10 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b88:	ff 45 f0             	incl   -0x10(%ebp)
  801b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b91:	0f 8c 2f ff ff ff    	jl     801ac6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ba5:	eb 26                	jmp    801bcd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ba7:	a1 20 30 80 00       	mov    0x803020,%eax
  801bac:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb5:	89 d0                	mov    %edx,%eax
  801bb7:	01 c0                	add    %eax,%eax
  801bb9:	01 d0                	add    %edx,%eax
  801bbb:	c1 e0 03             	shl    $0x3,%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 40 04             	mov    0x4(%eax),%al
  801bc3:	3c 01                	cmp    $0x1,%al
  801bc5:	75 03                	jne    801bca <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bc7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bca:	ff 45 e0             	incl   -0x20(%ebp)
  801bcd:	a1 20 30 80 00       	mov    0x803020,%eax
  801bd2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bdb:	39 c2                	cmp    %eax,%edx
  801bdd:	77 c8                	ja     801ba7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801be5:	74 14                	je     801bfb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	68 cc 26 80 00       	push   $0x8026cc
  801bef:	6a 44                	push   $0x44
  801bf1:	68 6c 26 80 00       	push   $0x80266c
  801bf6:	e8 15 fe ff ff       	call   801a10 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    
  801bfe:	66 90                	xchg   %ax,%ax

00801c00 <__udivdi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c17:	89 ca                	mov    %ecx,%edx
  801c19:	89 f8                	mov    %edi,%eax
  801c1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c1f:	85 f6                	test   %esi,%esi
  801c21:	75 2d                	jne    801c50 <__udivdi3+0x50>
  801c23:	39 cf                	cmp    %ecx,%edi
  801c25:	77 65                	ja     801c8c <__udivdi3+0x8c>
  801c27:	89 fd                	mov    %edi,%ebp
  801c29:	85 ff                	test   %edi,%edi
  801c2b:	75 0b                	jne    801c38 <__udivdi3+0x38>
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	31 d2                	xor    %edx,%edx
  801c34:	f7 f7                	div    %edi
  801c36:	89 c5                	mov    %eax,%ebp
  801c38:	31 d2                	xor    %edx,%edx
  801c3a:	89 c8                	mov    %ecx,%eax
  801c3c:	f7 f5                	div    %ebp
  801c3e:	89 c1                	mov    %eax,%ecx
  801c40:	89 d8                	mov    %ebx,%eax
  801c42:	f7 f5                	div    %ebp
  801c44:	89 cf                	mov    %ecx,%edi
  801c46:	89 fa                	mov    %edi,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 ce                	cmp    %ecx,%esi
  801c52:	77 28                	ja     801c7c <__udivdi3+0x7c>
  801c54:	0f bd fe             	bsr    %esi,%edi
  801c57:	83 f7 1f             	xor    $0x1f,%edi
  801c5a:	75 40                	jne    801c9c <__udivdi3+0x9c>
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	72 0a                	jb     801c6a <__udivdi3+0x6a>
  801c60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c64:	0f 87 9e 00 00 00    	ja     801d08 <__udivdi3+0x108>
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	89 fa                	mov    %edi,%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d 76 00             	lea    0x0(%esi),%esi
  801c7c:	31 ff                	xor    %edi,%edi
  801c7e:	31 c0                	xor    %eax,%eax
  801c80:	89 fa                	mov    %edi,%edx
  801c82:	83 c4 1c             	add    $0x1c,%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	f7 f7                	div    %edi
  801c90:	31 ff                	xor    %edi,%edi
  801c92:	89 fa                	mov    %edi,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ca1:	89 eb                	mov    %ebp,%ebx
  801ca3:	29 fb                	sub    %edi,%ebx
  801ca5:	89 f9                	mov    %edi,%ecx
  801ca7:	d3 e6                	shl    %cl,%esi
  801ca9:	89 c5                	mov    %eax,%ebp
  801cab:	88 d9                	mov    %bl,%cl
  801cad:	d3 ed                	shr    %cl,%ebp
  801caf:	89 e9                	mov    %ebp,%ecx
  801cb1:	09 f1                	or     %esi,%ecx
  801cb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cb7:	89 f9                	mov    %edi,%ecx
  801cb9:	d3 e0                	shl    %cl,%eax
  801cbb:	89 c5                	mov    %eax,%ebp
  801cbd:	89 d6                	mov    %edx,%esi
  801cbf:	88 d9                	mov    %bl,%cl
  801cc1:	d3 ee                	shr    %cl,%esi
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e2                	shl    %cl,%edx
  801cc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 e8                	shr    %cl,%eax
  801ccf:	09 c2                	or     %eax,%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	89 f2                	mov    %esi,%edx
  801cd5:	f7 74 24 0c          	divl   0xc(%esp)
  801cd9:	89 d6                	mov    %edx,%esi
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	f7 e5                	mul    %ebp
  801cdf:	39 d6                	cmp    %edx,%esi
  801ce1:	72 19                	jb     801cfc <__udivdi3+0xfc>
  801ce3:	74 0b                	je     801cf0 <__udivdi3+0xf0>
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	31 ff                	xor    %edi,%edi
  801ce9:	e9 58 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cf4:	89 f9                	mov    %edi,%ecx
  801cf6:	d3 e2                	shl    %cl,%edx
  801cf8:	39 c2                	cmp    %eax,%edx
  801cfa:	73 e9                	jae    801ce5 <__udivdi3+0xe5>
  801cfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 40 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	31 c0                	xor    %eax,%eax
  801d0a:	e9 37 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d0f:	90                   	nop

00801d10 <__umoddi3>:
  801d10:	55                   	push   %ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d2f:	89 f3                	mov    %esi,%ebx
  801d31:	89 fa                	mov    %edi,%edx
  801d33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d37:	89 34 24             	mov    %esi,(%esp)
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	75 1a                	jne    801d58 <__umoddi3+0x48>
  801d3e:	39 f7                	cmp    %esi,%edi
  801d40:	0f 86 a2 00 00 00    	jbe    801de8 <__umoddi3+0xd8>
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	89 f2                	mov    %esi,%edx
  801d4a:	f7 f7                	div    %edi
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	31 d2                	xor    %edx,%edx
  801d50:	83 c4 1c             	add    $0x1c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	39 f0                	cmp    %esi,%eax
  801d5a:	0f 87 ac 00 00 00    	ja     801e0c <__umoddi3+0xfc>
  801d60:	0f bd e8             	bsr    %eax,%ebp
  801d63:	83 f5 1f             	xor    $0x1f,%ebp
  801d66:	0f 84 ac 00 00 00    	je     801e18 <__umoddi3+0x108>
  801d6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d71:	29 ef                	sub    %ebp,%edi
  801d73:	89 fe                	mov    %edi,%esi
  801d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d79:	89 e9                	mov    %ebp,%ecx
  801d7b:	d3 e0                	shl    %cl,%eax
  801d7d:	89 d7                	mov    %edx,%edi
  801d7f:	89 f1                	mov    %esi,%ecx
  801d81:	d3 ef                	shr    %cl,%edi
  801d83:	09 c7                	or     %eax,%edi
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e2                	shl    %cl,%edx
  801d89:	89 14 24             	mov    %edx,(%esp)
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	d3 e0                	shl    %cl,%eax
  801d90:	89 c2                	mov    %eax,%edx
  801d92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d96:	d3 e0                	shl    %cl,%eax
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da0:	89 f1                	mov    %esi,%ecx
  801da2:	d3 e8                	shr    %cl,%eax
  801da4:	09 d0                	or     %edx,%eax
  801da6:	d3 eb                	shr    %cl,%ebx
  801da8:	89 da                	mov    %ebx,%edx
  801daa:	f7 f7                	div    %edi
  801dac:	89 d3                	mov    %edx,%ebx
  801dae:	f7 24 24             	mull   (%esp)
  801db1:	89 c6                	mov    %eax,%esi
  801db3:	89 d1                	mov    %edx,%ecx
  801db5:	39 d3                	cmp    %edx,%ebx
  801db7:	0f 82 87 00 00 00    	jb     801e44 <__umoddi3+0x134>
  801dbd:	0f 84 91 00 00 00    	je     801e54 <__umoddi3+0x144>
  801dc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dc7:	29 f2                	sub    %esi,%edx
  801dc9:	19 cb                	sbb    %ecx,%ebx
  801dcb:	89 d8                	mov    %ebx,%eax
  801dcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dd1:	d3 e0                	shl    %cl,%eax
  801dd3:	89 e9                	mov    %ebp,%ecx
  801dd5:	d3 ea                	shr    %cl,%edx
  801dd7:	09 d0                	or     %edx,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 eb                	shr    %cl,%ebx
  801ddd:	89 da                	mov    %ebx,%edx
  801ddf:	83 c4 1c             	add    $0x1c,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    
  801de7:	90                   	nop
  801de8:	89 fd                	mov    %edi,%ebp
  801dea:	85 ff                	test   %edi,%edi
  801dec:	75 0b                	jne    801df9 <__umoddi3+0xe9>
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f7                	div    %edi
  801df7:	89 c5                	mov    %eax,%ebp
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	f7 f5                	div    %ebp
  801dff:	89 c8                	mov    %ecx,%eax
  801e01:	f7 f5                	div    %ebp
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	e9 44 ff ff ff       	jmp    801d4e <__umoddi3+0x3e>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	89 c8                	mov    %ecx,%eax
  801e0e:	89 f2                	mov    %esi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	3b 04 24             	cmp    (%esp),%eax
  801e1b:	72 06                	jb     801e23 <__umoddi3+0x113>
  801e1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e21:	77 0f                	ja     801e32 <__umoddi3+0x122>
  801e23:	89 f2                	mov    %esi,%edx
  801e25:	29 f9                	sub    %edi,%ecx
  801e27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e2b:	89 14 24             	mov    %edx,(%esp)
  801e2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e36:	8b 14 24             	mov    (%esp),%edx
  801e39:	83 c4 1c             	add    $0x1c,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
  801e41:	8d 76 00             	lea    0x0(%esi),%esi
  801e44:	2b 04 24             	sub    (%esp),%eax
  801e47:	19 fa                	sbb    %edi,%edx
  801e49:	89 d1                	mov    %edx,%ecx
  801e4b:	89 c6                	mov    %eax,%esi
  801e4d:	e9 71 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e58:	72 ea                	jb     801e44 <__umoddi3+0x134>
  801e5a:	89 d9                	mov    %ebx,%ecx
  801e5c:	e9 62 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>

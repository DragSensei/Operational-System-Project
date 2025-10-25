
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 de 09 00 00       	call   800a14 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 54 1f 00 00       	call   801fb7 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 a0 2a 80 00       	push   $0x802aa0
  80006b:	e8 34 0c 00 00       	call   800ca4 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a4 2a 80 00       	push   $0x802aa4
  80007b:	e8 24 0c 00 00       	call   800ca4 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 c8 2a 80 00       	push   $0x802ac8
  80008b:	e8 14 0c 00 00       	call   800ca4 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 a4 2a 80 00       	push   $0x802aa4
  80009b:	e8 04 0c 00 00       	call   800ca4 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 a0 2a 80 00       	push   $0x802aa0
  8000ab:	e8 f4 0b 00 00       	call   800ca4 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 ec 2a 80 00       	push   $0x802aec
  8000c2:	e8 b6 12 00 00       	call   80137d <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 b7 18 00 00       	call   801994 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 0c 2b 80 00       	push   $0x802b0c
  8000eb:	e8 b4 0b 00 00       	call   800ca4 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 2e 2b 80 00       	push   $0x802b2e
  8000fb:	e8 a4 0b 00 00       	call   800ca4 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 3c 2b 80 00       	push   $0x802b3c
  80010b:	e8 94 0b 00 00       	call   800ca4 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 4a 2b 80 00       	push   $0x802b4a
  80011b:	e8 84 0b 00 00       	call   800ca4 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 5a 2b 80 00       	push   $0x802b5a
  80012b:	e8 74 0b 00 00       	call   800ca4 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 bf 08 00 00       	call   8009f7 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 90 08 00 00       	call   8009d8 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 83 08 00 00       	call   8009d8 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 64 2b 80 00       	push   $0x802b64
  80017f:	e8 f9 11 00 00       	call   80137d <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 fa 17 00 00       	call   801994 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 2c 1e 00 00       	call   801fd1 <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 ba 1c 00 00       	call   801e6e <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 a5 1c 00 00       	call   801e6e <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 77 1c 00 00       	call   801e6e <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 53 1c 00 00       	call   801e6e <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 e0 1c 00 00       	call   801fb7 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 88 2b 80 00       	push   $0x802b88
  8002df:	e8 c0 09 00 00       	call   800ca4 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 a6 2b 80 00       	push   $0x802ba6
  8002ef:	e8 b0 09 00 00       	call   800ca4 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 bd 2b 80 00       	push   $0x802bbd
  8002ff:	e8 a0 09 00 00       	call   800ca4 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 d4 2b 80 00       	push   $0x802bd4
  80030f:	e8 90 09 00 00       	call   800ca4 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 5a 2b 80 00       	push   $0x802b5a
  80031f:	e8 80 09 00 00       	call   800ca4 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 cb 06 00 00       	call   8009f7 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 9c 06 00 00       	call   8009d8 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 8f 06 00 00       	call   8009d8 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 6e 1c 00 00       	call   801fd1 <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 d3 1b 00 00       	call   801fb7 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 eb 2b 80 00       	push   $0x802beb
  8003ec:	e8 b3 08 00 00       	call   800ca4 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 d8 1b 00 00       	call   801fd1 <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 80 1a 00 00       	call   801e9c <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 63 1a 00 00       	call   801e9c <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 46 1a 00 00       	call   801e9c <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 2d 1a 00 00       	call   801e9c <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 1f 1a 00 00       	call   801e9c <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 11 1a 00 00       	call   801e9c <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 24 1b 00 00       	call   801fb7 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 04 2c 80 00       	push   $0x802c04
  80049b:	e8 04 08 00 00       	call   800ca4 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 4f 05 00 00       	call   8009f7 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 20 05 00 00       	call   8009d8 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 13 05 00 00       	call   8009d8 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 04 1b 00 00       	call   801fd1 <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 79 19 00 00       	call   801e6e <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 4b 19 00 00       	call   801e6e <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 2b 18 00 00       	call   801e6e <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 fd 17 00 00       	call   801e6e <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 4f 17 00 00       	call   801e6e <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 21 17 00 00       	call   801e6e <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 20             	sub    $0x20,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800893:	eb 56                	jmp    8008eb <InitializeSemiRandom+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80089c:	eb 42                	jmp    8008e0 <InitializeSemiRandom+0x5b>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
  80089e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8008b8:	0f 31                	rdtsc  
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8008c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	f7 f3                	div    %ebx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	89 01                	mov    %eax,(%ecx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008dd:	ff 45 f4             	incl   -0xc(%ebp)
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e6:	7c b6                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e8:	ff 45 f8             	incl   -0x8(%ebp)
  8008eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f1:	7c a2                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008f3:	90                   	nop
  8008f4:	83 c4 20             	add    $0x20,%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800907:	eb 53                	jmp    80095c <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800910:	eb 2f                	jmp    800941 <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800926:	c1 e2 02             	shl    $0x2,%edx
  800929:	01 d0                	add    %edx,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	50                   	push   %eax
  800931:	68 22 2c 80 00       	push   $0x802c22
  800936:	e8 69 03 00 00       	call   800ca4 <cprintf>
  80093b:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80093e:	ff 45 f0             	incl   -0x10(%ebp)
  800941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800944:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800947:	7c c9                	jl     800912 <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	68 29 2c 80 00       	push   $0x802c29
  800951:	e8 4e 03 00 00       	call   800ca4 <cprintf>
  800956:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800959:	ff 45 f4             	incl   -0xc(%ebp)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800962:	7c a5                	jl     800909 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80096d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800974:	eb 57                	jmp    8009cd <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097d:	eb 33                	jmp    8009b2 <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  80097f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800982:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800993:	c1 e2 03             	shl    $0x3,%edx
  800996:	01 d0                	add    %edx,%eax
  800998:	8b 50 04             	mov    0x4(%eax),%edx
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	52                   	push   %edx
  8009a1:	50                   	push   %eax
  8009a2:	68 2d 2c 80 00       	push   $0x802c2d
  8009a7:	e8 f8 02 00 00       	call   800ca4 <cprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009af:	ff 45 f0             	incl   -0x10(%ebp)
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b8:	7c c5                	jl     80097f <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	68 29 2c 80 00       	push   $0x802c29
  8009c2:	e8 dd 02 00 00       	call   800ca4 <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009ca:	ff 45 f4             	incl   -0xc(%ebp)
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009d3:	7c a1                	jl     800976 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009d5:	90                   	nop
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	50                   	push   %eax
  8009ec:	e8 0e 17 00 00       	call   8020ff <sys_cputc>
  8009f1:	83 c4 10             	add    $0x10,%esp
}
  8009f4:	90                   	nop
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <getchar>:


int
getchar(void)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009fd:	e8 9c 15 00 00       	call   801f9e <sys_cgetc>
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <iscons>:

int iscons(int fdnum)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800a1d:	e8 0e 18 00 00       	call   802230 <sys_getenvindex>
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 02             	shl    $0x2,%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	c1 e0 03             	shl    $0x3,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 02             	shl    $0x2,%eax
  800a40:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a45:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a4a:	a1 20 40 80 00       	mov    0x804020,%eax
  800a4f:	8a 40 20             	mov    0x20(%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	74 0d                	je     800a63 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800a56:	a1 20 40 80 00       	mov    0x804020,%eax
  800a5b:	83 c0 20             	add    $0x20,%eax
  800a5e:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a67:	7e 0a                	jle    800a73 <libmain+0x5f>
		binaryname = argv[0];
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 b7 f5 ff ff       	call   800038 <_main>
  800a81:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800a84:	a1 00 40 80 00       	mov    0x804000,%eax
  800a89:	85 c0                	test   %eax,%eax
  800a8b:	0f 84 01 01 00 00    	je     800b92 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800a91:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800a97:	bb 30 2d 80 00       	mov    $0x802d30,%ebx
  800a9c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	89 de                	mov    %ebx,%esi
  800aa5:	89 d1                	mov    %edx,%ecx
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800aa9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800aac:	b9 56 00 00 00       	mov    $0x56,%ecx
  800ab1:	b0 00                	mov    $0x0,%al
  800ab3:	89 d7                	mov    %edx,%edi
  800ab5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800ab7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800abe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	50                   	push   %eax
  800ac5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	e8 95 19 00 00       	call   802466 <sys_utilities>
  800ad1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800ad4:	e8 de 14 00 00       	call   801fb7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800ad9:	83 ec 0c             	sub    $0xc,%esp
  800adc:	68 50 2c 80 00       	push   $0x802c50
  800ae1:	e8 be 01 00 00       	call   800ca4 <cprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aec:	85 c0                	test   %eax,%eax
  800aee:	74 18                	je     800b08 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800af0:	e8 8f 19 00 00       	call   802484 <sys_get_optimal_num_faults>
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	50                   	push   %eax
  800af9:	68 78 2c 80 00       	push   $0x802c78
  800afe:	e8 a1 01 00 00       	call   800ca4 <cprintf>
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	eb 59                	jmp    800b61 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b08:	a1 20 40 80 00       	mov    0x804020,%eax
  800b0d:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800b13:	a1 20 40 80 00       	mov    0x804020,%eax
  800b18:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	50                   	push   %eax
  800b23:	68 9c 2c 80 00       	push   $0x802c9c
  800b28:	e8 77 01 00 00       	call   800ca4 <cprintf>
  800b2d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b30:	a1 20 40 80 00       	mov    0x804020,%eax
  800b35:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800b3b:	a1 20 40 80 00       	mov    0x804020,%eax
  800b40:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800b46:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800b51:	51                   	push   %ecx
  800b52:	52                   	push   %edx
  800b53:	50                   	push   %eax
  800b54:	68 c4 2c 80 00       	push   $0x802cc4
  800b59:	e8 46 01 00 00       	call   800ca4 <cprintf>
  800b5e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b61:	a1 20 40 80 00       	mov    0x804020,%eax
  800b66:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	50                   	push   %eax
  800b70:	68 1c 2d 80 00       	push   $0x802d1c
  800b75:	e8 2a 01 00 00       	call   800ca4 <cprintf>
  800b7a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800b7d:	83 ec 0c             	sub    $0xc,%esp
  800b80:	68 50 2c 80 00       	push   $0x802c50
  800b85:	e8 1a 01 00 00       	call   800ca4 <cprintf>
  800b8a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800b8d:	e8 3f 14 00 00       	call   801fd1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800b92:	e8 1f 00 00 00       	call   800bb6 <exit>
}
  800b97:	90                   	nop
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	6a 00                	push   $0x0
  800bab:	e8 4c 16 00 00       	call   8021fc <sys_destroy_env>
  800bb0:	83 c4 10             	add    $0x10,%esp
}
  800bb3:	90                   	nop
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <exit>:

void
exit(void)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800bbc:	e8 a1 16 00 00       	call   802262 <sys_exit_env>
}
  800bc1:	90                   	nop
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	89 0a                	mov    %ecx,(%edx)
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	88 d1                	mov    %dl,%cl
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bee:	75 30                	jne    800c20 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bf0:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800bf6:	a0 44 40 80 00       	mov    0x804044,%al
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	8b 09                	mov    (%ecx),%ecx
  800c03:	89 cb                	mov    %ecx,%ebx
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	83 c1 08             	add    $0x8,%ecx
  800c0b:	52                   	push   %edx
  800c0c:	50                   	push   %eax
  800c0d:	53                   	push   %ebx
  800c0e:	51                   	push   %ecx
  800c0f:	e8 5f 13 00 00       	call   801f73 <sys_cputs>
  800c14:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 40 04             	mov    0x4(%eax),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c2f:	90                   	nop
  800c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c3e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c45:	00 00 00 
	b.cnt = 0;
  800c48:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c4f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	ff 75 08             	pushl  0x8(%ebp)
  800c58:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c5e:	50                   	push   %eax
  800c5f:	68 c4 0b 80 00       	push   $0x800bc4
  800c64:	e8 5a 02 00 00       	call   800ec3 <vprintfmt>
  800c69:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c6c:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800c72:	a0 44 40 80 00       	mov    0x804044,%al
  800c77:	0f b6 c0             	movzbl %al,%eax
  800c7a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c80:	52                   	push   %edx
  800c81:	50                   	push   %eax
  800c82:	51                   	push   %ecx
  800c83:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c89:	83 c0 08             	add    $0x8,%eax
  800c8c:	50                   	push   %eax
  800c8d:	e8 e1 12 00 00       	call   801f73 <sys_cputs>
  800c92:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c95:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c9c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800caa:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800cb1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	e8 6f ff ff ff       	call   800c35 <vcprintf>
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cd7:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	c1 e0 08             	shl    $0x8,%eax
  800ce4:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800ce9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	e8 34 ff ff ff       	call   800c35 <vcprintf>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800d07:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800d0e:	07 00 00 

	return cnt;
  800d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d1c:	e8 96 12 00 00       	call   801fb7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d21:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	e8 ff fe ff ff       	call   800c35 <vcprintf>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d3c:	e8 90 12 00 00       	call   801fd1 <sys_unlock_cons>
	return cnt;
  800d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 14             	sub    $0x14,%esp
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d59:	8b 45 18             	mov    0x18(%ebp),%eax
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d64:	77 55                	ja     800dbb <printnum+0x75>
  800d66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d69:	72 05                	jb     800d70 <printnum+0x2a>
  800d6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d6e:	77 4b                	ja     800dbb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d70:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d73:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d76:	8b 45 18             	mov    0x18(%ebp),%eax
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	52                   	push   %edx
  800d7f:	50                   	push   %eax
  800d80:	ff 75 f4             	pushl  -0xc(%ebp)
  800d83:	ff 75 f0             	pushl  -0x10(%ebp)
  800d86:	e8 9d 1a 00 00       	call   802828 <__udivdi3>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	ff 75 20             	pushl  0x20(%ebp)
  800d94:	53                   	push   %ebx
  800d95:	ff 75 18             	pushl  0x18(%ebp)
  800d98:	52                   	push   %edx
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 a1 ff ff ff       	call   800d46 <printnum>
  800da5:	83 c4 20             	add    $0x20,%esp
  800da8:	eb 1a                	jmp    800dc4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	ff 75 20             	pushl  0x20(%ebp)
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dbb:	ff 4d 1c             	decl   0x1c(%ebp)
  800dbe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dc2:	7f e6                	jg     800daa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dc4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd2:	53                   	push   %ebx
  800dd3:	51                   	push   %ecx
  800dd4:	52                   	push   %edx
  800dd5:	50                   	push   %eax
  800dd6:	e8 5d 1b 00 00       	call   802938 <__umoddi3>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	05 b4 2f 80 00       	add    $0x802fb4,%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f be c0             	movsbl %al,%eax
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
}
  800df7:	90                   	nop
  800df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e00:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e04:	7e 1c                	jle    800e22 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	8d 50 08             	lea    0x8(%eax),%edx
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 10                	mov    %edx,(%eax)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	83 e8 08             	sub    $0x8,%eax
  800e1b:	8b 50 04             	mov    0x4(%eax),%edx
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	eb 40                	jmp    800e62 <getuint+0x65>
	else if (lflag)
  800e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e26:	74 1e                	je     800e46 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	8d 50 04             	lea    0x4(%eax),%edx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	89 10                	mov    %edx,(%eax)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8b 00                	mov    (%eax),%eax
  800e3a:	83 e8 04             	sub    $0x4,%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	eb 1c                	jmp    800e62 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	8d 50 04             	lea    0x4(%eax),%edx
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 10                	mov    %edx,(%eax)
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8b 00                	mov    (%eax),%eax
  800e58:	83 e8 04             	sub    $0x4,%eax
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e6b:	7e 1c                	jle    800e89 <getint+0x25>
		return va_arg(*ap, long long);
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 50 08             	lea    0x8(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 10                	mov    %edx,(%eax)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	83 e8 08             	sub    $0x8,%eax
  800e82:	8b 50 04             	mov    0x4(%eax),%edx
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	eb 38                	jmp    800ec1 <getint+0x5d>
	else if (lflag)
  800e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8d:	74 1a                	je     800ea9 <getint+0x45>
		return va_arg(*ap, long);
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	8d 50 04             	lea    0x4(%eax),%edx
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 10                	mov    %edx,(%eax)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 00                	mov    (%eax),%eax
  800ea1:	83 e8 04             	sub    $0x4,%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	99                   	cltd   
  800ea7:	eb 18                	jmp    800ec1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	8d 50 04             	lea    0x4(%eax),%edx
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 10                	mov    %edx,(%eax)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	99                   	cltd   
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecb:	eb 17                	jmp    800ee4 <vprintfmt+0x21>
			if (ch == '\0')
  800ecd:	85 db                	test   %ebx,%ebx
  800ecf:	0f 84 c1 03 00 00    	je     801296 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	53                   	push   %ebx
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	ff d0                	call   *%eax
  800ee1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	89 55 10             	mov    %edx,0x10(%ebp)
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 d8             	movzbl %al,%ebx
  800ef2:	83 fb 25             	cmp    $0x25,%ebx
  800ef5:	75 d6                	jne    800ecd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ef7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800efb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f02:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	0f b6 d8             	movzbl %al,%ebx
  800f25:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f28:	83 f8 5b             	cmp    $0x5b,%eax
  800f2b:	0f 87 3d 03 00 00    	ja     80126e <vprintfmt+0x3ab>
  800f31:	8b 04 85 d8 2f 80 00 	mov    0x802fd8(,%eax,4),%eax
  800f38:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f3a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f3e:	eb d7                	jmp    800f17 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f40:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f44:	eb d1                	jmp    800f17 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f50:	89 d0                	mov    %edx,%eax
  800f52:	c1 e0 02             	shl    $0x2,%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	01 c0                	add    %eax,%eax
  800f59:	01 d8                	add    %ebx,%eax
  800f5b:	83 e8 30             	sub    $0x30,%eax
  800f5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f61:	8b 45 10             	mov    0x10(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f69:	83 fb 2f             	cmp    $0x2f,%ebx
  800f6c:	7e 3e                	jle    800fac <vprintfmt+0xe9>
  800f6e:	83 fb 39             	cmp    $0x39,%ebx
  800f71:	7f 39                	jg     800fac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f73:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f76:	eb d5                	jmp    800f4d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	83 c0 04             	add    $0x4,%eax
  800f7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	83 e8 04             	sub    $0x4,%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f92:	79 83                	jns    800f17 <vprintfmt+0x54>
				width = 0;
  800f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f9b:	e9 77 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fa0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fa7:	e9 6b ff ff ff       	jmp    800f17 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb1:	0f 89 60 ff ff ff    	jns    800f17 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fbd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fc4:	e9 4e ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fc9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fcc:	e9 46 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	83 c0 04             	add    $0x4,%eax
  800fd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	ff d0                	call   *%eax
  800fee:	83 c4 10             	add    $0x10,%esp
			break;
  800ff1:	e9 9b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	83 c0 04             	add    $0x4,%eax
  800ffc:	89 45 14             	mov    %eax,0x14(%ebp)
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	83 e8 04             	sub    $0x4,%eax
  801005:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801007:	85 db                	test   %ebx,%ebx
  801009:	79 02                	jns    80100d <vprintfmt+0x14a>
				err = -err;
  80100b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80100d:	83 fb 64             	cmp    $0x64,%ebx
  801010:	7f 0b                	jg     80101d <vprintfmt+0x15a>
  801012:	8b 34 9d 20 2e 80 00 	mov    0x802e20(,%ebx,4),%esi
  801019:	85 f6                	test   %esi,%esi
  80101b:	75 19                	jne    801036 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80101d:	53                   	push   %ebx
  80101e:	68 c5 2f 80 00       	push   $0x802fc5
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 70 02 00 00       	call   80129e <printfmt>
  80102e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801031:	e9 5b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801036:	56                   	push   %esi
  801037:	68 ce 2f 80 00       	push   $0x802fce
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	ff 75 08             	pushl  0x8(%ebp)
  801042:	e8 57 02 00 00       	call   80129e <printfmt>
  801047:	83 c4 10             	add    $0x10,%esp
			break;
  80104a:	e9 42 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 c0 04             	add    $0x4,%eax
  801055:	89 45 14             	mov    %eax,0x14(%ebp)
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	83 e8 04             	sub    $0x4,%eax
  80105e:	8b 30                	mov    (%eax),%esi
  801060:	85 f6                	test   %esi,%esi
  801062:	75 05                	jne    801069 <vprintfmt+0x1a6>
				p = "(null)";
  801064:	be d1 2f 80 00       	mov    $0x802fd1,%esi
			if (width > 0 && padc != '-')
  801069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106d:	7e 6d                	jle    8010dc <vprintfmt+0x219>
  80106f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801073:	74 67                	je     8010dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	50                   	push   %eax
  80107c:	56                   	push   %esi
  80107d:	e8 26 05 00 00       	call   8015a8 <strnlen>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801088:	eb 16                	jmp    8010a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80108a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	ff d0                	call   *%eax
  80109a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80109d:	ff 4d e4             	decl   -0x1c(%ebp)
  8010a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a4:	7f e4                	jg     80108a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a6:	eb 34                	jmp    8010dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010ac:	74 1c                	je     8010ca <vprintfmt+0x207>
  8010ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b1:	7e 05                	jle    8010b8 <vprintfmt+0x1f5>
  8010b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8010b6:	7e 12                	jle    8010ca <vprintfmt+0x207>
					putch('?', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 3f                	push   $0x3f
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	eb 0f                	jmp    8010d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	53                   	push   %ebx
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8010dc:	89 f0                	mov    %esi,%eax
  8010de:	8d 70 01             	lea    0x1(%eax),%esi
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f be d8             	movsbl %al,%ebx
  8010e6:	85 db                	test   %ebx,%ebx
  8010e8:	74 24                	je     80110e <vprintfmt+0x24b>
  8010ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ee:	78 b8                	js     8010a8 <vprintfmt+0x1e5>
  8010f0:	ff 4d e0             	decl   -0x20(%ebp)
  8010f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010f7:	79 af                	jns    8010a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f9:	eb 13                	jmp    80110e <vprintfmt+0x24b>
				putch(' ', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 20                	push   $0x20
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110b:	ff 4d e4             	decl   -0x1c(%ebp)
  80110e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801112:	7f e7                	jg     8010fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801114:	e9 78 01 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 e8             	pushl  -0x18(%ebp)
  80111f:	8d 45 14             	lea    0x14(%ebp),%eax
  801122:	50                   	push   %eax
  801123:	e8 3c fd ff ff       	call   800e64 <getint>
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	79 23                	jns    80115e <vprintfmt+0x29b>
				putch('-', putdat);
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	6a 2d                	push   $0x2d
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80114b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801151:	f7 d8                	neg    %eax
  801153:	83 d2 00             	adc    $0x0,%edx
  801156:	f7 da                	neg    %edx
  801158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80115e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801165:	e9 bc 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 e8             	pushl  -0x18(%ebp)
  801170:	8d 45 14             	lea    0x14(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	e8 84 fc ff ff       	call   800dfd <getuint>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801182:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801189:	e9 98 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	ff 75 0c             	pushl  0xc(%ebp)
  801194:	6a 58                	push   $0x58
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	ff d0                	call   *%eax
  80119b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	6a 58                	push   $0x58
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	6a 58                	push   $0x58
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	ff d0                	call   *%eax
  8011bb:	83 c4 10             	add    $0x10,%esp
			break;
  8011be:	e9 ce 00 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	6a 30                	push   $0x30
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	6a 78                	push   $0x78
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	ff d0                	call   *%eax
  8011e0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	83 e8 04             	sub    $0x4,%eax
  8011f2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801205:	eb 1f                	jmp    801226 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	ff 75 e8             	pushl  -0x18(%ebp)
  80120d:	8d 45 14             	lea    0x14(%ebp),%eax
  801210:	50                   	push   %eax
  801211:	e8 e7 fb ff ff       	call   800dfd <getuint>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80121c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80121f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801226:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80122a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	52                   	push   %edx
  801231:	ff 75 e4             	pushl  -0x1c(%ebp)
  801234:	50                   	push   %eax
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	ff 75 f0             	pushl  -0x10(%ebp)
  80123b:	ff 75 0c             	pushl  0xc(%ebp)
  80123e:	ff 75 08             	pushl  0x8(%ebp)
  801241:	e8 00 fb ff ff       	call   800d46 <printnum>
  801246:	83 c4 20             	add    $0x20,%esp
			break;
  801249:	eb 46                	jmp    801291 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	53                   	push   %ebx
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	ff d0                	call   *%eax
  801257:	83 c4 10             	add    $0x10,%esp
			break;
  80125a:	eb 35                	jmp    801291 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80125c:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801263:	eb 2c                	jmp    801291 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801265:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  80126c:	eb 23                	jmp    801291 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	6a 25                	push   $0x25
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	ff d0                	call   *%eax
  80127b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80127e:	ff 4d 10             	decl   0x10(%ebp)
  801281:	eb 03                	jmp    801286 <vprintfmt+0x3c3>
  801283:	ff 4d 10             	decl   0x10(%ebp)
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	48                   	dec    %eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 25                	cmp    $0x25,%al
  80128e:	75 f3                	jne    801283 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801290:	90                   	nop
		}
	}
  801291:	e9 35 fc ff ff       	jmp    800ecb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801296:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a7:	83 c0 04             	add    $0x4,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 04 fc ff ff       	call   800ec3 <vprintfmt>
  8012bf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012c2:	90                   	nop
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8b 40 08             	mov    0x8(%eax),%eax
  8012ce:	8d 50 01             	lea    0x1(%eax),%edx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8b 10                	mov    (%eax),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 40 04             	mov    0x4(%eax),%eax
  8012e2:	39 c2                	cmp    %eax,%edx
  8012e4:	73 12                	jae    8012f8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8b 00                	mov    (%eax),%eax
  8012eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	89 0a                	mov    %ecx,(%edx)
  8012f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f6:	88 10                	mov    %dl,(%eax)
}
  8012f8:	90                   	nop
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80131c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801320:	74 06                	je     801328 <vsnprintf+0x2d>
  801322:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801326:	7f 07                	jg     80132f <vsnprintf+0x34>
		return -E_INVAL;
  801328:	b8 03 00 00 00       	mov    $0x3,%eax
  80132d:	eb 20                	jmp    80134f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80132f:	ff 75 14             	pushl  0x14(%ebp)
  801332:	ff 75 10             	pushl  0x10(%ebp)
  801335:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	68 c5 12 80 00       	push   $0x8012c5
  80133e:	e8 80 fb ff ff       	call   800ec3 <vprintfmt>
  801343:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801349:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801357:	8d 45 10             	lea    0x10(%ebp),%eax
  80135a:	83 c0 04             	add    $0x4,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	ff 75 f4             	pushl  -0xc(%ebp)
  801366:	50                   	push   %eax
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	e8 89 ff ff ff       	call   8012fb <vsnprintf>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801387:	74 13                	je     80139c <readline+0x1f>
		cprintf("%s", prompt);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	68 48 31 80 00       	push   $0x803148
  801394:	e8 0b f9 ff ff       	call   800ca4 <cprintf>
  801399:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80139c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 5d f6 ff ff       	call   800a0a <iscons>
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013b3:	e8 3f f6 ff ff       	call   8009f7 <getchar>
  8013b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013bf:	79 22                	jns    8013e3 <readline+0x66>
			if (c != -E_EOF)
  8013c1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013c5:	0f 84 ad 00 00 00    	je     801478 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8013d1:	68 4b 31 80 00       	push   $0x80314b
  8013d6:	e8 c9 f8 ff ff       	call   800ca4 <cprintf>
  8013db:	83 c4 10             	add    $0x10,%esp
			break;
  8013de:	e9 95 00 00 00       	jmp    801478 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013e7:	7e 34                	jle    80141d <readline+0xa0>
  8013e9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013f0:	7f 2b                	jg     80141d <readline+0xa0>
			if (echoing)
  8013f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f6:	74 0e                	je     801406 <readline+0x89>
				cputchar(c);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8013fe:	e8 d5 f5 ff ff       	call   8009d8 <cputchar>
  801403:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8d 50 01             	lea    0x1(%eax),%edx
  80140c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80140f:	89 c2                	mov    %eax,%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801419:	88 10                	mov    %dl,(%eax)
  80141b:	eb 56                	jmp    801473 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80141d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801421:	75 1f                	jne    801442 <readline+0xc5>
  801423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801427:	7e 19                	jle    801442 <readline+0xc5>
			if (echoing)
  801429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142d:	74 0e                	je     80143d <readline+0xc0>
				cputchar(c);
  80142f:	83 ec 0c             	sub    $0xc,%esp
  801432:	ff 75 ec             	pushl  -0x14(%ebp)
  801435:	e8 9e f5 ff ff       	call   8009d8 <cputchar>
  80143a:	83 c4 10             	add    $0x10,%esp

			i--;
  80143d:	ff 4d f4             	decl   -0xc(%ebp)
  801440:	eb 31                	jmp    801473 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801442:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801446:	74 0a                	je     801452 <readline+0xd5>
  801448:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80144c:	0f 85 61 ff ff ff    	jne    8013b3 <readline+0x36>
			if (echoing)
  801452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801456:	74 0e                	je     801466 <readline+0xe9>
				cputchar(c);
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	ff 75 ec             	pushl  -0x14(%ebp)
  80145e:	e8 75 f5 ff ff       	call   8009d8 <cputchar>
  801463:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801471:	eb 06                	jmp    801479 <readline+0xfc>
		}
	}
  801473:	e9 3b ff ff ff       	jmp    8013b3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801478:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801482:	e8 30 0b 00 00       	call   801fb7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148b:	74 13                	je     8014a0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	68 48 31 80 00       	push   $0x803148
  801498:	e8 07 f8 ff ff       	call   800ca4 <cprintf>
  80149d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 59 f5 ff ff       	call   800a0a <iscons>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014b7:	e8 3b f5 ff ff       	call   8009f7 <getchar>
  8014bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c3:	79 22                	jns    8014e7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014c5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014c9:	0f 84 ad 00 00 00    	je     80157c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d5:	68 4b 31 80 00       	push   $0x80314b
  8014da:	e8 c5 f7 ff ff       	call   800ca4 <cprintf>
  8014df:	83 c4 10             	add    $0x10,%esp
				break;
  8014e2:	e9 95 00 00 00       	jmp    80157c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014e7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014eb:	7e 34                	jle    801521 <atomic_readline+0xa5>
  8014ed:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014f4:	7f 2b                	jg     801521 <atomic_readline+0xa5>
				if (echoing)
  8014f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014fa:	74 0e                	je     80150a <atomic_readline+0x8e>
					cputchar(c);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801502:	e8 d1 f4 ff ff       	call   8009d8 <cputchar>
  801507:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801513:	89 c2                	mov    %eax,%edx
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151d:	88 10                	mov    %dl,(%eax)
  80151f:	eb 56                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801521:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801525:	75 1f                	jne    801546 <atomic_readline+0xca>
  801527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80152b:	7e 19                	jle    801546 <atomic_readline+0xca>
				if (echoing)
  80152d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801531:	74 0e                	je     801541 <atomic_readline+0xc5>
					cputchar(c);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 ec             	pushl  -0x14(%ebp)
  801539:	e8 9a f4 ff ff       	call   8009d8 <cputchar>
  80153e:	83 c4 10             	add    $0x10,%esp
				i--;
  801541:	ff 4d f4             	decl   -0xc(%ebp)
  801544:	eb 31                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801546:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80154a:	74 0a                	je     801556 <atomic_readline+0xda>
  80154c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801550:	0f 85 61 ff ff ff    	jne    8014b7 <atomic_readline+0x3b>
				if (echoing)
  801556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155a:	74 0e                	je     80156a <atomic_readline+0xee>
					cputchar(c);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	ff 75 ec             	pushl  -0x14(%ebp)
  801562:	e8 71 f4 ff ff       	call   8009d8 <cputchar>
  801567:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801575:	eb 06                	jmp    80157d <atomic_readline+0x101>
			}
		}
  801577:	e9 3b ff ff ff       	jmp    8014b7 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80157c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80157d:	e8 4f 0a 00 00       	call   801fd1 <sys_unlock_cons>
}
  801582:	90                   	nop
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80158b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801592:	eb 06                	jmp    80159a <strlen+0x15>
		n++;
  801594:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801597:	ff 45 08             	incl   0x8(%ebp)
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	84 c0                	test   %al,%al
  8015a1:	75 f1                	jne    801594 <strlen+0xf>
		n++;
	return n;
  8015a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b5:	eb 09                	jmp    8015c0 <strnlen+0x18>
		n++;
  8015b7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ba:	ff 45 08             	incl   0x8(%ebp)
  8015bd:	ff 4d 0c             	decl   0xc(%ebp)
  8015c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c4:	74 09                	je     8015cf <strnlen+0x27>
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	84 c0                	test   %al,%al
  8015cd:	75 e8                	jne    8015b7 <strnlen+0xf>
		n++;
	return n;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015e0:	90                   	nop
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8d 50 01             	lea    0x1(%eax),%edx
  8015e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015f3:	8a 12                	mov    (%edx),%dl
  8015f5:	88 10                	mov    %dl,(%eax)
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	84 c0                	test   %al,%al
  8015fb:	75 e4                	jne    8015e1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80160e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801615:	eb 1f                	jmp    801636 <strncpy+0x34>
		*dst++ = *src;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 08             	mov    %edx,0x8(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8a 12                	mov    (%edx),%dl
  801625:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	84 c0                	test   %al,%al
  80162e:	74 03                	je     801633 <strncpy+0x31>
			src++;
  801630:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801633:	ff 45 fc             	incl   -0x4(%ebp)
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	3b 45 10             	cmp    0x10(%ebp),%eax
  80163c:	72 d9                	jb     801617 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80164f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801653:	74 30                	je     801685 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801655:	eb 16                	jmp    80166d <strlcpy+0x2a>
			*dst++ = *src++;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8d 50 01             	lea    0x1(%eax),%edx
  80165d:	89 55 08             	mov    %edx,0x8(%ebp)
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8d 4a 01             	lea    0x1(%edx),%ecx
  801666:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801669:	8a 12                	mov    (%edx),%dl
  80166b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80166d:	ff 4d 10             	decl   0x10(%ebp)
  801670:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801674:	74 09                	je     80167f <strlcpy+0x3c>
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	84 c0                	test   %al,%al
  80167d:	75 d8                	jne    801657 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801685:	8b 55 08             	mov    0x8(%ebp),%edx
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	29 c2                	sub    %eax,%edx
  80168d:	89 d0                	mov    %edx,%eax
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801694:	eb 06                	jmp    80169c <strcmp+0xb>
		p++, q++;
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	84 c0                	test   %al,%al
  8016a3:	74 0e                	je     8016b3 <strcmp+0x22>
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 10                	mov    (%eax),%dl
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	38 c2                	cmp    %al,%dl
  8016b1:	74 e3                	je     801696 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	0f b6 d0             	movzbl %al,%edx
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f b6 c0             	movzbl %al,%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016cc:	eb 09                	jmp    8016d7 <strncmp+0xe>
		n--, p++, q++;
  8016ce:	ff 4d 10             	decl   0x10(%ebp)
  8016d1:	ff 45 08             	incl   0x8(%ebp)
  8016d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016db:	74 17                	je     8016f4 <strncmp+0x2b>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	84 c0                	test   %al,%al
  8016e4:	74 0e                	je     8016f4 <strncmp+0x2b>
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 10                	mov    (%eax),%dl
  8016eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	38 c2                	cmp    %al,%dl
  8016f2:	74 da                	je     8016ce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f8:	75 07                	jne    801701 <strncmp+0x38>
		return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	eb 14                	jmp    801715 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f b6 d0             	movzbl %al,%edx
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f b6 c0             	movzbl %al,%eax
  801711:	29 c2                	sub    %eax,%edx
  801713:	89 d0                	mov    %edx,%eax
}
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801723:	eb 12                	jmp    801737 <strchr+0x20>
		if (*s == c)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80172d:	75 05                	jne    801734 <strchr+0x1d>
			return (char *) s;
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	eb 11                	jmp    801745 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	84 c0                	test   %al,%al
  80173e:	75 e5                	jne    801725 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801753:	eb 0d                	jmp    801762 <strfind+0x1b>
		if (*s == c)
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80175d:	74 0e                	je     80176d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80175f:	ff 45 08             	incl   0x8(%ebp)
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	75 ea                	jne    801755 <strfind+0xe>
  80176b:	eb 01                	jmp    80176e <strfind+0x27>
		if (*s == c)
			break;
  80176d:	90                   	nop
	return (char *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80177f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801783:	76 63                	jbe    8017e8 <memset+0x75>
		uint64 data_block = c;
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	99                   	cltd   
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80178c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801799:	c1 e0 08             	shl    $0x8,%eax
  80179c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80179f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017ac:	c1 e0 10             	shl    $0x10,%eax
  8017af:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bb:	89 c2                	mov    %eax,%edx
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017c5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017c8:	eb 18                	jmp    8017e2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017cd:	8d 41 08             	lea    0x8(%ecx),%eax
  8017d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	89 01                	mov    %eax,(%ecx)
  8017db:	89 51 04             	mov    %edx,0x4(%ecx)
  8017de:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017e6:	77 e2                	ja     8017ca <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ec:	74 23                	je     801811 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f4:	eb 0e                	jmp    801804 <memset+0x91>
			*p8++ = (uint8)c;
  8017f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f9:	8d 50 01             	lea    0x1(%eax),%edx
  8017fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e5                	jne    8017f6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80181c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801828:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80182c:	76 24                	jbe    801852 <memcpy+0x3c>
		while(n >= 8){
  80182e:	eb 1c                	jmp    80184c <memcpy+0x36>
			*d64 = *s64;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	8b 50 04             	mov    0x4(%eax),%edx
  801836:	8b 00                	mov    (%eax),%eax
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	89 01                	mov    %eax,(%ecx)
  80183d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801840:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801844:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801848:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80184c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801850:	77 de                	ja     801830 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801852:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801856:	74 31                	je     801889 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80185e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801864:	eb 16                	jmp    80187c <memcpy+0x66>
			*d8++ = *s8++;
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	8d 50 01             	lea    0x1(%eax),%edx
  80186c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80186f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801872:	8d 4a 01             	lea    0x1(%edx),%ecx
  801875:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801878:	8a 12                	mov    (%edx),%dl
  80187a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80187c:	8b 45 10             	mov    0x10(%ebp),%eax
  80187f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801882:	89 55 10             	mov    %edx,0x10(%ebp)
  801885:	85 c0                	test   %eax,%eax
  801887:	75 dd                	jne    801866 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018a6:	73 50                	jae    8018f8 <memmove+0x6a>
  8018a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018b3:	76 43                	jbe    8018f8 <memmove+0x6a>
		s += n;
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018c1:	eb 10                	jmp    8018d3 <memmove+0x45>
			*--d = *--s;
  8018c3:	ff 4d f8             	decl   -0x8(%ebp)
  8018c6:	ff 4d fc             	decl   -0x4(%ebp)
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	8a 10                	mov    (%eax),%dl
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	75 e3                	jne    8018c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018e0:	eb 23                	jmp    801905 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	8d 50 01             	lea    0x1(%eax),%edx
  8018e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018f4:	8a 12                	mov    (%edx),%dl
  8018f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801901:	85 c0                	test   %eax,%eax
  801903:	75 dd                	jne    8018e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80191c:	eb 2a                	jmp    801948 <memcmp+0x3e>
		if (*s1 != *s2)
  80191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801921:	8a 10                	mov    (%eax),%dl
  801923:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	38 c2                	cmp    %al,%dl
  80192a:	74 16                	je     801942 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	0f b6 d0             	movzbl %al,%edx
  801934:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f b6 c0             	movzbl %al,%eax
  80193c:	29 c2                	sub    %eax,%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	eb 18                	jmp    80195a <memcmp+0x50>
		s1++, s2++;
  801942:	ff 45 fc             	incl   -0x4(%ebp)
  801945:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80194e:	89 55 10             	mov    %edx,0x10(%ebp)
  801951:	85 c0                	test   %eax,%eax
  801953:	75 c9                	jne    80191e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801962:	8b 55 08             	mov    0x8(%ebp),%edx
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80196d:	eb 15                	jmp    801984 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8a 00                	mov    (%eax),%al
  801974:	0f b6 d0             	movzbl %al,%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	0f b6 c0             	movzbl %al,%eax
  80197d:	39 c2                	cmp    %eax,%edx
  80197f:	74 0d                	je     80198e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801981:	ff 45 08             	incl   0x8(%ebp)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80198a:	72 e3                	jb     80196f <memfind+0x13>
  80198c:	eb 01                	jmp    80198f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80198e:	90                   	nop
	return (void *) s;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80199a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a8:	eb 03                	jmp    8019ad <strtol+0x19>
		s++;
  8019aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	3c 20                	cmp    $0x20,%al
  8019b4:	74 f4                	je     8019aa <strtol+0x16>
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	3c 09                	cmp    $0x9,%al
  8019bd:	74 eb                	je     8019aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	3c 2b                	cmp    $0x2b,%al
  8019c6:	75 05                	jne    8019cd <strtol+0x39>
		s++;
  8019c8:	ff 45 08             	incl   0x8(%ebp)
  8019cb:	eb 13                	jmp    8019e0 <strtol+0x4c>
	else if (*s == '-')
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8a 00                	mov    (%eax),%al
  8019d2:	3c 2d                	cmp    $0x2d,%al
  8019d4:	75 0a                	jne    8019e0 <strtol+0x4c>
		s++, neg = 1;
  8019d6:	ff 45 08             	incl   0x8(%ebp)
  8019d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019e4:	74 06                	je     8019ec <strtol+0x58>
  8019e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019ea:	75 20                	jne    801a0c <strtol+0x78>
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	3c 30                	cmp    $0x30,%al
  8019f3:	75 17                	jne    801a0c <strtol+0x78>
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	40                   	inc    %eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	3c 78                	cmp    $0x78,%al
  8019fd:	75 0d                	jne    801a0c <strtol+0x78>
		s += 2, base = 16;
  8019ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a03:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a0a:	eb 28                	jmp    801a34 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a10:	75 15                	jne    801a27 <strtol+0x93>
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	3c 30                	cmp    $0x30,%al
  801a19:	75 0c                	jne    801a27 <strtol+0x93>
		s++, base = 8;
  801a1b:	ff 45 08             	incl   0x8(%ebp)
  801a1e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a25:	eb 0d                	jmp    801a34 <strtol+0xa0>
	else if (base == 0)
  801a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2b:	75 07                	jne    801a34 <strtol+0xa0>
		base = 10;
  801a2d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	8a 00                	mov    (%eax),%al
  801a39:	3c 2f                	cmp    $0x2f,%al
  801a3b:	7e 19                	jle    801a56 <strtol+0xc2>
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 39                	cmp    $0x39,%al
  801a44:	7f 10                	jg     801a56 <strtol+0xc2>
			dig = *s - '0';
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	0f be c0             	movsbl %al,%eax
  801a4e:	83 e8 30             	sub    $0x30,%eax
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a54:	eb 42                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	3c 60                	cmp    $0x60,%al
  801a5d:	7e 19                	jle    801a78 <strtol+0xe4>
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	3c 7a                	cmp    $0x7a,%al
  801a66:	7f 10                	jg     801a78 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	8a 00                	mov    (%eax),%al
  801a6d:	0f be c0             	movsbl %al,%eax
  801a70:	83 e8 57             	sub    $0x57,%eax
  801a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a76:	eb 20                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	3c 40                	cmp    $0x40,%al
  801a7f:	7e 39                	jle    801aba <strtol+0x126>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	3c 5a                	cmp    $0x5a,%al
  801a88:	7f 30                	jg     801aba <strtol+0x126>
			dig = *s - 'A' + 10;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	83 e8 37             	sub    $0x37,%eax
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a9e:	7d 19                	jge    801ab9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aa0:	ff 45 08             	incl   0x8(%ebp)
  801aa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa6:	0f af 45 10          	imul   0x10(%ebp),%eax
  801aaa:	89 c2                	mov    %eax,%edx
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ab4:	e9 7b ff ff ff       	jmp    801a34 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ab9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801abe:	74 08                	je     801ac8 <strtol+0x134>
		*endptr = (char *) s;
  801ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801acc:	74 07                	je     801ad5 <strtol+0x141>
  801ace:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad1:	f7 d8                	neg    %eax
  801ad3:	eb 03                	jmp    801ad8 <strtol+0x144>
  801ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <ltostr>:

void
ltostr(long value, char *str)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ae7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801aee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af2:	79 13                	jns    801b07 <ltostr+0x2d>
	{
		neg = 1;
  801af4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b01:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b04:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b0f:	99                   	cltd   
  801b10:	f7 f9                	idiv   %ecx
  801b12:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b18:	8d 50 01             	lea    0x1(%eax),%edx
  801b1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b1e:	89 c2                	mov    %eax,%edx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b28:	83 c2 30             	add    $0x30,%edx
  801b2b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b30:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b35:	f7 e9                	imul   %ecx
  801b37:	c1 fa 02             	sar    $0x2,%edx
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	c1 f8 1f             	sar    $0x1f,%eax
  801b3f:	29 c2                	sub    %eax,%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b4a:	75 bb                	jne    801b07 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b56:	48                   	dec    %eax
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b5e:	74 3d                	je     801b9d <ltostr+0xc3>
		start = 1 ;
  801b60:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b67:	eb 34                	jmp    801b9d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 d0                	add    %edx,%eax
  801b71:	8a 00                	mov    (%eax),%al
  801b73:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7c:	01 c2                	add    %eax,%edx
  801b7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	01 c8                	add    %ecx,%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	01 c2                	add    %eax,%edx
  801b92:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b95:	88 02                	mov    %al,(%edx)
		start++ ;
  801b97:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b9a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ba3:	7c c4                	jl     801b69 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ba5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	e8 c4 f9 ff ff       	call   801585 <strlen>
  801bc1:	83 c4 04             	add    $0x4,%esp
  801bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 b6 f9 ff ff       	call   801585 <strlen>
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801be3:	eb 17                	jmp    801bfc <strcconcat+0x49>
		final[s] = str1[s] ;
  801be5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be8:	8b 45 10             	mov    0x10(%ebp),%eax
  801beb:	01 c2                	add    %eax,%edx
  801bed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	01 c8                	add    %ecx,%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bf9:	ff 45 fc             	incl   -0x4(%ebp)
  801bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c02:	7c e1                	jl     801be5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c12:	eb 1f                	jmp    801c33 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c1d:	89 c2                	mov    %eax,%edx
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	01 c2                	add    %eax,%edx
  801c24:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	01 c8                	add    %ecx,%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c30:	ff 45 f8             	incl   -0x8(%ebp)
  801c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c39:	7c d9                	jl     801c14 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	01 d0                	add    %edx,%eax
  801c43:	c6 00 00             	movb   $0x0,(%eax)
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c55:	8b 45 14             	mov    0x14(%ebp),%eax
  801c58:	8b 00                	mov    (%eax),%eax
  801c5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c6c:	eb 0c                	jmp    801c7a <strsplit+0x31>
			*string++ = 0;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8d 50 01             	lea    0x1(%eax),%edx
  801c74:	89 55 08             	mov    %edx,0x8(%ebp)
  801c77:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 18                	je     801c9b <strsplit+0x52>
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	0f be c0             	movsbl %al,%eax
  801c8b:	50                   	push   %eax
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	e8 83 fa ff ff       	call   801717 <strchr>
  801c94:	83 c4 08             	add    $0x8,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	75 d3                	jne    801c6e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8a 00                	mov    (%eax),%al
  801ca0:	84 c0                	test   %al,%al
  801ca2:	74 5a                	je     801cfe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca7:	8b 00                	mov    (%eax),%eax
  801ca9:	83 f8 0f             	cmp    $0xf,%eax
  801cac:	75 07                	jne    801cb5 <strsplit+0x6c>
		{
			return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	eb 66                	jmp    801d1b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb8:	8b 00                	mov    (%eax),%eax
  801cba:	8d 48 01             	lea    0x1(%eax),%ecx
  801cbd:	8b 55 14             	mov    0x14(%ebp),%edx
  801cc0:	89 0a                	mov    %ecx,(%edx)
  801cc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	01 c2                	add    %eax,%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd3:	eb 03                	jmp    801cd8 <strsplit+0x8f>
			string++;
  801cd5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8a 00                	mov    (%eax),%al
  801cdd:	84 c0                	test   %al,%al
  801cdf:	74 8b                	je     801c6c <strsplit+0x23>
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8a 00                	mov    (%eax),%al
  801ce6:	0f be c0             	movsbl %al,%eax
  801ce9:	50                   	push   %eax
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	e8 25 fa ff ff       	call   801717 <strchr>
  801cf2:	83 c4 08             	add    $0x8,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	74 dc                	je     801cd5 <strsplit+0x8c>
			string++;
	}
  801cf9:	e9 6e ff ff ff       	jmp    801c6c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cfe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	8b 00                	mov    (%eax),%eax
  801d04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d30:	eb 4a                	jmp    801d7c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	01 c2                	add    %eax,%edx
  801d3a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	01 c8                	add    %ecx,%eax
  801d42:	8a 00                	mov    (%eax),%al
  801d44:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	3c 40                	cmp    $0x40,%al
  801d52:	7e 25                	jle    801d79 <str2lower+0x5c>
  801d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	8a 00                	mov    (%eax),%al
  801d5e:	3c 5a                	cmp    $0x5a,%al
  801d60:	7f 17                	jg     801d79 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d70:	01 ca                	add    %ecx,%edx
  801d72:	8a 12                	mov    (%edx),%dl
  801d74:	83 c2 20             	add    $0x20,%edx
  801d77:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d79:	ff 45 fc             	incl   -0x4(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	e8 01 f8 ff ff       	call   801585 <strlen>
  801d84:	83 c4 04             	add    $0x4,%esp
  801d87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d8a:	7f a6                	jg     801d32 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d97:	a1 08 40 80 00       	mov    0x804008,%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 42                	je     801de2 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	68 00 00 00 82       	push   $0x82000000
  801da8:	68 00 00 00 80       	push   $0x80000000
  801dad:	e8 8c 07 00 00       	call   80253e <initialize_dynamic_allocator>
  801db2:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801db5:	e8 e7 05 00 00       	call   8023a1 <sys_get_uheap_strategy>
  801dba:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801dbf:	a1 40 40 80 00       	mov    0x804040,%eax
  801dc4:	05 00 10 00 00       	add    $0x1000,%eax
  801dc9:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801dce:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801dd3:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801dd8:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801ddf:	00 00 00 
	}
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df9:	83 ec 08             	sub    $0x8,%esp
  801dfc:	68 06 04 00 00       	push   $0x406
  801e01:	50                   	push   %eax
  801e02:	e8 e4 01 00 00       	call   801feb <__sys_allocate_page>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e11:	79 14                	jns    801e27 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	68 5c 31 80 00       	push   $0x80315c
  801e1b:	6a 1f                	push   $0x1f
  801e1d:	68 98 31 80 00       	push   $0x803198
  801e22:	e8 13 08 00 00       	call   80263a <_panic>
	return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	50                   	push   %eax
  801e46:	e8 e7 01 00 00       	call   802032 <__sys_unmap_frame>
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e55:	79 14                	jns    801e6b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 a4 31 80 00       	push   $0x8031a4
  801e5f:	6a 2a                	push   $0x2a
  801e61:	68 98 31 80 00       	push   $0x803198
  801e66:	e8 cf 07 00 00       	call   80263a <_panic>
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e74:	e8 18 ff ff ff       	call   801d91 <uheap_init>
	if (size == 0) return NULL ;
  801e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e7d:	75 07                	jne    801e86 <malloc+0x18>
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	eb 14                	jmp    801e9a <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	68 e4 31 80 00       	push   $0x8031e4
  801e8e:	6a 3e                	push   $0x3e
  801e90:	68 98 31 80 00       	push   $0x803198
  801e95:	e8 a0 07 00 00       	call   80263a <_panic>
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	68 0c 32 80 00       	push   $0x80320c
  801eaa:	6a 49                	push   $0x49
  801eac:	68 98 31 80 00       	push   $0x803198
  801eb1:	e8 84 07 00 00       	call   80263a <_panic>

00801eb6 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 18             	sub    $0x18,%esp
  801ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebf:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ec2:	e8 ca fe ff ff       	call   801d91 <uheap_init>
	if (size == 0) return NULL ;
  801ec7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ecb:	75 07                	jne    801ed4 <smalloc+0x1e>
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed2:	eb 14                	jmp    801ee8 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	68 30 32 80 00       	push   $0x803230
  801edc:	6a 5a                	push   $0x5a
  801ede:	68 98 31 80 00       	push   $0x803198
  801ee3:	e8 52 07 00 00       	call   80263a <_panic>
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ef0:	e8 9c fe ff ff       	call   801d91 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	68 58 32 80 00       	push   $0x803258
  801efd:	6a 6a                	push   $0x6a
  801eff:	68 98 31 80 00       	push   $0x803198
  801f04:	e8 31 07 00 00       	call   80263a <_panic>

00801f09 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f0f:	e8 7d fe ff ff       	call   801d91 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 7c 32 80 00       	push   $0x80327c
  801f1c:	68 88 00 00 00       	push   $0x88
  801f21:	68 98 31 80 00       	push   $0x803198
  801f26:	e8 0f 07 00 00       	call   80263a <_panic>

00801f2b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	68 a4 32 80 00       	push   $0x8032a4
  801f39:	68 9b 00 00 00       	push   $0x9b
  801f3e:	68 98 31 80 00       	push   $0x803198
  801f43:	e8 f2 06 00 00       	call   80263a <_panic>

00801f48 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f60:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f63:	cd 30                	int    $0x30
  801f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	5b                   	pop    %ebx
  801f6f:	5e                   	pop    %esi
  801f70:	5f                   	pop    %edi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801f7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f82:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	6a 00                	push   $0x0
  801f8b:	51                   	push   %ecx
  801f8c:	52                   	push   %edx
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	50                   	push   %eax
  801f91:	6a 00                	push   $0x0
  801f93:	e8 b0 ff ff ff       	call   801f48 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 02                	push   $0x2
  801fad:	e8 96 ff ff ff       	call   801f48 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 03                	push   $0x3
  801fc6:	e8 7d ff ff ff       	call   801f48 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	90                   	nop
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 04                	push   $0x4
  801fe0:	e8 63 ff ff ff       	call   801f48 <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
}
  801fe8:	90                   	nop
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	52                   	push   %edx
  801ffb:	50                   	push   %eax
  801ffc:	6a 08                	push   $0x8
  801ffe:	e8 45 ff ff ff       	call   801f48 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80200d:	8b 75 18             	mov    0x18(%ebp),%esi
  802010:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802013:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	56                   	push   %esi
  80201d:	53                   	push   %ebx
  80201e:	51                   	push   %ecx
  80201f:	52                   	push   %edx
  802020:	50                   	push   %eax
  802021:	6a 09                	push   $0x9
  802023:	e8 20 ff ff ff       	call   801f48 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 0a                	push   $0xa
  802042:	e8 01 ff ff ff       	call   801f48 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	6a 0b                	push   $0xb
  80205d:	e8 e6 fe ff ff       	call   801f48 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 0c                	push   $0xc
  802076:	e8 cd fe ff ff       	call   801f48 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 0d                	push   $0xd
  80208f:	e8 b4 fe ff ff       	call   801f48 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 0e                	push   $0xe
  8020a8:	e8 9b fe ff ff       	call   801f48 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 0f                	push   $0xf
  8020c1:	e8 82 fe ff ff       	call   801f48 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 10                	push   $0x10
  8020db:	e8 68 fe ff ff       	call   801f48 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 11                	push   $0x11
  8020f4:	e8 4f fe ff ff       	call   801f48 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	90                   	nop
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_cputc>:

void
sys_cputc(const char c)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80210b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	50                   	push   %eax
  802118:	6a 01                	push   $0x1
  80211a:	e8 29 fe ff ff       	call   801f48 <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	90                   	nop
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 14                	push   $0x14
  802134:	e8 0f fe ff ff       	call   801f48 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	90                   	nop
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	8b 45 10             	mov    0x10(%ebp),%eax
  802148:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80214b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80214e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	51                   	push   %ecx
  802158:	52                   	push   %edx
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	50                   	push   %eax
  80215d:	6a 15                	push   $0x15
  80215f:	e8 e4 fd ff ff       	call   801f48 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80216c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	52                   	push   %edx
  802179:	50                   	push   %eax
  80217a:	6a 16                	push   $0x16
  80217c:	e8 c7 fd ff ff       	call   801f48 <syscall>
  802181:	83 c4 18             	add    $0x18,%esp
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802189:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80218c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	51                   	push   %ecx
  802197:	52                   	push   %edx
  802198:	50                   	push   %eax
  802199:	6a 17                	push   $0x17
  80219b:	e8 a8 fd ff ff       	call   801f48 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	52                   	push   %edx
  8021b5:	50                   	push   %eax
  8021b6:	6a 18                	push   $0x18
  8021b8:	e8 8b fd ff ff       	call   801f48 <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	6a 00                	push   $0x0
  8021ca:	ff 75 14             	pushl  0x14(%ebp)
  8021cd:	ff 75 10             	pushl  0x10(%ebp)
  8021d0:	ff 75 0c             	pushl  0xc(%ebp)
  8021d3:	50                   	push   %eax
  8021d4:	6a 19                	push   $0x19
  8021d6:	e8 6d fd ff ff       	call   801f48 <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	50                   	push   %eax
  8021ef:	6a 1a                	push   $0x1a
  8021f1:	e8 52 fd ff ff       	call   801f48 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	90                   	nop
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	50                   	push   %eax
  80220b:	6a 1b                	push   $0x1b
  80220d:	e8 36 fd ff ff       	call   801f48 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 05                	push   $0x5
  802226:	e8 1d fd ff ff       	call   801f48 <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 06                	push   $0x6
  80223f:	e8 04 fd ff ff       	call   801f48 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 07                	push   $0x7
  802258:	e8 eb fc ff ff       	call   801f48 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_exit_env>:


void sys_exit_env(void)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 1c                	push   $0x1c
  802271:	e8 d2 fc ff ff       	call   801f48 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	90                   	nop
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802282:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802285:	8d 50 04             	lea    0x4(%eax),%edx
  802288:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	52                   	push   %edx
  802292:	50                   	push   %eax
  802293:	6a 1d                	push   $0x1d
  802295:	e8 ae fc ff ff       	call   801f48 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
	return result;
  80229d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022a6:	89 01                	mov    %eax,(%ecx)
  8022a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	c9                   	leave  
  8022af:	c2 04 00             	ret    $0x4

008022b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	ff 75 10             	pushl  0x10(%ebp)
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	ff 75 08             	pushl  0x8(%ebp)
  8022c2:	6a 13                	push   $0x13
  8022c4:	e8 7f fc ff ff       	call   801f48 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cc:	90                   	nop
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 1e                	push   $0x1e
  8022de:	e8 65 fc ff ff       	call   801f48 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	50                   	push   %eax
  802301:	6a 1f                	push   $0x1f
  802303:	e8 40 fc ff ff       	call   801f48 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
	return ;
  80230b:	90                   	nop
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <rsttst>:
void rsttst()
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 21                	push   $0x21
  80231d:	e8 26 fc ff ff       	call   801f48 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return ;
  802325:	90                   	nop
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802334:	8b 55 18             	mov    0x18(%ebp),%edx
  802337:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80233b:	52                   	push   %edx
  80233c:	50                   	push   %eax
  80233d:	ff 75 10             	pushl  0x10(%ebp)
  802340:	ff 75 0c             	pushl  0xc(%ebp)
  802343:	ff 75 08             	pushl  0x8(%ebp)
  802346:	6a 20                	push   $0x20
  802348:	e8 fb fb ff ff       	call   801f48 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
	return ;
  802350:	90                   	nop
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <chktst>:
void chktst(uint32 n)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	ff 75 08             	pushl  0x8(%ebp)
  802361:	6a 22                	push   $0x22
  802363:	e8 e0 fb ff ff       	call   801f48 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
	return ;
  80236b:	90                   	nop
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <inctst>:

void inctst()
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 23                	push   $0x23
  80237d:	e8 c6 fb ff ff       	call   801f48 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
	return ;
  802385:	90                   	nop
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <gettst>:
uint32 gettst()
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 24                	push   $0x24
  802397:	e8 ac fb ff ff       	call   801f48 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 25                	push   $0x25
  8023b0:	e8 93 fb ff ff       	call   801f48 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
  8023b8:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8023bd:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	ff 75 08             	pushl  0x8(%ebp)
  8023da:	6a 26                	push   $0x26
  8023dc:	e8 67 fb ff ff       	call   801f48 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e4:	90                   	nop
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	53                   	push   %ebx
  8023fa:	51                   	push   %ecx
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	6a 27                	push   $0x27
  8023ff:	e8 44 fb ff ff       	call   801f48 <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80240f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	52                   	push   %edx
  80241c:	50                   	push   %eax
  80241d:	6a 28                	push   $0x28
  80241f:	e8 24 fb ff ff       	call   801f48 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80242c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80242f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	51                   	push   %ecx
  802438:	ff 75 10             	pushl  0x10(%ebp)
  80243b:	52                   	push   %edx
  80243c:	50                   	push   %eax
  80243d:	6a 29                	push   $0x29
  80243f:	e8 04 fb ff ff       	call   801f48 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	ff 75 10             	pushl  0x10(%ebp)
  802453:	ff 75 0c             	pushl  0xc(%ebp)
  802456:	ff 75 08             	pushl  0x8(%ebp)
  802459:	6a 12                	push   $0x12
  80245b:	e8 e8 fa ff ff       	call   801f48 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
	return ;
  802463:	90                   	nop
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	52                   	push   %edx
  802476:	50                   	push   %eax
  802477:	6a 2a                	push   $0x2a
  802479:	e8 ca fa ff ff       	call   801f48 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
	return;
  802481:	90                   	nop
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 2b                	push   $0x2b
  802493:	e8 b0 fa ff ff       	call   801f48 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	ff 75 0c             	pushl  0xc(%ebp)
  8024a9:	ff 75 08             	pushl  0x8(%ebp)
  8024ac:	6a 2d                	push   $0x2d
  8024ae:	e8 95 fa ff ff       	call   801f48 <syscall>
  8024b3:	83 c4 18             	add    $0x18,%esp
	return;
  8024b6:	90                   	nop
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	ff 75 0c             	pushl  0xc(%ebp)
  8024c5:	ff 75 08             	pushl  0x8(%ebp)
  8024c8:	6a 2c                	push   $0x2c
  8024ca:	e8 79 fa ff ff       	call   801f48 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d2:	90                   	nop
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 c8 32 80 00       	push   $0x8032c8
  8024e3:	68 25 01 00 00       	push   $0x125
  8024e8:	68 fb 32 80 00       	push   $0x8032fb
  8024ed:	e8 48 01 00 00       	call   80263a <_panic>

008024f2 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	ba 60 40 80 00       	mov    $0x804060,%edx
  802500:	29 d0                	sub    %edx,%eax
  802502:	c1 f8 02             	sar    $0x2,%eax
  802505:	89 c2                	mov    %eax,%edx
  802507:	89 d0                	mov    %edx,%eax
  802509:	c1 e0 02             	shl    $0x2,%eax
  80250c:	01 d0                	add    %edx,%eax
  80250e:	c1 e0 02             	shl    $0x2,%eax
  802511:	01 d0                	add    %edx,%eax
  802513:	c1 e0 02             	shl    $0x2,%eax
  802516:	01 d0                	add    %edx,%eax
  802518:	89 c1                	mov    %eax,%ecx
  80251a:	c1 e1 08             	shl    $0x8,%ecx
  80251d:	01 c8                	add    %ecx,%eax
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	c1 e1 10             	shl    $0x10,%ecx
  802524:	01 c8                	add    %ecx,%eax
  802526:	01 c0                	add    %eax,%eax
  802528:	01 d0                	add    %edx,%eax
  80252a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80252d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802530:	c1 e0 0c             	shl    $0xc,%eax
  802533:	89 c2                	mov    %eax,%edx
  802535:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80253a:	01 d0                	add    %edx,%eax
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	05 00 00 00 02       	add    $0x2000000,%eax
  80254c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80254f:	73 16                	jae    802567 <initialize_dynamic_allocator+0x29>
  802551:	68 0c 33 80 00       	push   $0x80330c
  802556:	68 32 33 80 00       	push   $0x803332
  80255b:	6a 26                	push   $0x26
  80255d:	68 47 33 80 00       	push   $0x803347
  802562:	e8 d3 00 00 00       	call   80263a <_panic>
		is_initialized = 1;
  802567:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  80256e:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 60 33 80 00       	push   $0x803360
  802579:	6a 2e                	push   $0x2e
  80257b:	68 47 33 80 00       	push   $0x803347
  802580:	e8 b5 00 00 00       	call   80263a <_panic>

00802585 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  80258b:	83 ec 04             	sub    $0x4,%esp
  80258e:	68 94 33 80 00       	push   $0x803394
  802593:	6a 3a                	push   $0x3a
  802595:	68 47 33 80 00       	push   $0x803347
  80259a:	e8 9b 00 00 00       	call   80263a <_panic>

0080259f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8025a5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8025ac:	76 16                	jbe    8025c4 <alloc_block+0x25>
  8025ae:	68 bc 33 80 00       	push   $0x8033bc
  8025b3:	68 32 33 80 00       	push   $0x803332
  8025b8:	6a 46                	push   $0x46
  8025ba:	68 47 33 80 00       	push   $0x803347
  8025bf:	e8 76 00 00 00       	call   80263a <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8025c4:	83 ec 04             	sub    $0x4,%esp
  8025c7:	68 e0 33 80 00       	push   $0x8033e0
  8025cc:	6a 4d                	push   $0x4d
  8025ce:	68 47 33 80 00       	push   $0x803347
  8025d3:	e8 62 00 00 00       	call   80263a <_panic>

008025d8 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8025de:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8025e6:	39 c2                	cmp    %eax,%edx
  8025e8:	72 0c                	jb     8025f6 <free_block+0x1e>
  8025ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ed:	a1 40 40 80 00       	mov    0x804040,%eax
  8025f2:	39 c2                	cmp    %eax,%edx
  8025f4:	72 16                	jb     80260c <free_block+0x34>
  8025f6:	68 04 34 80 00       	push   $0x803404
  8025fb:	68 32 33 80 00       	push   $0x803332
  802600:	6a 5b                	push   $0x5b
  802602:	68 47 33 80 00       	push   $0x803347
  802607:	e8 2e 00 00 00       	call   80263a <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	68 3c 34 80 00       	push   $0x80343c
  802614:	6a 63                	push   $0x63
  802616:	68 47 33 80 00       	push   $0x803347
  80261b:	e8 1a 00 00 00       	call   80263a <_panic>

00802620 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	68 60 34 80 00       	push   $0x803460
  80262e:	6a 72                	push   $0x72
  802630:	68 47 33 80 00       	push   $0x803347
  802635:	e8 00 00 00 00       	call   80263a <_panic>

0080263a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802640:	8d 45 10             	lea    0x10(%ebp),%eax
  802643:	83 c0 04             	add    $0x4,%eax
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802649:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 16                	je     802668 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802652:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802657:	83 ec 08             	sub    $0x8,%esp
  80265a:	50                   	push   %eax
  80265b:	68 84 34 80 00       	push   $0x803484
  802660:	e8 3f e6 ff ff       	call   800ca4 <cprintf>
  802665:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802668:	a1 04 40 80 00       	mov    0x804004,%eax
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	ff 75 0c             	pushl  0xc(%ebp)
  802673:	ff 75 08             	pushl  0x8(%ebp)
  802676:	50                   	push   %eax
  802677:	68 8c 34 80 00       	push   $0x80348c
  80267c:	6a 74                	push   $0x74
  80267e:	e8 4e e6 ff ff       	call   800cd1 <cprintf_colored>
  802683:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802686:	8b 45 10             	mov    0x10(%ebp),%eax
  802689:	83 ec 08             	sub    $0x8,%esp
  80268c:	ff 75 f4             	pushl  -0xc(%ebp)
  80268f:	50                   	push   %eax
  802690:	e8 a0 e5 ff ff       	call   800c35 <vcprintf>
  802695:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	6a 00                	push   $0x0
  80269d:	68 b4 34 80 00       	push   $0x8034b4
  8026a2:	e8 8e e5 ff ff       	call   800c35 <vcprintf>
  8026a7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8026aa:	e8 07 e5 ff ff       	call   800bb6 <exit>

	// should not return here
	while (1) ;
  8026af:	eb fe                	jmp    8026af <_panic+0x75>

008026b1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8026b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8026bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8026c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c5:	39 c2                	cmp    %eax,%edx
  8026c7:	74 14                	je     8026dd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	68 b8 34 80 00       	push   $0x8034b8
  8026d1:	6a 26                	push   $0x26
  8026d3:	68 04 35 80 00       	push   $0x803504
  8026d8:	e8 5d ff ff ff       	call   80263a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8026dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8026e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026eb:	e9 c5 00 00 00       	jmp    8027b5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	01 d0                	add    %edx,%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	85 c0                	test   %eax,%eax
  802703:	75 08                	jne    80270d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802705:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802708:	e9 a5 00 00 00       	jmp    8027b2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80270d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802714:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80271b:	eb 69                	jmp    802786 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80271d:	a1 20 40 80 00       	mov    0x804020,%eax
  802722:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802728:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272b:	89 d0                	mov    %edx,%eax
  80272d:	01 c0                	add    %eax,%eax
  80272f:	01 d0                	add    %edx,%eax
  802731:	c1 e0 03             	shl    $0x3,%eax
  802734:	01 c8                	add    %ecx,%eax
  802736:	8a 40 04             	mov    0x4(%eax),%al
  802739:	84 c0                	test   %al,%al
  80273b:	75 46                	jne    802783 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80273d:	a1 20 40 80 00       	mov    0x804020,%eax
  802742:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802748:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	01 c0                	add    %eax,%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	c1 e0 03             	shl    $0x3,%eax
  802754:	01 c8                	add    %ecx,%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80275b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80275e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802763:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	01 c8                	add    %ecx,%eax
  802774:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802776:	39 c2                	cmp    %eax,%edx
  802778:	75 09                	jne    802783 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80277a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802781:	eb 15                	jmp    802798 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802783:	ff 45 e8             	incl   -0x18(%ebp)
  802786:	a1 20 40 80 00       	mov    0x804020,%eax
  80278b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802794:	39 c2                	cmp    %eax,%edx
  802796:	77 85                	ja     80271d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80279c:	75 14                	jne    8027b2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 10 35 80 00       	push   $0x803510
  8027a6:	6a 3a                	push   $0x3a
  8027a8:	68 04 35 80 00       	push   $0x803504
  8027ad:	e8 88 fe ff ff       	call   80263a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8027b2:	ff 45 f0             	incl   -0x10(%ebp)
  8027b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027bb:	0f 8c 2f ff ff ff    	jl     8026f0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8027c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8027c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027cf:	eb 26                	jmp    8027f7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8027d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8027d6:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8027dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027df:	89 d0                	mov    %edx,%eax
  8027e1:	01 c0                	add    %eax,%eax
  8027e3:	01 d0                	add    %edx,%eax
  8027e5:	c1 e0 03             	shl    $0x3,%eax
  8027e8:	01 c8                	add    %ecx,%eax
  8027ea:	8a 40 04             	mov    0x4(%eax),%al
  8027ed:	3c 01                	cmp    $0x1,%al
  8027ef:	75 03                	jne    8027f4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8027f1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8027f4:	ff 45 e0             	incl   -0x20(%ebp)
  8027f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8027fc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	39 c2                	cmp    %eax,%edx
  802807:	77 c8                	ja     8027d1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80280f:	74 14                	je     802825 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 64 35 80 00       	push   $0x803564
  802819:	6a 44                	push   $0x44
  80281b:	68 04 35 80 00       	push   $0x803504
  802820:	e8 15 fe ff ff       	call   80263a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802825:	90                   	nop
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <__udivdi3>:
  802828:	55                   	push   %ebp
  802829:	57                   	push   %edi
  80282a:	56                   	push   %esi
  80282b:	53                   	push   %ebx
  80282c:	83 ec 1c             	sub    $0x1c,%esp
  80282f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802833:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80283b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80283f:	89 ca                	mov    %ecx,%edx
  802841:	89 f8                	mov    %edi,%eax
  802843:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802847:	85 f6                	test   %esi,%esi
  802849:	75 2d                	jne    802878 <__udivdi3+0x50>
  80284b:	39 cf                	cmp    %ecx,%edi
  80284d:	77 65                	ja     8028b4 <__udivdi3+0x8c>
  80284f:	89 fd                	mov    %edi,%ebp
  802851:	85 ff                	test   %edi,%edi
  802853:	75 0b                	jne    802860 <__udivdi3+0x38>
  802855:	b8 01 00 00 00       	mov    $0x1,%eax
  80285a:	31 d2                	xor    %edx,%edx
  80285c:	f7 f7                	div    %edi
  80285e:	89 c5                	mov    %eax,%ebp
  802860:	31 d2                	xor    %edx,%edx
  802862:	89 c8                	mov    %ecx,%eax
  802864:	f7 f5                	div    %ebp
  802866:	89 c1                	mov    %eax,%ecx
  802868:	89 d8                	mov    %ebx,%eax
  80286a:	f7 f5                	div    %ebp
  80286c:	89 cf                	mov    %ecx,%edi
  80286e:	89 fa                	mov    %edi,%edx
  802870:	83 c4 1c             	add    $0x1c,%esp
  802873:	5b                   	pop    %ebx
  802874:	5e                   	pop    %esi
  802875:	5f                   	pop    %edi
  802876:	5d                   	pop    %ebp
  802877:	c3                   	ret    
  802878:	39 ce                	cmp    %ecx,%esi
  80287a:	77 28                	ja     8028a4 <__udivdi3+0x7c>
  80287c:	0f bd fe             	bsr    %esi,%edi
  80287f:	83 f7 1f             	xor    $0x1f,%edi
  802882:	75 40                	jne    8028c4 <__udivdi3+0x9c>
  802884:	39 ce                	cmp    %ecx,%esi
  802886:	72 0a                	jb     802892 <__udivdi3+0x6a>
  802888:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80288c:	0f 87 9e 00 00 00    	ja     802930 <__udivdi3+0x108>
  802892:	b8 01 00 00 00       	mov    $0x1,%eax
  802897:	89 fa                	mov    %edi,%edx
  802899:	83 c4 1c             	add    $0x1c,%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
  8028a1:	8d 76 00             	lea    0x0(%esi),%esi
  8028a4:	31 ff                	xor    %edi,%edi
  8028a6:	31 c0                	xor    %eax,%eax
  8028a8:	89 fa                	mov    %edi,%edx
  8028aa:	83 c4 1c             	add    $0x1c,%esp
  8028ad:	5b                   	pop    %ebx
  8028ae:	5e                   	pop    %esi
  8028af:	5f                   	pop    %edi
  8028b0:	5d                   	pop    %ebp
  8028b1:	c3                   	ret    
  8028b2:	66 90                	xchg   %ax,%ax
  8028b4:	89 d8                	mov    %ebx,%eax
  8028b6:	f7 f7                	div    %edi
  8028b8:	31 ff                	xor    %edi,%edi
  8028ba:	89 fa                	mov    %edi,%edx
  8028bc:	83 c4 1c             	add    $0x1c,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    
  8028c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028c9:	89 eb                	mov    %ebp,%ebx
  8028cb:	29 fb                	sub    %edi,%ebx
  8028cd:	89 f9                	mov    %edi,%ecx
  8028cf:	d3 e6                	shl    %cl,%esi
  8028d1:	89 c5                	mov    %eax,%ebp
  8028d3:	88 d9                	mov    %bl,%cl
  8028d5:	d3 ed                	shr    %cl,%ebp
  8028d7:	89 e9                	mov    %ebp,%ecx
  8028d9:	09 f1                	or     %esi,%ecx
  8028db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028df:	89 f9                	mov    %edi,%ecx
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 c5                	mov    %eax,%ebp
  8028e5:	89 d6                	mov    %edx,%esi
  8028e7:	88 d9                	mov    %bl,%cl
  8028e9:	d3 ee                	shr    %cl,%esi
  8028eb:	89 f9                	mov    %edi,%ecx
  8028ed:	d3 e2                	shl    %cl,%edx
  8028ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028f3:	88 d9                	mov    %bl,%cl
  8028f5:	d3 e8                	shr    %cl,%eax
  8028f7:	09 c2                	or     %eax,%edx
  8028f9:	89 d0                	mov    %edx,%eax
  8028fb:	89 f2                	mov    %esi,%edx
  8028fd:	f7 74 24 0c          	divl   0xc(%esp)
  802901:	89 d6                	mov    %edx,%esi
  802903:	89 c3                	mov    %eax,%ebx
  802905:	f7 e5                	mul    %ebp
  802907:	39 d6                	cmp    %edx,%esi
  802909:	72 19                	jb     802924 <__udivdi3+0xfc>
  80290b:	74 0b                	je     802918 <__udivdi3+0xf0>
  80290d:	89 d8                	mov    %ebx,%eax
  80290f:	31 ff                	xor    %edi,%edi
  802911:	e9 58 ff ff ff       	jmp    80286e <__udivdi3+0x46>
  802916:	66 90                	xchg   %ax,%ax
  802918:	8b 54 24 08          	mov    0x8(%esp),%edx
  80291c:	89 f9                	mov    %edi,%ecx
  80291e:	d3 e2                	shl    %cl,%edx
  802920:	39 c2                	cmp    %eax,%edx
  802922:	73 e9                	jae    80290d <__udivdi3+0xe5>
  802924:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802927:	31 ff                	xor    %edi,%edi
  802929:	e9 40 ff ff ff       	jmp    80286e <__udivdi3+0x46>
  80292e:	66 90                	xchg   %ax,%ax
  802930:	31 c0                	xor    %eax,%eax
  802932:	e9 37 ff ff ff       	jmp    80286e <__udivdi3+0x46>
  802937:	90                   	nop

00802938 <__umoddi3>:
  802938:	55                   	push   %ebp
  802939:	57                   	push   %edi
  80293a:	56                   	push   %esi
  80293b:	53                   	push   %ebx
  80293c:	83 ec 1c             	sub    $0x1c,%esp
  80293f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802943:	8b 74 24 34          	mov    0x34(%esp),%esi
  802947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80294b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80294f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802953:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802957:	89 f3                	mov    %esi,%ebx
  802959:	89 fa                	mov    %edi,%edx
  80295b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80295f:	89 34 24             	mov    %esi,(%esp)
  802962:	85 c0                	test   %eax,%eax
  802964:	75 1a                	jne    802980 <__umoddi3+0x48>
  802966:	39 f7                	cmp    %esi,%edi
  802968:	0f 86 a2 00 00 00    	jbe    802a10 <__umoddi3+0xd8>
  80296e:	89 c8                	mov    %ecx,%eax
  802970:	89 f2                	mov    %esi,%edx
  802972:	f7 f7                	div    %edi
  802974:	89 d0                	mov    %edx,%eax
  802976:	31 d2                	xor    %edx,%edx
  802978:	83 c4 1c             	add    $0x1c,%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5e                   	pop    %esi
  80297d:	5f                   	pop    %edi
  80297e:	5d                   	pop    %ebp
  80297f:	c3                   	ret    
  802980:	39 f0                	cmp    %esi,%eax
  802982:	0f 87 ac 00 00 00    	ja     802a34 <__umoddi3+0xfc>
  802988:	0f bd e8             	bsr    %eax,%ebp
  80298b:	83 f5 1f             	xor    $0x1f,%ebp
  80298e:	0f 84 ac 00 00 00    	je     802a40 <__umoddi3+0x108>
  802994:	bf 20 00 00 00       	mov    $0x20,%edi
  802999:	29 ef                	sub    %ebp,%edi
  80299b:	89 fe                	mov    %edi,%esi
  80299d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a1:	89 e9                	mov    %ebp,%ecx
  8029a3:	d3 e0                	shl    %cl,%eax
  8029a5:	89 d7                	mov    %edx,%edi
  8029a7:	89 f1                	mov    %esi,%ecx
  8029a9:	d3 ef                	shr    %cl,%edi
  8029ab:	09 c7                	or     %eax,%edi
  8029ad:	89 e9                	mov    %ebp,%ecx
  8029af:	d3 e2                	shl    %cl,%edx
  8029b1:	89 14 24             	mov    %edx,(%esp)
  8029b4:	89 d8                	mov    %ebx,%eax
  8029b6:	d3 e0                	shl    %cl,%eax
  8029b8:	89 c2                	mov    %eax,%edx
  8029ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029be:	d3 e0                	shl    %cl,%eax
  8029c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029c8:	89 f1                	mov    %esi,%ecx
  8029ca:	d3 e8                	shr    %cl,%eax
  8029cc:	09 d0                	or     %edx,%eax
  8029ce:	d3 eb                	shr    %cl,%ebx
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	f7 f7                	div    %edi
  8029d4:	89 d3                	mov    %edx,%ebx
  8029d6:	f7 24 24             	mull   (%esp)
  8029d9:	89 c6                	mov    %eax,%esi
  8029db:	89 d1                	mov    %edx,%ecx
  8029dd:	39 d3                	cmp    %edx,%ebx
  8029df:	0f 82 87 00 00 00    	jb     802a6c <__umoddi3+0x134>
  8029e5:	0f 84 91 00 00 00    	je     802a7c <__umoddi3+0x144>
  8029eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029ef:	29 f2                	sub    %esi,%edx
  8029f1:	19 cb                	sbb    %ecx,%ebx
  8029f3:	89 d8                	mov    %ebx,%eax
  8029f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8029f9:	d3 e0                	shl    %cl,%eax
  8029fb:	89 e9                	mov    %ebp,%ecx
  8029fd:	d3 ea                	shr    %cl,%edx
  8029ff:	09 d0                	or     %edx,%eax
  802a01:	89 e9                	mov    %ebp,%ecx
  802a03:	d3 eb                	shr    %cl,%ebx
  802a05:	89 da                	mov    %ebx,%edx
  802a07:	83 c4 1c             	add    $0x1c,%esp
  802a0a:	5b                   	pop    %ebx
  802a0b:	5e                   	pop    %esi
  802a0c:	5f                   	pop    %edi
  802a0d:	5d                   	pop    %ebp
  802a0e:	c3                   	ret    
  802a0f:	90                   	nop
  802a10:	89 fd                	mov    %edi,%ebp
  802a12:	85 ff                	test   %edi,%edi
  802a14:	75 0b                	jne    802a21 <__umoddi3+0xe9>
  802a16:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f7                	div    %edi
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	89 f0                	mov    %esi,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f5                	div    %ebp
  802a27:	89 c8                	mov    %ecx,%eax
  802a29:	f7 f5                	div    %ebp
  802a2b:	89 d0                	mov    %edx,%eax
  802a2d:	e9 44 ff ff ff       	jmp    802976 <__umoddi3+0x3e>
  802a32:	66 90                	xchg   %ax,%ax
  802a34:	89 c8                	mov    %ecx,%eax
  802a36:	89 f2                	mov    %esi,%edx
  802a38:	83 c4 1c             	add    $0x1c,%esp
  802a3b:	5b                   	pop    %ebx
  802a3c:	5e                   	pop    %esi
  802a3d:	5f                   	pop    %edi
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
  802a40:	3b 04 24             	cmp    (%esp),%eax
  802a43:	72 06                	jb     802a4b <__umoddi3+0x113>
  802a45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a49:	77 0f                	ja     802a5a <__umoddi3+0x122>
  802a4b:	89 f2                	mov    %esi,%edx
  802a4d:	29 f9                	sub    %edi,%ecx
  802a4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a53:	89 14 24             	mov    %edx,(%esp)
  802a56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a5e:	8b 14 24             	mov    (%esp),%edx
  802a61:	83 c4 1c             	add    $0x1c,%esp
  802a64:	5b                   	pop    %ebx
  802a65:	5e                   	pop    %esi
  802a66:	5f                   	pop    %edi
  802a67:	5d                   	pop    %ebp
  802a68:	c3                   	ret    
  802a69:	8d 76 00             	lea    0x0(%esi),%esi
  802a6c:	2b 04 24             	sub    (%esp),%eax
  802a6f:	19 fa                	sbb    %edi,%edx
  802a71:	89 d1                	mov    %edx,%ecx
  802a73:	89 c6                	mov    %eax,%esi
  802a75:	e9 71 ff ff ff       	jmp    8029eb <__umoddi3+0xb3>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a80:	72 ea                	jb     802a6c <__umoddi3+0x134>
  802a82:	89 d9                	mov    %ebx,%ecx
  802a84:	e9 62 ff ff ff       	jmp    8029eb <__umoddi3+0xb3>

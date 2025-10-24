
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 cf 07 00 00       	call   800805 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_lock_cons();
  80004c:	e8 45 1f 00 00       	call   801f96 <sys_lock_cons>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 80 28 80 00       	push   $0x802880
  800060:	e8 f7 12 00 00       	call   80135c <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 f8 18 00 00       	call   801973 <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 bd 1d 00 00       	call   801e4d <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 40 80 00       	mov    0x804024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 90 1f 00 00       	call   802046 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 a2 1f 00 00       	call   80205f <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 a0 28 80 00       	push   $0x8028a0
  8000e7:	e8 97 0b 00 00       	call   800c83 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 c3 28 80 00       	push   $0x8028c3
  8000f7:	e8 87 0b 00 00       	call   800c83 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 d1 28 80 00       	push   $0x8028d1
  800107:	e8 77 0b 00 00       	call   800c83 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e0 28 80 00       	push   $0x8028e0
  800117:	e8 67 0b 00 00       	call   800c83 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 f0 28 80 00       	push   $0x8028f0
  800127:	e8 57 0b 00 00       	call   800c83 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 b4 06 00 00       	call   8007e8 <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 85 06 00 00       	call   8007c9 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 78 06 00 00       	call   8007c9 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_unlock_cons();
  800166:	e8 45 1e 00 00       	call   801fb0 <sys_unlock_cons>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 05 05 00 00       	call   800691 <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 23 05 00 00       	call   8006c2 <InitializeIdentical>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 45 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 32 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 00 03 00 00       	call   8004d6 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 00 04 00 00       	call   8005e7 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 fc 28 80 00       	push   $0x8028fc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 1e 29 80 00       	push   $0x80291e
  800202:	e8 ae 07 00 00       	call   8009b5 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 3c 29 80 00       	push   $0x80293c
  80020f:	e8 6f 0a 00 00       	call   800c83 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 70 29 80 00       	push   $0x802970
  80021f:	e8 5f 0a 00 00       	call   800c83 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 a4 29 80 00       	push   $0x8029a4
  80022f:	e8 4f 0a 00 00       	call   800c83 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 d6 29 80 00       	push   $0x8029d6
  80023f:	e8 3f 0a 00 00       	call   800c83 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 29 1c 00 00       	call   801e7b <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 ec 29 80 00       	push   $0x8029ec
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 1e 29 80 00       	push   $0x80291e
  800282:	e8 2e 07 00 00       	call   8009b5 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 40 80 00       	mov    0x804024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 a6 1d 00 00       	call   802046 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 b8 1d 00 00       	call   80205f <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 3c 2a 80 00       	push   $0x802a3c
  8002c5:	68 61 2a 80 00       	push   $0x802a61
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 1e 29 80 00       	push   $0x80291e
  8002d1:	e8 df 06 00 00       	call   8009b5 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 ec 29 80 00       	push   $0x8029ec
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 1e 29 80 00       	push   $0x80291e
  8002fa:	e8 b6 06 00 00       	call   8009b5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 40 80 00       	mov    0x804024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 2e 1d 00 00       	call   802046 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 40 1d 00 00       	call   80205f <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 3c 2a 80 00       	push   $0x802a3c
  80033d:	68 61 2a 80 00       	push   $0x802a61
  800342:	6a 77                	push   $0x77
  800344:	68 1e 29 80 00       	push   $0x80291e
  800349:	e8 67 06 00 00       	call   8009b5 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 ec 29 80 00       	push   $0x8029ec
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 1e 29 80 00       	push   $0x80291e
  800372:	e8 3e 06 00 00       	call   8009b5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 40 80 00       	mov    0x804024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 b6 1c 00 00       	call   802046 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 c8 1c 00 00       	call   80205f <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 3c 2a 80 00       	push   $0x802a3c
  8003b1:	68 61 2a 80 00       	push   $0x802a61
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 1e 29 80 00       	push   $0x80291e
  8003c0:	e8 f0 05 00 00       	call   8009b5 <_panic>
		}
		///========================================================================
	sys_lock_cons();
  8003c5:	e8 cc 1b 00 00       	call   801f96 <sys_lock_cons>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 76 2a 80 00       	push   $0x802a76
  8003d8:	e8 a6 08 00 00       	call   800c83 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 03 04 00 00       	call   8007e8 <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d4 03 00 00       	call   8007c9 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c7 03 00 00       	call   8007c9 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 ba 03 00 00       	call   8007c9 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_unlock_cons();
  80041e:	e8 8d 1b 00 00       	call   801fb0 <sys_unlock_cons>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 94 2a 80 00       	push   $0x802a94
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 1e 29 80 00       	push   $0x80291e
  8004b5:	e8 fb 04 00 00       	call   8009b5 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	0f 87 78 ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004d1:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004df:	48                   	dec    %eax
  8004e0:	50                   	push   %eax
  8004e1:	6a 00                	push   $0x0
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 06 00 00 00       	call   8004f4 <QSort>
  8004ee:	83 c4 10             	add    $0x10,%esp
}
  8004f1:	90                   	nop
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800500:	0f 8d de 00 00 00    	jge    8005e4 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	40                   	inc    %eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800513:	e9 80 00 00 00       	jmp    800598 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800518:	ff 45 f4             	incl   -0xc(%ebp)
  80051b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800521:	7f 2b                	jg     80054e <QSort+0x5a>
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	8b 10                	mov    (%eax),%edx
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	39 c2                	cmp    %eax,%edx
  800547:	7d cf                	jge    800518 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800549:	eb 03                	jmp    80054e <QSort+0x5a>
  80054b:	ff 4d f0             	decl   -0x10(%ebp)
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	3b 45 10             	cmp    0x10(%ebp),%eax
  800554:	7e 26                	jle    80057c <QSort+0x88>
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	8b 10                	mov    (%eax),%edx
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	7e cf                	jle    80054b <QSort+0x57>

		if (i <= j)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800582:	7f 14                	jg     800598 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	ff 75 f0             	pushl  -0x10(%ebp)
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	e8 a9 00 00 00       	call   80063e <Swap>
  800595:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059e:	0f 8e 77 ff ff ff    	jle    80051b <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	e8 89 00 00 00       	call   80063e <Swap>
  8005b5:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 29 ff ff ff       	call   8004f4 <QSort>
  8005cb:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005ce:	ff 75 14             	pushl  0x14(%ebp)
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 15 ff ff ff       	call   8004f4 <QSort>
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb 01                	jmp    8005e5 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e4:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005fb:	eb 33                	jmp    800630 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800611:	40                   	inc    %eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7e 09                	jle    80062d <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80062b:	eb 0c                	jmp    800639 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062d:	ff 45 f8             	incl   -0x8(%ebp)
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	48                   	dec    %eax
  800634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800637:	7f c4                	jg     8005fd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	01 d0                	add    %edx,%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	01 c2                	add    %eax,%edx
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c8                	add    %ecx,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 c2                	add    %eax,%edx
  800689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80068c:	89 02                	mov    %eax,(%edx)
}
  80068e:	90                   	nop
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069e:	eb 17                	jmp    8006b7 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	01 c2                	add    %eax,%edx
  8006af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b2:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b4:	ff 45 fc             	incl   -0x4(%ebp)
  8006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bd:	7c e1                	jl     8006a0 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bf:	90                   	nop
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    

008006c2 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cf:	eb 1b                	jmp    8006ec <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	01 c2                	add    %eax,%edx
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e6:	48                   	dec    %eax
  8006e7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e9:	ff 45 fc             	incl   -0x4(%ebp)
  8006ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f2:	7c dd                	jl     8006d1 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f4:	90                   	nop
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800705:	f7 e9                	imul   %ecx
  800707:	c1 f9 1f             	sar    $0x1f,%ecx
  80070a:	89 d0                	mov    %edx,%eax
  80070c:	29 c8                	sub    %ecx,%eax
  80070e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800718:	eb 1e                	jmp    800738 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80071a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80072a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072d:	99                   	cltd   
  80072e:	f7 7d f8             	idivl  -0x8(%ebp)
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800735:	ff 45 fc             	incl   -0x4(%ebp)
  800738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	7c da                	jl     80071a <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800749:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800757:	eb 42                	jmp    80079b <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075c:	99                   	cltd   
  80075d:	f7 7d f0             	idivl  -0x10(%ebp)
  800760:	89 d0                	mov    %edx,%eax
  800762:	85 c0                	test   %eax,%eax
  800764:	75 10                	jne    800776 <PrintElements+0x33>
			cprintf("\n");
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	68 c2 2a 80 00       	push   $0x802ac2
  80076e:	e8 10 05 00 00       	call   800c83 <cprintf>
  800773:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800779:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	50                   	push   %eax
  80078b:	68 c4 2a 80 00       	push   $0x802ac4
  800790:	e8 ee 04 00 00       	call   800c83 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800798:	ff 45 f4             	incl   -0xc(%ebp)
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	48                   	dec    %eax
  80079f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8007a2:	7f b5                	jg     800759 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	50                   	push   %eax
  8007b9:	68 c9 2a 80 00       	push   $0x802ac9
  8007be:	e8 c0 04 00 00       	call   800c83 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp

}
  8007c6:	90                   	nop
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	50                   	push   %eax
  8007dd:	e8 fc 18 00 00       	call   8020de <sys_cputc>
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	90                   	nop
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <getchar>:


int
getchar(void)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8007ee:	e8 8a 17 00 00       	call   801f7d <sys_cgetc>
  8007f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <iscons>:

int iscons(int fdnum)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	57                   	push   %edi
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80080e:	e8 fc 19 00 00       	call   80220f <sys_getenvindex>
  800813:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800819:	89 d0                	mov    %edx,%eax
  80081b:	c1 e0 02             	shl    $0x2,%eax
  80081e:	01 d0                	add    %edx,%eax
  800820:	c1 e0 03             	shl    $0x3,%eax
  800823:	01 d0                	add    %edx,%eax
  800825:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80082c:	01 d0                	add    %edx,%eax
  80082e:	c1 e0 02             	shl    $0x2,%eax
  800831:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800836:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80083b:	a1 24 40 80 00       	mov    0x804024,%eax
  800840:	8a 40 20             	mov    0x20(%eax),%al
  800843:	84 c0                	test   %al,%al
  800845:	74 0d                	je     800854 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800847:	a1 24 40 80 00       	mov    0x804024,%eax
  80084c:	83 c0 20             	add    $0x20,%eax
  80084f:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800858:	7e 0a                	jle    800864 <libmain+0x5f>
		binaryname = argv[0];
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 c6 f7 ff ff       	call   800038 <_main>
  800872:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800875:	a1 00 40 80 00       	mov    0x804000,%eax
  80087a:	85 c0                	test   %eax,%eax
  80087c:	0f 84 01 01 00 00    	je     800983 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800882:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800888:	bb c8 2b 80 00       	mov    $0x802bc8,%ebx
  80088d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800892:	89 c7                	mov    %eax,%edi
  800894:	89 de                	mov    %ebx,%esi
  800896:	89 d1                	mov    %edx,%ecx
  800898:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80089a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80089d:	b9 56 00 00 00       	mov    $0x56,%ecx
  8008a2:	b0 00                	mov    $0x0,%al
  8008a4:	89 d7                	mov    %edx,%edi
  8008a6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8008a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8008af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	50                   	push   %eax
  8008b6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	e8 83 1b 00 00       	call   802445 <sys_utilities>
  8008c2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008c5:	e8 cc 16 00 00       	call   801f96 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008ca:	83 ec 0c             	sub    $0xc,%esp
  8008cd:	68 e8 2a 80 00       	push   $0x802ae8
  8008d2:	e8 ac 03 00 00       	call   800c83 <cprintf>
  8008d7:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 18                	je     8008f9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008e1:	e8 7d 1b 00 00       	call   802463 <sys_get_optimal_num_faults>
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	50                   	push   %eax
  8008ea:	68 10 2b 80 00       	push   $0x802b10
  8008ef:	e8 8f 03 00 00       	call   800c83 <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb 59                	jmp    800952 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008f9:	a1 24 40 80 00       	mov    0x804024,%eax
  8008fe:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800904:	a1 24 40 80 00       	mov    0x804024,%eax
  800909:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	68 34 2b 80 00       	push   $0x802b34
  800919:	e8 65 03 00 00       	call   800c83 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800921:	a1 24 40 80 00       	mov    0x804024,%eax
  800926:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80092c:	a1 24 40 80 00       	mov    0x804024,%eax
  800931:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800937:	a1 24 40 80 00       	mov    0x804024,%eax
  80093c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	50                   	push   %eax
  800945:	68 5c 2b 80 00       	push   $0x802b5c
  80094a:	e8 34 03 00 00       	call   800c83 <cprintf>
  80094f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800952:	a1 24 40 80 00       	mov    0x804024,%eax
  800957:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	50                   	push   %eax
  800961:	68 b4 2b 80 00       	push   $0x802bb4
  800966:	e8 18 03 00 00       	call   800c83 <cprintf>
  80096b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80096e:	83 ec 0c             	sub    $0xc,%esp
  800971:	68 e8 2a 80 00       	push   $0x802ae8
  800976:	e8 08 03 00 00       	call   800c83 <cprintf>
  80097b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80097e:	e8 2d 16 00 00       	call   801fb0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800983:	e8 1f 00 00 00       	call   8009a7 <exit>
}
  800988:	90                   	nop
  800989:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5f                   	pop    %edi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800997:	83 ec 0c             	sub    $0xc,%esp
  80099a:	6a 00                	push   $0x0
  80099c:	e8 3a 18 00 00       	call   8021db <sys_destroy_env>
  8009a1:	83 c4 10             	add    $0x10,%esp
}
  8009a4:	90                   	nop
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <exit>:

void
exit(void)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8009ad:	e8 8f 18 00 00       	call   802241 <sys_exit_env>
}
  8009b2:	90                   	nop
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8009be:	83 c0 04             	add    $0x4,%eax
  8009c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009c4:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	74 16                	je     8009e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009cd:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	50                   	push   %eax
  8009d6:	68 2c 2c 80 00       	push   $0x802c2c
  8009db:	e8 a3 02 00 00       	call   800c83 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8009e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	ff 75 08             	pushl  0x8(%ebp)
  8009f1:	50                   	push   %eax
  8009f2:	68 34 2c 80 00       	push   $0x802c34
  8009f7:	6a 74                	push   $0x74
  8009f9:	e8 b2 02 00 00       	call   800cb0 <cprintf_colored>
  8009fe:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800a01:	8b 45 10             	mov    0x10(%ebp),%eax
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	e8 04 02 00 00       	call   800c14 <vcprintf>
  800a10:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	6a 00                	push   $0x0
  800a18:	68 5c 2c 80 00       	push   $0x802c5c
  800a1d:	e8 f2 01 00 00       	call   800c14 <vcprintf>
  800a22:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a25:	e8 7d ff ff ff       	call   8009a7 <exit>

	// should not return here
	while (1) ;
  800a2a:	eb fe                	jmp    800a2a <_panic+0x75>

00800a2c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a32:	a1 24 40 80 00       	mov    0x804024,%eax
  800a37:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	74 14                	je     800a58 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a44:	83 ec 04             	sub    $0x4,%esp
  800a47:	68 60 2c 80 00       	push   $0x802c60
  800a4c:	6a 26                	push   $0x26
  800a4e:	68 ac 2c 80 00       	push   $0x802cac
  800a53:	e8 5d ff ff ff       	call   8009b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a66:	e9 c5 00 00 00       	jmp    800b30 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	01 d0                	add    %edx,%eax
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 08                	jne    800a88 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a80:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a83:	e9 a5 00 00 00       	jmp    800b2d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a96:	eb 69                	jmp    800b01 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a98:	a1 24 40 80 00       	mov    0x804024,%eax
  800a9d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800aa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	84 c0                	test   %al,%al
  800ab6:	75 46                	jne    800afe <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ab8:	a1 24 40 80 00       	mov    0x804024,%eax
  800abd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ac3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	01 c0                	add    %eax,%eax
  800aca:	01 d0                	add    %edx,%eax
  800acc:	c1 e0 03             	shl    $0x3,%eax
  800acf:	01 c8                	add    %ecx,%eax
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ad6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ade:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	01 c8                	add    %ecx,%eax
  800aef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	75 09                	jne    800afe <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800af5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800afc:	eb 15                	jmp    800b13 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800afe:	ff 45 e8             	incl   -0x18(%ebp)
  800b01:	a1 24 40 80 00       	mov    0x804024,%eax
  800b06:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	77 85                	ja     800a98 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b17:	75 14                	jne    800b2d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	68 b8 2c 80 00       	push   $0x802cb8
  800b21:	6a 3a                	push   $0x3a
  800b23:	68 ac 2c 80 00       	push   $0x802cac
  800b28:	e8 88 fe ff ff       	call   8009b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b2d:	ff 45 f0             	incl   -0x10(%ebp)
  800b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b33:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b36:	0f 8c 2f ff ff ff    	jl     800a6b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b4a:	eb 26                	jmp    800b72 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b4c:	a1 24 40 80 00       	mov    0x804024,%eax
  800b51:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b5a:	89 d0                	mov    %edx,%eax
  800b5c:	01 c0                	add    %eax,%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	c1 e0 03             	shl    $0x3,%eax
  800b63:	01 c8                	add    %ecx,%eax
  800b65:	8a 40 04             	mov    0x4(%eax),%al
  800b68:	3c 01                	cmp    $0x1,%al
  800b6a:	75 03                	jne    800b6f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b6c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b6f:	ff 45 e0             	incl   -0x20(%ebp)
  800b72:	a1 24 40 80 00       	mov    0x804024,%eax
  800b77:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	77 c8                	ja     800b4c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b87:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b8a:	74 14                	je     800ba0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b8c:	83 ec 04             	sub    $0x4,%esp
  800b8f:	68 0c 2d 80 00       	push   $0x802d0c
  800b94:	6a 44                	push   $0x44
  800b96:	68 ac 2c 80 00       	push   $0x802cac
  800b9b:	e8 15 fe ff ff       	call   8009b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ba0:	90                   	nop
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	53                   	push   %ebx
  800ba7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	8d 48 01             	lea    0x1(%eax),%ecx
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb5:	89 0a                	mov    %ecx,(%edx)
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bba:	88 d1                	mov    %dl,%cl
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 00                	mov    (%eax),%eax
  800bc8:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bcd:	75 30                	jne    800bff <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bcf:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bd5:	a0 44 40 80 00       	mov    0x804044,%al
  800bda:	0f b6 c0             	movzbl %al,%eax
  800bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be0:	8b 09                	mov    (%ecx),%ecx
  800be2:	89 cb                	mov    %ecx,%ebx
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	83 c1 08             	add    $0x8,%ecx
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	53                   	push   %ebx
  800bed:	51                   	push   %ecx
  800bee:	e8 5f 13 00 00       	call   801f52 <sys_cputs>
  800bf3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c0e:	90                   	nop
  800c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c1d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c24:	00 00 00 
	b.cnt = 0;
  800c27:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c2e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	ff 75 08             	pushl  0x8(%ebp)
  800c37:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3d:	50                   	push   %eax
  800c3e:	68 a3 0b 80 00       	push   $0x800ba3
  800c43:	e8 5a 02 00 00       	call   800ea2 <vprintfmt>
  800c48:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c4b:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800c51:	a0 44 40 80 00       	mov    0x804044,%al
  800c56:	0f b6 c0             	movzbl %al,%eax
  800c59:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c5f:	52                   	push   %edx
  800c60:	50                   	push   %eax
  800c61:	51                   	push   %ecx
  800c62:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c68:	83 c0 08             	add    $0x8,%eax
  800c6b:	50                   	push   %eax
  800c6c:	e8 e1 12 00 00       	call   801f52 <sys_cputs>
  800c71:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c74:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c89:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c90:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9f:	50                   	push   %eax
  800ca0:	e8 6f ff ff ff       	call   800c14 <vcprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cb6:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	c1 e0 08             	shl    $0x8,%eax
  800cc3:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800cc8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ccb:	83 c0 04             	add    $0x4,%eax
  800cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cda:	50                   	push   %eax
  800cdb:	e8 34 ff ff ff       	call   800c14 <vcprintf>
  800ce0:	83 c4 10             	add    $0x10,%esp
  800ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ce6:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800ced:	07 00 00 

	return cnt;
  800cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800cfb:	e8 96 12 00 00       	call   801f96 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d00:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	e8 ff fe ff ff       	call   800c14 <vcprintf>
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d1b:	e8 90 12 00 00       	call   801fb0 <sys_unlock_cons>
	return cnt;
  800d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	53                   	push   %ebx
  800d29:	83 ec 14             	sub    $0x14,%esp
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d38:	8b 45 18             	mov    0x18(%ebp),%eax
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d43:	77 55                	ja     800d9a <printnum+0x75>
  800d45:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d48:	72 05                	jb     800d4f <printnum+0x2a>
  800d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d4d:	77 4b                	ja     800d9a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d4f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d52:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d55:	8b 45 18             	mov    0x18(%ebp),%eax
  800d58:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5d:	52                   	push   %edx
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d62:	ff 75 f0             	pushl  -0x10(%ebp)
  800d65:	e8 b2 18 00 00       	call   80261c <__udivdi3>
  800d6a:	83 c4 10             	add    $0x10,%esp
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	ff 75 20             	pushl  0x20(%ebp)
  800d73:	53                   	push   %ebx
  800d74:	ff 75 18             	pushl  0x18(%ebp)
  800d77:	52                   	push   %edx
  800d78:	50                   	push   %eax
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	ff 75 08             	pushl  0x8(%ebp)
  800d7f:	e8 a1 ff ff ff       	call   800d25 <printnum>
  800d84:	83 c4 20             	add    $0x20,%esp
  800d87:	eb 1a                	jmp    800da3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 20             	pushl  0x20(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d9a:	ff 4d 1c             	decl   0x1c(%ebp)
  800d9d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800da1:	7f e6                	jg     800d89 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800da3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db1:	53                   	push   %ebx
  800db2:	51                   	push   %ecx
  800db3:	52                   	push   %edx
  800db4:	50                   	push   %eax
  800db5:	e8 72 19 00 00       	call   80272c <__umoddi3>
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	05 74 2f 80 00       	add    $0x802f74,%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f be c0             	movsbl %al,%eax
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	50                   	push   %eax
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
}
  800dd6:	90                   	nop
  800dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ddf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800de3:	7e 1c                	jle    800e01 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	8d 50 08             	lea    0x8(%eax),%edx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 10                	mov    %edx,(%eax)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	83 e8 08             	sub    $0x8,%eax
  800dfa:	8b 50 04             	mov    0x4(%eax),%edx
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	eb 40                	jmp    800e41 <getuint+0x65>
	else if (lflag)
  800e01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e05:	74 1e                	je     800e25 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	8d 50 04             	lea    0x4(%eax),%edx
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 10                	mov    %edx,(%eax)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8b 00                	mov    (%eax),%eax
  800e19:	83 e8 04             	sub    $0x4,%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e23:	eb 1c                	jmp    800e41 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8b 00                	mov    (%eax),%eax
  800e2a:	8d 50 04             	lea    0x4(%eax),%edx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	89 10                	mov    %edx,(%eax)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8b 00                	mov    (%eax),%eax
  800e37:	83 e8 04             	sub    $0x4,%eax
  800e3a:	8b 00                	mov    (%eax),%eax
  800e3c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e4a:	7e 1c                	jle    800e68 <getint+0x25>
		return va_arg(*ap, long long);
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	8d 50 08             	lea    0x8(%eax),%edx
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 10                	mov    %edx,(%eax)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8b 00                	mov    (%eax),%eax
  800e5e:	83 e8 08             	sub    $0x8,%eax
  800e61:	8b 50 04             	mov    0x4(%eax),%edx
  800e64:	8b 00                	mov    (%eax),%eax
  800e66:	eb 38                	jmp    800ea0 <getint+0x5d>
	else if (lflag)
  800e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6c:	74 1a                	je     800e88 <getint+0x45>
		return va_arg(*ap, long);
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8b 00                	mov    (%eax),%eax
  800e73:	8d 50 04             	lea    0x4(%eax),%edx
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 10                	mov    %edx,(%eax)
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8b 00                	mov    (%eax),%eax
  800e80:	83 e8 04             	sub    $0x4,%eax
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	99                   	cltd   
  800e86:	eb 18                	jmp    800ea0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8b 00                	mov    (%eax),%eax
  800e8d:	8d 50 04             	lea    0x4(%eax),%edx
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 10                	mov    %edx,(%eax)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	83 e8 04             	sub    $0x4,%eax
  800e9d:	8b 00                	mov    (%eax),%eax
  800e9f:	99                   	cltd   
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eaa:	eb 17                	jmp    800ec3 <vprintfmt+0x21>
			if (ch == '\0')
  800eac:	85 db                	test   %ebx,%ebx
  800eae:	0f 84 c1 03 00 00    	je     801275 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	53                   	push   %ebx
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	ff d0                	call   *%eax
  800ec0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	0f b6 d8             	movzbl %al,%ebx
  800ed1:	83 fb 25             	cmp    $0x25,%ebx
  800ed4:	75 d6                	jne    800eac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ed6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eda:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ee1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ee8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800eef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	8d 50 01             	lea    0x1(%eax),%edx
  800efc:	89 55 10             	mov    %edx,0x10(%ebp)
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d8             	movzbl %al,%ebx
  800f04:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f07:	83 f8 5b             	cmp    $0x5b,%eax
  800f0a:	0f 87 3d 03 00 00    	ja     80124d <vprintfmt+0x3ab>
  800f10:	8b 04 85 98 2f 80 00 	mov    0x802f98(,%eax,4),%eax
  800f17:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f19:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f1d:	eb d7                	jmp    800ef6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f1f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f23:	eb d1                	jmp    800ef6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f2f:	89 d0                	mov    %edx,%eax
  800f31:	c1 e0 02             	shl    $0x2,%eax
  800f34:	01 d0                	add    %edx,%eax
  800f36:	01 c0                	add    %eax,%eax
  800f38:	01 d8                	add    %ebx,%eax
  800f3a:	83 e8 30             	sub    $0x30,%eax
  800f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f48:	83 fb 2f             	cmp    $0x2f,%ebx
  800f4b:	7e 3e                	jle    800f8b <vprintfmt+0xe9>
  800f4d:	83 fb 39             	cmp    $0x39,%ebx
  800f50:	7f 39                	jg     800f8b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f52:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f55:	eb d5                	jmp    800f2c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	83 c0 04             	add    $0x4,%eax
  800f5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 e8 04             	sub    $0x4,%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f71:	79 83                	jns    800ef6 <vprintfmt+0x54>
				width = 0;
  800f73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f7a:	e9 77 ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f7f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f86:	e9 6b ff ff ff       	jmp    800ef6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f8b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f90:	0f 89 60 ff ff ff    	jns    800ef6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fa3:	e9 4e ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fa8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fab:	e9 46 ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	83 c0 04             	add    $0x4,%eax
  800fb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbc:	83 e8 04             	sub    $0x4,%eax
  800fbf:	8b 00                	mov    (%eax),%eax
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	ff 75 0c             	pushl  0xc(%ebp)
  800fc7:	50                   	push   %eax
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	ff d0                	call   *%eax
  800fcd:	83 c4 10             	add    $0x10,%esp
			break;
  800fd0:	e9 9b 02 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd8:	83 c0 04             	add    $0x4,%eax
  800fdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	83 e8 04             	sub    $0x4,%eax
  800fe4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fe6:	85 db                	test   %ebx,%ebx
  800fe8:	79 02                	jns    800fec <vprintfmt+0x14a>
				err = -err;
  800fea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fec:	83 fb 64             	cmp    $0x64,%ebx
  800fef:	7f 0b                	jg     800ffc <vprintfmt+0x15a>
  800ff1:	8b 34 9d e0 2d 80 00 	mov    0x802de0(,%ebx,4),%esi
  800ff8:	85 f6                	test   %esi,%esi
  800ffa:	75 19                	jne    801015 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ffc:	53                   	push   %ebx
  800ffd:	68 85 2f 80 00       	push   $0x802f85
  801002:	ff 75 0c             	pushl  0xc(%ebp)
  801005:	ff 75 08             	pushl  0x8(%ebp)
  801008:	e8 70 02 00 00       	call   80127d <printfmt>
  80100d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801010:	e9 5b 02 00 00       	jmp    801270 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801015:	56                   	push   %esi
  801016:	68 8e 2f 80 00       	push   $0x802f8e
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	ff 75 08             	pushl  0x8(%ebp)
  801021:	e8 57 02 00 00       	call   80127d <printfmt>
  801026:	83 c4 10             	add    $0x10,%esp
			break;
  801029:	e9 42 02 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 14             	mov    %eax,0x14(%ebp)
  801037:	8b 45 14             	mov    0x14(%ebp),%eax
  80103a:	83 e8 04             	sub    $0x4,%eax
  80103d:	8b 30                	mov    (%eax),%esi
  80103f:	85 f6                	test   %esi,%esi
  801041:	75 05                	jne    801048 <vprintfmt+0x1a6>
				p = "(null)";
  801043:	be 91 2f 80 00       	mov    $0x802f91,%esi
			if (width > 0 && padc != '-')
  801048:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80104c:	7e 6d                	jle    8010bb <vprintfmt+0x219>
  80104e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801052:	74 67                	je     8010bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	50                   	push   %eax
  80105b:	56                   	push   %esi
  80105c:	e8 26 05 00 00       	call   801587 <strnlen>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801067:	eb 16                	jmp    80107f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801069:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	50                   	push   %eax
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80107c:	ff 4d e4             	decl   -0x1c(%ebp)
  80107f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801083:	7f e4                	jg     801069 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801085:	eb 34                	jmp    8010bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801087:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80108b:	74 1c                	je     8010a9 <vprintfmt+0x207>
  80108d:	83 fb 1f             	cmp    $0x1f,%ebx
  801090:	7e 05                	jle    801097 <vprintfmt+0x1f5>
  801092:	83 fb 7e             	cmp    $0x7e,%ebx
  801095:	7e 12                	jle    8010a9 <vprintfmt+0x207>
					putch('?', putdat);
  801097:	83 ec 08             	sub    $0x8,%esp
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	6a 3f                	push   $0x3f
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	ff d0                	call   *%eax
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	eb 0f                	jmp    8010b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	53                   	push   %ebx
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8010bb:	89 f0                	mov    %esi,%eax
  8010bd:	8d 70 01             	lea    0x1(%eax),%esi
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be d8             	movsbl %al,%ebx
  8010c5:	85 db                	test   %ebx,%ebx
  8010c7:	74 24                	je     8010ed <vprintfmt+0x24b>
  8010c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010cd:	78 b8                	js     801087 <vprintfmt+0x1e5>
  8010cf:	ff 4d e0             	decl   -0x20(%ebp)
  8010d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010d6:	79 af                	jns    801087 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010d8:	eb 13                	jmp    8010ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8010da:	83 ec 08             	sub    $0x8,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	6a 20                	push   $0x20
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010f1:	7f e7                	jg     8010da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010f3:	e9 78 01 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8010fe:	8d 45 14             	lea    0x14(%ebp),%eax
  801101:	50                   	push   %eax
  801102:	e8 3c fd ff ff       	call   800e43 <getint>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80110d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801116:	85 d2                	test   %edx,%edx
  801118:	79 23                	jns    80113d <vprintfmt+0x29b>
				putch('-', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 2d                	push   $0x2d
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	f7 d8                	neg    %eax
  801132:	83 d2 00             	adc    $0x0,%edx
  801135:	f7 da                	neg    %edx
  801137:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80113d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801144:	e9 bc 00 00 00       	jmp    801205 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801149:	83 ec 08             	sub    $0x8,%esp
  80114c:	ff 75 e8             	pushl  -0x18(%ebp)
  80114f:	8d 45 14             	lea    0x14(%ebp),%eax
  801152:	50                   	push   %eax
  801153:	e8 84 fc ff ff       	call   800ddc <getuint>
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801161:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801168:	e9 98 00 00 00       	jmp    801205 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	ff 75 0c             	pushl  0xc(%ebp)
  801173:	6a 58                	push   $0x58
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	ff d0                	call   *%eax
  80117a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80117d:	83 ec 08             	sub    $0x8,%esp
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	6a 58                	push   $0x58
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	ff d0                	call   *%eax
  80118a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	6a 58                	push   $0x58
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	ff d0                	call   *%eax
  80119a:	83 c4 10             	add    $0x10,%esp
			break;
  80119d:	e9 ce 00 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	6a 30                	push   $0x30
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	ff d0                	call   *%eax
  8011af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	ff 75 0c             	pushl  0xc(%ebp)
  8011b8:	6a 78                	push   $0x78
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	ff d0                	call   *%eax
  8011bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	83 c0 04             	add    $0x4,%eax
  8011c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8011cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ce:	83 e8 04             	sub    $0x4,%eax
  8011d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011e4:	eb 1f                	jmp    801205 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8011ef:	50                   	push   %eax
  8011f0:	e8 e7 fb ff ff       	call   800ddc <getuint>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801205:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	52                   	push   %edx
  801210:	ff 75 e4             	pushl  -0x1c(%ebp)
  801213:	50                   	push   %eax
  801214:	ff 75 f4             	pushl  -0xc(%ebp)
  801217:	ff 75 f0             	pushl  -0x10(%ebp)
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	e8 00 fb ff ff       	call   800d25 <printnum>
  801225:	83 c4 20             	add    $0x20,%esp
			break;
  801228:	eb 46                	jmp    801270 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	53                   	push   %ebx
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	ff d0                	call   *%eax
  801236:	83 c4 10             	add    $0x10,%esp
			break;
  801239:	eb 35                	jmp    801270 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80123b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801242:	eb 2c                	jmp    801270 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801244:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  80124b:	eb 23                	jmp    801270 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	6a 25                	push   $0x25
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	ff d0                	call   *%eax
  80125a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125d:	ff 4d 10             	decl   0x10(%ebp)
  801260:	eb 03                	jmp    801265 <vprintfmt+0x3c3>
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	48                   	dec    %eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 25                	cmp    $0x25,%al
  80126d:	75 f3                	jne    801262 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80126f:	90                   	nop
		}
	}
  801270:	e9 35 fc ff ff       	jmp    800eaa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801275:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801276:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801283:	8d 45 10             	lea    0x10(%ebp),%eax
  801286:	83 c0 04             	add    $0x4,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	50                   	push   %eax
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	ff 75 08             	pushl  0x8(%ebp)
  801299:	e8 04 fc ff ff       	call   800ea2 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	8b 40 08             	mov    0x8(%eax),%eax
  8012ad:	8d 50 01             	lea    0x1(%eax),%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	8b 10                	mov    (%eax),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	8b 40 04             	mov    0x4(%eax),%eax
  8012c1:	39 c2                	cmp    %eax,%edx
  8012c3:	73 12                	jae    8012d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	8b 00                	mov    (%eax),%eax
  8012ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8012cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d0:	89 0a                	mov    %ecx,(%edx)
  8012d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d5:	88 10                	mov    %dl,(%eax)
}
  8012d7:	90                   	nop
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ff:	74 06                	je     801307 <vsnprintf+0x2d>
  801301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801305:	7f 07                	jg     80130e <vsnprintf+0x34>
		return -E_INVAL;
  801307:	b8 03 00 00 00       	mov    $0x3,%eax
  80130c:	eb 20                	jmp    80132e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130e:	ff 75 14             	pushl  0x14(%ebp)
  801311:	ff 75 10             	pushl  0x10(%ebp)
  801314:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	68 a4 12 80 00       	push   $0x8012a4
  80131d:	e8 80 fb ff ff       	call   800ea2 <vprintfmt>
  801322:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801336:	8d 45 10             	lea    0x10(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	ff 75 f4             	pushl  -0xc(%ebp)
  801345:	50                   	push   %eax
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 89 ff ff ff       	call   8012da <vsnprintf>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801366:	74 13                	je     80137b <readline+0x1f>
		cprintf("%s", prompt);
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	68 08 31 80 00       	push   $0x803108
  801373:	e8 0b f9 ff ff       	call   800c83 <cprintf>
  801378:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80137b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	6a 00                	push   $0x0
  801387:	e8 6f f4 ff ff       	call   8007fb <iscons>
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801392:	e8 51 f4 ff ff       	call   8007e8 <getchar>
  801397:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80139a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80139e:	79 22                	jns    8013c2 <readline+0x66>
			if (c != -E_EOF)
  8013a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013a4:	0f 84 ad 00 00 00    	je     801457 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b0:	68 0b 31 80 00       	push   $0x80310b
  8013b5:	e8 c9 f8 ff ff       	call   800c83 <cprintf>
  8013ba:	83 c4 10             	add    $0x10,%esp
			break;
  8013bd:	e9 95 00 00 00       	jmp    801457 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013c6:	7e 34                	jle    8013fc <readline+0xa0>
  8013c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013cf:	7f 2b                	jg     8013fc <readline+0xa0>
			if (echoing)
  8013d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d5:	74 0e                	je     8013e5 <readline+0x89>
				cputchar(c);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	ff 75 ec             	pushl  -0x14(%ebp)
  8013dd:	e8 e7 f3 ff ff       	call   8007c9 <cputchar>
  8013e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	8d 50 01             	lea    0x1(%eax),%edx
  8013eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013ee:	89 c2                	mov    %eax,%edx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f8:	88 10                	mov    %dl,(%eax)
  8013fa:	eb 56                	jmp    801452 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8013fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801400:	75 1f                	jne    801421 <readline+0xc5>
  801402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801406:	7e 19                	jle    801421 <readline+0xc5>
			if (echoing)
  801408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140c:	74 0e                	je     80141c <readline+0xc0>
				cputchar(c);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	ff 75 ec             	pushl  -0x14(%ebp)
  801414:	e8 b0 f3 ff ff       	call   8007c9 <cputchar>
  801419:	83 c4 10             	add    $0x10,%esp

			i--;
  80141c:	ff 4d f4             	decl   -0xc(%ebp)
  80141f:	eb 31                	jmp    801452 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801421:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801425:	74 0a                	je     801431 <readline+0xd5>
  801427:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80142b:	0f 85 61 ff ff ff    	jne    801392 <readline+0x36>
			if (echoing)
  801431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801435:	74 0e                	je     801445 <readline+0xe9>
				cputchar(c);
  801437:	83 ec 0c             	sub    $0xc,%esp
  80143a:	ff 75 ec             	pushl  -0x14(%ebp)
  80143d:	e8 87 f3 ff ff       	call   8007c9 <cputchar>
  801442:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801450:	eb 06                	jmp    801458 <readline+0xfc>
		}
	}
  801452:	e9 3b ff ff ff       	jmp    801392 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801457:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801461:	e8 30 0b 00 00       	call   801f96 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146a:	74 13                	je     80147f <atomic_readline+0x24>
			cprintf("%s", prompt);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	68 08 31 80 00       	push   $0x803108
  801477:	e8 07 f8 ff ff       	call   800c83 <cprintf>
  80147c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80147f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	6a 00                	push   $0x0
  80148b:	e8 6b f3 ff ff       	call   8007fb <iscons>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801496:	e8 4d f3 ff ff       	call   8007e8 <getchar>
  80149b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80149e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a2:	79 22                	jns    8014c6 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014a4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014a8:	0f 84 ad 00 00 00    	je     80155b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b4:	68 0b 31 80 00       	push   $0x80310b
  8014b9:	e8 c5 f7 ff ff       	call   800c83 <cprintf>
  8014be:	83 c4 10             	add    $0x10,%esp
				break;
  8014c1:	e9 95 00 00 00       	jmp    80155b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014ca:	7e 34                	jle    801500 <atomic_readline+0xa5>
  8014cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014d3:	7f 2b                	jg     801500 <atomic_readline+0xa5>
				if (echoing)
  8014d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014d9:	74 0e                	je     8014e9 <atomic_readline+0x8e>
					cputchar(c);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e1:	e8 e3 f2 ff ff       	call   8007c9 <cputchar>
  8014e6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8014e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014fc:	88 10                	mov    %dl,(%eax)
  8014fe:	eb 56                	jmp    801556 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801500:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801504:	75 1f                	jne    801525 <atomic_readline+0xca>
  801506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150a:	7e 19                	jle    801525 <atomic_readline+0xca>
				if (echoing)
  80150c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801510:	74 0e                	je     801520 <atomic_readline+0xc5>
					cputchar(c);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	ff 75 ec             	pushl  -0x14(%ebp)
  801518:	e8 ac f2 ff ff       	call   8007c9 <cputchar>
  80151d:	83 c4 10             	add    $0x10,%esp
				i--;
  801520:	ff 4d f4             	decl   -0xc(%ebp)
  801523:	eb 31                	jmp    801556 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801525:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801529:	74 0a                	je     801535 <atomic_readline+0xda>
  80152b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80152f:	0f 85 61 ff ff ff    	jne    801496 <atomic_readline+0x3b>
				if (echoing)
  801535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801539:	74 0e                	je     801549 <atomic_readline+0xee>
					cputchar(c);
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	ff 75 ec             	pushl  -0x14(%ebp)
  801541:	e8 83 f2 ff ff       	call   8007c9 <cputchar>
  801546:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801554:	eb 06                	jmp    80155c <atomic_readline+0x101>
			}
		}
  801556:	e9 3b ff ff ff       	jmp    801496 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80155b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80155c:	e8 4f 0a 00 00       	call   801fb0 <sys_unlock_cons>
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80156a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801571:	eb 06                	jmp    801579 <strlen+0x15>
		n++;
  801573:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	84 c0                	test   %al,%al
  801580:	75 f1                	jne    801573 <strlen+0xf>
		n++;
	return n;
  801582:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80158d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801594:	eb 09                	jmp    80159f <strnlen+0x18>
		n++;
  801596:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801599:	ff 45 08             	incl   0x8(%ebp)
  80159c:	ff 4d 0c             	decl   0xc(%ebp)
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	74 09                	je     8015ae <strnlen+0x27>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	84 c0                	test   %al,%al
  8015ac:	75 e8                	jne    801596 <strnlen+0xf>
		n++;
	return n;
  8015ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015bf:	90                   	nop
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8d 50 01             	lea    0x1(%eax),%edx
  8015c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015d2:	8a 12                	mov    (%edx),%dl
  8015d4:	88 10                	mov    %dl,(%eax)
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	84 c0                	test   %al,%al
  8015da:	75 e4                	jne    8015c0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8015ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f4:	eb 1f                	jmp    801615 <strncpy+0x34>
		*dst++ = *src;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8d 50 01             	lea    0x1(%eax),%edx
  8015fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8a 12                	mov    (%edx),%dl
  801604:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	84 c0                	test   %al,%al
  80160d:	74 03                	je     801612 <strncpy+0x31>
			src++;
  80160f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801612:	ff 45 fc             	incl   -0x4(%ebp)
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	3b 45 10             	cmp    0x10(%ebp),%eax
  80161b:	72 d9                	jb     8015f6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80162e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801632:	74 30                	je     801664 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801634:	eb 16                	jmp    80164c <strlcpy+0x2a>
			*dst++ = *src++;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 08             	mov    %edx,0x8(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8d 4a 01             	lea    0x1(%edx),%ecx
  801645:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801648:	8a 12                	mov    (%edx),%dl
  80164a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80164c:	ff 4d 10             	decl   0x10(%ebp)
  80164f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801653:	74 09                	je     80165e <strlcpy+0x3c>
  801655:	8b 45 0c             	mov    0xc(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	84 c0                	test   %al,%al
  80165c:	75 d8                	jne    801636 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801664:	8b 55 08             	mov    0x8(%ebp),%edx
  801667:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801673:	eb 06                	jmp    80167b <strcmp+0xb>
		p++, q++;
  801675:	ff 45 08             	incl   0x8(%ebp)
  801678:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	84 c0                	test   %al,%al
  801682:	74 0e                	je     801692 <strcmp+0x22>
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 10                	mov    (%eax),%dl
  801689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	38 c2                	cmp    %al,%dl
  801690:	74 e3                	je     801675 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	0f b6 d0             	movzbl %al,%edx
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	0f b6 c0             	movzbl %al,%eax
  8016a2:	29 c2                	sub    %eax,%edx
  8016a4:	89 d0                	mov    %edx,%eax
}
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016ab:	eb 09                	jmp    8016b6 <strncmp+0xe>
		n--, p++, q++;
  8016ad:	ff 4d 10             	decl   0x10(%ebp)
  8016b0:	ff 45 08             	incl   0x8(%ebp)
  8016b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ba:	74 17                	je     8016d3 <strncmp+0x2b>
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	84 c0                	test   %al,%al
  8016c3:	74 0e                	je     8016d3 <strncmp+0x2b>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 10                	mov    (%eax),%dl
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	38 c2                	cmp    %al,%dl
  8016d1:	74 da                	je     8016ad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d7:	75 07                	jne    8016e0 <strncmp+0x38>
		return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	eb 14                	jmp    8016f4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	0f b6 d0             	movzbl %al,%edx
  8016e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	0f b6 c0             	movzbl %al,%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
}
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801702:	eb 12                	jmp    801716 <strchr+0x20>
		if (*s == c)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80170c:	75 05                	jne    801713 <strchr+0x1d>
			return (char *) s;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	eb 11                	jmp    801724 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801713:	ff 45 08             	incl   0x8(%ebp)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	84 c0                	test   %al,%al
  80171d:	75 e5                	jne    801704 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801732:	eb 0d                	jmp    801741 <strfind+0x1b>
		if (*s == c)
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80173c:	74 0e                	je     80174c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80173e:	ff 45 08             	incl   0x8(%ebp)
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	84 c0                	test   %al,%al
  801748:	75 ea                	jne    801734 <strfind+0xe>
  80174a:	eb 01                	jmp    80174d <strfind+0x27>
		if (*s == c)
			break;
  80174c:	90                   	nop
	return (char *) s;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80175e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801762:	76 63                	jbe    8017c7 <memset+0x75>
		uint64 data_block = c;
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	99                   	cltd   
  801768:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80176b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801774:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801778:	c1 e0 08             	shl    $0x8,%eax
  80177b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80177e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801787:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80178b:	c1 e0 10             	shl    $0x10,%eax
  80178e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801791:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179a:	89 c2                	mov    %eax,%edx
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017a4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017a7:	eb 18                	jmp    8017c1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017ac:	8d 41 08             	lea    0x8(%ecx),%eax
  8017af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b8:	89 01                	mov    %eax,(%ecx)
  8017ba:	89 51 04             	mov    %edx,0x4(%ecx)
  8017bd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017c1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017c5:	77 e2                	ja     8017a9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cb:	74 23                	je     8017f0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017d3:	eb 0e                	jmp    8017e3 <memset+0x91>
			*p8++ = (uint8)c;
  8017d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d8:	8d 50 01             	lea    0x1(%eax),%edx
  8017db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 e5                	jne    8017d5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801807:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80180b:	76 24                	jbe    801831 <memcpy+0x3c>
		while(n >= 8){
  80180d:	eb 1c                	jmp    80182b <memcpy+0x36>
			*d64 = *s64;
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8b 50 04             	mov    0x4(%eax),%edx
  801815:	8b 00                	mov    (%eax),%eax
  801817:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80181a:	89 01                	mov    %eax,(%ecx)
  80181c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80181f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801823:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801827:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80182b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80182f:	77 de                	ja     80180f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801835:	74 31                	je     801868 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801837:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80183d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801843:	eb 16                	jmp    80185b <memcpy+0x66>
			*d8++ = *s8++;
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801848:	8d 50 01             	lea    0x1(%eax),%edx
  80184b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80184e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801851:	8d 4a 01             	lea    0x1(%edx),%ecx
  801854:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801857:	8a 12                	mov    (%edx),%dl
  801859:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801861:	89 55 10             	mov    %edx,0x10(%ebp)
  801864:	85 c0                	test   %eax,%eax
  801866:	75 dd                	jne    801845 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80187f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801882:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801885:	73 50                	jae    8018d7 <memmove+0x6a>
  801887:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801892:	76 43                	jbe    8018d7 <memmove+0x6a>
		s += n;
  801894:	8b 45 10             	mov    0x10(%ebp),%eax
  801897:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018a0:	eb 10                	jmp    8018b2 <memmove+0x45>
			*--d = *--s;
  8018a2:	ff 4d f8             	decl   -0x8(%ebp)
  8018a5:	ff 4d fc             	decl   -0x4(%ebp)
  8018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ab:	8a 10                	mov    (%eax),%dl
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	75 e3                	jne    8018a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018bf:	eb 23                	jmp    8018e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c4:	8d 50 01             	lea    0x1(%eax),%edx
  8018c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018d3:	8a 12                	mov    (%edx),%dl
  8018d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	75 dd                	jne    8018c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018fb:	eb 2a                	jmp    801927 <memcmp+0x3e>
		if (*s1 != *s2)
  8018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801900:	8a 10                	mov    (%eax),%dl
  801902:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	38 c2                	cmp    %al,%dl
  801909:	74 16                	je     801921 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	0f b6 d0             	movzbl %al,%edx
  801913:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	0f b6 c0             	movzbl %al,%eax
  80191b:	29 c2                	sub    %eax,%edx
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	eb 18                	jmp    801939 <memcmp+0x50>
		s1++, s2++;
  801921:	ff 45 fc             	incl   -0x4(%ebp)
  801924:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801927:	8b 45 10             	mov    0x10(%ebp),%eax
  80192a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80192d:	89 55 10             	mov    %edx,0x10(%ebp)
  801930:	85 c0                	test   %eax,%eax
  801932:	75 c9                	jne    8018fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801934:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801941:	8b 55 08             	mov    0x8(%ebp),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80194c:	eb 15                	jmp    801963 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	0f b6 d0             	movzbl %al,%edx
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	0f b6 c0             	movzbl %al,%eax
  80195c:	39 c2                	cmp    %eax,%edx
  80195e:	74 0d                	je     80196d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801960:	ff 45 08             	incl   0x8(%ebp)
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801969:	72 e3                	jb     80194e <memfind+0x13>
  80196b:	eb 01                	jmp    80196e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80196d:	90                   	nop
	return (void *) s;
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801980:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801987:	eb 03                	jmp    80198c <strtol+0x19>
		s++;
  801989:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	3c 20                	cmp    $0x20,%al
  801993:	74 f4                	je     801989 <strtol+0x16>
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8a 00                	mov    (%eax),%al
  80199a:	3c 09                	cmp    $0x9,%al
  80199c:	74 eb                	je     801989 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8a 00                	mov    (%eax),%al
  8019a3:	3c 2b                	cmp    $0x2b,%al
  8019a5:	75 05                	jne    8019ac <strtol+0x39>
		s++;
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	eb 13                	jmp    8019bf <strtol+0x4c>
	else if (*s == '-')
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	3c 2d                	cmp    $0x2d,%al
  8019b3:	75 0a                	jne    8019bf <strtol+0x4c>
		s++, neg = 1;
  8019b5:	ff 45 08             	incl   0x8(%ebp)
  8019b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c3:	74 06                	je     8019cb <strtol+0x58>
  8019c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019c9:	75 20                	jne    8019eb <strtol+0x78>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	3c 30                	cmp    $0x30,%al
  8019d2:	75 17                	jne    8019eb <strtol+0x78>
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	40                   	inc    %eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	3c 78                	cmp    $0x78,%al
  8019dc:	75 0d                	jne    8019eb <strtol+0x78>
		s += 2, base = 16;
  8019de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019e9:	eb 28                	jmp    801a13 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ef:	75 15                	jne    801a06 <strtol+0x93>
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	3c 30                	cmp    $0x30,%al
  8019f8:	75 0c                	jne    801a06 <strtol+0x93>
		s++, base = 8;
  8019fa:	ff 45 08             	incl   0x8(%ebp)
  8019fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a04:	eb 0d                	jmp    801a13 <strtol+0xa0>
	else if (base == 0)
  801a06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0a:	75 07                	jne    801a13 <strtol+0xa0>
		base = 10;
  801a0c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	3c 2f                	cmp    $0x2f,%al
  801a1a:	7e 19                	jle    801a35 <strtol+0xc2>
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	3c 39                	cmp    $0x39,%al
  801a23:	7f 10                	jg     801a35 <strtol+0xc2>
			dig = *s - '0';
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8a 00                	mov    (%eax),%al
  801a2a:	0f be c0             	movsbl %al,%eax
  801a2d:	83 e8 30             	sub    $0x30,%eax
  801a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a33:	eb 42                	jmp    801a77 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	3c 60                	cmp    $0x60,%al
  801a3c:	7e 19                	jle    801a57 <strtol+0xe4>
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3c 7a                	cmp    $0x7a,%al
  801a45:	7f 10                	jg     801a57 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	83 e8 57             	sub    $0x57,%eax
  801a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a55:	eb 20                	jmp    801a77 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	8a 00                	mov    (%eax),%al
  801a5c:	3c 40                	cmp    $0x40,%al
  801a5e:	7e 39                	jle    801a99 <strtol+0x126>
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	3c 5a                	cmp    $0x5a,%al
  801a67:	7f 30                	jg     801a99 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	0f be c0             	movsbl %al,%eax
  801a71:	83 e8 37             	sub    $0x37,%eax
  801a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a7d:	7d 19                	jge    801a98 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a7f:	ff 45 08             	incl   0x8(%ebp)
  801a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a85:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a89:	89 c2                	mov    %eax,%edx
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	01 d0                	add    %edx,%eax
  801a90:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a93:	e9 7b ff ff ff       	jmp    801a13 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a98:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9d:	74 08                	je     801aa7 <strtol+0x134>
		*endptr = (char *) s;
  801a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aab:	74 07                	je     801ab4 <strtol+0x141>
  801aad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab0:	f7 d8                	neg    %eax
  801ab2:	eb 03                	jmp    801ab7 <strtol+0x144>
  801ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <ltostr>:

void
ltostr(long value, char *str)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ac6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801acd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad1:	79 13                	jns    801ae6 <ltostr+0x2d>
	{
		neg = 1;
  801ad3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801ae0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ae3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801aee:	99                   	cltd   
  801aef:	f7 f9                	idiv   %ecx
  801af1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801af4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af7:	8d 50 01             	lea    0x1(%eax),%edx
  801afa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801afd:	89 c2                	mov    %eax,%edx
  801aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b02:	01 d0                	add    %edx,%eax
  801b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b07:	83 c2 30             	add    $0x30,%edx
  801b0a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b14:	f7 e9                	imul   %ecx
  801b16:	c1 fa 02             	sar    $0x2,%edx
  801b19:	89 c8                	mov    %ecx,%eax
  801b1b:	c1 f8 1f             	sar    $0x1f,%eax
  801b1e:	29 c2                	sub    %eax,%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b29:	75 bb                	jne    801ae6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b35:	48                   	dec    %eax
  801b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b3d:	74 3d                	je     801b7c <ltostr+0xc3>
		start = 1 ;
  801b3f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b46:	eb 34                	jmp    801b7c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	8a 00                	mov    (%eax),%al
  801b52:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	01 c8                	add    %ecx,%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 c2                	add    %eax,%edx
  801b71:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b74:	88 02                	mov    %al,(%edx)
		start++ ;
  801b76:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b79:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b82:	7c c4                	jl     801b48 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b84:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	01 d0                	add    %edx,%eax
  801b8c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	e8 c4 f9 ff ff       	call   801564 <strlen>
  801ba0:	83 c4 04             	add    $0x4,%esp
  801ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	e8 b6 f9 ff ff       	call   801564 <strlen>
  801bae:	83 c4 04             	add    $0x4,%esp
  801bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bc2:	eb 17                	jmp    801bdb <strcconcat+0x49>
		final[s] = str1[s] ;
  801bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bd8:	ff 45 fc             	incl   -0x4(%ebp)
  801bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801be1:	7c e1                	jl     801bc4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801be3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bf1:	eb 1f                	jmp    801c12 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf6:	8d 50 01             	lea    0x1(%eax),%edx
  801bf9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bfc:	89 c2                	mov    %eax,%edx
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	01 c2                	add    %eax,%edx
  801c03:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	01 c8                	add    %ecx,%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c0f:	ff 45 f8             	incl   -0x8(%ebp)
  801c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c18:	7c d9                	jl     801bf3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c20:	01 d0                	add    %edx,%eax
  801c22:	c6 00 00             	movb   $0x0,(%eax)
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	8b 00                	mov    (%eax),%eax
  801c39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	01 d0                	add    %edx,%eax
  801c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c4b:	eb 0c                	jmp    801c59 <strsplit+0x31>
			*string++ = 0;
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	8d 50 01             	lea    0x1(%eax),%edx
  801c53:	89 55 08             	mov    %edx,0x8(%ebp)
  801c56:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	84 c0                	test   %al,%al
  801c60:	74 18                	je     801c7a <strsplit+0x52>
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	0f be c0             	movsbl %al,%eax
  801c6a:	50                   	push   %eax
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	e8 83 fa ff ff       	call   8016f6 <strchr>
  801c73:	83 c4 08             	add    $0x8,%esp
  801c76:	85 c0                	test   %eax,%eax
  801c78:	75 d3                	jne    801c4d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 5a                	je     801cdd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c83:	8b 45 14             	mov    0x14(%ebp),%eax
  801c86:	8b 00                	mov    (%eax),%eax
  801c88:	83 f8 0f             	cmp    $0xf,%eax
  801c8b:	75 07                	jne    801c94 <strsplit+0x6c>
		{
			return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	eb 66                	jmp    801cfa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	8d 48 01             	lea    0x1(%eax),%ecx
  801c9c:	8b 55 14             	mov    0x14(%ebp),%edx
  801c9f:	89 0a                	mov    %ecx,(%edx)
  801ca1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	01 c2                	add    %eax,%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cb2:	eb 03                	jmp    801cb7 <strsplit+0x8f>
			string++;
  801cb4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8a 00                	mov    (%eax),%al
  801cbc:	84 c0                	test   %al,%al
  801cbe:	74 8b                	je     801c4b <strsplit+0x23>
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	0f be c0             	movsbl %al,%eax
  801cc8:	50                   	push   %eax
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	e8 25 fa ff ff       	call   8016f6 <strchr>
  801cd1:	83 c4 08             	add    $0x8,%esp
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	74 dc                	je     801cb4 <strsplit+0x8c>
			string++;
	}
  801cd8:	e9 6e ff ff ff       	jmp    801c4b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cdd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cde:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	01 d0                	add    %edx,%eax
  801cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cf5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d0f:	eb 4a                	jmp    801d5b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	01 c2                	add    %eax,%edx
  801d19:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	01 c8                	add    %ecx,%eax
  801d21:	8a 00                	mov    (%eax),%al
  801d23:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	3c 40                	cmp    $0x40,%al
  801d31:	7e 25                	jle    801d58 <str2lower+0x5c>
  801d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	3c 5a                	cmp    $0x5a,%al
  801d3f:	7f 17                	jg     801d58 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d4f:	01 ca                	add    %ecx,%edx
  801d51:	8a 12                	mov    (%edx),%dl
  801d53:	83 c2 20             	add    $0x20,%edx
  801d56:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d58:	ff 45 fc             	incl   -0x4(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	e8 01 f8 ff ff       	call   801564 <strlen>
  801d63:	83 c4 04             	add    $0x4,%esp
  801d66:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d69:	7f a6                	jg     801d11 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d76:	a1 08 40 80 00       	mov    0x804008,%eax
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	74 42                	je     801dc1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d7f:	83 ec 08             	sub    $0x8,%esp
  801d82:	68 00 00 00 82       	push   $0x82000000
  801d87:	68 00 00 00 80       	push   $0x80000000
  801d8c:	e8 8c 07 00 00       	call   80251d <initialize_dynamic_allocator>
  801d91:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801d94:	e8 e7 05 00 00       	call   802380 <sys_get_uheap_strategy>
  801d99:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801d9e:	a1 40 40 80 00       	mov    0x804040,%eax
  801da3:	05 00 10 00 00       	add    $0x1000,%eax
  801da8:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801dad:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801db2:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801db7:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801dbe:	00 00 00 
	}
}
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	68 06 04 00 00       	push   $0x406
  801de0:	50                   	push   %eax
  801de1:	e8 e4 01 00 00       	call   801fca <__sys_allocate_page>
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801dec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df0:	79 14                	jns    801e06 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	68 1c 31 80 00       	push   $0x80311c
  801dfa:	6a 1f                	push   $0x1f
  801dfc:	68 58 31 80 00       	push   $0x803158
  801e01:	e8 af eb ff ff       	call   8009b5 <_panic>
	return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	50                   	push   %eax
  801e25:	e8 e7 01 00 00       	call   802011 <__sys_unmap_frame>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e34:	79 14                	jns    801e4a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 64 31 80 00       	push   $0x803164
  801e3e:	6a 2a                	push   $0x2a
  801e40:	68 58 31 80 00       	push   $0x803158
  801e45:	e8 6b eb ff ff       	call   8009b5 <_panic>
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e53:	e8 18 ff ff ff       	call   801d70 <uheap_init>
	if (size == 0) return NULL ;
  801e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e5c:	75 07                	jne    801e65 <malloc+0x18>
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	eb 14                	jmp    801e79 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 a4 31 80 00       	push   $0x8031a4
  801e6d:	6a 3e                	push   $0x3e
  801e6f:	68 58 31 80 00       	push   $0x803158
  801e74:	e8 3c eb ff ff       	call   8009b5 <_panic>
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	68 cc 31 80 00       	push   $0x8031cc
  801e89:	6a 49                	push   $0x49
  801e8b:	68 58 31 80 00       	push   $0x803158
  801e90:	e8 20 eb ff ff       	call   8009b5 <_panic>

00801e95 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 18             	sub    $0x18,%esp
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ea1:	e8 ca fe ff ff       	call   801d70 <uheap_init>
	if (size == 0) return NULL ;
  801ea6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eaa:	75 07                	jne    801eb3 <smalloc+0x1e>
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	eb 14                	jmp    801ec7 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 f0 31 80 00       	push   $0x8031f0
  801ebb:	6a 5a                	push   $0x5a
  801ebd:	68 58 31 80 00       	push   $0x803158
  801ec2:	e8 ee ea ff ff       	call   8009b5 <_panic>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ecf:	e8 9c fe ff ff       	call   801d70 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	68 18 32 80 00       	push   $0x803218
  801edc:	6a 6a                	push   $0x6a
  801ede:	68 58 31 80 00       	push   $0x803158
  801ee3:	e8 cd ea ff ff       	call   8009b5 <_panic>

00801ee8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801eee:	e8 7d fe ff ff       	call   801d70 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	68 3c 32 80 00       	push   $0x80323c
  801efb:	68 88 00 00 00       	push   $0x88
  801f00:	68 58 31 80 00       	push   $0x803158
  801f05:	e8 ab ea ff ff       	call   8009b5 <_panic>

00801f0a <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801f10:	83 ec 04             	sub    $0x4,%esp
  801f13:	68 64 32 80 00       	push   $0x803264
  801f18:	68 9b 00 00 00       	push   $0x9b
  801f1d:	68 58 31 80 00       	push   $0x803158
  801f22:	e8 8e ea ff ff       	call   8009b5 <_panic>

00801f27 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	57                   	push   %edi
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f3f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f42:	cd 30                	int    $0x30
  801f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	5b                   	pop    %ebx
  801f4e:	5e                   	pop    %esi
  801f4f:	5f                   	pop    %edi
  801f50:	5d                   	pop    %ebp
  801f51:	c3                   	ret    

00801f52 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801f5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f61:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	51                   	push   %ecx
  801f6b:	52                   	push   %edx
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	50                   	push   %eax
  801f70:	6a 00                	push   $0x0
  801f72:	e8 b0 ff ff ff       	call   801f27 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	90                   	nop
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_cgetc>:

int
sys_cgetc(void)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 02                	push   $0x2
  801f8c:	e8 96 ff ff ff       	call   801f27 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 03                	push   $0x3
  801fa5:	e8 7d ff ff ff       	call   801f27 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	90                   	nop
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 04                	push   $0x4
  801fbf:	e8 63 ff ff ff       	call   801f27 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	90                   	nop
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 08                	push   $0x8
  801fdd:	e8 45 ff ff ff       	call   801f27 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	56                   	push   %esi
  801feb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fec:	8b 75 18             	mov    0x18(%ebp),%esi
  801fef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	56                   	push   %esi
  801ffc:	53                   	push   %ebx
  801ffd:	51                   	push   %ecx
  801ffe:	52                   	push   %edx
  801fff:	50                   	push   %eax
  802000:	6a 09                	push   $0x9
  802002:	e8 20 ff ff ff       	call   801f27 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	6a 0a                	push   $0xa
  802021:	e8 01 ff ff ff       	call   801f27 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	ff 75 08             	pushl  0x8(%ebp)
  80203a:	6a 0b                	push   $0xb
  80203c:	e8 e6 fe ff ff       	call   801f27 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 0c                	push   $0xc
  802055:	e8 cd fe ff ff       	call   801f27 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 0d                	push   $0xd
  80206e:	e8 b4 fe ff ff       	call   801f27 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 0e                	push   $0xe
  802087:	e8 9b fe ff ff       	call   801f27 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 0f                	push   $0xf
  8020a0:	e8 82 fe ff ff       	call   801f27 <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	ff 75 08             	pushl  0x8(%ebp)
  8020b8:	6a 10                	push   $0x10
  8020ba:	e8 68 fe ff ff       	call   801f27 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 11                	push   $0x11
  8020d3:	e8 4f fe ff ff       	call   801f27 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
}
  8020db:	90                   	nop
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_cputc>:

void
sys_cputc(const char c)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	50                   	push   %eax
  8020f7:	6a 01                	push   $0x1
  8020f9:	e8 29 fe ff ff       	call   801f27 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 14                	push   $0x14
  802113:	e8 0f fe ff ff       	call   801f27 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	90                   	nop
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80212a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80212d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	51                   	push   %ecx
  802137:	52                   	push   %edx
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	6a 15                	push   $0x15
  80213e:	e8 e4 fd ff ff       	call   801f27 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 16                	push   $0x16
  80215b:	e8 c7 fd ff ff       	call   801f27 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802168:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	51                   	push   %ecx
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 17                	push   $0x17
  80217a:	e8 a8 fd ff ff       	call   801f27 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 18                	push   $0x18
  802197:	e8 8b fd ff ff       	call   801f27 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 14             	pushl  0x14(%ebp)
  8021ac:	ff 75 10             	pushl  0x10(%ebp)
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	50                   	push   %eax
  8021b3:	6a 19                	push   $0x19
  8021b5:	e8 6d fd ff ff       	call   801f27 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	50                   	push   %eax
  8021ce:	6a 1a                	push   $0x1a
  8021d0:	e8 52 fd ff ff       	call   801f27 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	90                   	nop
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	50                   	push   %eax
  8021ea:	6a 1b                	push   $0x1b
  8021ec:	e8 36 fd ff ff       	call   801f27 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 05                	push   $0x5
  802205:	e8 1d fd ff ff       	call   801f27 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 06                	push   $0x6
  80221e:	e8 04 fd ff ff       	call   801f27 <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 07                	push   $0x7
  802237:	e8 eb fc ff ff       	call   801f27 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_exit_env>:


void sys_exit_env(void)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 1c                	push   $0x1c
  802250:	e8 d2 fc ff ff       	call   801f27 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802261:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802264:	8d 50 04             	lea    0x4(%eax),%edx
  802267:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 1d                	push   $0x1d
  802274:	e8 ae fc ff ff       	call   801f27 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
	return result;
  80227c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80227f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802285:	89 01                	mov    %eax,(%ecx)
  802287:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	c9                   	leave  
  80228e:	c2 04 00             	ret    $0x4

00802291 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	ff 75 10             	pushl  0x10(%ebp)
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	6a 13                	push   $0x13
  8022a3:	e8 7f fc ff ff       	call   801f27 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ab:	90                   	nop
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 1e                	push   $0x1e
  8022bd:	e8 65 fc ff ff       	call   801f27 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	50                   	push   %eax
  8022e0:	6a 1f                	push   $0x1f
  8022e2:	e8 40 fc ff ff       	call   801f27 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ea:	90                   	nop
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <rsttst>:
void rsttst()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 21                	push   $0x21
  8022fc:	e8 26 fc ff ff       	call   801f27 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
	return ;
  802304:	90                   	nop
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	8b 45 14             	mov    0x14(%ebp),%eax
  802310:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802313:	8b 55 18             	mov    0x18(%ebp),%edx
  802316:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80231a:	52                   	push   %edx
  80231b:	50                   	push   %eax
  80231c:	ff 75 10             	pushl  0x10(%ebp)
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	6a 20                	push   $0x20
  802327:	e8 fb fb ff ff       	call   801f27 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
	return ;
  80232f:	90                   	nop
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <chktst>:
void chktst(uint32 n)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	6a 22                	push   $0x22
  802342:	e8 e0 fb ff ff       	call   801f27 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return ;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <inctst>:

void inctst()
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 23                	push   $0x23
  80235c:	e8 c6 fb ff ff       	call   801f27 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return ;
  802364:	90                   	nop
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <gettst>:
uint32 gettst()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 24                	push   $0x24
  802376:	e8 ac fb ff ff       	call   801f27 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 25                	push   $0x25
  80238f:	e8 93 fb ff ff       	call   801f27 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
  802397:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  80239c:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	ff 75 08             	pushl  0x8(%ebp)
  8023b9:	6a 26                	push   $0x26
  8023bb:	e8 67 fb ff ff       	call   801f27 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c3:	90                   	nop
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	53                   	push   %ebx
  8023d9:	51                   	push   %ecx
  8023da:	52                   	push   %edx
  8023db:	50                   	push   %eax
  8023dc:	6a 27                	push   $0x27
  8023de:	e8 44 fb ff ff       	call   801f27 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	52                   	push   %edx
  8023fb:	50                   	push   %eax
  8023fc:	6a 28                	push   $0x28
  8023fe:	e8 24 fb ff ff       	call   801f27 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80240b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80240e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	6a 00                	push   $0x0
  802416:	51                   	push   %ecx
  802417:	ff 75 10             	pushl  0x10(%ebp)
  80241a:	52                   	push   %edx
  80241b:	50                   	push   %eax
  80241c:	6a 29                	push   $0x29
  80241e:	e8 04 fb ff ff       	call   801f27 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	ff 75 10             	pushl  0x10(%ebp)
  802432:	ff 75 0c             	pushl  0xc(%ebp)
  802435:	ff 75 08             	pushl  0x8(%ebp)
  802438:	6a 12                	push   $0x12
  80243a:	e8 e8 fa ff ff       	call   801f27 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
	return ;
  802442:	90                   	nop
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	52                   	push   %edx
  802455:	50                   	push   %eax
  802456:	6a 2a                	push   $0x2a
  802458:	e8 ca fa ff ff       	call   801f27 <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
	return;
  802460:	90                   	nop
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 2b                	push   $0x2b
  802472:	e8 b0 fa ff ff       	call   801f27 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	ff 75 0c             	pushl  0xc(%ebp)
  802488:	ff 75 08             	pushl  0x8(%ebp)
  80248b:	6a 2d                	push   $0x2d
  80248d:	e8 95 fa ff ff       	call   801f27 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
	return;
  802495:	90                   	nop
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	ff 75 0c             	pushl  0xc(%ebp)
  8024a4:	ff 75 08             	pushl  0x8(%ebp)
  8024a7:	6a 2c                	push   $0x2c
  8024a9:	e8 79 fa ff ff       	call   801f27 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b1:	90                   	nop
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	68 88 32 80 00       	push   $0x803288
  8024c2:	68 25 01 00 00       	push   $0x125
  8024c7:	68 bb 32 80 00       	push   $0x8032bb
  8024cc:	e8 e4 e4 ff ff       	call   8009b5 <_panic>

008024d1 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	ba 60 40 80 00       	mov    $0x804060,%edx
  8024df:	29 d0                	sub    %edx,%eax
  8024e1:	c1 f8 02             	sar    $0x2,%eax
  8024e4:	89 c2                	mov    %eax,%edx
  8024e6:	89 d0                	mov    %edx,%eax
  8024e8:	c1 e0 02             	shl    $0x2,%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	c1 e0 02             	shl    $0x2,%eax
  8024f0:	01 d0                	add    %edx,%eax
  8024f2:	c1 e0 02             	shl    $0x2,%eax
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	89 c1                	mov    %eax,%ecx
  8024f9:	c1 e1 08             	shl    $0x8,%ecx
  8024fc:	01 c8                	add    %ecx,%eax
  8024fe:	89 c1                	mov    %eax,%ecx
  802500:	c1 e1 10             	shl    $0x10,%ecx
  802503:	01 c8                	add    %ecx,%eax
  802505:	01 c0                	add    %eax,%eax
  802507:	01 d0                	add    %edx,%eax
  802509:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80250c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80250f:	c1 e0 0c             	shl    $0xc,%eax
  802512:	89 c2                	mov    %eax,%edx
  802514:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802519:	01 d0                	add    %edx,%eax
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
  802520:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	05 00 00 00 02       	add    $0x2000000,%eax
  80252b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80252e:	73 16                	jae    802546 <initialize_dynamic_allocator+0x29>
  802530:	68 cc 32 80 00       	push   $0x8032cc
  802535:	68 f2 32 80 00       	push   $0x8032f2
  80253a:	6a 26                	push   $0x26
  80253c:	68 07 33 80 00       	push   $0x803307
  802541:	e8 6f e4 ff ff       	call   8009b5 <_panic>
		is_initialized = 1;
  802546:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80254d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 20 33 80 00       	push   $0x803320
  802558:	6a 2e                	push   $0x2e
  80255a:	68 07 33 80 00       	push   $0x803307
  80255f:	e8 51 e4 ff ff       	call   8009b5 <_panic>

00802564 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  80256a:	83 ec 04             	sub    $0x4,%esp
  80256d:	68 54 33 80 00       	push   $0x803354
  802572:	6a 3a                	push   $0x3a
  802574:	68 07 33 80 00       	push   $0x803307
  802579:	e8 37 e4 ff ff       	call   8009b5 <_panic>

0080257e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802584:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80258b:	76 16                	jbe    8025a3 <alloc_block+0x25>
  80258d:	68 7c 33 80 00       	push   $0x80337c
  802592:	68 f2 32 80 00       	push   $0x8032f2
  802597:	6a 46                	push   $0x46
  802599:	68 07 33 80 00       	push   $0x803307
  80259e:	e8 12 e4 ff ff       	call   8009b5 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 a0 33 80 00       	push   $0x8033a0
  8025ab:	6a 4d                	push   $0x4d
  8025ad:	68 07 33 80 00       	push   $0x803307
  8025b2:	e8 fe e3 ff ff       	call   8009b5 <_panic>

008025b7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8025bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c0:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8025c5:	39 c2                	cmp    %eax,%edx
  8025c7:	72 0c                	jb     8025d5 <free_block+0x1e>
  8025c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cc:	a1 40 40 80 00       	mov    0x804040,%eax
  8025d1:	39 c2                	cmp    %eax,%edx
  8025d3:	72 16                	jb     8025eb <free_block+0x34>
  8025d5:	68 c4 33 80 00       	push   $0x8033c4
  8025da:	68 f2 32 80 00       	push   $0x8032f2
  8025df:	6a 5b                	push   $0x5b
  8025e1:	68 07 33 80 00       	push   $0x803307
  8025e6:	e8 ca e3 ff ff       	call   8009b5 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 fc 33 80 00       	push   $0x8033fc
  8025f3:	6a 63                	push   $0x63
  8025f5:	68 07 33 80 00       	push   $0x803307
  8025fa:	e8 b6 e3 ff ff       	call   8009b5 <_panic>

008025ff <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	68 20 34 80 00       	push   $0x803420
  80260d:	6a 72                	push   $0x72
  80260f:	68 07 33 80 00       	push   $0x803307
  802614:	e8 9c e3 ff ff       	call   8009b5 <_panic>
  802619:	66 90                	xchg   %ax,%ax
  80261b:	90                   	nop

0080261c <__udivdi3>:
  80261c:	55                   	push   %ebp
  80261d:	57                   	push   %edi
  80261e:	56                   	push   %esi
  80261f:	53                   	push   %ebx
  802620:	83 ec 1c             	sub    $0x1c,%esp
  802623:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802627:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80262b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80262f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802633:	89 ca                	mov    %ecx,%edx
  802635:	89 f8                	mov    %edi,%eax
  802637:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80263b:	85 f6                	test   %esi,%esi
  80263d:	75 2d                	jne    80266c <__udivdi3+0x50>
  80263f:	39 cf                	cmp    %ecx,%edi
  802641:	77 65                	ja     8026a8 <__udivdi3+0x8c>
  802643:	89 fd                	mov    %edi,%ebp
  802645:	85 ff                	test   %edi,%edi
  802647:	75 0b                	jne    802654 <__udivdi3+0x38>
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
  80264e:	31 d2                	xor    %edx,%edx
  802650:	f7 f7                	div    %edi
  802652:	89 c5                	mov    %eax,%ebp
  802654:	31 d2                	xor    %edx,%edx
  802656:	89 c8                	mov    %ecx,%eax
  802658:	f7 f5                	div    %ebp
  80265a:	89 c1                	mov    %eax,%ecx
  80265c:	89 d8                	mov    %ebx,%eax
  80265e:	f7 f5                	div    %ebp
  802660:	89 cf                	mov    %ecx,%edi
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	39 ce                	cmp    %ecx,%esi
  80266e:	77 28                	ja     802698 <__udivdi3+0x7c>
  802670:	0f bd fe             	bsr    %esi,%edi
  802673:	83 f7 1f             	xor    $0x1f,%edi
  802676:	75 40                	jne    8026b8 <__udivdi3+0x9c>
  802678:	39 ce                	cmp    %ecx,%esi
  80267a:	72 0a                	jb     802686 <__udivdi3+0x6a>
  80267c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802680:	0f 87 9e 00 00 00    	ja     802724 <__udivdi3+0x108>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	89 fa                	mov    %edi,%edx
  80268d:	83 c4 1c             	add    $0x1c,%esp
  802690:	5b                   	pop    %ebx
  802691:	5e                   	pop    %esi
  802692:	5f                   	pop    %edi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    
  802695:	8d 76 00             	lea    0x0(%esi),%esi
  802698:	31 ff                	xor    %edi,%edi
  80269a:	31 c0                	xor    %eax,%eax
  80269c:	89 fa                	mov    %edi,%edx
  80269e:	83 c4 1c             	add    $0x1c,%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    
  8026a6:	66 90                	xchg   %ax,%ax
  8026a8:	89 d8                	mov    %ebx,%eax
  8026aa:	f7 f7                	div    %edi
  8026ac:	31 ff                	xor    %edi,%edi
  8026ae:	89 fa                	mov    %edi,%edx
  8026b0:	83 c4 1c             	add    $0x1c,%esp
  8026b3:	5b                   	pop    %ebx
  8026b4:	5e                   	pop    %esi
  8026b5:	5f                   	pop    %edi
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    
  8026b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026bd:	89 eb                	mov    %ebp,%ebx
  8026bf:	29 fb                	sub    %edi,%ebx
  8026c1:	89 f9                	mov    %edi,%ecx
  8026c3:	d3 e6                	shl    %cl,%esi
  8026c5:	89 c5                	mov    %eax,%ebp
  8026c7:	88 d9                	mov    %bl,%cl
  8026c9:	d3 ed                	shr    %cl,%ebp
  8026cb:	89 e9                	mov    %ebp,%ecx
  8026cd:	09 f1                	or     %esi,%ecx
  8026cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8026d3:	89 f9                	mov    %edi,%ecx
  8026d5:	d3 e0                	shl    %cl,%eax
  8026d7:	89 c5                	mov    %eax,%ebp
  8026d9:	89 d6                	mov    %edx,%esi
  8026db:	88 d9                	mov    %bl,%cl
  8026dd:	d3 ee                	shr    %cl,%esi
  8026df:	89 f9                	mov    %edi,%ecx
  8026e1:	d3 e2                	shl    %cl,%edx
  8026e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026e7:	88 d9                	mov    %bl,%cl
  8026e9:	d3 e8                	shr    %cl,%eax
  8026eb:	09 c2                	or     %eax,%edx
  8026ed:	89 d0                	mov    %edx,%eax
  8026ef:	89 f2                	mov    %esi,%edx
  8026f1:	f7 74 24 0c          	divl   0xc(%esp)
  8026f5:	89 d6                	mov    %edx,%esi
  8026f7:	89 c3                	mov    %eax,%ebx
  8026f9:	f7 e5                	mul    %ebp
  8026fb:	39 d6                	cmp    %edx,%esi
  8026fd:	72 19                	jb     802718 <__udivdi3+0xfc>
  8026ff:	74 0b                	je     80270c <__udivdi3+0xf0>
  802701:	89 d8                	mov    %ebx,%eax
  802703:	31 ff                	xor    %edi,%edi
  802705:	e9 58 ff ff ff       	jmp    802662 <__udivdi3+0x46>
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802710:	89 f9                	mov    %edi,%ecx
  802712:	d3 e2                	shl    %cl,%edx
  802714:	39 c2                	cmp    %eax,%edx
  802716:	73 e9                	jae    802701 <__udivdi3+0xe5>
  802718:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80271b:	31 ff                	xor    %edi,%edi
  80271d:	e9 40 ff ff ff       	jmp    802662 <__udivdi3+0x46>
  802722:	66 90                	xchg   %ax,%ax
  802724:	31 c0                	xor    %eax,%eax
  802726:	e9 37 ff ff ff       	jmp    802662 <__udivdi3+0x46>
  80272b:	90                   	nop

0080272c <__umoddi3>:
  80272c:	55                   	push   %ebp
  80272d:	57                   	push   %edi
  80272e:	56                   	push   %esi
  80272f:	53                   	push   %ebx
  802730:	83 ec 1c             	sub    $0x1c,%esp
  802733:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802737:	8b 74 24 34          	mov    0x34(%esp),%esi
  80273b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80273f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802743:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802747:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80274b:	89 f3                	mov    %esi,%ebx
  80274d:	89 fa                	mov    %edi,%edx
  80274f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802753:	89 34 24             	mov    %esi,(%esp)
  802756:	85 c0                	test   %eax,%eax
  802758:	75 1a                	jne    802774 <__umoddi3+0x48>
  80275a:	39 f7                	cmp    %esi,%edi
  80275c:	0f 86 a2 00 00 00    	jbe    802804 <__umoddi3+0xd8>
  802762:	89 c8                	mov    %ecx,%eax
  802764:	89 f2                	mov    %esi,%edx
  802766:	f7 f7                	div    %edi
  802768:	89 d0                	mov    %edx,%eax
  80276a:	31 d2                	xor    %edx,%edx
  80276c:	83 c4 1c             	add    $0x1c,%esp
  80276f:	5b                   	pop    %ebx
  802770:	5e                   	pop    %esi
  802771:	5f                   	pop    %edi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    
  802774:	39 f0                	cmp    %esi,%eax
  802776:	0f 87 ac 00 00 00    	ja     802828 <__umoddi3+0xfc>
  80277c:	0f bd e8             	bsr    %eax,%ebp
  80277f:	83 f5 1f             	xor    $0x1f,%ebp
  802782:	0f 84 ac 00 00 00    	je     802834 <__umoddi3+0x108>
  802788:	bf 20 00 00 00       	mov    $0x20,%edi
  80278d:	29 ef                	sub    %ebp,%edi
  80278f:	89 fe                	mov    %edi,%esi
  802791:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802795:	89 e9                	mov    %ebp,%ecx
  802797:	d3 e0                	shl    %cl,%eax
  802799:	89 d7                	mov    %edx,%edi
  80279b:	89 f1                	mov    %esi,%ecx
  80279d:	d3 ef                	shr    %cl,%edi
  80279f:	09 c7                	or     %eax,%edi
  8027a1:	89 e9                	mov    %ebp,%ecx
  8027a3:	d3 e2                	shl    %cl,%edx
  8027a5:	89 14 24             	mov    %edx,(%esp)
  8027a8:	89 d8                	mov    %ebx,%eax
  8027aa:	d3 e0                	shl    %cl,%eax
  8027ac:	89 c2                	mov    %eax,%edx
  8027ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027b2:	d3 e0                	shl    %cl,%eax
  8027b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027bc:	89 f1                	mov    %esi,%ecx
  8027be:	d3 e8                	shr    %cl,%eax
  8027c0:	09 d0                	or     %edx,%eax
  8027c2:	d3 eb                	shr    %cl,%ebx
  8027c4:	89 da                	mov    %ebx,%edx
  8027c6:	f7 f7                	div    %edi
  8027c8:	89 d3                	mov    %edx,%ebx
  8027ca:	f7 24 24             	mull   (%esp)
  8027cd:	89 c6                	mov    %eax,%esi
  8027cf:	89 d1                	mov    %edx,%ecx
  8027d1:	39 d3                	cmp    %edx,%ebx
  8027d3:	0f 82 87 00 00 00    	jb     802860 <__umoddi3+0x134>
  8027d9:	0f 84 91 00 00 00    	je     802870 <__umoddi3+0x144>
  8027df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027e3:	29 f2                	sub    %esi,%edx
  8027e5:	19 cb                	sbb    %ecx,%ebx
  8027e7:	89 d8                	mov    %ebx,%eax
  8027e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8027ed:	d3 e0                	shl    %cl,%eax
  8027ef:	89 e9                	mov    %ebp,%ecx
  8027f1:	d3 ea                	shr    %cl,%edx
  8027f3:	09 d0                	or     %edx,%eax
  8027f5:	89 e9                	mov    %ebp,%ecx
  8027f7:	d3 eb                	shr    %cl,%ebx
  8027f9:	89 da                	mov    %ebx,%edx
  8027fb:	83 c4 1c             	add    $0x1c,%esp
  8027fe:	5b                   	pop    %ebx
  8027ff:	5e                   	pop    %esi
  802800:	5f                   	pop    %edi
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    
  802803:	90                   	nop
  802804:	89 fd                	mov    %edi,%ebp
  802806:	85 ff                	test   %edi,%edi
  802808:	75 0b                	jne    802815 <__umoddi3+0xe9>
  80280a:	b8 01 00 00 00       	mov    $0x1,%eax
  80280f:	31 d2                	xor    %edx,%edx
  802811:	f7 f7                	div    %edi
  802813:	89 c5                	mov    %eax,%ebp
  802815:	89 f0                	mov    %esi,%eax
  802817:	31 d2                	xor    %edx,%edx
  802819:	f7 f5                	div    %ebp
  80281b:	89 c8                	mov    %ecx,%eax
  80281d:	f7 f5                	div    %ebp
  80281f:	89 d0                	mov    %edx,%eax
  802821:	e9 44 ff ff ff       	jmp    80276a <__umoddi3+0x3e>
  802826:	66 90                	xchg   %ax,%ax
  802828:	89 c8                	mov    %ecx,%eax
  80282a:	89 f2                	mov    %esi,%edx
  80282c:	83 c4 1c             	add    $0x1c,%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5f                   	pop    %edi
  802832:	5d                   	pop    %ebp
  802833:	c3                   	ret    
  802834:	3b 04 24             	cmp    (%esp),%eax
  802837:	72 06                	jb     80283f <__umoddi3+0x113>
  802839:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80283d:	77 0f                	ja     80284e <__umoddi3+0x122>
  80283f:	89 f2                	mov    %esi,%edx
  802841:	29 f9                	sub    %edi,%ecx
  802843:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802847:	89 14 24             	mov    %edx,(%esp)
  80284a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80284e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802852:	8b 14 24             	mov    (%esp),%edx
  802855:	83 c4 1c             	add    $0x1c,%esp
  802858:	5b                   	pop    %ebx
  802859:	5e                   	pop    %esi
  80285a:	5f                   	pop    %edi
  80285b:	5d                   	pop    %ebp
  80285c:	c3                   	ret    
  80285d:	8d 76 00             	lea    0x0(%esi),%esi
  802860:	2b 04 24             	sub    (%esp),%eax
  802863:	19 fa                	sbb    %edi,%edx
  802865:	89 d1                	mov    %edx,%ecx
  802867:	89 c6                	mov    %eax,%esi
  802869:	e9 71 ff ff ff       	jmp    8027df <__umoddi3+0xb3>
  80286e:	66 90                	xchg   %ax,%ax
  802870:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802874:	72 ea                	jb     802860 <__umoddi3+0x134>
  802876:	89 d9                	mov    %ebx,%ecx
  802878:	e9 62 ff ff ff       	jmp    8027df <__umoddi3+0xb3>

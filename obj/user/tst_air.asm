
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 91 0f 00 00       	call   800fc7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 03 00 00    	sub    $0x39c,%esp
	int envID = sys_getenvid();
  800044:	e8 6f 29 00 00       	call   8029b8 <sys_getenvid>
  800049:	89 45 a0             	mov    %eax,-0x60(%ebp)

	int numOfClerks = 3;
  80004c:	c7 45 9c 03 00 00 00 	movl   $0x3,-0x64(%ebp)
	int agentCapacity = 20;
  800053:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
	int numOfCustomers = 30;
  80005a:	c7 45 e0 1e 00 00 00 	movl   $0x1e,-0x20(%ebp)
	int flight1NumOfCustomers = numOfCustomers/3;
  800061:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800064:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800069:	f7 e9                	imul   %ecx
  80006b:	c1 f9 1f             	sar    $0x1f,%ecx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	29 c8                	sub    %ecx,%eax
  800072:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int flight2NumOfCustomers = numOfCustomers/3;
  800075:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800078:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80007d:	f7 e9                	imul   %ecx
  80007f:	c1 f9 1f             	sar    $0x1f,%ecx
  800082:	89 d0                	mov    %edx,%eax
  800084:	29 c8                	sub    %ecx,%eax
  800086:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80008c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008f:	01 c2                	add    %eax,%edx
  800091:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800094:	29 d0                	sub    %edx,%eax
  800096:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int flight1NumOfTickets = 15;
  800099:	c7 45 d0 0f 00 00 00 	movl   $0xf,-0x30(%ebp)
	int flight2NumOfTickets = 8;
  8000a0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%ebp)
	// *************************************************************************************************
	/// Reading Inputs *********************************************************************************
	// *************************************************************************************************
	char Line[255] ;
	char Chose;
	sys_lock_cons();
  8000a7:	e8 ac 26 00 00       	call   802758 <sys_lock_cons>
	{
		cprintf("\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 80 31 80 00       	push   $0x803180
  8000b4:	e8 8c 13 00 00       	call   801445 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 84 31 80 00       	push   $0x803184
  8000c4:	e8 7c 13 00 00       	call   801445 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! AIR PLANE RESERVATION !!!!\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 a8 31 80 00       	push   $0x8031a8
  8000d4:	e8 6c 13 00 00       	call   801445 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 84 31 80 00       	push   $0x803184
  8000e4:	e8 5c 13 00 00       	call   801445 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 80 31 80 00       	push   $0x803180
  8000f4:	e8 4c 13 00 00       	call   801445 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	ff 75 cc             	pushl  -0x34(%ebp)
  800105:	ff 75 d0             	pushl  -0x30(%ebp)
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	68 cc 31 80 00       	push   $0x8031cc
  800110:	e8 30 13 00 00       	call   801445 <cprintf>
  800115:	83 c4 20             	add    $0x20,%esp
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
  800118:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  80011c:	eb 42                	jmp    800160 <_main+0x128>
		{
			cprintf("%~Do you want to change these values(y/n)? ") ;
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 4c 32 80 00       	push   $0x80324c
  800126:	e8 1a 13 00 00       	call   801445 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012e:	e8 77 0e 00 00       	call   800faa <getchar>
  800133:	88 45 cb             	mov    %al,-0x35(%ebp)
			cputchar(Chose);
  800136:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 48 0e 00 00       	call   800f8b <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	6a 0a                	push   $0xa
  80014b:	e8 3b 0e 00 00       	call   800f8b <cputchar>
  800150:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 0a                	push   $0xa
  800158:	e8 2e 0e 00 00       	call   800f8b <cputchar>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  800160:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  800164:	74 12                	je     800178 <_main+0x140>
  800166:	80 7d cb 6e          	cmpb   $0x6e,-0x35(%ebp)
  80016a:	74 0c                	je     800178 <_main+0x140>
  80016c:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800170:	74 06                	je     800178 <_main+0x140>
  800172:	80 7d cb 4e          	cmpb   $0x4e,-0x35(%ebp)
  800176:	75 a6                	jne    80011e <_main+0xe6>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		if (Chose == 'y' || Chose == 'Y')
  800178:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  80017c:	74 0a                	je     800188 <_main+0x150>
  80017e:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800182:	0f 85 ea 00 00 00    	jne    800272 <_main+0x23a>
		{
			readline("Enter the capacity of the agent: ", Line);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	68 78 32 80 00       	push   $0x803278
  800197:	e8 82 19 00 00       	call   801b1e <readline>
  80019c:	83 c4 10             	add    $0x10,%esp
			agentCapacity = strtol(Line, NULL, 10) ;
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	6a 0a                	push   $0xa
  8001a4:	6a 00                	push   $0x0
  8001a6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 83 1f 00 00       	call   802135 <strtol>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			readline("Enter the total number of customers: ", Line);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 9c 32 80 00       	push   $0x80329c
  8001c7:	e8 52 19 00 00       	call   801b1e <readline>
  8001cc:	83 c4 10             	add    $0x10,%esp
			numOfCustomers = strtol(Line, NULL, 10) ;
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 0a                	push   $0xa
  8001d4:	6a 00                	push   $0x0
  8001d6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 53 1f 00 00       	call   802135 <strtol>
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			flight1NumOfCustomers = flight2NumOfCustomers = numOfCustomers / 3;
  8001e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8001eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8001f0:	f7 e9                	imul   %ecx
  8001f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8001f5:	89 d0                	mov    %edx,%eax
  8001f7:	29 c8                	sub    %ecx,%eax
  8001f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
			flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	01 c2                	add    %eax,%edx
  80020a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020d:	29 d0                	sub    %edx,%eax
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			readline("Enter # tickets of flight#1: ", Line);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 c2 32 80 00       	push   $0x8032c2
  800221:	e8 f8 18 00 00       	call   801b1e <readline>
  800226:	83 c4 10             	add    $0x10,%esp
			flight1NumOfTickets = strtol(Line, NULL, 10) ;
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	6a 0a                	push   $0xa
  80022e:	6a 00                	push   $0x0
  800230:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	e8 f9 1e 00 00       	call   802135 <strtol>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			readline("Enter # tickets of flight#2: ", Line);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	68 e0 32 80 00       	push   $0x8032e0
  800251:	e8 c8 18 00 00       	call   801b1e <readline>
  800256:	83 c4 10             	add    $0x10,%esp
			flight2NumOfTickets = strtol(Line, NULL, 10) ;
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	6a 0a                	push   $0xa
  80025e:	6a 00                	push   $0x0
  800260:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 c9 1e 00 00       	call   802135 <strtol>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		}
	}
	sys_unlock_cons();
  800272:	e8 fb 24 00 00       	call   802772 <sys_unlock_cons>

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************
	char _isOpened[] = "isOpened";
  800277:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80027d:	bb f6 36 80 00       	mov    $0x8036f6,%ebx
  800282:	ba 09 00 00 00       	mov    $0x9,%edx
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	89 d1                	mov    %edx,%ecx
  80028d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _agentCapacity[] = "agentCapacity";
  80028f:	8d 85 42 fe ff ff    	lea    -0x1be(%ebp),%eax
  800295:	bb ff 36 80 00       	mov    $0x8036ff,%ebx
  80029a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80029f:	89 c7                	mov    %eax,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	89 d1                	mov    %edx,%ecx
  8002a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  8002a7:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8002ad:	bb 0d 37 80 00       	mov    $0x80370d,%ebx
  8002b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  8002bf:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  8002c5:	bb 17 37 80 00       	mov    $0x803717,%ebx
  8002ca:	ba 03 00 00 00       	mov    $0x3,%edx
  8002cf:	89 c7                	mov    %eax,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Customers[] = "flight1Customers";
  8002d7:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  8002dd:	bb 23 37 80 00       	mov    $0x803723,%ebx
  8002e2:	ba 11 00 00 00       	mov    $0x11,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  8002ef:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  8002f5:	bb 34 37 80 00       	mov    $0x803734,%ebx
  8002fa:	ba 11 00 00 00       	mov    $0x11,%edx
  8002ff:	89 c7                	mov    %eax,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	89 d1                	mov    %edx,%ecx
  800305:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800307:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  80030d:	bb 45 37 80 00       	mov    $0x803745,%ebx
  800312:	ba 11 00 00 00       	mov    $0x11,%edx
  800317:	89 c7                	mov    %eax,%edi
  800319:	89 de                	mov    %ebx,%esi
  80031b:	89 d1                	mov    %edx,%ecx
  80031d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  80031f:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  800325:	bb 56 37 80 00       	mov    $0x803756,%ebx
  80032a:	ba 0f 00 00 00       	mov    $0xf,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  800337:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  80033d:	bb 65 37 80 00       	mov    $0x803765,%ebx
  800342:	ba 0f 00 00 00       	mov    $0xf,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  80034f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  800355:	bb 74 37 80 00       	mov    $0x803774,%ebx
  80035a:	ba 15 00 00 00       	mov    $0x15,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  800367:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  80036d:	bb 89 37 80 00       	mov    $0x803789,%ebx
  800372:	ba 15 00 00 00       	mov    $0x15,%edx
  800377:	89 c7                	mov    %eax,%edi
  800379:	89 de                	mov    %ebx,%esi
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  80037f:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800385:	bb 9e 37 80 00       	mov    $0x80379e,%ebx
  80038a:	ba 11 00 00 00       	mov    $0x11,%edx
  80038f:	89 c7                	mov    %eax,%edi
  800391:	89 de                	mov    %ebx,%esi
  800393:	89 d1                	mov    %edx,%ecx
  800395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  800397:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  80039d:	bb af 37 80 00       	mov    $0x8037af,%ebx
  8003a2:	ba 11 00 00 00       	mov    $0x11,%edx
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	89 de                	mov    %ebx,%esi
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8003af:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  8003b5:	bb c0 37 80 00       	mov    $0x8037c0,%ebx
  8003ba:	ba 11 00 00 00       	mov    $0x11,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  8003c7:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8003cd:	bb d1 37 80 00       	mov    $0x8037d1,%ebx
  8003d2:	ba 09 00 00 00       	mov    $0x9,%edx
  8003d7:	89 c7                	mov    %eax,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	89 d1                	mov    %edx,%ecx
  8003dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  8003df:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8003e5:	bb da 37 80 00       	mov    $0x8037da,%ebx
  8003ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	89 de                	mov    %ebx,%esi
  8003f3:	89 d1                	mov    %edx,%ecx
  8003f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  8003f7:	8d 85 60 fd ff ff    	lea    -0x2a0(%ebp),%eax
  8003fd:	bb e4 37 80 00       	mov    $0x8037e4,%ebx
  800402:	ba 0b 00 00 00       	mov    $0xb,%edx
  800407:	89 c7                	mov    %eax,%edi
  800409:	89 de                	mov    %ebx,%esi
  80040b:	89 d1                	mov    %edx,%ecx
  80040d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80040f:	8d 85 54 fd ff ff    	lea    -0x2ac(%ebp),%eax
  800415:	bb ef 37 80 00       	mov    $0x8037ef,%ebx
  80041a:	ba 03 00 00 00       	mov    $0x3,%edx
  80041f:	89 c7                	mov    %eax,%edi
  800421:	89 de                	mov    %ebx,%esi
  800423:	89 d1                	mov    %edx,%ecx
  800425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800427:	8d 85 4a fd ff ff    	lea    -0x2b6(%ebp),%eax
  80042d:	bb fb 37 80 00       	mov    $0x8037fb,%ebx
  800432:	ba 0a 00 00 00       	mov    $0xa,%edx
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 de                	mov    %ebx,%esi
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80043f:	8d 85 40 fd ff ff    	lea    -0x2c0(%ebp),%eax
  800445:	bb 05 38 80 00       	mov    $0x803805,%ebx
  80044a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044f:	89 c7                	mov    %eax,%edi
  800451:	89 de                	mov    %ebx,%esi
  800453:	89 d1                	mov    %edx,%ecx
  800455:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  800457:	c7 85 3a fd ff ff 63 	movl   $0x72656c63,-0x2c6(%ebp)
  80045e:	6c 65 72 
  800461:	66 c7 85 3e fd ff ff 	movw   $0x6b,-0x2c2(%ebp)
  800468:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  80046a:	8d 85 2c fd ff ff    	lea    -0x2d4(%ebp),%eax
  800470:	bb 0f 38 80 00       	mov    $0x80380f,%ebx
  800475:	ba 0e 00 00 00       	mov    $0xe,%edx
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	89 de                	mov    %ebx,%esi
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800482:	8d 85 1d fd ff ff    	lea    -0x2e3(%ebp),%eax
  800488:	bb 1d 38 80 00       	mov    $0x80381d,%ebx
  80048d:	ba 0f 00 00 00       	mov    $0xf,%edx
  800492:	89 c7                	mov    %eax,%edi
  800494:	89 de                	mov    %ebx,%esi
  800496:	89 d1                	mov    %edx,%ecx
  800498:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80049a:	8d 85 0d fd ff ff    	lea    -0x2f3(%ebp),%eax
  8004a0:	bb 2c 38 80 00       	mov    $0x80382c,%ebx
  8004a5:	ba 04 00 00 00       	mov    $0x4,%edx
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	89 de                	mov    %ebx,%esi
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8004b2:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8004b8:	bb 3c 38 80 00       	mov    $0x80383c,%ebx
  8004bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8004c2:	89 c7                	mov    %eax,%edi
  8004c4:	89 de                	mov    %ebx,%esi
  8004c6:	89 d1                	mov    %edx,%ecx
  8004c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  8004ca:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  8004d0:	bb 43 38 80 00       	mov    $0x803843,%ebx
  8004d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	89 de                	mov    %ebx,%esi
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*(numOfCustomers+1), 1);
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	40                   	inc    %eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	50                   	push   %eax
  8004ef:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 5c 21 00 00       	call   802657 <smalloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);

	int* flight1Customers = smalloc(_flight1Customers, sizeof(int), 1); *flight1Customers = flight1NumOfCustomers;
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	6a 01                	push   $0x1
  800506:	6a 04                	push   $0x4
  800508:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	e8 43 21 00 00       	call   802657 <smalloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80051a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	89 10                	mov    %edx,(%eax)
	int* flight2Customers = smalloc(_flight2Customers, sizeof(int), 1); *flight2Customers = flight2NumOfCustomers;
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	6a 01                	push   $0x1
  800527:	6a 04                	push   $0x4
  800529:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 22 21 00 00       	call   802657 <smalloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 45 90             	mov    %eax,-0x70(%ebp)
  80053b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	89 10                	mov    %edx,(%eax)
	int* flight3Customers = smalloc(_flight3Customers, sizeof(int), 1); *flight3Customers = flight3NumOfCustomers;
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	6a 01                	push   $0x1
  800548:	6a 04                	push   $0x4
  80054a:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  800550:	50                   	push   %eax
  800551:	e8 01 21 00 00       	call   802657 <smalloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 8c             	mov    %eax,-0x74(%ebp)
  80055c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800562:	89 10                	mov    %edx,(%eax)

	int* isOpened = smalloc(_isOpened, sizeof(int), 0);
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	6a 00                	push   $0x0
  800569:	6a 04                	push   $0x4
  80056b:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	e8 e0 20 00 00       	call   802657 <smalloc>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 88             	mov    %eax,-0x78(%ebp)
	*isOpened = 1;
  80057d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	6a 01                	push   $0x1
  80058b:	6a 04                	push   $0x4
  80058d:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 be 20 00 00       	call   802657 <smalloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 84             	mov    %eax,-0x7c(%ebp)
	*custCounter = 0;
  80059f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	6a 01                	push   $0x1
  8005ad:	6a 04                	push   $0x4
  8005af:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 9c 20 00 00       	call   802657 <smalloc>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 80             	mov    %eax,-0x80(%ebp)
	*flight1Counter = flight1NumOfTickets;
  8005c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c7:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	6a 01                	push   $0x1
  8005ce:	6a 04                	push   $0x4
  8005d0:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 7b 20 00 00       	call   802657 <smalloc>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*flight2Counter = flight2NumOfTickets;
  8005e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ee:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	6a 01                	push   $0x1
  8005f5:	6a 04                	push   $0x4
  8005f7:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 54 20 00 00       	call   802657 <smalloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*flight1BookedCounter = 0;
  80060c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	6a 04                	push   $0x4
  80061f:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 2c 20 00 00       	call   802657 <smalloc>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	*flight2BookedCounter = 0;
  800634:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80063a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  800640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800643:	c1 e0 02             	shl    $0x2,%eax
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	6a 01                	push   $0x1
  80064b:	50                   	push   %eax
  80064c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	e8 ff 1f 00 00       	call   802657 <smalloc>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	6a 01                	push   $0x1
  80066c:	50                   	push   %eax
  80066d:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	e8 de 1f 00 00       	call   802657 <smalloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*(numOfCustomers+1), 1);
  800682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800685:	40                   	inc    %eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	6a 01                	push   $0x1
  80068e:	50                   	push   %eax
  80068f:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 bc 1f 00 00       	call   802657 <smalloc>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	6a 01                	push   $0x1
  8006a9:	6a 04                	push   $0x4
  8006ab:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 a0 1f 00 00       	call   802657 <smalloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	*queue_in = 0;
  8006c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	6a 01                	push   $0x1
  8006d1:	6a 04                	push   $0x4
  8006d3:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 78 1f 00 00       	call   802657 <smalloc>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	*queue_out = 0;
  8006e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8006ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	struct semaphore capacity = create_semaphore(_agentCapacity, agentCapacity);
  8006f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f7:	8d 85 f8 fc ff ff    	lea    -0x308(%ebp),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	52                   	push   %edx
  800701:	8d 95 42 fe ff ff    	lea    -0x1be(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 cd 26 00 00       	call   802ddb <create_semaphore>
  80070e:	83 c4 0c             	add    $0xc,%esp

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800711:	8d 85 f4 fc ff ff    	lea    -0x30c(%ebp),%eax
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	6a 01                	push   $0x1
  80071c:	8d 95 4a fd ff ff    	lea    -0x2b6(%ebp),%edx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	e8 b2 26 00 00       	call   802ddb <create_semaphore>
  800729:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  80072c:	8d 85 f0 fc ff ff    	lea    -0x310(%ebp),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	6a 01                	push   $0x1
  800737:	8d 95 40 fd ff ff    	lea    -0x2c0(%ebp),%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	e8 97 26 00 00       	call   802ddb <create_semaphore>
  800744:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  800747:	8d 85 ec fc ff ff    	lea    -0x314(%ebp),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	6a 01                	push   $0x1
  800752:	8d 95 2c fd ff ff    	lea    -0x2d4(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	e8 7c 26 00 00       	call   802ddb <create_semaphore>
  80075f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  800762:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	6a 01                	push   $0x1
  80076d:	8d 95 54 fd ff ff    	lea    -0x2ac(%ebp),%edx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	e8 61 26 00 00       	call   802ddb <create_semaphore>
  80077a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  80077d:	8d 85 e4 fc ff ff    	lea    -0x31c(%ebp),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	6a 03                	push   $0x3
  800788:	8d 95 3a fd ff ff    	lea    -0x2c6(%ebp),%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 46 26 00 00       	call   802ddb <create_semaphore>
  800795:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  800798:	8d 85 e0 fc ff ff    	lea    -0x320(%ebp),%eax
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 2b 26 00 00       	call   802ddb <create_semaphore>
  8007b0:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  8007b3:	8d 85 dc fc ff ff    	lea    -0x324(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	6a 00                	push   $0x0
  8007be:	8d 95 1d fd ff ff    	lea    -0x2e3(%ebp),%edx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	e8 10 26 00 00       	call   802ddb <create_semaphore>
  8007cb:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);
  8007ce:	8d 85 d8 fc ff ff    	lea    -0x328(%ebp),%eax
  8007d4:	83 ec 04             	sub    $0x4,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	8d 95 0d fd ff ff    	lea    -0x2f3(%ebp),%edx
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	e8 f5 25 00 00       	call   802ddb <create_semaphore>
  8007e6:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	c1 e0 02             	shl    $0x2,%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	6a 01                	push   $0x1
  8007f4:	50                   	push   %eax
  8007f5:	68 fe 32 80 00       	push   $0x8032fe
  8007fa:	e8 58 1e 00 00       	call   802657 <smalloc>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)

	int s=0;
  800808:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  80080f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800816:	e9 9a 00 00 00       	jmp    8008b5 <_main+0x87d>
	{
		char prefix[30]="cust_finished";
  80081b:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800821:	bb 4a 38 80 00       	mov    $0x80384a,%ebx
  800826:	ba 0e 00 00 00       	mov    $0xe,%edx
  80082b:	89 c7                	mov    %eax,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	89 d1                	mov    %edx,%ecx
  800831:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800833:	8d 95 bc fc ff ff    	lea    -0x344(%ebp),%edx
  800839:	b9 04 00 00 00       	mov    $0x4,%ecx
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	89 d7                	mov    %edx,%edi
  800845:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	ff 75 c4             	pushl  -0x3c(%ebp)
  800854:	e8 22 1a 00 00       	call   80227b <ltostr>
  800859:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	8d 85 77 fc ff ff    	lea    -0x389(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 db 1a 00 00       	call   802354 <strcconcat>
  800879:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  80087c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80087f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800886:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80088c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80088f:	8d 85 64 fc ff ff    	lea    -0x39c(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	6a 00                	push   $0x0
  80089a:	8d 95 77 fc ff ff    	lea    -0x389(%ebp),%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 34 25 00 00       	call   802ddb <create_semaphore>
  8008a7:	83 c4 0c             	add    $0xc,%esp
  8008aa:	8b 85 64 fc ff ff    	mov    -0x39c(%ebp),%eax
  8008b0:	89 03                	mov    %eax,(%ebx)
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  8008b2:	ff 45 c4             	incl   -0x3c(%ebp)
  8008b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8008bb:	0f 8c 5a ff ff ff    	jl     80081b <_main+0x7e3>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  8008c1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8008c8:	eb 50                	jmp    80091a <_main+0x8e2>
	{
		envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8008ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8008cf:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8008d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008da:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8008e0:	89 c1                	mov    %eax,%ecx
  8008e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8008ed:	52                   	push   %edx
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 67 20 00 00       	call   802963 <sys_create_env>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		sys_run_env(envId);
  800905:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	50                   	push   %eax
  80090f:	e8 6d 20 00 00       	call   802981 <sys_run_env>
  800914:	83 c4 10             	add    $0x10,%esp
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  800917:	ff 45 c0             	incl   -0x40(%ebp)
  80091a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80091d:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800920:	7c a8                	jl     8008ca <_main+0x892>
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800922:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  800929:	eb 70                	jmp    80099b <_main+0x963>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80092b:	a1 20 50 80 00       	mov    0x805020,%eax
  800930:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800936:	a1 20 50 80 00       	mov    0x805020,%eax
  80093b:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800941:	89 c1                	mov    %eax,%ecx
  800943:	a1 20 50 80 00       	mov    0x805020,%eax
  800948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80094e:	52                   	push   %edx
  80094f:	51                   	push   %ecx
  800950:	50                   	push   %eax
  800951:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 06 20 00 00       	call   802963 <sys_create_env>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800966:	83 bd 58 ff ff ff ef 	cmpl   $0xffffffef,-0xa8(%ebp)
  80096d:	75 17                	jne    800986 <_main+0x94e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	68 14 33 80 00       	push   $0x803314
  800977:	68 b5 00 00 00       	push   $0xb5
  80097c:	68 5a 33 80 00       	push   $0x80335a
  800981:	e8 f1 07 00 00       	call   801177 <_panic>

		sys_run_env(envId);
  800986:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 ec 1f 00 00       	call   802981 <sys_run_env>
  800995:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800998:	ff 45 bc             	incl   -0x44(%ebp)
  80099b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80099e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a1:	7c 88                	jl     80092b <_main+0x8f3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009a3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009aa:	eb 14                	jmp    8009c0 <_main+0x988>
	{
		wait_semaphore(custTerminated);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  8009b5:	e8 55 24 00 00       	call   802e0f <wait_semaphore>
  8009ba:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009bd:	ff 45 bc             	incl   -0x44(%ebp)
  8009c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009c6:	7c e4                	jl     8009ac <_main+0x974>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	68 dc 05 00 00       	push   $0x5dc
  8009d0:	e8 79 24 00 00       	call   802e4e <env_sleep>
  8009d5:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
  8009d8:	e8 7b 1d 00 00       	call   802758 <sys_lock_cons>
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  8009dd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  8009e4:	eb 4b                	jmp    800a31 <_main+0x9f9>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8009e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 10                	mov    (%eax),%edx
  800a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a12:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	68 6c 33 80 00       	push   $0x80336c
  800a26:	e8 1a 0a 00 00       	call   801445 <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  800a2e:	ff 45 b8             	incl   -0x48(%ebp)
  800a31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a3c:	7f a8                	jg     8009e6 <_main+0x9ae>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a3e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800a45:	eb 4b                	jmp    800a92 <_main+0xa5a>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800a47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a51:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a62:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a73:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	68 9c 33 80 00       	push   $0x80339c
  800a87:	e8 b9 09 00 00       	call   801445 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a8f:	ff 45 b8             	incl   -0x48(%ebp)
  800a92:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a9d:	7f a8                	jg     800a47 <_main+0xa0f>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}
	}
	sys_unlock_cons();
  800a9f:	e8 ce 1c 00 00       	call   802772 <sys_unlock_cons>

	int numOfBookings = 0;
  800aa4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int numOfFCusts[3] = {0};
  800aab:	8d 95 cc fc ff ff    	lea    -0x334(%ebp),%edx
  800ab1:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	89 d7                	mov    %edx,%edi
  800abd:	f3 ab                	rep stos %eax,%es:(%edi)

	for(b=0; b< numOfCustomers;++b)
  800abf:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800ac6:	eb 3d                	jmp    800b05 <_main+0xacd>
	{
		if (custs[b].booked)
  800ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800ad2:	8b 45 98             	mov    -0x68(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	74 24                	je     800b02 <_main+0xaca>
		{
			numOfBookings++;
  800ade:	ff 45 b4             	incl   -0x4c(%ebp)
			numOfFCusts[custs[b].flightType - 1]++ ;
  800ae1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800aeb:	8b 45 98             	mov    -0x68(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	48                   	dec    %eax
  800af3:	8b 94 85 cc fc ff ff 	mov    -0x334(%ebp,%eax,4),%edx
  800afa:	42                   	inc    %edx
  800afb:	89 94 85 cc fc ff ff 	mov    %edx,-0x334(%ebp,%eax,4)
	sys_unlock_cons();

	int numOfBookings = 0;
	int numOfFCusts[3] = {0};

	for(b=0; b< numOfCustomers;++b)
  800b02:	ff 45 b8             	incl   -0x48(%ebp)
  800b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b08:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b0b:	7c bb                	jl     800ac8 <_main+0xa90>
			numOfBookings++;
			numOfFCusts[custs[b].flightType - 1]++ ;
		}
	}

	sys_lock_cons();
  800b0d:	e8 46 1c 00 00       	call   802758 <sys_lock_cons>
	{
	cprintf("%~[*] FINAL RESULTS:\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 cc 33 80 00       	push   $0x8033cc
  800b1a:	e8 26 09 00 00       	call   801445 <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("%~\tTotal number of customers = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfCustomers, flight1NumOfCustomers,flight2NumOfCustomers,flight3NumOfCustomers);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b28:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b31:	68 e4 33 80 00       	push   $0x8033e4
  800b36:	e8 0a 09 00 00       	call   801445 <cprintf>
  800b3b:	83 c4 20             	add    $0x20,%esp
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
  800b3e:	8b 8d d4 fc ff ff    	mov    -0x32c(%ebp),%ecx
  800b44:	8b 95 d0 fc ff ff    	mov    -0x330(%ebp),%edx
  800b4a:	8b 85 cc fc ff ff    	mov    -0x334(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	51                   	push   %ecx
  800b54:	52                   	push   %edx
  800b55:	50                   	push   %eax
  800b56:	ff 75 b4             	pushl  -0x4c(%ebp)
  800b59:	68 38 34 80 00       	push   $0x803438
  800b5e:	e8 e2 08 00 00       	call   801445 <cprintf>
  800b63:	83 c4 20             	add    $0x20,%esp
	}
	sys_unlock_cons();
  800b66:	e8 07 1c 00 00       	call   802772 <sys_unlock_cons>
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800b6b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  800b72:	e9 13 01 00 00       	jmp    800c8a <_main+0xc52>
		{
			if (custs[c].booked)
  800b77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b81:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	8b 40 04             	mov    0x4(%eax),%eax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	0f 84 f6 00 00 00    	je     800c87 <_main+0xc4f>
			{
				if(custs[c].flightType ==1 && find(flight1BookedArr, flight1NumOfTickets, c) != 1)
  800b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 f8 01             	cmp    $0x1,%eax
  800ba5:	75 33                	jne    800bda <_main+0xba2>
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 b0             	pushl  -0x50(%ebp)
  800bad:	ff 75 d0             	pushl  -0x30(%ebp)
  800bb0:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800bb6:	e8 8b 03 00 00       	call   800f46 <find>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	83 f8 01             	cmp    $0x1,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
				{
					panic("Error, wrong booking for user %d\n", c);
  800bc3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bc6:	68 a0 34 80 00       	push   $0x8034a0
  800bcb:	68 ed 00 00 00       	push   $0xed
  800bd0:	68 5a 33 80 00       	push   $0x80335a
  800bd5:	e8 9d 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==2 && find(flight2BookedArr, flight2NumOfTickets, c) != 1)
  800bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800bdd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800be4:	8b 45 98             	mov    -0x68(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 f8 02             	cmp    $0x2,%eax
  800bee:	75 33                	jne    800c23 <_main+0xbeb>
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bf6:	ff 75 cc             	pushl  -0x34(%ebp)
  800bf9:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800bff:	e8 42 03 00 00       	call   800f46 <find>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	83 f8 01             	cmp    $0x1,%eax
  800c0a:	74 17                	je     800c23 <_main+0xbeb>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c0f:	68 a0 34 80 00       	push   $0x8034a0
  800c14:	68 f1 00 00 00       	push   $0xf1
  800c19:	68 5a 33 80 00       	push   $0x80335a
  800c1e:	e8 54 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==3 && ((find(flight1BookedArr, flight1NumOfTickets, c) + find(flight2BookedArr, flight2NumOfTickets, c)) != 2))
  800c23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800c2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 f8 03             	cmp    $0x3,%eax
  800c37:	75 4e                	jne    800c87 <_main+0xc4f>
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c3f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c42:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800c48:	e8 f9 02 00 00       	call   800f46 <find>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	ff 75 b0             	pushl  -0x50(%ebp)
  800c58:	ff 75 cc             	pushl  -0x34(%ebp)
  800c5b:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800c61:	e8 e0 02 00 00       	call   800f46 <find>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	01 d8                	add    %ebx,%eax
  800c6b:	83 f8 02             	cmp    $0x2,%eax
  800c6e:	74 17                	je     800c87 <_main+0xc4f>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c70:	ff 75 b0             	pushl  -0x50(%ebp)
  800c73:	68 a0 34 80 00       	push   $0x8034a0
  800c78:	68 f5 00 00 00       	push   $0xf5
  800c7d:	68 5a 33 80 00       	push   $0x80335a
  800c82:	e8 f0 04 00 00       	call   801177 <_panic>
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
	}
	sys_unlock_cons();
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800c87:	ff 45 b0             	incl   -0x50(%ebp)
  800c8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c90:	0f 8c e1 fe ff ff    	jl     800b77 <_main+0xb3f>
					panic("Error, wrong booking for user %d\n", c);
				}
			}
		}

		assert(semaphore_count(capacity) == agentCapacity);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff b5 f8 fc ff ff    	pushl  -0x308(%ebp)
  800c9f:	e8 9f 21 00 00       	call   802e43 <semaphore_count>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800caa:	74 19                	je     800cc5 <_main+0xc8d>
  800cac:	68 c4 34 80 00       	push   $0x8034c4
  800cb1:	68 ef 34 80 00       	push   $0x8034ef
  800cb6:	68 fa 00 00 00       	push   $0xfa
  800cbb:	68 5a 33 80 00       	push   $0x80335a
  800cc0:	e8 b2 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(flight1CS) == 1);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  800cce:	e8 70 21 00 00       	call   802e43 <semaphore_count>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 f8 01             	cmp    $0x1,%eax
  800cd9:	74 19                	je     800cf4 <_main+0xcbc>
  800cdb:	68 04 35 80 00       	push   $0x803504
  800ce0:	68 ef 34 80 00       	push   $0x8034ef
  800ce5:	68 fc 00 00 00       	push   $0xfc
  800cea:	68 5a 33 80 00       	push   $0x80335a
  800cef:	e8 83 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	ff b5 f0 fc ff ff    	pushl  -0x310(%ebp)
  800cfd:	e8 41 21 00 00       	call   802e43 <semaphore_count>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	83 f8 01             	cmp    $0x1,%eax
  800d08:	74 19                	je     800d23 <_main+0xceb>
  800d0a:	68 24 35 80 00       	push   $0x803524
  800d0f:	68 ef 34 80 00       	push   $0x8034ef
  800d14:	68 fd 00 00 00       	push   $0xfd
  800d19:	68 5a 33 80 00       	push   $0x80335a
  800d1e:	e8 54 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	ff b5 ec fc ff ff    	pushl  -0x314(%ebp)
  800d2c:	e8 12 21 00 00       	call   802e43 <semaphore_count>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	83 f8 01             	cmp    $0x1,%eax
  800d37:	74 19                	je     800d52 <_main+0xd1a>
  800d39:	68 44 35 80 00       	push   $0x803544
  800d3e:	68 ef 34 80 00       	push   $0x8034ef
  800d43:	68 ff 00 00 00       	push   $0xff
  800d48:	68 5a 33 80 00       	push   $0x80335a
  800d4d:	e8 25 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	ff b5 e8 fc ff ff    	pushl  -0x318(%ebp)
  800d5b:	e8 e3 20 00 00       	call   802e43 <semaphore_count>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	83 f8 01             	cmp    $0x1,%eax
  800d66:	74 19                	je     800d81 <_main+0xd49>
  800d68:	68 68 35 80 00       	push   $0x803568
  800d6d:	68 ef 34 80 00       	push   $0x8034ef
  800d72:	68 00 01 00 00       	push   $0x100
  800d77:	68 5a 33 80 00       	push   $0x80335a
  800d7c:	e8 f6 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	ff b5 e4 fc ff ff    	pushl  -0x31c(%ebp)
  800d8a:	e8 b4 20 00 00       	call   802e43 <semaphore_count>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	83 f8 03             	cmp    $0x3,%eax
  800d95:	74 19                	je     800db0 <_main+0xd78>
  800d97:	68 8a 35 80 00       	push   $0x80358a
  800d9c:	68 ef 34 80 00       	push   $0x8034ef
  800da1:	68 02 01 00 00       	push   $0x102
  800da6:	68 5a 33 80 00       	push   $0x80335a
  800dab:	e8 c7 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800db9:	e8 85 20 00 00       	call   802e43 <semaphore_count>
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800dc4:	74 19                	je     800ddf <_main+0xda7>
  800dc6:	68 a8 35 80 00       	push   $0x8035a8
  800dcb:	68 ef 34 80 00       	push   $0x8034ef
  800dd0:	68 04 01 00 00       	push   $0x104
  800dd5:	68 5a 33 80 00       	push   $0x80335a
  800dda:	e8 98 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  800de8:	e8 56 20 00 00       	call   802e43 <semaphore_count>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	74 19                	je     800e0d <_main+0xdd5>
  800df4:	68 cc 35 80 00       	push   $0x8035cc
  800df9:	68 ef 34 80 00       	push   $0x8034ef
  800dfe:	68 06 01 00 00       	push   $0x106
  800e03:	68 5a 33 80 00       	push   $0x80335a
  800e08:	e8 6a 03 00 00       	call   801177 <_panic>

		int s=0;
  800e0d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800e14:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  800e1b:	eb 3f                	jmp    800e5c <_main+0xe24>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
  800e1d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e27:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 30                	pushl  (%eax)
  800e34:	e8 0a 20 00 00       	call   802e43 <semaphore_count>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	74 19                	je     800e59 <_main+0xe21>
  800e40:	68 f4 35 80 00       	push   $0x8035f4
  800e45:	68 ef 34 80 00       	push   $0x8034ef
  800e4a:	68 0b 01 00 00       	push   $0x10b
  800e4f:	68 5a 33 80 00       	push   $0x80335a
  800e54:	e8 1e 03 00 00       	call   801177 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800e59:	ff 45 ac             	incl   -0x54(%ebp)
  800e5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e62:	7c b9                	jl     800e1d <_main+0xde5>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		atomic_cprintf("%~\nAll reservations are successfully done... have a nice flight :)\n");
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	68 1c 36 80 00       	push   $0x80361c
  800e6c:	e8 46 06 00 00       	call   8014b7 <atomic_cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

		//waste some time then close the agency
		env_sleep(5000) ;
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	68 88 13 00 00       	push   $0x1388
  800e7c:	e8 cd 1f 00 00       	call   802e4e <env_sleep>
  800e81:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
  800e84:	8b 45 88             	mov    -0x78(%ebp),%eax
  800e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		atomic_cprintf("\n%~The agency is closing now...\n");
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	68 60 36 80 00       	push   $0x803660
  800e95:	e8 1d 06 00 00       	call   8014b7 <atomic_cprintf>
  800e9a:	83 c4 10             	add    $0x10,%esp

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ea7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
		for (int k = 0; k < numOfClerks; ++k)
  800eb5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  800ebc:	eb 14                	jmp    800ed2 <_main+0xe9a>
		{
			signal_semaphore(cust_ready);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800ec7:	e8 5d 1f 00 00       	call   802e29 <signal_semaphore>
  800ecc:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
		atomic_cprintf("\n%~The agency is closing now...\n");

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
		for (int k = 0; k < numOfClerks; ++k)
  800ecf:	ff 45 a8             	incl   -0x58(%ebp)
  800ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800ed5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800ed8:	7c e4                	jl     800ebe <_main+0xe86>
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800eda:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  800ee1:	eb 14                	jmp    800ef7 <_main+0xebf>
		{
			wait_semaphore(clerkTerminated);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800eec:	e8 1e 1f 00 00       	call   802e0f <wait_semaphore>
  800ef1:	83 c4 10             	add    $0x10,%esp
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800ef4:	ff 45 a4             	incl   -0x5c(%ebp)
  800ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800efa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800efd:	7c e4                	jl     800ee3 <_main+0xeab>
		{
			wait_semaphore(clerkTerminated);
		}

		assert(semaphore_count(clerkTerminated) ==  0);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800f08:	e8 36 1f 00 00       	call   802e43 <semaphore_count>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 19                	je     800f2d <_main+0xef5>
  800f14:	68 84 36 80 00       	push   $0x803684
  800f19:	68 ef 34 80 00       	push   $0x8034ef
  800f1e:	68 22 01 00 00       	push   $0x122
  800f23:	68 5a 33 80 00       	push   $0x80335a
  800f28:	e8 4a 02 00 00       	call   801177 <_panic>

		atomic_cprintf("%~\nCongratulations... Airplane Reservation App is Finished Successfully\n\n");
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	68 ac 36 80 00       	push   $0x8036ac
  800f35:	e8 7d 05 00 00       	call   8014b7 <atomic_cprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
	}

}
  800f3d:	90                   	nop
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <find>:


int find(int* arr, int size, int val)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 22                	jmp    800f7e <find+0x38>
	{
		if(arr[i] == val)
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f70:	75 09                	jne    800f7b <find+0x35>
		{
			result = 1;
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800f79:	eb 0b                	jmp    800f86 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f84:	7c d6                	jl     800f5c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800f97:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	e8 fc 18 00 00       	call   8028a0 <sys_cputc>
  800fa4:	83 c4 10             	add    $0x10,%esp
}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <getchar>:


int
getchar(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800fb0:	e8 8a 17 00 00       	call   80273f <sys_cgetc>
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <iscons>:

int iscons(int fdnum)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800fd0:	e8 fc 19 00 00       	call   8029d1 <sys_getenvindex>
  800fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	c1 e0 02             	shl    $0x2,%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c1 e0 03             	shl    $0x3,%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	c1 e0 02             	shl    $0x2,%eax
  800ff3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ff8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ffd:	a1 20 50 80 00       	mov    0x805020,%eax
  801002:	8a 40 20             	mov    0x20(%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	74 0d                	je     801016 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801009:	a1 20 50 80 00       	mov    0x805020,%eax
  80100e:	83 c0 20             	add    $0x20,%eax
  801011:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101a:	7e 0a                	jle    801026 <libmain+0x5f>
		binaryname = argv[0];
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 04 f0 ff ff       	call   800038 <_main>
  801034:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801037:	a1 00 50 80 00       	mov    0x805000,%eax
  80103c:	85 c0                	test   %eax,%eax
  80103e:	0f 84 01 01 00 00    	je     801145 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801044:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80104a:	bb 60 39 80 00       	mov    $0x803960,%ebx
  80104f:	ba 0e 00 00 00       	mov    $0xe,%edx
  801054:	89 c7                	mov    %eax,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80105c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80105f:	b9 56 00 00 00       	mov    $0x56,%ecx
  801064:	b0 00                	mov    $0x0,%al
  801066:	89 d7                	mov    %edx,%edi
  801068:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80106a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801071:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	50                   	push   %eax
  801078:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	e8 83 1b 00 00       	call   802c07 <sys_utilities>
  801084:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801087:	e8 cc 16 00 00       	call   802758 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	68 80 38 80 00       	push   $0x803880
  801094:	e8 ac 03 00 00       	call   801445 <cprintf>
  801099:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80109c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	74 18                	je     8010bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8010a3:	e8 7d 1b 00 00       	call   802c25 <sys_get_optimal_num_faults>
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	50                   	push   %eax
  8010ac:	68 a8 38 80 00       	push   $0x8038a8
  8010b1:	e8 8f 03 00 00       	call   801445 <cprintf>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	eb 59                	jmp    801114 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8010c0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8010c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8010cb:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	52                   	push   %edx
  8010d5:	50                   	push   %eax
  8010d6:	68 cc 38 80 00       	push   $0x8038cc
  8010db:	e8 65 03 00 00       	call   801445 <cprintf>
  8010e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8010e8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8010ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8010f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8010fe:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801104:	51                   	push   %ecx
  801105:	52                   	push   %edx
  801106:	50                   	push   %eax
  801107:	68 f4 38 80 00       	push   $0x8038f4
  80110c:	e8 34 03 00 00       	call   801445 <cprintf>
  801111:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801114:	a1 20 50 80 00       	mov    0x805020,%eax
  801119:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	50                   	push   %eax
  801123:	68 4c 39 80 00       	push   $0x80394c
  801128:	e8 18 03 00 00       	call   801445 <cprintf>
  80112d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	68 80 38 80 00       	push   $0x803880
  801138:	e8 08 03 00 00       	call   801445 <cprintf>
  80113d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801140:	e8 2d 16 00 00       	call   802772 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801145:	e8 1f 00 00 00       	call   801169 <exit>
}
  80114a:	90                   	nop
  80114b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	6a 00                	push   $0x0
  80115e:	e8 3a 18 00 00       	call   80299d <sys_destroy_env>
  801163:	83 c4 10             	add    $0x10,%esp
}
  801166:	90                   	nop
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <exit>:

void
exit(void)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80116f:	e8 8f 18 00 00       	call   802a03 <sys_exit_env>
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80117d:	8d 45 10             	lea    0x10(%ebp),%eax
  801180:	83 c0 04             	add    $0x4,%eax
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801186:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80118b:	85 c0                	test   %eax,%eax
  80118d:	74 16                	je     8011a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80118f:	a1 18 d1 81 00       	mov    0x81d118,%eax
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	50                   	push   %eax
  801198:	68 c4 39 80 00       	push   $0x8039c4
  80119d:	e8 a3 02 00 00       	call   801445 <cprintf>
  8011a2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8011a5:	a1 04 50 80 00       	mov    0x805004,%eax
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	ff 75 08             	pushl  0x8(%ebp)
  8011b3:	50                   	push   %eax
  8011b4:	68 cc 39 80 00       	push   $0x8039cc
  8011b9:	6a 74                	push   $0x74
  8011bb:	e8 b2 02 00 00       	call   801472 <cprintf_colored>
  8011c0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cc:	50                   	push   %eax
  8011cd:	e8 04 02 00 00       	call   8013d6 <vcprintf>
  8011d2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	6a 00                	push   $0x0
  8011da:	68 f4 39 80 00       	push   $0x8039f4
  8011df:	e8 f2 01 00 00       	call   8013d6 <vcprintf>
  8011e4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011e7:	e8 7d ff ff ff       	call   801169 <exit>

	// should not return here
	while (1) ;
  8011ec:	eb fe                	jmp    8011ec <_panic+0x75>

008011ee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	39 c2                	cmp    %eax,%edx
  801204:	74 14                	je     80121a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 f8 39 80 00       	push   $0x8039f8
  80120e:	6a 26                	push   $0x26
  801210:	68 44 3a 80 00       	push   $0x803a44
  801215:	e8 5d ff ff ff       	call   801177 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80121a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801221:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801228:	e9 c5 00 00 00       	jmp    8012f2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	8b 00                	mov    (%eax),%eax
  80123e:	85 c0                	test   %eax,%eax
  801240:	75 08                	jne    80124a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801242:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801245:	e9 a5 00 00 00       	jmp    8012ef <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80124a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801251:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801258:	eb 69                	jmp    8012c3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80125a:	a1 20 50 80 00       	mov    0x805020,%eax
  80125f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801268:	89 d0                	mov    %edx,%eax
  80126a:	01 c0                	add    %eax,%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	c1 e0 03             	shl    $0x3,%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 40 04             	mov    0x4(%eax),%al
  801276:	84 c0                	test   %al,%al
  801278:	75 46                	jne    8012c0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80127a:	a1 20 50 80 00       	mov    0x805020,%eax
  80127f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801285:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801288:	89 d0                	mov    %edx,%eax
  80128a:	01 c0                	add    %eax,%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	c1 e0 03             	shl    $0x3,%eax
  801291:	01 c8                	add    %ecx,%eax
  801293:	8b 00                	mov    (%eax),%eax
  801295:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801298:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012b3:	39 c2                	cmp    %eax,%edx
  8012b5:	75 09                	jne    8012c0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012be:	eb 15                	jmp    8012d5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012c0:	ff 45 e8             	incl   -0x18(%ebp)
  8012c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012d1:	39 c2                	cmp    %eax,%edx
  8012d3:	77 85                	ja     80125a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d9:	75 14                	jne    8012ef <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012db:	83 ec 04             	sub    $0x4,%esp
  8012de:	68 50 3a 80 00       	push   $0x803a50
  8012e3:	6a 3a                	push   $0x3a
  8012e5:	68 44 3a 80 00       	push   $0x803a44
  8012ea:	e8 88 fe ff ff       	call   801177 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012ef:	ff 45 f0             	incl   -0x10(%ebp)
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8012f8:	0f 8c 2f ff ff ff    	jl     80122d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8012fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801305:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80130c:	eb 26                	jmp    801334 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80130e:	a1 20 50 80 00       	mov    0x805020,%eax
  801313:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801319:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80131c:	89 d0                	mov    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	c1 e0 03             	shl    $0x3,%eax
  801325:	01 c8                	add    %ecx,%eax
  801327:	8a 40 04             	mov    0x4(%eax),%al
  80132a:	3c 01                	cmp    $0x1,%al
  80132c:	75 03                	jne    801331 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80132e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801331:	ff 45 e0             	incl   -0x20(%ebp)
  801334:	a1 20 50 80 00       	mov    0x805020,%eax
  801339:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80133f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801342:	39 c2                	cmp    %eax,%edx
  801344:	77 c8                	ja     80130e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80134c:	74 14                	je     801362 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	68 a4 3a 80 00       	push   $0x803aa4
  801356:	6a 44                	push   $0x44
  801358:	68 44 3a 80 00       	push   $0x803a44
  80135d:	e8 15 fe ff ff       	call   801177 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801362:	90                   	nop
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	53                   	push   %ebx
  801369:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 48 01             	lea    0x1(%eax),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	89 0a                	mov    %ecx,(%edx)
  801379:	8b 55 08             	mov    0x8(%ebp),%edx
  80137c:	88 d1                	mov    %dl,%cl
  80137e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801381:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80138f:	75 30                	jne    8013c1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801391:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  801397:	a0 44 50 80 00       	mov    0x805044,%al
  80139c:	0f b6 c0             	movzbl %al,%eax
  80139f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a2:	8b 09                	mov    (%ecx),%ecx
  8013a4:	89 cb                	mov    %ecx,%ebx
  8013a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a9:	83 c1 08             	add    $0x8,%ecx
  8013ac:	52                   	push   %edx
  8013ad:	50                   	push   %eax
  8013ae:	53                   	push   %ebx
  8013af:	51                   	push   %ecx
  8013b0:	e8 5f 13 00 00       	call   802714 <sys_cputs>
  8013b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	8b 40 04             	mov    0x4(%eax),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013d0:	90                   	nop
  8013d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013e6:	00 00 00 
	b.cnt = 0;
  8013e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013f0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	68 65 13 80 00       	push   $0x801365
  801405:	e8 5a 02 00 00       	call   801664 <vprintfmt>
  80140a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80140d:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  801413:	a0 44 50 80 00       	mov    0x805044,%al
  801418:	0f b6 c0             	movzbl %al,%eax
  80141b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801421:	52                   	push   %edx
  801422:	50                   	push   %eax
  801423:	51                   	push   %ecx
  801424:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80142a:	83 c0 08             	add    $0x8,%eax
  80142d:	50                   	push   %eax
  80142e:	e8 e1 12 00 00       	call   802714 <sys_cputs>
  801433:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801436:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80143d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80144b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  801452:	8d 45 0c             	lea    0xc(%ebp),%eax
  801455:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	e8 6f ff ff ff       	call   8013d6 <vcprintf>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801478:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	c1 e0 08             	shl    $0x8,%eax
  801485:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  80148a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80148d:	83 c0 04             	add    $0x4,%eax
  801490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	50                   	push   %eax
  80149d:	e8 34 ff ff ff       	call   8013d6 <vcprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8014a8:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8014af:	07 00 00 

	return cnt;
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8014bd:	e8 96 12 00 00       	call   802758 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8014c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d1:	50                   	push   %eax
  8014d2:	e8 ff fe ff ff       	call   8013d6 <vcprintf>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8014dd:	e8 90 12 00 00       	call   802772 <sys_unlock_cons>
	return cnt;
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 14             	sub    $0x14,%esp
  8014ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801505:	77 55                	ja     80155c <printnum+0x75>
  801507:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80150a:	72 05                	jb     801511 <printnum+0x2a>
  80150c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80150f:	77 4b                	ja     80155c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801511:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801517:	8b 45 18             	mov    0x18(%ebp),%eax
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	ff 75 f4             	pushl  -0xc(%ebp)
  801524:	ff 75 f0             	pushl  -0x10(%ebp)
  801527:	e8 e0 19 00 00       	call   802f0c <__udivdi3>
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	ff 75 20             	pushl  0x20(%ebp)
  801535:	53                   	push   %ebx
  801536:	ff 75 18             	pushl  0x18(%ebp)
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	e8 a1 ff ff ff       	call   8014e7 <printnum>
  801546:	83 c4 20             	add    $0x20,%esp
  801549:	eb 1a                	jmp    801565 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	ff 75 20             	pushl  0x20(%ebp)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80155c:	ff 4d 1c             	decl   0x1c(%ebp)
  80155f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801563:	7f e6                	jg     80154b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801565:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801573:	53                   	push   %ebx
  801574:	51                   	push   %ecx
  801575:	52                   	push   %edx
  801576:	50                   	push   %eax
  801577:	e8 a0 1a 00 00       	call   80301c <__umoddi3>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	05 14 3d 80 00       	add    $0x803d14,%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	0f be c0             	movsbl %al,%eax
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	50                   	push   %eax
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
}
  801598:	90                   	nop
  801599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015a5:	7e 1c                	jle    8015c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	8d 50 08             	lea    0x8(%eax),%edx
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 10                	mov    %edx,(%eax)
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	83 e8 08             	sub    $0x8,%eax
  8015bc:	8b 50 04             	mov    0x4(%eax),%edx
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	eb 40                	jmp    801603 <getuint+0x65>
	else if (lflag)
  8015c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c7:	74 1e                	je     8015e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	8d 50 04             	lea    0x4(%eax),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 10                	mov    %edx,(%eax)
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	83 e8 04             	sub    $0x4,%eax
  8015de:	8b 00                	mov    (%eax),%eax
  8015e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e5:	eb 1c                	jmp    801603 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	8d 50 04             	lea    0x4(%eax),%edx
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	89 10                	mov    %edx,(%eax)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8b 00                	mov    (%eax),%eax
  8015f9:	83 e8 04             	sub    $0x4,%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801608:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80160c:	7e 1c                	jle    80162a <getint+0x25>
		return va_arg(*ap, long long);
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8b 00                	mov    (%eax),%eax
  801613:	8d 50 08             	lea    0x8(%eax),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	89 10                	mov    %edx,(%eax)
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	83 e8 08             	sub    $0x8,%eax
  801623:	8b 50 04             	mov    0x4(%eax),%edx
  801626:	8b 00                	mov    (%eax),%eax
  801628:	eb 38                	jmp    801662 <getint+0x5d>
	else if (lflag)
  80162a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162e:	74 1a                	je     80164a <getint+0x45>
		return va_arg(*ap, long);
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8d 50 04             	lea    0x4(%eax),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 10                	mov    %edx,(%eax)
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	83 e8 04             	sub    $0x4,%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	99                   	cltd   
  801648:	eb 18                	jmp    801662 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8b 00                	mov    (%eax),%eax
  80164f:	8d 50 04             	lea    0x4(%eax),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	89 10                	mov    %edx,(%eax)
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	83 e8 04             	sub    $0x4,%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	99                   	cltd   
}
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    

00801664 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	56                   	push   %esi
  801668:	53                   	push   %ebx
  801669:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80166c:	eb 17                	jmp    801685 <vprintfmt+0x21>
			if (ch == '\0')
  80166e:	85 db                	test   %ebx,%ebx
  801670:	0f 84 c1 03 00 00    	je     801a37 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	53                   	push   %ebx
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	ff d0                	call   *%eax
  801682:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 01             	lea    0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	8a 00                	mov    (%eax),%al
  801690:	0f b6 d8             	movzbl %al,%ebx
  801693:	83 fb 25             	cmp    $0x25,%ebx
  801696:	75 d6                	jne    80166e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801698:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80169c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	8d 50 01             	lea    0x1(%eax),%edx
  8016be:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	0f b6 d8             	movzbl %al,%ebx
  8016c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8016c9:	83 f8 5b             	cmp    $0x5b,%eax
  8016cc:	0f 87 3d 03 00 00    	ja     801a0f <vprintfmt+0x3ab>
  8016d2:	8b 04 85 38 3d 80 00 	mov    0x803d38(,%eax,4),%eax
  8016d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016df:	eb d7                	jmp    8016b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8016e5:	eb d1                	jmp    8016b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016f1:	89 d0                	mov    %edx,%eax
  8016f3:	c1 e0 02             	shl    $0x2,%eax
  8016f6:	01 d0                	add    %edx,%eax
  8016f8:	01 c0                	add    %eax,%eax
  8016fa:	01 d8                	add    %ebx,%eax
  8016fc:	83 e8 30             	sub    $0x30,%eax
  8016ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801702:	8b 45 10             	mov    0x10(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80170a:	83 fb 2f             	cmp    $0x2f,%ebx
  80170d:	7e 3e                	jle    80174d <vprintfmt+0xe9>
  80170f:	83 fb 39             	cmp    $0x39,%ebx
  801712:	7f 39                	jg     80174d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801714:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801717:	eb d5                	jmp    8016ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801719:	8b 45 14             	mov    0x14(%ebp),%eax
  80171c:	83 c0 04             	add    $0x4,%eax
  80171f:	89 45 14             	mov    %eax,0x14(%ebp)
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	83 e8 04             	sub    $0x4,%eax
  801728:	8b 00                	mov    (%eax),%eax
  80172a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80172d:	eb 1f                	jmp    80174e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80172f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801733:	79 83                	jns    8016b8 <vprintfmt+0x54>
				width = 0;
  801735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80173c:	e9 77 ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801748:	e9 6b ff ff ff       	jmp    8016b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80174d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80174e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801752:	0f 89 60 ff ff ff    	jns    8016b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80175e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801765:	e9 4e ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80176a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80176d:	e9 46 ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801772:	8b 45 14             	mov    0x14(%ebp),%eax
  801775:	83 c0 04             	add    $0x4,%eax
  801778:	89 45 14             	mov    %eax,0x14(%ebp)
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	83 e8 04             	sub    $0x4,%eax
  801781:	8b 00                	mov    (%eax),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	50                   	push   %eax
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	ff d0                	call   *%eax
  80178f:	83 c4 10             	add    $0x10,%esp
			break;
  801792:	e9 9b 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	83 c0 04             	add    $0x4,%eax
  80179d:	89 45 14             	mov    %eax,0x14(%ebp)
  8017a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a3:	83 e8 04             	sub    $0x4,%eax
  8017a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8017a8:	85 db                	test   %ebx,%ebx
  8017aa:	79 02                	jns    8017ae <vprintfmt+0x14a>
				err = -err;
  8017ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8017ae:	83 fb 64             	cmp    $0x64,%ebx
  8017b1:	7f 0b                	jg     8017be <vprintfmt+0x15a>
  8017b3:	8b 34 9d 80 3b 80 00 	mov    0x803b80(,%ebx,4),%esi
  8017ba:	85 f6                	test   %esi,%esi
  8017bc:	75 19                	jne    8017d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8017be:	53                   	push   %ebx
  8017bf:	68 25 3d 80 00       	push   $0x803d25
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 70 02 00 00       	call   801a3f <printfmt>
  8017cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017d2:	e9 5b 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017d7:	56                   	push   %esi
  8017d8:	68 2e 3d 80 00       	push   $0x803d2e
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	e8 57 02 00 00       	call   801a3f <printfmt>
  8017e8:	83 c4 10             	add    $0x10,%esp
			break;
  8017eb:	e9 42 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	83 c0 04             	add    $0x4,%eax
  8017f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	83 e8 04             	sub    $0x4,%eax
  8017ff:	8b 30                	mov    (%eax),%esi
  801801:	85 f6                	test   %esi,%esi
  801803:	75 05                	jne    80180a <vprintfmt+0x1a6>
				p = "(null)";
  801805:	be 31 3d 80 00       	mov    $0x803d31,%esi
			if (width > 0 && padc != '-')
  80180a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180e:	7e 6d                	jle    80187d <vprintfmt+0x219>
  801810:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801814:	74 67                	je     80187d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	50                   	push   %eax
  80181d:	56                   	push   %esi
  80181e:	e8 26 05 00 00       	call   801d49 <strnlen>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801829:	eb 16                	jmp    801841 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80182b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	ff d0                	call   *%eax
  80183b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80183e:	ff 4d e4             	decl   -0x1c(%ebp)
  801841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801845:	7f e4                	jg     80182b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801847:	eb 34                	jmp    80187d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801849:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80184d:	74 1c                	je     80186b <vprintfmt+0x207>
  80184f:	83 fb 1f             	cmp    $0x1f,%ebx
  801852:	7e 05                	jle    801859 <vprintfmt+0x1f5>
  801854:	83 fb 7e             	cmp    $0x7e,%ebx
  801857:	7e 12                	jle    80186b <vprintfmt+0x207>
					putch('?', putdat);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	6a 3f                	push   $0x3f
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	ff d0                	call   *%eax
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	eb 0f                	jmp    80187a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	53                   	push   %ebx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	ff d0                	call   *%eax
  801877:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80187a:	ff 4d e4             	decl   -0x1c(%ebp)
  80187d:	89 f0                	mov    %esi,%eax
  80187f:	8d 70 01             	lea    0x1(%eax),%esi
  801882:	8a 00                	mov    (%eax),%al
  801884:	0f be d8             	movsbl %al,%ebx
  801887:	85 db                	test   %ebx,%ebx
  801889:	74 24                	je     8018af <vprintfmt+0x24b>
  80188b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80188f:	78 b8                	js     801849 <vprintfmt+0x1e5>
  801891:	ff 4d e0             	decl   -0x20(%ebp)
  801894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801898:	79 af                	jns    801849 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80189a:	eb 13                	jmp    8018af <vprintfmt+0x24b>
				putch(' ', putdat);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	6a 20                	push   $0x20
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	ff d0                	call   *%eax
  8018a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8018af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b3:	7f e7                	jg     80189c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8018b5:	e9 78 01 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8018c3:	50                   	push   %eax
  8018c4:	e8 3c fd ff ff       	call   801605 <getint>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d8:	85 d2                	test   %edx,%edx
  8018da:	79 23                	jns    8018ff <vprintfmt+0x29b>
				putch('-', putdat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	6a 2d                	push   $0x2d
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	ff d0                	call   *%eax
  8018e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8018ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f2:	f7 d8                	neg    %eax
  8018f4:	83 d2 00             	adc    $0x0,%edx
  8018f7:	f7 da                	neg    %edx
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801906:	e9 bc 00 00 00       	jmp    8019c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	ff 75 e8             	pushl  -0x18(%ebp)
  801911:	8d 45 14             	lea    0x14(%ebp),%eax
  801914:	50                   	push   %eax
  801915:	e8 84 fc ff ff       	call   80159e <getuint>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801920:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801923:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80192a:	e9 98 00 00 00       	jmp    8019c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	6a 58                	push   $0x58
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	ff d0                	call   *%eax
  80193c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	6a 58                	push   $0x58
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	ff d0                	call   *%eax
  80194c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	6a 58                	push   $0x58
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	ff d0                	call   *%eax
  80195c:	83 c4 10             	add    $0x10,%esp
			break;
  80195f:	e9 ce 00 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	6a 30                	push   $0x30
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	ff d0                	call   *%eax
  801971:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	6a 78                	push   $0x78
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	ff d0                	call   *%eax
  801981:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801984:	8b 45 14             	mov    0x14(%ebp),%eax
  801987:	83 c0 04             	add    $0x4,%eax
  80198a:	89 45 14             	mov    %eax,0x14(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	83 e8 04             	sub    $0x4,%eax
  801993:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80199f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8019a6:	eb 1f                	jmp    8019c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8019b1:	50                   	push   %eax
  8019b2:	e8 e7 fb ff ff       	call   80159e <getuint>
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8019c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8019cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	52                   	push   %edx
  8019d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	e8 00 fb ff ff       	call   8014e7 <printnum>
  8019e7:	83 c4 20             	add    $0x20,%esp
			break;
  8019ea:	eb 46                	jmp    801a32 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	53                   	push   %ebx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	ff d0                	call   *%eax
  8019f8:	83 c4 10             	add    $0x10,%esp
			break;
  8019fb:	eb 35                	jmp    801a32 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8019fd:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801a04:	eb 2c                	jmp    801a32 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a06:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801a0d:	eb 23                	jmp    801a32 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	6a 25                	push   $0x25
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	ff d0                	call   *%eax
  801a1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a1f:	ff 4d 10             	decl   0x10(%ebp)
  801a22:	eb 03                	jmp    801a27 <vprintfmt+0x3c3>
  801a24:	ff 4d 10             	decl   0x10(%ebp)
  801a27:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2a:	48                   	dec    %eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	3c 25                	cmp    $0x25,%al
  801a2f:	75 f3                	jne    801a24 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801a31:	90                   	nop
		}
	}
  801a32:	e9 35 fc ff ff       	jmp    80166c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801a37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a45:	8d 45 10             	lea    0x10(%ebp),%eax
  801a48:	83 c0 04             	add    $0x4,%eax
  801a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	ff 75 f4             	pushl  -0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	e8 04 fc ff ff       	call   801664 <vprintfmt>
  801a60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6c:	8b 40 08             	mov    0x8(%eax),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7b:	8b 10                	mov    (%eax),%edx
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	8b 40 04             	mov    0x4(%eax),%eax
  801a83:	39 c2                	cmp    %eax,%edx
  801a85:	73 12                	jae    801a99 <sprintputch+0x33>
		*b->buf++ = ch;
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	8b 00                	mov    (%eax),%eax
  801a8c:	8d 48 01             	lea    0x1(%eax),%ecx
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	89 0a                	mov    %ecx,(%edx)
  801a94:	8b 55 08             	mov    0x8(%ebp),%edx
  801a97:	88 10                	mov    %dl,(%eax)
}
  801a99:	90                   	nop
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ac1:	74 06                	je     801ac9 <vsnprintf+0x2d>
  801ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac7:	7f 07                	jg     801ad0 <vsnprintf+0x34>
		return -E_INVAL;
  801ac9:	b8 03 00 00 00       	mov    $0x3,%eax
  801ace:	eb 20                	jmp    801af0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ad0:	ff 75 14             	pushl  0x14(%ebp)
  801ad3:	ff 75 10             	pushl  0x10(%ebp)
  801ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ad9:	50                   	push   %eax
  801ada:	68 66 1a 80 00       	push   $0x801a66
  801adf:	e8 80 fb ff ff       	call   801664 <vprintfmt>
  801ae4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801af8:	8d 45 10             	lea    0x10(%ebp),%eax
  801afb:	83 c0 04             	add    $0x4,%eax
  801afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b01:	8b 45 10             	mov    0x10(%ebp),%eax
  801b04:	ff 75 f4             	pushl  -0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	e8 89 ff ff ff       	call   801a9c <vsnprintf>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b28:	74 13                	je     801b3d <readline+0x1f>
		cprintf("%s", prompt);
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	68 a8 3e 80 00       	push   $0x803ea8
  801b35:	e8 0b f9 ff ff       	call   801445 <cprintf>
  801b3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	6a 00                	push   $0x0
  801b49:	e8 6f f4 ff ff       	call   800fbd <iscons>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801b54:	e8 51 f4 ff ff       	call   800faa <getchar>
  801b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b60:	79 22                	jns    801b84 <readline+0x66>
			if (c != -E_EOF)
  801b62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801b66:	0f 84 ad 00 00 00    	je     801c19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	ff 75 ec             	pushl  -0x14(%ebp)
  801b72:	68 ab 3e 80 00       	push   $0x803eab
  801b77:	e8 c9 f8 ff ff       	call   801445 <cprintf>
  801b7c:	83 c4 10             	add    $0x10,%esp
			break;
  801b7f:	e9 95 00 00 00       	jmp    801c19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801b84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801b88:	7e 34                	jle    801bbe <readline+0xa0>
  801b8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801b91:	7f 2b                	jg     801bbe <readline+0xa0>
			if (echoing)
  801b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b97:	74 0e                	je     801ba7 <readline+0x89>
				cputchar(c);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  801b9f:	e8 e7 f3 ff ff       	call   800f8b <cputchar>
  801ba4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	8d 50 01             	lea    0x1(%eax),%edx
  801bad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	01 d0                	add    %edx,%eax
  801bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bba:	88 10                	mov    %dl,(%eax)
  801bbc:	eb 56                	jmp    801c14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801bbe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801bc2:	75 1f                	jne    801be3 <readline+0xc5>
  801bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc8:	7e 19                	jle    801be3 <readline+0xc5>
			if (echoing)
  801bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bce:	74 0e                	je     801bde <readline+0xc0>
				cputchar(c);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bd6:	e8 b0 f3 ff ff       	call   800f8b <cputchar>
  801bdb:	83 c4 10             	add    $0x10,%esp

			i--;
  801bde:	ff 4d f4             	decl   -0xc(%ebp)
  801be1:	eb 31                	jmp    801c14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801be3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801be7:	74 0a                	je     801bf3 <readline+0xd5>
  801be9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801bed:	0f 85 61 ff ff ff    	jne    801b54 <readline+0x36>
			if (echoing)
  801bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf7:	74 0e                	je     801c07 <readline+0xe9>
				cputchar(c);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  801bff:	e8 87 f3 ff ff       	call   800f8b <cputchar>
  801c04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0d:	01 d0                	add    %edx,%eax
  801c0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801c12:	eb 06                	jmp    801c1a <readline+0xfc>
		}
	}
  801c14:	e9 3b ff ff ff       	jmp    801b54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801c19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801c23:	e8 30 0b 00 00       	call   802758 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2c:	74 13                	je     801c41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	68 a8 3e 80 00       	push   $0x803ea8
  801c39:	e8 07 f8 ff ff       	call   801445 <cprintf>
  801c3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 6b f3 ff ff       	call   800fbd <iscons>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801c58:	e8 4d f3 ff ff       	call   800faa <getchar>
  801c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c64:	79 22                	jns    801c88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801c66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801c6a:	0f 84 ad 00 00 00    	je     801d1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	ff 75 ec             	pushl  -0x14(%ebp)
  801c76:	68 ab 3e 80 00       	push   $0x803eab
  801c7b:	e8 c5 f7 ff ff       	call   801445 <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp
				break;
  801c83:	e9 95 00 00 00       	jmp    801d1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801c88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801c8c:	7e 34                	jle    801cc2 <atomic_readline+0xa5>
  801c8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801c95:	7f 2b                	jg     801cc2 <atomic_readline+0xa5>
				if (echoing)
  801c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c9b:	74 0e                	je     801cab <atomic_readline+0x8e>
					cputchar(c);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	ff 75 ec             	pushl  -0x14(%ebp)
  801ca3:	e8 e3 f2 ff ff       	call   800f8b <cputchar>
  801ca8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	8d 50 01             	lea    0x1(%eax),%edx
  801cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb9:	01 d0                	add    %edx,%eax
  801cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cbe:	88 10                	mov    %dl,(%eax)
  801cc0:	eb 56                	jmp    801d18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801cc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801cc6:	75 1f                	jne    801ce7 <atomic_readline+0xca>
  801cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ccc:	7e 19                	jle    801ce7 <atomic_readline+0xca>
				if (echoing)
  801cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd2:	74 0e                	je     801ce2 <atomic_readline+0xc5>
					cputchar(c);
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cda:	e8 ac f2 ff ff       	call   800f8b <cputchar>
  801cdf:	83 c4 10             	add    $0x10,%esp
				i--;
  801ce2:	ff 4d f4             	decl   -0xc(%ebp)
  801ce5:	eb 31                	jmp    801d18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801ce7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801ceb:	74 0a                	je     801cf7 <atomic_readline+0xda>
  801ced:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801cf1:	0f 85 61 ff ff ff    	jne    801c58 <atomic_readline+0x3b>
				if (echoing)
  801cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cfb:	74 0e                	je     801d0b <atomic_readline+0xee>
					cputchar(c);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 ec             	pushl  -0x14(%ebp)
  801d03:	e8 83 f2 ff ff       	call   800f8b <cputchar>
  801d08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801d16:	eb 06                	jmp    801d1e <atomic_readline+0x101>
			}
		}
  801d18:	e9 3b ff ff ff       	jmp    801c58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801d1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801d1e:	e8 4f 0a 00 00       	call   802772 <sys_unlock_cons>
}
  801d23:	90                   	nop
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d33:	eb 06                	jmp    801d3b <strlen+0x15>
		n++;
  801d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d38:	ff 45 08             	incl   0x8(%ebp)
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8a 00                	mov    (%eax),%al
  801d40:	84 c0                	test   %al,%al
  801d42:	75 f1                	jne    801d35 <strlen+0xf>
		n++;
	return n;
  801d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d56:	eb 09                	jmp    801d61 <strnlen+0x18>
		n++;
  801d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d5b:	ff 45 08             	incl   0x8(%ebp)
  801d5e:	ff 4d 0c             	decl   0xc(%ebp)
  801d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d65:	74 09                	je     801d70 <strnlen+0x27>
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8a 00                	mov    (%eax),%al
  801d6c:	84 c0                	test   %al,%al
  801d6e:	75 e8                	jne    801d58 <strnlen+0xf>
		n++;
	return n;
  801d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d81:	90                   	nop
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d94:	8a 12                	mov    (%edx),%dl
  801d96:	88 10                	mov    %dl,(%eax)
  801d98:	8a 00                	mov    (%eax),%al
  801d9a:	84 c0                	test   %al,%al
  801d9c:	75 e4                	jne    801d82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801daf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801db6:	eb 1f                	jmp    801dd7 <strncpy+0x34>
		*dst++ = *src;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	8d 50 01             	lea    0x1(%eax),%edx
  801dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8a 12                	mov    (%edx),%dl
  801dc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	8a 00                	mov    (%eax),%al
  801dcd:	84 c0                	test   %al,%al
  801dcf:	74 03                	je     801dd4 <strncpy+0x31>
			src++;
  801dd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801dd4:	ff 45 fc             	incl   -0x4(%ebp)
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dda:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ddd:	72 d9                	jb     801db8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df4:	74 30                	je     801e26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801df6:	eb 16                	jmp    801e0e <strlcpy+0x2a>
			*dst++ = *src++;
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	8d 50 01             	lea    0x1(%eax),%edx
  801dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e0a:	8a 12                	mov    (%edx),%dl
  801e0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e0e:	ff 4d 10             	decl   0x10(%ebp)
  801e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e15:	74 09                	je     801e20 <strlcpy+0x3c>
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	8a 00                	mov    (%eax),%al
  801e1c:	84 c0                	test   %al,%al
  801e1e:	75 d8                	jne    801df8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e26:	8b 55 08             	mov    0x8(%ebp),%edx
  801e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2c:	29 c2                	sub    %eax,%edx
  801e2e:	89 d0                	mov    %edx,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e35:	eb 06                	jmp    801e3d <strcmp+0xb>
		p++, q++;
  801e37:	ff 45 08             	incl   0x8(%ebp)
  801e3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	8a 00                	mov    (%eax),%al
  801e42:	84 c0                	test   %al,%al
  801e44:	74 0e                	je     801e54 <strcmp+0x22>
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	8a 10                	mov    (%eax),%dl
  801e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4e:	8a 00                	mov    (%eax),%al
  801e50:	38 c2                	cmp    %al,%dl
  801e52:	74 e3                	je     801e37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	8a 00                	mov    (%eax),%al
  801e59:	0f b6 d0             	movzbl %al,%edx
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5f:	8a 00                	mov    (%eax),%al
  801e61:	0f b6 c0             	movzbl %al,%eax
  801e64:	29 c2                	sub    %eax,%edx
  801e66:	89 d0                	mov    %edx,%eax
}
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e6d:	eb 09                	jmp    801e78 <strncmp+0xe>
		n--, p++, q++;
  801e6f:	ff 4d 10             	decl   0x10(%ebp)
  801e72:	ff 45 08             	incl   0x8(%ebp)
  801e75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7c:	74 17                	je     801e95 <strncmp+0x2b>
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 0e                	je     801e95 <strncmp+0x2b>
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	8a 10                	mov    (%eax),%dl
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	38 c2                	cmp    %al,%dl
  801e93:	74 da                	je     801e6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e99:	75 07                	jne    801ea2 <strncmp+0x38>
		return 0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb 14                	jmp    801eb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	8a 00                	mov    (%eax),%al
  801ea7:	0f b6 d0             	movzbl %al,%edx
  801eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ead:	8a 00                	mov    (%eax),%al
  801eaf:	0f b6 c0             	movzbl %al,%eax
  801eb2:	29 c2                	sub    %eax,%edx
  801eb4:	89 d0                	mov    %edx,%eax
}
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ec4:	eb 12                	jmp    801ed8 <strchr+0x20>
		if (*s == c)
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	8a 00                	mov    (%eax),%al
  801ecb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ece:	75 05                	jne    801ed5 <strchr+0x1d>
			return (char *) s;
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	eb 11                	jmp    801ee6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ed5:	ff 45 08             	incl   0x8(%ebp)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	84 c0                	test   %al,%al
  801edf:	75 e5                	jne    801ec6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ef4:	eb 0d                	jmp    801f03 <strfind+0x1b>
		if (*s == c)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8a 00                	mov    (%eax),%al
  801efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801efe:	74 0e                	je     801f0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f00:	ff 45 08             	incl   0x8(%ebp)
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	75 ea                	jne    801ef6 <strfind+0xe>
  801f0c:	eb 01                	jmp    801f0f <strfind+0x27>
		if (*s == c)
			break;
  801f0e:	90                   	nop
	return (char *) s;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801f20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f24:	76 63                	jbe    801f89 <memset+0x75>
		uint64 data_block = c;
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	99                   	cltd   
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f36:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801f3a:	c1 e0 08             	shl    $0x8,%eax
  801f3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f49:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801f4d:	c1 e0 10             	shl    $0x10,%eax
  801f50:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f53:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	89 c2                	mov    %eax,%edx
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f66:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801f69:	eb 18                	jmp    801f83 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f6e:	8d 41 08             	lea    0x8(%ecx),%eax
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7a:	89 01                	mov    %eax,(%ecx)
  801f7c:	89 51 04             	mov    %edx,0x4(%ecx)
  801f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801f83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f87:	77 e2                	ja     801f6b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8d:	74 23                	je     801fb2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f95:	eb 0e                	jmp    801fa5 <memset+0x91>
			*p8++ = (uint8)c;
  801f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fab:	89 55 10             	mov    %edx,0x10(%ebp)
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	75 e5                	jne    801f97 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801fc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fcd:	76 24                	jbe    801ff3 <memcpy+0x3c>
		while(n >= 8){
  801fcf:	eb 1c                	jmp    801fed <memcpy+0x36>
			*d64 = *s64;
  801fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd4:	8b 50 04             	mov    0x4(%eax),%edx
  801fd7:	8b 00                	mov    (%eax),%eax
  801fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801fdc:	89 01                	mov    %eax,(%ecx)
  801fde:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801fe1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801fe5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801fe9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ff1:	77 de                	ja     801fd1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801ff3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff7:	74 31                	je     80202a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802002:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802005:	eb 16                	jmp    80201d <memcpy+0x66>
			*d8++ = *s8++;
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	8d 50 01             	lea    0x1(%eax),%edx
  80200d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802013:	8d 4a 01             	lea    0x1(%edx),%ecx
  802016:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802019:	8a 12                	mov    (%edx),%dl
  80201b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80201d:	8b 45 10             	mov    0x10(%ebp),%eax
  802020:	8d 50 ff             	lea    -0x1(%eax),%edx
  802023:	89 55 10             	mov    %edx,0x10(%ebp)
  802026:	85 c0                	test   %eax,%eax
  802028:	75 dd                	jne    802007 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802035:	8b 45 0c             	mov    0xc(%ebp),%eax
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802047:	73 50                	jae    802099 <memmove+0x6a>
  802049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80204c:	8b 45 10             	mov    0x10(%ebp),%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802054:	76 43                	jbe    802099 <memmove+0x6a>
		s += n;
  802056:	8b 45 10             	mov    0x10(%ebp),%eax
  802059:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80205c:	8b 45 10             	mov    0x10(%ebp),%eax
  80205f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802062:	eb 10                	jmp    802074 <memmove+0x45>
			*--d = *--s;
  802064:	ff 4d f8             	decl   -0x8(%ebp)
  802067:	ff 4d fc             	decl   -0x4(%ebp)
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	8a 10                	mov    (%eax),%dl
  80206f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802072:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802074:	8b 45 10             	mov    0x10(%ebp),%eax
  802077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80207a:	89 55 10             	mov    %edx,0x10(%ebp)
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 e3                	jne    802064 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802081:	eb 23                	jmp    8020a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802086:	8d 50 01             	lea    0x1(%eax),%edx
  802089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80208c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80208f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802092:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802095:	8a 12                	mov    (%edx),%dl
  802097:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802099:	8b 45 10             	mov    0x10(%ebp),%eax
  80209c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80209f:	89 55 10             	mov    %edx,0x10(%ebp)
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 dd                	jne    802083 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8020bd:	eb 2a                	jmp    8020e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8020bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c2:	8a 10                	mov    (%eax),%dl
  8020c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c7:	8a 00                	mov    (%eax),%al
  8020c9:	38 c2                	cmp    %al,%dl
  8020cb:	74 16                	je     8020e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8020cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	0f b6 d0             	movzbl %al,%edx
  8020d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d8:	8a 00                	mov    (%eax),%al
  8020da:	0f b6 c0             	movzbl %al,%eax
  8020dd:	29 c2                	sub    %eax,%edx
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	eb 18                	jmp    8020fb <memcmp+0x50>
		s1++, s2++;
  8020e3:	ff 45 fc             	incl   -0x4(%ebp)
  8020e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 c9                	jne    8020bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802103:	8b 55 08             	mov    0x8(%ebp),%edx
  802106:	8b 45 10             	mov    0x10(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80210e:	eb 15                	jmp    802125 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8a 00                	mov    (%eax),%al
  802115:	0f b6 d0             	movzbl %al,%edx
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	0f b6 c0             	movzbl %al,%eax
  80211e:	39 c2                	cmp    %eax,%edx
  802120:	74 0d                	je     80212f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802122:	ff 45 08             	incl   0x8(%ebp)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80212b:	72 e3                	jb     802110 <memfind+0x13>
  80212d:	eb 01                	jmp    802130 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80212f:	90                   	nop
	return (void *) s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80213b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802149:	eb 03                	jmp    80214e <strtol+0x19>
		s++;
  80214b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	3c 20                	cmp    $0x20,%al
  802155:	74 f4                	je     80214b <strtol+0x16>
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8a 00                	mov    (%eax),%al
  80215c:	3c 09                	cmp    $0x9,%al
  80215e:	74 eb                	je     80214b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8a 00                	mov    (%eax),%al
  802165:	3c 2b                	cmp    $0x2b,%al
  802167:	75 05                	jne    80216e <strtol+0x39>
		s++;
  802169:	ff 45 08             	incl   0x8(%ebp)
  80216c:	eb 13                	jmp    802181 <strtol+0x4c>
	else if (*s == '-')
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	8a 00                	mov    (%eax),%al
  802173:	3c 2d                	cmp    $0x2d,%al
  802175:	75 0a                	jne    802181 <strtol+0x4c>
		s++, neg = 1;
  802177:	ff 45 08             	incl   0x8(%ebp)
  80217a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802185:	74 06                	je     80218d <strtol+0x58>
  802187:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80218b:	75 20                	jne    8021ad <strtol+0x78>
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8a 00                	mov    (%eax),%al
  802192:	3c 30                	cmp    $0x30,%al
  802194:	75 17                	jne    8021ad <strtol+0x78>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	40                   	inc    %eax
  80219a:	8a 00                	mov    (%eax),%al
  80219c:	3c 78                	cmp    $0x78,%al
  80219e:	75 0d                	jne    8021ad <strtol+0x78>
		s += 2, base = 16;
  8021a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8021a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021ab:	eb 28                	jmp    8021d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8021ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b1:	75 15                	jne    8021c8 <strtol+0x93>
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8a 00                	mov    (%eax),%al
  8021b8:	3c 30                	cmp    $0x30,%al
  8021ba:	75 0c                	jne    8021c8 <strtol+0x93>
		s++, base = 8;
  8021bc:	ff 45 08             	incl   0x8(%ebp)
  8021bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021c6:	eb 0d                	jmp    8021d5 <strtol+0xa0>
	else if (base == 0)
  8021c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021cc:	75 07                	jne    8021d5 <strtol+0xa0>
		base = 10;
  8021ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8a 00                	mov    (%eax),%al
  8021da:	3c 2f                	cmp    $0x2f,%al
  8021dc:	7e 19                	jle    8021f7 <strtol+0xc2>
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8a 00                	mov    (%eax),%al
  8021e3:	3c 39                	cmp    $0x39,%al
  8021e5:	7f 10                	jg     8021f7 <strtol+0xc2>
			dig = *s - '0';
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8a 00                	mov    (%eax),%al
  8021ec:	0f be c0             	movsbl %al,%eax
  8021ef:	83 e8 30             	sub    $0x30,%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f5:	eb 42                	jmp    802239 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	8a 00                	mov    (%eax),%al
  8021fc:	3c 60                	cmp    $0x60,%al
  8021fe:	7e 19                	jle    802219 <strtol+0xe4>
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	3c 7a                	cmp    $0x7a,%al
  802207:	7f 10                	jg     802219 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8a 00                	mov    (%eax),%al
  80220e:	0f be c0             	movsbl %al,%eax
  802211:	83 e8 57             	sub    $0x57,%eax
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802217:	eb 20                	jmp    802239 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8a 00                	mov    (%eax),%al
  80221e:	3c 40                	cmp    $0x40,%al
  802220:	7e 39                	jle    80225b <strtol+0x126>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8a 00                	mov    (%eax),%al
  802227:	3c 5a                	cmp    $0x5a,%al
  802229:	7f 30                	jg     80225b <strtol+0x126>
			dig = *s - 'A' + 10;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8a 00                	mov    (%eax),%al
  802230:	0f be c0             	movsbl %al,%eax
  802233:	83 e8 37             	sub    $0x37,%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80223f:	7d 19                	jge    80225a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802241:	ff 45 08             	incl   0x8(%ebp)
  802244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802247:	0f af 45 10          	imul   0x10(%ebp),%eax
  80224b:	89 c2                	mov    %eax,%edx
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	01 d0                	add    %edx,%eax
  802252:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802255:	e9 7b ff ff ff       	jmp    8021d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80225a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80225b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80225f:	74 08                	je     802269 <strtol+0x134>
		*endptr = (char *) s;
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	8b 55 08             	mov    0x8(%ebp),%edx
  802267:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80226d:	74 07                	je     802276 <strtol+0x141>
  80226f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802272:	f7 d8                	neg    %eax
  802274:	eb 03                	jmp    802279 <strtol+0x144>
  802276:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <ltostr>:

void
ltostr(long value, char *str)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80228f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802293:	79 13                	jns    8022a8 <ltostr+0x2d>
	{
		neg = 1;
  802295:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8022a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8022a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022b0:	99                   	cltd   
  8022b1:	f7 f9                	idiv   %ecx
  8022b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8022b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b9:	8d 50 01             	lea    0x1(%eax),%edx
  8022bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022bf:	89 c2                	mov    %eax,%edx
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	01 d0                	add    %edx,%eax
  8022c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022c9:	83 c2 30             	add    $0x30,%edx
  8022cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8022d6:	f7 e9                	imul   %ecx
  8022d8:	c1 fa 02             	sar    $0x2,%edx
  8022db:	89 c8                	mov    %ecx,%eax
  8022dd:	c1 f8 1f             	sar    $0x1f,%eax
  8022e0:	29 c2                	sub    %eax,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8022e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022eb:	75 bb                	jne    8022a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8022ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8022f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f7:	48                   	dec    %eax
  8022f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ff:	74 3d                	je     80233e <ltostr+0xc3>
		start = 1 ;
  802301:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802308:	eb 34                	jmp    80233e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80230a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	01 d0                	add    %edx,%eax
  802312:	8a 00                	mov    (%eax),%al
  802314:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	01 c2                	add    %eax,%edx
  80231f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	01 c8                	add    %ecx,%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80232b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	01 c2                	add    %eax,%edx
  802333:	8a 45 eb             	mov    -0x15(%ebp),%al
  802336:	88 02                	mov    %al,(%edx)
		start++ ;
  802338:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80233b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802344:	7c c4                	jl     80230a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802346:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234c:	01 d0                	add    %edx,%eax
  80234e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	e8 c4 f9 ff ff       	call   801d26 <strlen>
  802362:	83 c4 04             	add    $0x4,%esp
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	e8 b6 f9 ff ff       	call   801d26 <strlen>
  802370:	83 c4 04             	add    $0x4,%esp
  802373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80237d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802384:	eb 17                	jmp    80239d <strcconcat+0x49>
		final[s] = str1[s] ;
  802386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802389:	8b 45 10             	mov    0x10(%ebp),%eax
  80238c:	01 c2                	add    %eax,%edx
  80238e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	01 c8                	add    %ecx,%eax
  802396:	8a 00                	mov    (%eax),%al
  802398:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80239a:	ff 45 fc             	incl   -0x4(%ebp)
  80239d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023a3:	7c e1                	jl     802386 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8023a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8023ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8023b3:	eb 1f                	jmp    8023d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8023b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b8:	8d 50 01             	lea    0x1(%eax),%edx
  8023bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8023be:	89 c2                	mov    %eax,%edx
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	01 c2                	add    %eax,%edx
  8023c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	01 c8                	add    %ecx,%eax
  8023cd:	8a 00                	mov    (%eax),%al
  8023cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8023d1:	ff 45 f8             	incl   -0x8(%ebp)
  8023d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023da:	7c d9                	jl     8023b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8023dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023df:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e2:	01 d0                	add    %edx,%eax
  8023e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8023e7:	90                   	nop
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8023ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802402:	8b 45 10             	mov    0x10(%ebp),%eax
  802405:	01 d0                	add    %edx,%eax
  802407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80240d:	eb 0c                	jmp    80241b <strsplit+0x31>
			*string++ = 0;
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8d 50 01             	lea    0x1(%eax),%edx
  802415:	89 55 08             	mov    %edx,0x8(%ebp)
  802418:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8a 00                	mov    (%eax),%al
  802420:	84 c0                	test   %al,%al
  802422:	74 18                	je     80243c <strsplit+0x52>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	0f be c0             	movsbl %al,%eax
  80242c:	50                   	push   %eax
  80242d:	ff 75 0c             	pushl  0xc(%ebp)
  802430:	e8 83 fa ff ff       	call   801eb8 <strchr>
  802435:	83 c4 08             	add    $0x8,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	75 d3                	jne    80240f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	8a 00                	mov    (%eax),%al
  802441:	84 c0                	test   %al,%al
  802443:	74 5a                	je     80249f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802445:	8b 45 14             	mov    0x14(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	83 f8 0f             	cmp    $0xf,%eax
  80244d:	75 07                	jne    802456 <strsplit+0x6c>
		{
			return 0;
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	eb 66                	jmp    8024bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802456:	8b 45 14             	mov    0x14(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	8d 48 01             	lea    0x1(%eax),%ecx
  80245e:	8b 55 14             	mov    0x14(%ebp),%edx
  802461:	89 0a                	mov    %ecx,(%edx)
  802463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80246a:	8b 45 10             	mov    0x10(%ebp),%eax
  80246d:	01 c2                	add    %eax,%edx
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802474:	eb 03                	jmp    802479 <strsplit+0x8f>
			string++;
  802476:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8a 00                	mov    (%eax),%al
  80247e:	84 c0                	test   %al,%al
  802480:	74 8b                	je     80240d <strsplit+0x23>
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	8a 00                	mov    (%eax),%al
  802487:	0f be c0             	movsbl %al,%eax
  80248a:	50                   	push   %eax
  80248b:	ff 75 0c             	pushl  0xc(%ebp)
  80248e:	e8 25 fa ff ff       	call   801eb8 <strchr>
  802493:	83 c4 08             	add    $0x8,%esp
  802496:	85 c0                	test   %eax,%eax
  802498:	74 dc                	je     802476 <strsplit+0x8c>
			string++;
	}
  80249a:	e9 6e ff ff ff       	jmp    80240d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80249f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8024a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8024b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8024ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024d1:	eb 4a                	jmp    80251d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8024d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	01 c2                	add    %eax,%edx
  8024db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	01 c8                	add    %ecx,%eax
  8024e3:	8a 00                	mov    (%eax),%al
  8024e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8024e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	8a 00                	mov    (%eax),%al
  8024f1:	3c 40                	cmp    $0x40,%al
  8024f3:	7e 25                	jle    80251a <str2lower+0x5c>
  8024f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	8a 00                	mov    (%eax),%al
  8024ff:	3c 5a                	cmp    $0x5a,%al
  802501:	7f 17                	jg     80251a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80250e:	8b 55 08             	mov    0x8(%ebp),%edx
  802511:	01 ca                	add    %ecx,%edx
  802513:	8a 12                	mov    (%edx),%dl
  802515:	83 c2 20             	add    $0x20,%edx
  802518:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80251a:	ff 45 fc             	incl   -0x4(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	e8 01 f8 ff ff       	call   801d26 <strlen>
  802525:	83 c4 04             	add    $0x4,%esp
  802528:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80252b:	7f a6                	jg     8024d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80252d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802538:	a1 08 50 80 00       	mov    0x805008,%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 42                	je     802583 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802541:	83 ec 08             	sub    $0x8,%esp
  802544:	68 00 00 00 82       	push   $0x82000000
  802549:	68 00 00 00 80       	push   $0x80000000
  80254e:	e8 8c 07 00 00       	call   802cdf <initialize_dynamic_allocator>
  802553:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802556:	e8 e7 05 00 00       	call   802b42 <sys_get_uheap_strategy>
  80255b:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802560:	a1 40 50 80 00       	mov    0x805040,%eax
  802565:	05 00 10 00 00       	add    $0x1000,%eax
  80256a:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80256f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802574:	a3 68 d0 81 00       	mov    %eax,0x81d068

		__firstTimeFlag = 0;
  802579:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802580:	00 00 00 
	}
}
  802583:	90                   	nop
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	68 06 04 00 00       	push   $0x406
  8025a2:	50                   	push   %eax
  8025a3:	e8 e4 01 00 00       	call   80278c <__sys_allocate_page>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8025ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b2:	79 14                	jns    8025c8 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 bc 3e 80 00       	push   $0x803ebc
  8025bc:	6a 1f                	push   $0x1f
  8025be:	68 f8 3e 80 00       	push   $0x803ef8
  8025c3:	e8 af eb ff ff       	call   801177 <_panic>
	return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	50                   	push   %eax
  8025e7:	e8 e7 01 00 00       	call   8027d3 <__sys_unmap_frame>
  8025ec:	83 c4 10             	add    $0x10,%esp
  8025ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8025f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f6:	79 14                	jns    80260c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 04 3f 80 00       	push   $0x803f04
  802600:	6a 2a                	push   $0x2a
  802602:	68 f8 3e 80 00       	push   $0x803ef8
  802607:	e8 6b eb ff ff       	call   801177 <_panic>
}
  80260c:	90                   	nop
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802615:	e8 18 ff ff ff       	call   802532 <uheap_init>
	if (size == 0) return NULL ;
  80261a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261e:	75 07                	jne    802627 <malloc+0x18>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	eb 14                	jmp    80263b <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 44 3f 80 00       	push   $0x803f44
  80262f:	6a 3e                	push   $0x3e
  802631:	68 f8 3e 80 00       	push   $0x803ef8
  802636:	e8 3c eb ff ff       	call   801177 <_panic>
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 6c 3f 80 00       	push   $0x803f6c
  80264b:	6a 49                	push   $0x49
  80264d:	68 f8 3e 80 00       	push   $0x803ef8
  802652:	e8 20 eb ff ff       	call   801177 <_panic>

00802657 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 18             	sub    $0x18,%esp
  80265d:	8b 45 10             	mov    0x10(%ebp),%eax
  802660:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802663:	e8 ca fe ff ff       	call   802532 <uheap_init>
	if (size == 0) return NULL ;
  802668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80266c:	75 07                	jne    802675 <smalloc+0x1e>
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	eb 14                	jmp    802689 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 90 3f 80 00       	push   $0x803f90
  80267d:	6a 5a                	push   $0x5a
  80267f:	68 f8 3e 80 00       	push   $0x803ef8
  802684:	e8 ee ea ff ff       	call   801177 <_panic>
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802691:	e8 9c fe ff ff       	call   802532 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802696:	83 ec 04             	sub    $0x4,%esp
  802699:	68 b8 3f 80 00       	push   $0x803fb8
  80269e:	6a 6a                	push   $0x6a
  8026a0:	68 f8 3e 80 00       	push   $0x803ef8
  8026a5:	e8 cd ea ff ff       	call   801177 <_panic>

008026aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026b0:	e8 7d fe ff ff       	call   802532 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	68 dc 3f 80 00       	push   $0x803fdc
  8026bd:	68 88 00 00 00       	push   $0x88
  8026c2:	68 f8 3e 80 00       	push   $0x803ef8
  8026c7:	e8 ab ea ff ff       	call   801177 <_panic>

008026cc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 04 40 80 00       	push   $0x804004
  8026da:	68 9b 00 00 00       	push   $0x9b
  8026df:	68 f8 3e 80 00       	push   $0x803ef8
  8026e4:	e8 8e ea ff ff       	call   801177 <_panic>

008026e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	57                   	push   %edi
  8026ed:	56                   	push   %esi
  8026ee:	53                   	push   %ebx
  8026ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  802701:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802704:	cd 30                	int    $0x30
  802706:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	5b                   	pop    %ebx
  802710:	5e                   	pop    %esi
  802711:	5f                   	pop    %edi
  802712:	5d                   	pop    %ebp
  802713:	c3                   	ret    

00802714 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	8b 45 10             	mov    0x10(%ebp),%eax
  80271d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802720:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802723:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	6a 00                	push   $0x0
  80272c:	51                   	push   %ecx
  80272d:	52                   	push   %edx
  80272e:	ff 75 0c             	pushl  0xc(%ebp)
  802731:	50                   	push   %eax
  802732:	6a 00                	push   $0x0
  802734:	e8 b0 ff ff ff       	call   8026e9 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	90                   	nop
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <sys_cgetc>:

int
sys_cgetc(void)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 02                	push   $0x2
  80274e:	e8 96 ff ff ff       	call   8026e9 <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 03                	push   $0x3
  802767:	e8 7d ff ff ff       	call   8026e9 <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
}
  80276f:	90                   	nop
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 04                	push   $0x4
  802781:	e8 63 ff ff ff       	call   8026e9 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
}
  802789:	90                   	nop
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80278f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	52                   	push   %edx
  80279c:	50                   	push   %eax
  80279d:	6a 08                	push   $0x8
  80279f:	e8 45 ff ff ff       	call   8026e9 <syscall>
  8027a4:	83 c4 18             	add    $0x18,%esp
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	56                   	push   %esi
  8027ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8027b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	56                   	push   %esi
  8027be:	53                   	push   %ebx
  8027bf:	51                   	push   %ecx
  8027c0:	52                   	push   %edx
  8027c1:	50                   	push   %eax
  8027c2:	6a 09                	push   $0x9
  8027c4:	e8 20 ff ff ff       	call   8026e9 <syscall>
  8027c9:	83 c4 18             	add    $0x18,%esp
}
  8027cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027cf:	5b                   	pop    %ebx
  8027d0:	5e                   	pop    %esi
  8027d1:	5d                   	pop    %ebp
  8027d2:	c3                   	ret    

008027d3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	ff 75 08             	pushl  0x8(%ebp)
  8027e1:	6a 0a                	push   $0xa
  8027e3:	e8 01 ff ff ff       	call   8026e9 <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	ff 75 0c             	pushl  0xc(%ebp)
  8027f9:	ff 75 08             	pushl  0x8(%ebp)
  8027fc:	6a 0b                	push   $0xb
  8027fe:	e8 e6 fe ff ff       	call   8026e9 <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 0c                	push   $0xc
  802817:	e8 cd fe ff ff       	call   8026e9 <syscall>
  80281c:	83 c4 18             	add    $0x18,%esp
}
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 0d                	push   $0xd
  802830:	e8 b4 fe ff ff       	call   8026e9 <syscall>
  802835:	83 c4 18             	add    $0x18,%esp
}
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 0e                	push   $0xe
  802849:	e8 9b fe ff ff       	call   8026e9 <syscall>
  80284e:	83 c4 18             	add    $0x18,%esp
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 0f                	push   $0xf
  802862:	e8 82 fe ff ff       	call   8026e9 <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	ff 75 08             	pushl  0x8(%ebp)
  80287a:	6a 10                	push   $0x10
  80287c:	e8 68 fe ff ff       	call   8026e9 <syscall>
  802881:	83 c4 18             	add    $0x18,%esp
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 11                	push   $0x11
  802895:	e8 4f fe ff ff       	call   8026e9 <syscall>
  80289a:	83 c4 18             	add    $0x18,%esp
}
  80289d:	90                   	nop
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	50                   	push   %eax
  8028b9:	6a 01                	push   $0x1
  8028bb:	e8 29 fe ff ff       	call   8026e9 <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
}
  8028c3:	90                   	nop
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 14                	push   $0x14
  8028d5:	e8 0f fe ff ff       	call   8026e9 <syscall>
  8028da:	83 c4 18             	add    $0x18,%esp
}
  8028dd:	90                   	nop
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8028ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	6a 00                	push   $0x0
  8028f8:	51                   	push   %ecx
  8028f9:	52                   	push   %edx
  8028fa:	ff 75 0c             	pushl  0xc(%ebp)
  8028fd:	50                   	push   %eax
  8028fe:	6a 15                	push   $0x15
  802900:	e8 e4 fd ff ff       	call   8026e9 <syscall>
  802905:	83 c4 18             	add    $0x18,%esp
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80290d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	52                   	push   %edx
  80291a:	50                   	push   %eax
  80291b:	6a 16                	push   $0x16
  80291d:	e8 c7 fd ff ff       	call   8026e9 <syscall>
  802922:	83 c4 18             	add    $0x18,%esp
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80292a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80292d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	51                   	push   %ecx
  802938:	52                   	push   %edx
  802939:	50                   	push   %eax
  80293a:	6a 17                	push   $0x17
  80293c:	e8 a8 fd ff ff       	call   8026e9 <syscall>
  802941:	83 c4 18             	add    $0x18,%esp
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	52                   	push   %edx
  802956:	50                   	push   %eax
  802957:	6a 18                	push   $0x18
  802959:	e8 8b fd ff ff       	call   8026e9 <syscall>
  80295e:	83 c4 18             	add    $0x18,%esp
}
  802961:	c9                   	leave  
  802962:	c3                   	ret    

00802963 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	6a 00                	push   $0x0
  80296b:	ff 75 14             	pushl  0x14(%ebp)
  80296e:	ff 75 10             	pushl  0x10(%ebp)
  802971:	ff 75 0c             	pushl  0xc(%ebp)
  802974:	50                   	push   %eax
  802975:	6a 19                	push   $0x19
  802977:	e8 6d fd ff ff       	call   8026e9 <syscall>
  80297c:	83 c4 18             	add    $0x18,%esp
}
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	50                   	push   %eax
  802990:	6a 1a                	push   $0x1a
  802992:	e8 52 fd ff ff       	call   8026e9 <syscall>
  802997:	83 c4 18             	add    $0x18,%esp
}
  80299a:	90                   	nop
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 00                	push   $0x0
  8029ab:	50                   	push   %eax
  8029ac:	6a 1b                	push   $0x1b
  8029ae:	e8 36 fd ff ff       	call   8026e9 <syscall>
  8029b3:	83 c4 18             	add    $0x18,%esp
}
  8029b6:	c9                   	leave  
  8029b7:	c3                   	ret    

008029b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 05                	push   $0x5
  8029c7:	e8 1d fd ff ff       	call   8026e9 <syscall>
  8029cc:	83 c4 18             	add    $0x18,%esp
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 06                	push   $0x6
  8029e0:	e8 04 fd ff ff       	call   8026e9 <syscall>
  8029e5:	83 c4 18             	add    $0x18,%esp
}
  8029e8:	c9                   	leave  
  8029e9:	c3                   	ret    

008029ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 07                	push   $0x7
  8029f9:	e8 eb fc ff ff       	call   8026e9 <syscall>
  8029fe:	83 c4 18             	add    $0x18,%esp
}
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <sys_exit_env>:


void sys_exit_env(void)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 1c                	push   $0x1c
  802a12:	e8 d2 fc ff ff       	call   8026e9 <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
}
  802a1a:	90                   	nop
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
  802a20:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a26:	8d 50 04             	lea    0x4(%eax),%edx
  802a29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	52                   	push   %edx
  802a33:	50                   	push   %eax
  802a34:	6a 1d                	push   $0x1d
  802a36:	e8 ae fc ff ff       	call   8026e9 <syscall>
  802a3b:	83 c4 18             	add    $0x18,%esp
	return result;
  802a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a47:	89 01                	mov    %eax,(%ecx)
  802a49:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	c9                   	leave  
  802a50:	c2 04 00             	ret    $0x4

00802a53 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	ff 75 10             	pushl  0x10(%ebp)
  802a5d:	ff 75 0c             	pushl  0xc(%ebp)
  802a60:	ff 75 08             	pushl  0x8(%ebp)
  802a63:	6a 13                	push   $0x13
  802a65:	e8 7f fc ff ff       	call   8026e9 <syscall>
  802a6a:	83 c4 18             	add    $0x18,%esp
	return ;
  802a6d:	90                   	nop
}
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 1e                	push   $0x1e
  802a7f:	e8 65 fc ff ff       	call   8026e9 <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a95:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	50                   	push   %eax
  802aa2:	6a 1f                	push   $0x1f
  802aa4:	e8 40 fc ff ff       	call   8026e9 <syscall>
  802aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  802aac:	90                   	nop
}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    

00802aaf <rsttst>:
void rsttst()
{
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 00                	push   $0x0
  802abc:	6a 21                	push   $0x21
  802abe:	e8 26 fc ff ff       	call   8026e9 <syscall>
  802ac3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ac6:	90                   	nop
}
  802ac7:	c9                   	leave  
  802ac8:	c3                   	ret    

00802ac9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ac9:	55                   	push   %ebp
  802aca:	89 e5                	mov    %esp,%ebp
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	8b 45 14             	mov    0x14(%ebp),%eax
  802ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ad5:	8b 55 18             	mov    0x18(%ebp),%edx
  802ad8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802adc:	52                   	push   %edx
  802add:	50                   	push   %eax
  802ade:	ff 75 10             	pushl  0x10(%ebp)
  802ae1:	ff 75 0c             	pushl  0xc(%ebp)
  802ae4:	ff 75 08             	pushl  0x8(%ebp)
  802ae7:	6a 20                	push   $0x20
  802ae9:	e8 fb fb ff ff       	call   8026e9 <syscall>
  802aee:	83 c4 18             	add    $0x18,%esp
	return ;
  802af1:	90                   	nop
}
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <chktst>:
void chktst(uint32 n)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	6a 00                	push   $0x0
  802afd:	6a 00                	push   $0x0
  802aff:	ff 75 08             	pushl  0x8(%ebp)
  802b02:	6a 22                	push   $0x22
  802b04:	e8 e0 fb ff ff       	call   8026e9 <syscall>
  802b09:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0c:	90                   	nop
}
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <inctst>:

void inctst()
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 23                	push   $0x23
  802b1e:	e8 c6 fb ff ff       	call   8026e9 <syscall>
  802b23:	83 c4 18             	add    $0x18,%esp
	return ;
  802b26:	90                   	nop
}
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <gettst>:
uint32 gettst()
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 24                	push   $0x24
  802b38:	e8 ac fb ff ff       	call   8026e9 <syscall>
  802b3d:	83 c4 18             	add    $0x18,%esp
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 25                	push   $0x25
  802b51:	e8 93 fb ff ff       	call   8026e9 <syscall>
  802b56:	83 c4 18             	add    $0x18,%esp
  802b59:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802b5e:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    

00802b65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	6a 26                	push   $0x26
  802b7d:	e8 67 fb ff ff       	call   8026e9 <syscall>
  802b82:	83 c4 18             	add    $0x18,%esp
	return ;
  802b85:	90                   	nop
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	6a 00                	push   $0x0
  802b9a:	53                   	push   %ebx
  802b9b:	51                   	push   %ecx
  802b9c:	52                   	push   %edx
  802b9d:	50                   	push   %eax
  802b9e:	6a 27                	push   $0x27
  802ba0:	e8 44 fb ff ff       	call   8026e9 <syscall>
  802ba5:	83 c4 18             	add    $0x18,%esp
}
  802ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bab:	c9                   	leave  
  802bac:	c3                   	ret    

00802bad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bad:	55                   	push   %ebp
  802bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	52                   	push   %edx
  802bbd:	50                   	push   %eax
  802bbe:	6a 28                	push   $0x28
  802bc0:	e8 24 fb ff ff       	call   8026e9 <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
}
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802bcd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	6a 00                	push   $0x0
  802bd8:	51                   	push   %ecx
  802bd9:	ff 75 10             	pushl  0x10(%ebp)
  802bdc:	52                   	push   %edx
  802bdd:	50                   	push   %eax
  802bde:	6a 29                	push   $0x29
  802be0:	e8 04 fb ff ff       	call   8026e9 <syscall>
  802be5:	83 c4 18             	add    $0x18,%esp
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	ff 75 10             	pushl  0x10(%ebp)
  802bf4:	ff 75 0c             	pushl  0xc(%ebp)
  802bf7:	ff 75 08             	pushl  0x8(%ebp)
  802bfa:	6a 12                	push   $0x12
  802bfc:	e8 e8 fa ff ff       	call   8026e9 <syscall>
  802c01:	83 c4 18             	add    $0x18,%esp
	return ;
  802c04:	90                   	nop
}
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	52                   	push   %edx
  802c17:	50                   	push   %eax
  802c18:	6a 2a                	push   $0x2a
  802c1a:	e8 ca fa ff ff       	call   8026e9 <syscall>
  802c1f:	83 c4 18             	add    $0x18,%esp
	return;
  802c22:	90                   	nop
}
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 2b                	push   $0x2b
  802c34:	e8 b0 fa ff ff       	call   8026e9 <syscall>
  802c39:	83 c4 18             	add    $0x18,%esp
}
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	ff 75 0c             	pushl  0xc(%ebp)
  802c4a:	ff 75 08             	pushl  0x8(%ebp)
  802c4d:	6a 2d                	push   $0x2d
  802c4f:	e8 95 fa ff ff       	call   8026e9 <syscall>
  802c54:	83 c4 18             	add    $0x18,%esp
	return;
  802c57:	90                   	nop
}
  802c58:	c9                   	leave  
  802c59:	c3                   	ret    

00802c5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802c5d:	6a 00                	push   $0x0
  802c5f:	6a 00                	push   $0x0
  802c61:	6a 00                	push   $0x0
  802c63:	ff 75 0c             	pushl  0xc(%ebp)
  802c66:	ff 75 08             	pushl  0x8(%ebp)
  802c69:	6a 2c                	push   $0x2c
  802c6b:	e8 79 fa ff ff       	call   8026e9 <syscall>
  802c70:	83 c4 18             	add    $0x18,%esp
	return ;
  802c73:	90                   	nop
}
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
  802c79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	68 28 40 80 00       	push   $0x804028
  802c84:	68 25 01 00 00       	push   $0x125
  802c89:	68 5b 40 80 00       	push   $0x80405b
  802c8e:	e8 e4 e4 ff ff       	call   801177 <_panic>

00802c93 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	ba 60 50 80 00       	mov    $0x805060,%edx
  802ca1:	29 d0                	sub    %edx,%eax
  802ca3:	c1 f8 02             	sar    $0x2,%eax
  802ca6:	89 c2                	mov    %eax,%edx
  802ca8:	89 d0                	mov    %edx,%eax
  802caa:	c1 e0 02             	shl    $0x2,%eax
  802cad:	01 d0                	add    %edx,%eax
  802caf:	c1 e0 02             	shl    $0x2,%eax
  802cb2:	01 d0                	add    %edx,%eax
  802cb4:	c1 e0 02             	shl    $0x2,%eax
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	89 c1                	mov    %eax,%ecx
  802cbb:	c1 e1 08             	shl    $0x8,%ecx
  802cbe:	01 c8                	add    %ecx,%eax
  802cc0:	89 c1                	mov    %eax,%ecx
  802cc2:	c1 e1 10             	shl    $0x10,%ecx
  802cc5:	01 c8                	add    %ecx,%eax
  802cc7:	01 c0                	add    %eax,%eax
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cd1:	c1 e0 0c             	shl    $0xc,%eax
  802cd4:	89 c2                	mov    %eax,%edx
  802cd6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802cdb:	01 d0                	add    %edx,%eax
}
  802cdd:	c9                   	leave  
  802cde:	c3                   	ret    

00802cdf <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cdf:	55                   	push   %ebp
  802ce0:	89 e5                	mov    %esp,%ebp
  802ce2:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	05 00 00 00 02       	add    $0x2000000,%eax
  802ced:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cf0:	73 16                	jae    802d08 <initialize_dynamic_allocator+0x29>
  802cf2:	68 6c 40 80 00       	push   $0x80406c
  802cf7:	68 92 40 80 00       	push   $0x804092
  802cfc:	6a 26                	push   $0x26
  802cfe:	68 a7 40 80 00       	push   $0x8040a7
  802d03:	e8 6f e4 ff ff       	call   801177 <_panic>
		is_initialized = 1;
  802d08:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802d0f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 c0 40 80 00       	push   $0x8040c0
  802d1a:	6a 2e                	push   $0x2e
  802d1c:	68 a7 40 80 00       	push   $0x8040a7
  802d21:	e8 51 e4 ff ff       	call   801177 <_panic>

00802d26 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802d26:	55                   	push   %ebp
  802d27:	89 e5                	mov    %esp,%ebp
  802d29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	68 f4 40 80 00       	push   $0x8040f4
  802d34:	6a 3a                	push   $0x3a
  802d36:	68 a7 40 80 00       	push   $0x8040a7
  802d3b:	e8 37 e4 ff ff       	call   801177 <_panic>

00802d40 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
  802d43:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802d46:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802d4d:	76 16                	jbe    802d65 <alloc_block+0x25>
  802d4f:	68 1c 41 80 00       	push   $0x80411c
  802d54:	68 92 40 80 00       	push   $0x804092
  802d59:	6a 46                	push   $0x46
  802d5b:	68 a7 40 80 00       	push   $0x8040a7
  802d60:	e8 12 e4 ff ff       	call   801177 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 40 41 80 00       	push   $0x804140
  802d6d:	6a 4d                	push   $0x4d
  802d6f:	68 a7 40 80 00       	push   $0x8040a7
  802d74:	e8 fe e3 ff ff       	call   801177 <_panic>

00802d79 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d87:	39 c2                	cmp    %eax,%edx
  802d89:	72 0c                	jb     802d97 <free_block+0x1e>
  802d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8e:	a1 40 50 80 00       	mov    0x805040,%eax
  802d93:	39 c2                	cmp    %eax,%edx
  802d95:	72 16                	jb     802dad <free_block+0x34>
  802d97:	68 64 41 80 00       	push   $0x804164
  802d9c:	68 92 40 80 00       	push   $0x804092
  802da1:	6a 5b                	push   $0x5b
  802da3:	68 a7 40 80 00       	push   $0x8040a7
  802da8:	e8 ca e3 ff ff       	call   801177 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	68 9c 41 80 00       	push   $0x80419c
  802db5:	6a 63                	push   $0x63
  802db7:	68 a7 40 80 00       	push   $0x8040a7
  802dbc:	e8 b6 e3 ff ff       	call   801177 <_panic>

00802dc1 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
  802dc4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 c0 41 80 00       	push   $0x8041c0
  802dcf:	6a 72                	push   $0x72
  802dd1:	68 a7 40 80 00       	push   $0x8040a7
  802dd6:	e8 9c e3 ff ff       	call   801177 <_panic>

00802ddb <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
  802dde:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 e4 41 80 00       	push   $0x8041e4
  802de9:	6a 07                	push   $0x7
  802deb:	68 13 42 80 00       	push   $0x804213
  802df0:	e8 82 e3 ff ff       	call   801177 <_panic>

00802df5 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	68 24 42 80 00       	push   $0x804224
  802e03:	6a 0b                	push   $0xb
  802e05:	68 13 42 80 00       	push   $0x804213
  802e0a:	e8 68 e3 ff ff       	call   801177 <_panic>

00802e0f <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
  802e12:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 50 42 80 00       	push   $0x804250
  802e1d:	6a 10                	push   $0x10
  802e1f:	68 13 42 80 00       	push   $0x804213
  802e24:	e8 4e e3 ff ff       	call   801177 <_panic>

00802e29 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
  802e2c:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 80 42 80 00       	push   $0x804280
  802e37:	6a 15                	push   $0x15
  802e39:	68 13 42 80 00       	push   $0x804213
  802e3e:	e8 34 e3 ff ff       	call   801177 <_panic>

00802e43 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802e43:	55                   	push   %ebp
  802e44:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 10             	mov    0x10(%eax),%eax
}
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    

00802e4e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e4e:	55                   	push   %ebp
  802e4f:	89 e5                	mov    %esp,%ebp
  802e51:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 d0                	mov    %edx,%eax
  802e59:	c1 e0 02             	shl    $0x2,%eax
  802e5c:	01 d0                	add    %edx,%eax
  802e5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e65:	01 d0                	add    %edx,%eax
  802e67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e6e:	01 d0                	add    %edx,%eax
  802e70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e77:	01 d0                	add    %edx,%eax
  802e79:	c1 e0 04             	shl    $0x4,%eax
  802e7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802e86:	0f 31                	rdtsc  
  802e88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e8b:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e97:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802e9a:	eb 46                	jmp    802ee2 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802e9c:	0f 31                	rdtsc  
  802e9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802ea1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802ea4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ea7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802eaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802ead:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	29 c2                	sub    %eax,%edx
  802eb8:	89 d0                	mov    %edx,%eax
  802eba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ebd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	89 d1                	mov    %edx,%ecx
  802ec5:	29 c1                	sub    %eax,%ecx
  802ec7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecd:	39 c2                	cmp    %eax,%edx
  802ecf:	0f 97 c0             	seta   %al
  802ed2:	0f b6 c0             	movzbl %al,%eax
  802ed5:	29 c1                	sub    %eax,%ecx
  802ed7:	89 c8                	mov    %ecx,%eax
  802ed9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802edc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ee5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802ee8:	72 b2                	jb     802e9c <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802eea:	90                   	nop
  802eeb:	c9                   	leave  
  802eec:	c3                   	ret    

00802eed <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802eed:	55                   	push   %ebp
  802eee:	89 e5                	mov    %esp,%ebp
  802ef0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802efa:	eb 03                	jmp    802eff <busy_wait+0x12>
  802efc:	ff 45 fc             	incl   -0x4(%ebp)
  802eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f05:	72 f5                	jb     802efc <busy_wait+0xf>
	return i;
  802f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f0a:	c9                   	leave  
  802f0b:	c3                   	ret    

00802f0c <__udivdi3>:
  802f0c:	55                   	push   %ebp
  802f0d:	57                   	push   %edi
  802f0e:	56                   	push   %esi
  802f0f:	53                   	push   %ebx
  802f10:	83 ec 1c             	sub    $0x1c,%esp
  802f13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f23:	89 ca                	mov    %ecx,%edx
  802f25:	89 f8                	mov    %edi,%eax
  802f27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f2b:	85 f6                	test   %esi,%esi
  802f2d:	75 2d                	jne    802f5c <__udivdi3+0x50>
  802f2f:	39 cf                	cmp    %ecx,%edi
  802f31:	77 65                	ja     802f98 <__udivdi3+0x8c>
  802f33:	89 fd                	mov    %edi,%ebp
  802f35:	85 ff                	test   %edi,%edi
  802f37:	75 0b                	jne    802f44 <__udivdi3+0x38>
  802f39:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3e:	31 d2                	xor    %edx,%edx
  802f40:	f7 f7                	div    %edi
  802f42:	89 c5                	mov    %eax,%ebp
  802f44:	31 d2                	xor    %edx,%edx
  802f46:	89 c8                	mov    %ecx,%eax
  802f48:	f7 f5                	div    %ebp
  802f4a:	89 c1                	mov    %eax,%ecx
  802f4c:	89 d8                	mov    %ebx,%eax
  802f4e:	f7 f5                	div    %ebp
  802f50:	89 cf                	mov    %ecx,%edi
  802f52:	89 fa                	mov    %edi,%edx
  802f54:	83 c4 1c             	add    $0x1c,%esp
  802f57:	5b                   	pop    %ebx
  802f58:	5e                   	pop    %esi
  802f59:	5f                   	pop    %edi
  802f5a:	5d                   	pop    %ebp
  802f5b:	c3                   	ret    
  802f5c:	39 ce                	cmp    %ecx,%esi
  802f5e:	77 28                	ja     802f88 <__udivdi3+0x7c>
  802f60:	0f bd fe             	bsr    %esi,%edi
  802f63:	83 f7 1f             	xor    $0x1f,%edi
  802f66:	75 40                	jne    802fa8 <__udivdi3+0x9c>
  802f68:	39 ce                	cmp    %ecx,%esi
  802f6a:	72 0a                	jb     802f76 <__udivdi3+0x6a>
  802f6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f70:	0f 87 9e 00 00 00    	ja     803014 <__udivdi3+0x108>
  802f76:	b8 01 00 00 00       	mov    $0x1,%eax
  802f7b:	89 fa                	mov    %edi,%edx
  802f7d:	83 c4 1c             	add    $0x1c,%esp
  802f80:	5b                   	pop    %ebx
  802f81:	5e                   	pop    %esi
  802f82:	5f                   	pop    %edi
  802f83:	5d                   	pop    %ebp
  802f84:	c3                   	ret    
  802f85:	8d 76 00             	lea    0x0(%esi),%esi
  802f88:	31 ff                	xor    %edi,%edi
  802f8a:	31 c0                	xor    %eax,%eax
  802f8c:	89 fa                	mov    %edi,%edx
  802f8e:	83 c4 1c             	add    $0x1c,%esp
  802f91:	5b                   	pop    %ebx
  802f92:	5e                   	pop    %esi
  802f93:	5f                   	pop    %edi
  802f94:	5d                   	pop    %ebp
  802f95:	c3                   	ret    
  802f96:	66 90                	xchg   %ax,%ax
  802f98:	89 d8                	mov    %ebx,%eax
  802f9a:	f7 f7                	div    %edi
  802f9c:	31 ff                	xor    %edi,%edi
  802f9e:	89 fa                	mov    %edi,%edx
  802fa0:	83 c4 1c             	add    $0x1c,%esp
  802fa3:	5b                   	pop    %ebx
  802fa4:	5e                   	pop    %esi
  802fa5:	5f                   	pop    %edi
  802fa6:	5d                   	pop    %ebp
  802fa7:	c3                   	ret    
  802fa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fad:	89 eb                	mov    %ebp,%ebx
  802faf:	29 fb                	sub    %edi,%ebx
  802fb1:	89 f9                	mov    %edi,%ecx
  802fb3:	d3 e6                	shl    %cl,%esi
  802fb5:	89 c5                	mov    %eax,%ebp
  802fb7:	88 d9                	mov    %bl,%cl
  802fb9:	d3 ed                	shr    %cl,%ebp
  802fbb:	89 e9                	mov    %ebp,%ecx
  802fbd:	09 f1                	or     %esi,%ecx
  802fbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fc3:	89 f9                	mov    %edi,%ecx
  802fc5:	d3 e0                	shl    %cl,%eax
  802fc7:	89 c5                	mov    %eax,%ebp
  802fc9:	89 d6                	mov    %edx,%esi
  802fcb:	88 d9                	mov    %bl,%cl
  802fcd:	d3 ee                	shr    %cl,%esi
  802fcf:	89 f9                	mov    %edi,%ecx
  802fd1:	d3 e2                	shl    %cl,%edx
  802fd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fd7:	88 d9                	mov    %bl,%cl
  802fd9:	d3 e8                	shr    %cl,%eax
  802fdb:	09 c2                	or     %eax,%edx
  802fdd:	89 d0                	mov    %edx,%eax
  802fdf:	89 f2                	mov    %esi,%edx
  802fe1:	f7 74 24 0c          	divl   0xc(%esp)
  802fe5:	89 d6                	mov    %edx,%esi
  802fe7:	89 c3                	mov    %eax,%ebx
  802fe9:	f7 e5                	mul    %ebp
  802feb:	39 d6                	cmp    %edx,%esi
  802fed:	72 19                	jb     803008 <__udivdi3+0xfc>
  802fef:	74 0b                	je     802ffc <__udivdi3+0xf0>
  802ff1:	89 d8                	mov    %ebx,%eax
  802ff3:	31 ff                	xor    %edi,%edi
  802ff5:	e9 58 ff ff ff       	jmp    802f52 <__udivdi3+0x46>
  802ffa:	66 90                	xchg   %ax,%ax
  802ffc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803000:	89 f9                	mov    %edi,%ecx
  803002:	d3 e2                	shl    %cl,%edx
  803004:	39 c2                	cmp    %eax,%edx
  803006:	73 e9                	jae    802ff1 <__udivdi3+0xe5>
  803008:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80300b:	31 ff                	xor    %edi,%edi
  80300d:	e9 40 ff ff ff       	jmp    802f52 <__udivdi3+0x46>
  803012:	66 90                	xchg   %ax,%ax
  803014:	31 c0                	xor    %eax,%eax
  803016:	e9 37 ff ff ff       	jmp    802f52 <__udivdi3+0x46>
  80301b:	90                   	nop

0080301c <__umoddi3>:
  80301c:	55                   	push   %ebp
  80301d:	57                   	push   %edi
  80301e:	56                   	push   %esi
  80301f:	53                   	push   %ebx
  803020:	83 ec 1c             	sub    $0x1c,%esp
  803023:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803027:	8b 74 24 34          	mov    0x34(%esp),%esi
  80302b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80302f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803033:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803037:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80303b:	89 f3                	mov    %esi,%ebx
  80303d:	89 fa                	mov    %edi,%edx
  80303f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803043:	89 34 24             	mov    %esi,(%esp)
  803046:	85 c0                	test   %eax,%eax
  803048:	75 1a                	jne    803064 <__umoddi3+0x48>
  80304a:	39 f7                	cmp    %esi,%edi
  80304c:	0f 86 a2 00 00 00    	jbe    8030f4 <__umoddi3+0xd8>
  803052:	89 c8                	mov    %ecx,%eax
  803054:	89 f2                	mov    %esi,%edx
  803056:	f7 f7                	div    %edi
  803058:	89 d0                	mov    %edx,%eax
  80305a:	31 d2                	xor    %edx,%edx
  80305c:	83 c4 1c             	add    $0x1c,%esp
  80305f:	5b                   	pop    %ebx
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
  803064:	39 f0                	cmp    %esi,%eax
  803066:	0f 87 ac 00 00 00    	ja     803118 <__umoddi3+0xfc>
  80306c:	0f bd e8             	bsr    %eax,%ebp
  80306f:	83 f5 1f             	xor    $0x1f,%ebp
  803072:	0f 84 ac 00 00 00    	je     803124 <__umoddi3+0x108>
  803078:	bf 20 00 00 00       	mov    $0x20,%edi
  80307d:	29 ef                	sub    %ebp,%edi
  80307f:	89 fe                	mov    %edi,%esi
  803081:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803085:	89 e9                	mov    %ebp,%ecx
  803087:	d3 e0                	shl    %cl,%eax
  803089:	89 d7                	mov    %edx,%edi
  80308b:	89 f1                	mov    %esi,%ecx
  80308d:	d3 ef                	shr    %cl,%edi
  80308f:	09 c7                	or     %eax,%edi
  803091:	89 e9                	mov    %ebp,%ecx
  803093:	d3 e2                	shl    %cl,%edx
  803095:	89 14 24             	mov    %edx,(%esp)
  803098:	89 d8                	mov    %ebx,%eax
  80309a:	d3 e0                	shl    %cl,%eax
  80309c:	89 c2                	mov    %eax,%edx
  80309e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a2:	d3 e0                	shl    %cl,%eax
  8030a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030ac:	89 f1                	mov    %esi,%ecx
  8030ae:	d3 e8                	shr    %cl,%eax
  8030b0:	09 d0                	or     %edx,%eax
  8030b2:	d3 eb                	shr    %cl,%ebx
  8030b4:	89 da                	mov    %ebx,%edx
  8030b6:	f7 f7                	div    %edi
  8030b8:	89 d3                	mov    %edx,%ebx
  8030ba:	f7 24 24             	mull   (%esp)
  8030bd:	89 c6                	mov    %eax,%esi
  8030bf:	89 d1                	mov    %edx,%ecx
  8030c1:	39 d3                	cmp    %edx,%ebx
  8030c3:	0f 82 87 00 00 00    	jb     803150 <__umoddi3+0x134>
  8030c9:	0f 84 91 00 00 00    	je     803160 <__umoddi3+0x144>
  8030cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030d3:	29 f2                	sub    %esi,%edx
  8030d5:	19 cb                	sbb    %ecx,%ebx
  8030d7:	89 d8                	mov    %ebx,%eax
  8030d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030dd:	d3 e0                	shl    %cl,%eax
  8030df:	89 e9                	mov    %ebp,%ecx
  8030e1:	d3 ea                	shr    %cl,%edx
  8030e3:	09 d0                	or     %edx,%eax
  8030e5:	89 e9                	mov    %ebp,%ecx
  8030e7:	d3 eb                	shr    %cl,%ebx
  8030e9:	89 da                	mov    %ebx,%edx
  8030eb:	83 c4 1c             	add    $0x1c,%esp
  8030ee:	5b                   	pop    %ebx
  8030ef:	5e                   	pop    %esi
  8030f0:	5f                   	pop    %edi
  8030f1:	5d                   	pop    %ebp
  8030f2:	c3                   	ret    
  8030f3:	90                   	nop
  8030f4:	89 fd                	mov    %edi,%ebp
  8030f6:	85 ff                	test   %edi,%edi
  8030f8:	75 0b                	jne    803105 <__umoddi3+0xe9>
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	31 d2                	xor    %edx,%edx
  803101:	f7 f7                	div    %edi
  803103:	89 c5                	mov    %eax,%ebp
  803105:	89 f0                	mov    %esi,%eax
  803107:	31 d2                	xor    %edx,%edx
  803109:	f7 f5                	div    %ebp
  80310b:	89 c8                	mov    %ecx,%eax
  80310d:	f7 f5                	div    %ebp
  80310f:	89 d0                	mov    %edx,%eax
  803111:	e9 44 ff ff ff       	jmp    80305a <__umoddi3+0x3e>
  803116:	66 90                	xchg   %ax,%ax
  803118:	89 c8                	mov    %ecx,%eax
  80311a:	89 f2                	mov    %esi,%edx
  80311c:	83 c4 1c             	add    $0x1c,%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    
  803124:	3b 04 24             	cmp    (%esp),%eax
  803127:	72 06                	jb     80312f <__umoddi3+0x113>
  803129:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80312d:	77 0f                	ja     80313e <__umoddi3+0x122>
  80312f:	89 f2                	mov    %esi,%edx
  803131:	29 f9                	sub    %edi,%ecx
  803133:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803137:	89 14 24             	mov    %edx,(%esp)
  80313a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80313e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803142:	8b 14 24             	mov    (%esp),%edx
  803145:	83 c4 1c             	add    $0x1c,%esp
  803148:	5b                   	pop    %ebx
  803149:	5e                   	pop    %esi
  80314a:	5f                   	pop    %edi
  80314b:	5d                   	pop    %ebp
  80314c:	c3                   	ret    
  80314d:	8d 76 00             	lea    0x0(%esi),%esi
  803150:	2b 04 24             	sub    (%esp),%eax
  803153:	19 fa                	sbb    %edi,%edx
  803155:	89 d1                	mov    %edx,%ecx
  803157:	89 c6                	mov    %eax,%esi
  803159:	e9 71 ff ff ff       	jmp    8030cf <__umoddi3+0xb3>
  80315e:	66 90                	xchg   %ax,%ax
  803160:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803164:	72 ea                	jb     803150 <__umoddi3+0x134>
  803166:	89 d9                	mov    %ebx,%ecx
  803168:	e9 62 ff ff ff       	jmp    8030cf <__umoddi3+0xb3>

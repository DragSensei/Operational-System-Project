
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 07 00 00       	call   800791 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  80004b:	00 00 00 

	int parentenvID = sys_getparentenvid();
  80004e:	e8 59 1f 00 00       	call   801fac <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _isOpened[] = "isOpened";
  800056:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800059:	bb bf 27 80 00       	mov    $0x8027bf,%ebx
  80005e:	ba 09 00 00 00       	mov    $0x9,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80006e:	bb c8 27 80 00       	mov    $0x8027c8,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 95             	lea    -0x6b(%ebp),%eax
  800083:	bb d2 27 80 00       	mov    $0x8027d2,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800098:	bb de 27 80 00       	mov    $0x8027de,%ebx
  80009d:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 de                	mov    %ebx,%esi
  8000a6:	89 d1                	mov    %edx,%ecx
  8000a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000aa:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  8000b0:	bb ed 27 80 00       	mov    $0x8027ed,%ebx
  8000b5:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 de                	mov    %ebx,%esi
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c2:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8000c8:	bb fc 27 80 00       	mov    $0x8027fc,%ebx
  8000cd:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 de                	mov    %ebx,%esi
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000da:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8000e0:	bb 11 28 80 00       	mov    $0x802811,%ebx
  8000e5:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000f8:	bb 26 28 80 00       	mov    $0x802826,%ebx
  8000fd:	ba 11 00 00 00       	mov    $0x11,%edx
  800102:	89 c7                	mov    %eax,%edi
  800104:	89 de                	mov    %ebx,%esi
  800106:	89 d1                	mov    %edx,%ecx
  800108:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010a:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  800110:	bb 37 28 80 00       	mov    $0x802837,%ebx
  800115:	ba 11 00 00 00       	mov    $0x11,%edx
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	89 de                	mov    %ebx,%esi
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800122:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800128:	bb 48 28 80 00       	mov    $0x802848,%ebx
  80012d:	ba 11 00 00 00       	mov    $0x11,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013a:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800140:	bb 59 28 80 00       	mov    $0x802859,%ebx
  800145:	ba 09 00 00 00       	mov    $0x9,%edx
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 de                	mov    %ebx,%esi
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800152:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  800158:	bb 62 28 80 00       	mov    $0x802862,%ebx
  80015d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	89 d1                	mov    %edx,%ecx
  800168:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016a:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800170:	bb 6c 28 80 00       	mov    $0x80286c,%ebx
  800175:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	bb 77 28 80 00       	mov    $0x802877,%ebx
  80018d:	ba 03 00 00 00       	mov    $0x3,%edx
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 de                	mov    %ebx,%esi
  800196:	89 d1                	mov    %edx,%ecx
  800198:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019a:	8d 85 e6 fe ff ff    	lea    -0x11a(%ebp),%eax
  8001a0:	bb 83 28 80 00       	mov    $0x802883,%ebx
  8001a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	89 de                	mov    %ebx,%esi
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8001b8:	bb 8d 28 80 00       	mov    $0x80288d,%ebx
  8001bd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	89 de                	mov    %ebx,%esi
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001ca:	c7 85 d6 fe ff ff 63 	movl   $0x72656c63,-0x12a(%ebp)
  8001d1:	6c 65 72 
  8001d4:	66 c7 85 da fe ff ff 	movw   $0x6b,-0x126(%ebp)
  8001db:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001dd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  8001e3:	bb 97 28 80 00       	mov    $0x802897,%ebx
  8001e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 de                	mov    %ebx,%esi
  8001f1:	89 d1                	mov    %edx,%ecx
  8001f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f5:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8001fb:	bb a5 28 80 00       	mov    $0x8028a5,%ebx
  800200:	ba 0f 00 00 00       	mov    $0xf,%edx
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 de                	mov    %ebx,%esi
  800209:	89 d1                	mov    %edx,%ecx
  80020b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80020d:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800213:	bb b4 28 80 00       	mov    $0x8028b4,%ebx
  800218:	ba 04 00 00 00       	mov    $0x4,%edx
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	89 d1                	mov    %edx,%ecx
  800223:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800225:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022b:	bb c4 28 80 00       	mov    $0x8028c4,%ebx
  800230:	ba 07 00 00 00       	mov    $0x7,%edx
  800235:	89 c7                	mov    %eax,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  80023d:	8d 85 9b fe ff ff    	lea    -0x165(%ebp),%eax
  800243:	bb cb 28 80 00       	mov    $0x8028cb,%ebx
  800248:	ba 07 00 00 00       	mov    $0x7,%edx
  80024d:	89 c7                	mov    %eax,%edi
  80024f:	89 de                	mov    %ebx,%esi
  800251:	89 d1                	mov    %edx,%ecx
  800253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	e8 e9 19 00 00       	call   801c4d <sget>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* isOpened = sget(parentenvID, _isOpened);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	e8 d4 19 00 00       	call   801c4d <sget>
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	e8 bf 19 00 00       	call   801c4d <sget>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	e8 a7 19 00 00       	call   801c4d <sget>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	e8 8f 19 00 00       	call   801c4d <sget>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	e8 77 19 00 00       	call   801c4d <sget>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	e8 5f 19 00 00       	call   801c4d <sget>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	e8 47 19 00 00       	call   801c4d <sget>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	e8 2f 19 00 00       	call   801c4d <sget>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	e8 17 19 00 00       	call   801c4d <sget>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	89 45 bc             	mov    %eax,-0x44(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  80033c:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  80034b:	52                   	push   %edx
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 62 20 00 00       	call   8023b7 <get_semaphore>
  800355:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800358:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800367:	52                   	push   %edx
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 46 20 00 00       	call   8023b7 <get_semaphore>
  800371:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800374:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	8d 95 e6 fe ff ff    	lea    -0x11a(%ebp),%edx
  800383:	52                   	push   %edx
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 2a 20 00 00       	call   8023b7 <get_semaphore>
  80038d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  800390:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  80039f:	52                   	push   %edx
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	e8 0e 20 00 00       	call   8023b7 <get_semaphore>
  8003a9:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  8003ac:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	8d 95 d6 fe ff ff    	lea    -0x12a(%ebp),%edx
  8003bb:	52                   	push   %edx
  8003bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 f2 1f 00 00       	call   8023b7 <get_semaphore>
  8003c5:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);
  8003c8:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8d 95 a9 fe ff ff    	lea    -0x157(%ebp),%edx
  8003d7:	52                   	push   %edx
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 d6 1f 00 00       	call   8023b7 <get_semaphore>
  8003e1:	83 c4 0c             	add    $0xc,%esp

	while(*isOpened)
  8003e4:	e9 71 03 00 00       	jmp    80075a <_main+0x722>
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
  8003f2:	e8 da 1f 00 00       	call   8023d1 <wait_semaphore>
  8003f7:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800403:	e8 c9 1f 00 00       	call   8023d1 <wait_semaphore>
  800408:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  80040b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 b8             	mov    %eax,-0x48(%ebp)
			//there's no more customers for now...
			if (custId == -1)
  800421:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
  800425:	75 16                	jne    80043d <_main+0x405>
			{
				signal_semaphore(custQueueCS);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800430:	e8 b6 1f 00 00       	call   8023eb <signal_semaphore>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 1d 03 00 00       	jmp    80075a <_main+0x722>
				continue;
			}
			*queue_out = *queue_out +1;
  80043d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 01             	lea    0x1(%eax),%edx
  800445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800453:	e8 93 1f 00 00       	call   8023eb <signal_semaphore>
  800458:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80045b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  80046f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800472:	83 f8 02             	cmp    $0x2,%eax
  800475:	0f 84 9d 00 00 00    	je     800518 <_main+0x4e0>
  80047b:	83 f8 03             	cmp    $0x3,%eax
  80047e:	0f 84 1f 01 00 00    	je     8005a3 <_main+0x56b>
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	0f 85 17 02 00 00    	jne    8006a4 <_main+0x66c>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800496:	e8 36 1f 00 00       	call   8023d1 <wait_semaphore>
  80049b:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80049e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	7e 48                	jle    8004ef <_main+0x4b7>
				{
					*flight1Counter = *flight1Counter - 1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	01 c2                	add    %eax,%edx
  8004db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004de:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 01             	lea    0x1(%eax),%edx
  8004e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	eb 13                	jmp    800502 <_main+0x4ca>
				}
				else
				{
					cprintf("%~\nFlight#1 is FULL! Reservation request of customer#%d is rejected\n", custId);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f5:	68 80 26 80 00       	push   $0x802680
  8004fa:	e8 10 07 00 00       	call   800c0f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  80050b:	e8 db 1e 00 00       	call   8023eb <signal_semaphore>
  800510:	83 c4 10             	add    $0x10,%esp
		}

		break;
  800513:	e9 a3 01 00 00       	jmp    8006bb <_main+0x683>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800521:	e8 ab 1e 00 00       	call   8023d1 <wait_semaphore>
  800526:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	7e 48                	jle    80057a <_main+0x542>
				{
					*flight2Counter = *flight2Counter - 1;
  800532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	8d 50 ff             	lea    -0x1(%eax),%edx
  80053a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053d:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80053f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800542:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800561:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800564:	01 c2                	add    %eax,%edx
  800566:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800569:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80056b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 01             	lea    0x1(%eax),%edx
  800573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	eb 13                	jmp    80058d <_main+0x555>
				}
				else
				{
					cprintf("%~\nFlight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 b8             	pushl  -0x48(%ebp)
  800580:	68 c8 26 80 00       	push   $0x8026c8
  800585:	e8 85 06 00 00       	call   800c0f <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight2CS);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800596:	e8 50 1e 00 00       	call   8023eb <signal_semaphore>
  80059b:	83 c4 10             	add    $0x10,%esp
		}
		break;
  80059e:	e9 18 01 00 00       	jmp    8006bb <_main+0x683>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  8005ac:	e8 20 1e 00 00       	call   8023d1 <wait_semaphore>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  8005bd:	e8 0f 1e 00 00       	call   8023d1 <wait_semaphore>
  8005c2:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8005c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 8e 9b 00 00 00    	jle    80066d <_main+0x635>
  8005d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	0f 8e 8e 00 00 00    	jle    80066d <_main+0x635>
				{
					*flight1Counter = *flight1Counter - 1;
  8005df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8005ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	01 c2                	add    %eax,%edx
  800613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800616:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80062d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800648:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	eb 13                	jmp    800680 <_main+0x648>

				}
				else
				{
					cprintf("%~\nFlight#1 and/or Flight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 b8             	pushl  -0x48(%ebp)
  800673:	68 10 27 80 00       	push   $0x802710
  800678:	e8 92 05 00 00       	call   800c0f <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800689:	e8 5d 1d 00 00       	call   8023eb <signal_semaphore>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  80069a:	e8 4c 1d 00 00       	call   8023eb <signal_semaphore>
  80069f:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8006a2:	eb 17                	jmp    8006bb <_main+0x683>
		default:
			panic("customer must have flight type\n");
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 68 27 80 00       	push   $0x802768
  8006ac:	68 a4 00 00 00       	push   $0xa4
  8006b1:	68 88 27 80 00       	push   $0x802788
  8006b6:	e8 86 02 00 00       	call   800941 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8006bb:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  8006c1:	bb d2 28 80 00       	mov    $0x8028d2,%ebx
  8006c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006cb:	89 c7                	mov    %eax,%edi
  8006cd:	89 de                	mov    %ebx,%esi
  8006cf:	89 d1                	mov    %edx,%ecx
  8006d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006d3:	8d 95 70 fe ff ff    	lea    -0x190(%ebp),%edx
  8006d9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	89 d7                	mov    %edx,%edi
  8006e5:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8006f4:	e8 44 11 00 00       	call   80183d <ltostr>
  8006f9:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	e8 fd 11 00 00       	call   801916 <strcconcat>
  800719:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80071c:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	8d 95 26 fe ff ff    	lea    -0x1da(%ebp),%edx
  80072b:	52                   	push   %edx
  80072c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 82 1c 00 00       	call   8023b7 <get_semaphore>
  800735:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800741:	e8 a5 1c 00 00       	call   8023eb <signal_semaphore>
  800746:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	ff b5 84 fe ff ff    	pushl  -0x17c(%ebp)
  800752:	e8 94 1c 00 00       	call   8023eb <signal_semaphore>
  800757:	83 c4 10             	add    $0x10,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);

	while(*isOpened)
  80075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 85 82 fc ff ff    	jne    8003e9 <_main+0x3b1>

		//signal the clerk
		signal_semaphore(clerk);
	}

	cprintf("\nclerk is finished...........\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 a0 27 80 00       	push   $0x8027a0
  80076f:	e8 9b 04 00 00       	call   800c0f <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(clerkTerminated);
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	ff b5 80 fe ff ff    	pushl  -0x180(%ebp)
  800780:	e8 66 1c 00 00       	call   8023eb <signal_semaphore>
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	90                   	nop
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	57                   	push   %edi
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80079a:	e8 f4 17 00 00       	call   801f93 <sys_getenvindex>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	c1 e0 02             	shl    $0x2,%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b8:	01 d0                	add    %edx,%eax
  8007ba:	c1 e0 02             	shl    $0x2,%eax
  8007bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8007cc:	8a 40 20             	mov    0x20(%eax),%al
  8007cf:	84 c0                	test   %al,%al
  8007d1:	74 0d                	je     8007e0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8007d8:	83 c0 20             	add    $0x20,%eax
  8007db:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e4:	7e 0a                	jle    8007f0 <libmain+0x5f>
		binaryname = argv[0];
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 3a f8 ff ff       	call   800038 <_main>
  8007fe:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800801:	a1 00 40 80 00       	mov    0x804000,%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 84 01 01 00 00    	je     80090f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80080e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800814:	bb e8 29 80 00       	mov    $0x8029e8,%ebx
  800819:	ba 0e 00 00 00       	mov    $0xe,%edx
  80081e:	89 c7                	mov    %eax,%edi
  800820:	89 de                	mov    %ebx,%esi
  800822:	89 d1                	mov    %edx,%ecx
  800824:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800826:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800829:	b9 56 00 00 00       	mov    $0x56,%ecx
  80082e:	b0 00                	mov    $0x0,%al
  800830:	89 d7                	mov    %edx,%edi
  800832:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800834:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80083b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	e8 7b 19 00 00       	call   8021c9 <sys_utilities>
  80084e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800851:	e8 c4 14 00 00       	call   801d1a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800856:	83 ec 0c             	sub    $0xc,%esp
  800859:	68 08 29 80 00       	push   $0x802908
  80085e:	e8 ac 03 00 00       	call   800c0f <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	74 18                	je     800885 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80086d:	e8 75 19 00 00       	call   8021e7 <sys_get_optimal_num_faults>
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 30 29 80 00       	push   $0x802930
  80087b:	e8 8f 03 00 00       	call   800c0f <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	eb 59                	jmp    8008de <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800885:	a1 20 40 80 00       	mov    0x804020,%eax
  80088a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800890:	a1 20 40 80 00       	mov    0x804020,%eax
  800895:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	68 54 29 80 00       	push   $0x802954
  8008a5:	e8 65 03 00 00       	call   800c0f <cprintf>
  8008aa:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b2:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8008b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8008bd:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8008c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8008c8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8008ce:	51                   	push   %ecx
  8008cf:	52                   	push   %edx
  8008d0:	50                   	push   %eax
  8008d1:	68 7c 29 80 00       	push   $0x80297c
  8008d6:	e8 34 03 00 00       	call   800c0f <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008de:	a1 20 40 80 00       	mov    0x804020,%eax
  8008e3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	50                   	push   %eax
  8008ed:	68 d4 29 80 00       	push   $0x8029d4
  8008f2:	e8 18 03 00 00       	call   800c0f <cprintf>
  8008f7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	68 08 29 80 00       	push   $0x802908
  800902:	e8 08 03 00 00       	call   800c0f <cprintf>
  800907:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80090a:	e8 25 14 00 00       	call   801d34 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80090f:	e8 1f 00 00 00       	call   800933 <exit>
}
  800914:	90                   	nop
  800915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5f                   	pop    %edi
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800923:	83 ec 0c             	sub    $0xc,%esp
  800926:	6a 00                	push   $0x0
  800928:	e8 32 16 00 00       	call   801f5f <sys_destroy_env>
  80092d:	83 c4 10             	add    $0x10,%esp
}
  800930:	90                   	nop
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <exit>:

void
exit(void)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800939:	e8 87 16 00 00       	call   801fc5 <sys_exit_env>
}
  80093e:	90                   	nop
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800947:	8d 45 10             	lea    0x10(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800950:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800955:	85 c0                	test   %eax,%eax
  800957:	74 16                	je     80096f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800959:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	50                   	push   %eax
  800962:	68 4c 2a 80 00       	push   $0x802a4c
  800967:	e8 a3 02 00 00       	call   800c0f <cprintf>
  80096c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80096f:	a1 04 40 80 00       	mov    0x804004,%eax
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	50                   	push   %eax
  80097e:	68 54 2a 80 00       	push   $0x802a54
  800983:	6a 74                	push   $0x74
  800985:	e8 b2 02 00 00       	call   800c3c <cprintf_colored>
  80098a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 f4             	pushl  -0xc(%ebp)
  800996:	50                   	push   %eax
  800997:	e8 04 02 00 00       	call   800ba0 <vcprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	6a 00                	push   $0x0
  8009a4:	68 7c 2a 80 00       	push   $0x802a7c
  8009a9:	e8 f2 01 00 00       	call   800ba0 <vcprintf>
  8009ae:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009b1:	e8 7d ff ff ff       	call   800933 <exit>

	// should not return here
	while (1) ;
  8009b6:	eb fe                	jmp    8009b6 <_panic+0x75>

008009b8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009be:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	74 14                	je     8009e4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009d0:	83 ec 04             	sub    $0x4,%esp
  8009d3:	68 80 2a 80 00       	push   $0x802a80
  8009d8:	6a 26                	push   $0x26
  8009da:	68 cc 2a 80 00       	push   $0x802acc
  8009df:	e8 5d ff ff ff       	call   800941 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f2:	e9 c5 00 00 00       	jmp    800abc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 00                	mov    (%eax),%eax
  800a08:	85 c0                	test   %eax,%eax
  800a0a:	75 08                	jne    800a14 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a0c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a0f:	e9 a5 00 00 00       	jmp    800ab9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a22:	eb 69                	jmp    800a8d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a24:	a1 20 40 80 00       	mov    0x804020,%eax
  800a29:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	01 d0                	add    %edx,%eax
  800a38:	c1 e0 03             	shl    $0x3,%eax
  800a3b:	01 c8                	add    %ecx,%eax
  800a3d:	8a 40 04             	mov    0x4(%eax),%al
  800a40:	84 c0                	test   %al,%al
  800a42:	75 46                	jne    800a8a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a44:	a1 20 40 80 00       	mov    0x804020,%eax
  800a49:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	01 c0                	add    %eax,%eax
  800a56:	01 d0                	add    %edx,%eax
  800a58:	c1 e0 03             	shl    $0x3,%eax
  800a5b:	01 c8                	add    %ecx,%eax
  800a5d:	8b 00                	mov    (%eax),%eax
  800a5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a6a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a7d:	39 c2                	cmp    %eax,%edx
  800a7f:	75 09                	jne    800a8a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a81:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a88:	eb 15                	jmp    800a9f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8a:	ff 45 e8             	incl   -0x18(%ebp)
  800a8d:	a1 20 40 80 00       	mov    0x804020,%eax
  800a92:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a9b:	39 c2                	cmp    %eax,%edx
  800a9d:	77 85                	ja     800a24 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa3:	75 14                	jne    800ab9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	68 d8 2a 80 00       	push   $0x802ad8
  800aad:	6a 3a                	push   $0x3a
  800aaf:	68 cc 2a 80 00       	push   $0x802acc
  800ab4:	e8 88 fe ff ff       	call   800941 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ab9:	ff 45 f0             	incl   -0x10(%ebp)
  800abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ac2:	0f 8c 2f ff ff ff    	jl     8009f7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ac8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800acf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ad6:	eb 26                	jmp    800afe <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ad8:	a1 20 40 80 00       	mov    0x804020,%eax
  800add:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae6:	89 d0                	mov    %edx,%eax
  800ae8:	01 c0                	add    %eax,%eax
  800aea:	01 d0                	add    %edx,%eax
  800aec:	c1 e0 03             	shl    $0x3,%eax
  800aef:	01 c8                	add    %ecx,%eax
  800af1:	8a 40 04             	mov    0x4(%eax),%al
  800af4:	3c 01                	cmp    $0x1,%al
  800af6:	75 03                	jne    800afb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800af8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800afb:	ff 45 e0             	incl   -0x20(%ebp)
  800afe:	a1 20 40 80 00       	mov    0x804020,%eax
  800b03:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	77 c8                	ja     800ad8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b13:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b16:	74 14                	je     800b2c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b18:	83 ec 04             	sub    $0x4,%esp
  800b1b:	68 2c 2b 80 00       	push   $0x802b2c
  800b20:	6a 44                	push   $0x44
  800b22:	68 cc 2a 80 00       	push   $0x802acc
  800b27:	e8 15 fe ff ff       	call   800941 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b2c:	90                   	nop
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	53                   	push   %ebx
  800b33:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	89 0a                	mov    %ecx,(%edx)
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
  800b46:	88 d1                	mov    %dl,%cl
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b59:	75 30                	jne    800b8b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b5b:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b61:	a0 44 40 80 00       	mov    0x804044,%al
  800b66:	0f b6 c0             	movzbl %al,%eax
  800b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6c:	8b 09                	mov    (%ecx),%ecx
  800b6e:	89 cb                	mov    %ecx,%ebx
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b73:	83 c1 08             	add    $0x8,%ecx
  800b76:	52                   	push   %edx
  800b77:	50                   	push   %eax
  800b78:	53                   	push   %ebx
  800b79:	51                   	push   %ecx
  800b7a:	e8 57 11 00 00       	call   801cd6 <sys_cputs>
  800b7f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 40 04             	mov    0x4(%eax),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b9a:	90                   	nop
  800b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ba9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bb0:	00 00 00 
	b.cnt = 0;
  800bb3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	68 2f 0b 80 00       	push   $0x800b2f
  800bcf:	e8 5a 02 00 00       	call   800e2e <vprintfmt>
  800bd4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bd7:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bdd:	a0 44 40 80 00       	mov    0x804044,%al
  800be2:	0f b6 c0             	movzbl %al,%eax
  800be5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800beb:	52                   	push   %edx
  800bec:	50                   	push   %eax
  800bed:	51                   	push   %ecx
  800bee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bf4:	83 c0 08             	add    $0x8,%eax
  800bf7:	50                   	push   %eax
  800bf8:	e8 d9 10 00 00       	call   801cd6 <sys_cputs>
  800bfd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c00:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c07:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c15:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c1c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2b:	50                   	push   %eax
  800c2c:	e8 6f ff ff ff       	call   800ba0 <vcprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c42:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	c1 e0 08             	shl    $0x8,%eax
  800c4f:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c54:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c57:	83 c0 04             	add    $0x4,%eax
  800c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	e8 34 ff ff ff       	call   800ba0 <vcprintf>
  800c6c:	83 c4 10             	add    $0x10,%esp
  800c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c72:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c79:	07 00 00 

	return cnt;
  800c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c87:	e8 8e 10 00 00       	call   801d1a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	e8 ff fe ff ff       	call   800ba0 <vcprintf>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ca7:	e8 88 10 00 00       	call   801d34 <sys_unlock_cons>
	return cnt;
  800cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 14             	sub    $0x14,%esp
  800cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc4:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ccf:	77 55                	ja     800d26 <printnum+0x75>
  800cd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd4:	72 05                	jb     800cdb <printnum+0x2a>
  800cd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cd9:	77 4b                	ja     800d26 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cde:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce9:	52                   	push   %edx
  800cea:	50                   	push   %eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf1:	e8 1a 17 00 00       	call   802410 <__udivdi3>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	83 ec 04             	sub    $0x4,%esp
  800cfc:	ff 75 20             	pushl  0x20(%ebp)
  800cff:	53                   	push   %ebx
  800d00:	ff 75 18             	pushl  0x18(%ebp)
  800d03:	52                   	push   %edx
  800d04:	50                   	push   %eax
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	ff 75 08             	pushl  0x8(%ebp)
  800d0b:	e8 a1 ff ff ff       	call   800cb1 <printnum>
  800d10:	83 c4 20             	add    $0x20,%esp
  800d13:	eb 1a                	jmp    800d2f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	ff 75 20             	pushl  0x20(%ebp)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	ff d0                	call   *%eax
  800d23:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d26:	ff 4d 1c             	decl   0x1c(%ebp)
  800d29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2d:	7f e6                	jg     800d15 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d2f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3d:	53                   	push   %ebx
  800d3e:	51                   	push   %ecx
  800d3f:	52                   	push   %edx
  800d40:	50                   	push   %eax
  800d41:	e8 da 17 00 00       	call   802520 <__umoddi3>
  800d46:	83 c4 10             	add    $0x10,%esp
  800d49:	05 94 2d 80 00       	add    $0x802d94,%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	0f be c0             	movsbl %al,%eax
  800d53:	83 ec 08             	sub    $0x8,%esp
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	50                   	push   %eax
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
}
  800d62:	90                   	nop
  800d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d6f:	7e 1c                	jle    800d8d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	8d 50 08             	lea    0x8(%eax),%edx
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	89 10                	mov    %edx,(%eax)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	83 e8 08             	sub    $0x8,%eax
  800d86:	8b 50 04             	mov    0x4(%eax),%edx
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	eb 40                	jmp    800dcd <getuint+0x65>
	else if (lflag)
  800d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d91:	74 1e                	je     800db1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	8d 50 04             	lea    0x4(%eax),%edx
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 10                	mov    %edx,(%eax)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	83 e8 04             	sub    $0x4,%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	eb 1c                	jmp    800dcd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	8d 50 04             	lea    0x4(%eax),%edx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 10                	mov    %edx,(%eax)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	83 e8 04             	sub    $0x4,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd6:	7e 1c                	jle    800df4 <getint+0x25>
		return va_arg(*ap, long long);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8b 00                	mov    (%eax),%eax
  800ddd:	8d 50 08             	lea    0x8(%eax),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 10                	mov    %edx,(%eax)
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	83 e8 08             	sub    $0x8,%eax
  800ded:	8b 50 04             	mov    0x4(%eax),%edx
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	eb 38                	jmp    800e2c <getint+0x5d>
	else if (lflag)
  800df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df8:	74 1a                	je     800e14 <getint+0x45>
		return va_arg(*ap, long);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	8d 50 04             	lea    0x4(%eax),%edx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 10                	mov    %edx,(%eax)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	83 e8 04             	sub    $0x4,%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	99                   	cltd   
  800e12:	eb 18                	jmp    800e2c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8b 00                	mov    (%eax),%eax
  800e19:	8d 50 04             	lea    0x4(%eax),%edx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 10                	mov    %edx,(%eax)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	99                   	cltd   
}
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e36:	eb 17                	jmp    800e4f <vprintfmt+0x21>
			if (ch == '\0')
  800e38:	85 db                	test   %ebx,%ebx
  800e3a:	0f 84 c1 03 00 00    	je     801201 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	53                   	push   %ebx
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d8             	movzbl %al,%ebx
  800e5d:	83 fb 25             	cmp    $0x25,%ebx
  800e60:	75 d6                	jne    800e38 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e62:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e82:	8b 45 10             	mov    0x10(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 d8             	movzbl %al,%ebx
  800e90:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e93:	83 f8 5b             	cmp    $0x5b,%eax
  800e96:	0f 87 3d 03 00 00    	ja     8011d9 <vprintfmt+0x3ab>
  800e9c:	8b 04 85 b8 2d 80 00 	mov    0x802db8(,%eax,4),%eax
  800ea3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ea9:	eb d7                	jmp    800e82 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eaf:	eb d1                	jmp    800e82 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebb:	89 d0                	mov    %edx,%eax
  800ebd:	c1 e0 02             	shl    $0x2,%eax
  800ec0:	01 d0                	add    %edx,%eax
  800ec2:	01 c0                	add    %eax,%eax
  800ec4:	01 d8                	add    %ebx,%eax
  800ec6:	83 e8 30             	sub    $0x30,%eax
  800ec9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed7:	7e 3e                	jle    800f17 <vprintfmt+0xe9>
  800ed9:	83 fb 39             	cmp    $0x39,%ebx
  800edc:	7f 39                	jg     800f17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ede:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee1:	eb d5                	jmp    800eb8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee6:	83 c0 04             	add    $0x4,%eax
  800ee9:	89 45 14             	mov    %eax,0x14(%ebp)
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 e8 04             	sub    $0x4,%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef7:	eb 1f                	jmp    800f18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ef9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800efd:	79 83                	jns    800e82 <vprintfmt+0x54>
				width = 0;
  800eff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f06:	e9 77 ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f12:	e9 6b ff ff ff       	jmp    800e82 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1c:	0f 89 60 ff ff ff    	jns    800e82 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f2f:	e9 4e ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f37:	e9 46 ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 14             	mov    %eax,0x14(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 e8 04             	sub    $0x4,%eax
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	50                   	push   %eax
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
			break;
  800f5c:	e9 9b 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f61:	8b 45 14             	mov    0x14(%ebp),%eax
  800f64:	83 c0 04             	add    $0x4,%eax
  800f67:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 e8 04             	sub    $0x4,%eax
  800f70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f72:	85 db                	test   %ebx,%ebx
  800f74:	79 02                	jns    800f78 <vprintfmt+0x14a>
				err = -err;
  800f76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f78:	83 fb 64             	cmp    $0x64,%ebx
  800f7b:	7f 0b                	jg     800f88 <vprintfmt+0x15a>
  800f7d:	8b 34 9d 00 2c 80 00 	mov    0x802c00(,%ebx,4),%esi
  800f84:	85 f6                	test   %esi,%esi
  800f86:	75 19                	jne    800fa1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f88:	53                   	push   %ebx
  800f89:	68 a5 2d 80 00       	push   $0x802da5
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	e8 70 02 00 00       	call   801209 <printfmt>
  800f99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9c:	e9 5b 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa1:	56                   	push   %esi
  800fa2:	68 ae 2d 80 00       	push   $0x802dae
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 57 02 00 00       	call   801209 <printfmt>
  800fb2:	83 c4 10             	add    $0x10,%esp
			break;
  800fb5:	e9 42 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fba:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbd:	83 c0 04             	add    $0x4,%eax
  800fc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 e8 04             	sub    $0x4,%eax
  800fc9:	8b 30                	mov    (%eax),%esi
  800fcb:	85 f6                	test   %esi,%esi
  800fcd:	75 05                	jne    800fd4 <vprintfmt+0x1a6>
				p = "(null)";
  800fcf:	be b1 2d 80 00       	mov    $0x802db1,%esi
			if (width > 0 && padc != '-')
  800fd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd8:	7e 6d                	jle    801047 <vprintfmt+0x219>
  800fda:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fde:	74 67                	je     801047 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	50                   	push   %eax
  800fe7:	56                   	push   %esi
  800fe8:	e8 1e 03 00 00       	call   80130b <strnlen>
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff3:	eb 16                	jmp    80100b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	50                   	push   %eax
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	ff d0                	call   *%eax
  801005:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801008:	ff 4d e4             	decl   -0x1c(%ebp)
  80100b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80100f:	7f e4                	jg     800ff5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801011:	eb 34                	jmp    801047 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801013:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801017:	74 1c                	je     801035 <vprintfmt+0x207>
  801019:	83 fb 1f             	cmp    $0x1f,%ebx
  80101c:	7e 05                	jle    801023 <vprintfmt+0x1f5>
  80101e:	83 fb 7e             	cmp    $0x7e,%ebx
  801021:	7e 12                	jle    801035 <vprintfmt+0x207>
					putch('?', putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	6a 3f                	push   $0x3f
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	ff d0                	call   *%eax
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	eb 0f                	jmp    801044 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	53                   	push   %ebx
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	ff d0                	call   *%eax
  801041:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801044:	ff 4d e4             	decl   -0x1c(%ebp)
  801047:	89 f0                	mov    %esi,%eax
  801049:	8d 70 01             	lea    0x1(%eax),%esi
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be d8             	movsbl %al,%ebx
  801051:	85 db                	test   %ebx,%ebx
  801053:	74 24                	je     801079 <vprintfmt+0x24b>
  801055:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801059:	78 b8                	js     801013 <vprintfmt+0x1e5>
  80105b:	ff 4d e0             	decl   -0x20(%ebp)
  80105e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801062:	79 af                	jns    801013 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801064:	eb 13                	jmp    801079 <vprintfmt+0x24b>
				putch(' ', putdat);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	ff 75 0c             	pushl  0xc(%ebp)
  80106c:	6a 20                	push   $0x20
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	ff d0                	call   *%eax
  801073:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801076:	ff 4d e4             	decl   -0x1c(%ebp)
  801079:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107d:	7f e7                	jg     801066 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80107f:	e9 78 01 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 e8             	pushl  -0x18(%ebp)
  80108a:	8d 45 14             	lea    0x14(%ebp),%eax
  80108d:	50                   	push   %eax
  80108e:	e8 3c fd ff ff       	call   800dcf <getint>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a2:	85 d2                	test   %edx,%edx
  8010a4:	79 23                	jns    8010c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ac:	6a 2d                	push   $0x2d
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	ff d0                	call   *%eax
  8010b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bc:	f7 d8                	neg    %eax
  8010be:	83 d2 00             	adc    $0x0,%edx
  8010c1:	f7 da                	neg    %edx
  8010c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d0:	e9 bc 00 00 00       	jmp    801191 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d5:	83 ec 08             	sub    $0x8,%esp
  8010d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010db:	8d 45 14             	lea    0x14(%ebp),%eax
  8010de:	50                   	push   %eax
  8010df:	e8 84 fc ff ff       	call   800d68 <getuint>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f4:	e9 98 00 00 00       	jmp    801191 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	ff 75 0c             	pushl  0xc(%ebp)
  8010ff:	6a 58                	push   $0x58
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	ff d0                	call   *%eax
  801106:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	6a 58                	push   $0x58
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	ff d0                	call   *%eax
  801116:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	6a 58                	push   $0x58
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	ff d0                	call   *%eax
  801126:	83 c4 10             	add    $0x10,%esp
			break;
  801129:	e9 ce 00 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	6a 30                	push   $0x30
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	ff d0                	call   *%eax
  80113b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80113e:	83 ec 08             	sub    $0x8,%esp
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	6a 78                	push   $0x78
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	ff d0                	call   *%eax
  80114b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80114e:	8b 45 14             	mov    0x14(%ebp),%eax
  801151:	83 c0 04             	add    $0x4,%eax
  801154:	89 45 14             	mov    %eax,0x14(%ebp)
  801157:	8b 45 14             	mov    0x14(%ebp),%eax
  80115a:	83 e8 04             	sub    $0x4,%eax
  80115d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801169:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801170:	eb 1f                	jmp    801191 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	ff 75 e8             	pushl  -0x18(%ebp)
  801178:	8d 45 14             	lea    0x14(%ebp),%eax
  80117b:	50                   	push   %eax
  80117c:	e8 e7 fb ff ff       	call   800d68 <getuint>
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801187:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801191:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	52                   	push   %edx
  80119c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119f:	50                   	push   %eax
  8011a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	e8 00 fb ff ff       	call   800cb1 <printnum>
  8011b1:	83 c4 20             	add    $0x20,%esp
			break;
  8011b4:	eb 46                	jmp    8011fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	53                   	push   %ebx
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			break;
  8011c5:	eb 35                	jmp    8011fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011c7:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011ce:	eb 2c                	jmp    8011fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011d0:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011d7:	eb 23                	jmp    8011fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	6a 25                	push   $0x25
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	ff d0                	call   *%eax
  8011e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011e9:	ff 4d 10             	decl   0x10(%ebp)
  8011ec:	eb 03                	jmp    8011f1 <vprintfmt+0x3c3>
  8011ee:	ff 4d 10             	decl   0x10(%ebp)
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	48                   	dec    %eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 25                	cmp    $0x25,%al
  8011f9:	75 f3                	jne    8011ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011fb:	90                   	nop
		}
	}
  8011fc:	e9 35 fc ff ff       	jmp    800e36 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801201:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80120f:	8d 45 10             	lea    0x10(%ebp),%eax
  801212:	83 c0 04             	add    $0x4,%eax
  801215:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	ff 75 f4             	pushl  -0xc(%ebp)
  80121e:	50                   	push   %eax
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	e8 04 fc ff ff       	call   800e2e <vprintfmt>
  80122a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8b 40 08             	mov    0x8(%eax),%eax
  801239:	8d 50 01             	lea    0x1(%eax),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	8b 10                	mov    (%eax),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	8b 40 04             	mov    0x4(%eax),%eax
  80124d:	39 c2                	cmp    %eax,%edx
  80124f:	73 12                	jae    801263 <sprintputch+0x33>
		*b->buf++ = ch;
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	8b 00                	mov    (%eax),%eax
  801256:	8d 48 01             	lea    0x1(%eax),%ecx
  801259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125c:	89 0a                	mov    %ecx,(%edx)
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	88 10                	mov    %dl,(%eax)
}
  801263:	90                   	nop
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	8d 50 ff             	lea    -0x1(%eax),%edx
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128b:	74 06                	je     801293 <vsnprintf+0x2d>
  80128d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801291:	7f 07                	jg     80129a <vsnprintf+0x34>
		return -E_INVAL;
  801293:	b8 03 00 00 00       	mov    $0x3,%eax
  801298:	eb 20                	jmp    8012ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80129a:	ff 75 14             	pushl  0x14(%ebp)
  80129d:	ff 75 10             	pushl  0x10(%ebp)
  8012a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	68 30 12 80 00       	push   $0x801230
  8012a9:	e8 80 fb ff ff       	call   800e2e <vprintfmt>
  8012ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c5:	83 c0 04             	add    $0x4,%eax
  8012c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d1:	50                   	push   %eax
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	ff 75 08             	pushl  0x8(%ebp)
  8012d8:	e8 89 ff ff ff       	call   801266 <vsnprintf>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f5:	eb 06                	jmp    8012fd <strlen+0x15>
		n++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012fa:	ff 45 08             	incl   0x8(%ebp)
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 f1                	jne    8012f7 <strlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801311:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801318:	eb 09                	jmp    801323 <strnlen+0x18>
		n++;
  80131a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131d:	ff 45 08             	incl   0x8(%ebp)
  801320:	ff 4d 0c             	decl   0xc(%ebp)
  801323:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801327:	74 09                	je     801332 <strnlen+0x27>
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	84 c0                	test   %al,%al
  801330:	75 e8                	jne    80131a <strnlen+0xf>
		n++;
	return n;
  801332:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801343:	90                   	nop
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 08             	mov    %edx,0x8(%ebp)
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8d 4a 01             	lea    0x1(%edx),%ecx
  801353:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801356:	8a 12                	mov    (%edx),%dl
  801358:	88 10                	mov    %dl,(%eax)
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	75 e4                	jne    801344 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801378:	eb 1f                	jmp    801399 <strncpy+0x34>
		*dst++ = *src;
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8d 50 01             	lea    0x1(%eax),%edx
  801380:	89 55 08             	mov    %edx,0x8(%ebp)
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	8a 12                	mov    (%edx),%dl
  801388:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	84 c0                	test   %al,%al
  801391:	74 03                	je     801396 <strncpy+0x31>
			src++;
  801393:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801396:	ff 45 fc             	incl   -0x4(%ebp)
  801399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80139f:	72 d9                	jb     80137a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b6:	74 30                	je     8013e8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013b8:	eb 16                	jmp    8013d0 <strlcpy+0x2a>
			*dst++ = *src++;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8d 50 01             	lea    0x1(%eax),%edx
  8013c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cc:	8a 12                	mov    (%edx),%dl
  8013ce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013d0:	ff 4d 10             	decl   0x10(%ebp)
  8013d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d7:	74 09                	je     8013e2 <strlcpy+0x3c>
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	84 c0                	test   %al,%al
  8013e0:	75 d8                	jne    8013ba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013f7:	eb 06                	jmp    8013ff <strcmp+0xb>
		p++, q++;
  8013f9:	ff 45 08             	incl   0x8(%ebp)
  8013fc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 0e                	je     801416 <strcmp+0x22>
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 10                	mov    (%eax),%dl
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	38 c2                	cmp    %al,%dl
  801414:	74 e3                	je     8013f9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	0f b6 d0             	movzbl %al,%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	0f b6 c0             	movzbl %al,%eax
  801426:	29 c2                	sub    %eax,%edx
  801428:	89 d0                	mov    %edx,%eax
}
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80142f:	eb 09                	jmp    80143a <strncmp+0xe>
		n--, p++, q++;
  801431:	ff 4d 10             	decl   0x10(%ebp)
  801434:	ff 45 08             	incl   0x8(%ebp)
  801437:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80143a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143e:	74 17                	je     801457 <strncmp+0x2b>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 0e                	je     801457 <strncmp+0x2b>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 10                	mov    (%eax),%dl
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	38 c2                	cmp    %al,%dl
  801455:	74 da                	je     801431 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801457:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145b:	75 07                	jne    801464 <strncmp+0x38>
		return 0;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb 14                	jmp    801478 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	0f b6 d0             	movzbl %al,%edx
  80146c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f b6 c0             	movzbl %al,%eax
  801474:	29 c2                	sub    %eax,%edx
  801476:	89 d0                	mov    %edx,%eax
}
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    

0080147a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	8b 45 0c             	mov    0xc(%ebp),%eax
  801483:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801486:	eb 12                	jmp    80149a <strchr+0x20>
		if (*s == c)
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801490:	75 05                	jne    801497 <strchr+0x1d>
			return (char *) s;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	eb 11                	jmp    8014a8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801497:	ff 45 08             	incl   0x8(%ebp)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 e5                	jne    801488 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014b6:	eb 0d                	jmp    8014c5 <strfind+0x1b>
		if (*s == c)
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014c0:	74 0e                	je     8014d0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c2:	ff 45 08             	incl   0x8(%ebp)
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	84 c0                	test   %al,%al
  8014cc:	75 ea                	jne    8014b8 <strfind+0xe>
  8014ce:	eb 01                	jmp    8014d1 <strfind+0x27>
		if (*s == c)
			break;
  8014d0:	90                   	nop
	return (char *) s;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014e6:	76 63                	jbe    80154b <memset+0x75>
		uint64 data_block = c;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	99                   	cltd   
  8014ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014fc:	c1 e0 08             	shl    $0x8,%eax
  8014ff:	09 45 f0             	or     %eax,-0x10(%ebp)
  801502:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80150f:	c1 e0 10             	shl    $0x10,%eax
  801512:	09 45 f0             	or     %eax,-0x10(%ebp)
  801515:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151e:	89 c2                	mov    %eax,%edx
  801520:	b8 00 00 00 00       	mov    $0x0,%eax
  801525:	09 45 f0             	or     %eax,-0x10(%ebp)
  801528:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80152b:	eb 18                	jmp    801545 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80152d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801530:	8d 41 08             	lea    0x8(%ecx),%eax
  801533:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153c:	89 01                	mov    %eax,(%ecx)
  80153e:	89 51 04             	mov    %edx,0x4(%ecx)
  801541:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801545:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801549:	77 e2                	ja     80152d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80154b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154f:	74 23                	je     801574 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801557:	eb 0e                	jmp    801567 <memset+0x91>
			*p8++ = (uint8)c;
  801559:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155c:	8d 50 01             	lea    0x1(%eax),%edx
  80155f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156d:	89 55 10             	mov    %edx,0x10(%ebp)
  801570:	85 c0                	test   %eax,%eax
  801572:	75 e5                	jne    801559 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80158b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80158f:	76 24                	jbe    8015b5 <memcpy+0x3c>
		while(n >= 8){
  801591:	eb 1c                	jmp    8015af <memcpy+0x36>
			*d64 = *s64;
  801593:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801596:	8b 50 04             	mov    0x4(%eax),%edx
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80159e:	89 01                	mov    %eax,(%ecx)
  8015a0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015a3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015a7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015ab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015b3:	77 de                	ja     801593 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b9:	74 31                	je     8015ec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015c7:	eb 16                	jmp    8015df <memcpy+0x66>
			*d8++ = *s8++;
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8d 50 01             	lea    0x1(%eax),%edx
  8015cf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015db:	8a 12                	mov    (%edx),%dl
  8015dd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015df:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	75 dd                	jne    8015c9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801603:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801606:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801609:	73 50                	jae    80165b <memmove+0x6a>
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801616:	76 43                	jbe    80165b <memmove+0x6a>
		s += n;
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80161e:	8b 45 10             	mov    0x10(%ebp),%eax
  801621:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801624:	eb 10                	jmp    801636 <memmove+0x45>
			*--d = *--s;
  801626:	ff 4d f8             	decl   -0x8(%ebp)
  801629:	ff 4d fc             	decl   -0x4(%ebp)
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162f:	8a 10                	mov    (%eax),%dl
  801631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801634:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801636:	8b 45 10             	mov    0x10(%ebp),%eax
  801639:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163c:	89 55 10             	mov    %edx,0x10(%ebp)
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 e3                	jne    801626 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801643:	eb 23                	jmp    801668 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80167f:	eb 2a                	jmp    8016ab <memcmp+0x3e>
		if (*s1 != *s2)
  801681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801684:	8a 10                	mov    (%eax),%dl
  801686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	38 c2                	cmp    %al,%dl
  80168d:	74 16                	je     8016a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	0f b6 d0             	movzbl %al,%edx
  801697:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	0f b6 c0             	movzbl %al,%eax
  80169f:	29 c2                	sub    %eax,%edx
  8016a1:	89 d0                	mov    %edx,%eax
  8016a3:	eb 18                	jmp    8016bd <memcmp+0x50>
		s1++, s2++;
  8016a5:	ff 45 fc             	incl   -0x4(%ebp)
  8016a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 c9                	jne    801681 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016d0:	eb 15                	jmp    8016e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	0f b6 d0             	movzbl %al,%edx
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	0f b6 c0             	movzbl %al,%eax
  8016e0:	39 c2                	cmp    %eax,%edx
  8016e2:	74 0d                	je     8016f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e4:	ff 45 08             	incl   0x8(%ebp)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ed:	72 e3                	jb     8016d2 <memfind+0x13>
  8016ef:	eb 01                	jmp    8016f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016f1:	90                   	nop
	return (void *) s;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801704:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170b:	eb 03                	jmp    801710 <strtol+0x19>
		s++;
  80170d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	3c 20                	cmp    $0x20,%al
  801717:	74 f4                	je     80170d <strtol+0x16>
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3c 09                	cmp    $0x9,%al
  801720:	74 eb                	je     80170d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	3c 2b                	cmp    $0x2b,%al
  801729:	75 05                	jne    801730 <strtol+0x39>
		s++;
  80172b:	ff 45 08             	incl   0x8(%ebp)
  80172e:	eb 13                	jmp    801743 <strtol+0x4c>
	else if (*s == '-')
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	3c 2d                	cmp    $0x2d,%al
  801737:	75 0a                	jne    801743 <strtol+0x4c>
		s++, neg = 1;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801743:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801747:	74 06                	je     80174f <strtol+0x58>
  801749:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80174d:	75 20                	jne    80176f <strtol+0x78>
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	3c 30                	cmp    $0x30,%al
  801756:	75 17                	jne    80176f <strtol+0x78>
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	40                   	inc    %eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 78                	cmp    $0x78,%al
  801760:	75 0d                	jne    80176f <strtol+0x78>
		s += 2, base = 16;
  801762:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801766:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80176d:	eb 28                	jmp    801797 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80176f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801773:	75 15                	jne    80178a <strtol+0x93>
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	3c 30                	cmp    $0x30,%al
  80177c:	75 0c                	jne    80178a <strtol+0x93>
		s++, base = 8;
  80177e:	ff 45 08             	incl   0x8(%ebp)
  801781:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801788:	eb 0d                	jmp    801797 <strtol+0xa0>
	else if (base == 0)
  80178a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80178e:	75 07                	jne    801797 <strtol+0xa0>
		base = 10;
  801790:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 2f                	cmp    $0x2f,%al
  80179e:	7e 19                	jle    8017b9 <strtol+0xc2>
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	3c 39                	cmp    $0x39,%al
  8017a7:	7f 10                	jg     8017b9 <strtol+0xc2>
			dig = *s - '0';
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8a 00                	mov    (%eax),%al
  8017ae:	0f be c0             	movsbl %al,%eax
  8017b1:	83 e8 30             	sub    $0x30,%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b7:	eb 42                	jmp    8017fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	3c 60                	cmp    $0x60,%al
  8017c0:	7e 19                	jle    8017db <strtol+0xe4>
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	3c 7a                	cmp    $0x7a,%al
  8017c9:	7f 10                	jg     8017db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f be c0             	movsbl %al,%eax
  8017d3:	83 e8 57             	sub    $0x57,%eax
  8017d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d9:	eb 20                	jmp    8017fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8a 00                	mov    (%eax),%al
  8017e0:	3c 40                	cmp    $0x40,%al
  8017e2:	7e 39                	jle    80181d <strtol+0x126>
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	3c 5a                	cmp    $0x5a,%al
  8017eb:	7f 30                	jg     80181d <strtol+0x126>
			dig = *s - 'A' + 10;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	0f be c0             	movsbl %al,%eax
  8017f5:	83 e8 37             	sub    $0x37,%eax
  8017f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801801:	7d 19                	jge    80181c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801803:	ff 45 08             	incl   0x8(%ebp)
  801806:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801809:	0f af 45 10          	imul   0x10(%ebp),%eax
  80180d:	89 c2                	mov    %eax,%edx
  80180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801817:	e9 7b ff ff ff       	jmp    801797 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80181c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80181d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801821:	74 08                	je     80182b <strtol+0x134>
		*endptr = (char *) s;
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	8b 55 08             	mov    0x8(%ebp),%edx
  801829:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80182b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80182f:	74 07                	je     801838 <strtol+0x141>
  801831:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801834:	f7 d8                	neg    %eax
  801836:	eb 03                	jmp    80183b <strtol+0x144>
  801838:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <ltostr>:

void
ltostr(long value, char *str)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801843:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80184a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801855:	79 13                	jns    80186a <ltostr+0x2d>
	{
		neg = 1;
  801857:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801864:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801867:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801872:	99                   	cltd   
  801873:	f7 f9                	idiv   %ecx
  801875:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801878:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187b:	8d 50 01             	lea    0x1(%eax),%edx
  80187e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801881:	89 c2                	mov    %eax,%edx
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188b:	83 c2 30             	add    $0x30,%edx
  80188e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801890:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801893:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801898:	f7 e9                	imul   %ecx
  80189a:	c1 fa 02             	sar    $0x2,%edx
  80189d:	89 c8                	mov    %ecx,%eax
  80189f:	c1 f8 1f             	sar    $0x1f,%eax
  8018a2:	29 c2                	sub    %eax,%edx
  8018a4:	89 d0                	mov    %edx,%eax
  8018a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ad:	75 bb                	jne    80186a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b9:	48                   	dec    %eax
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c1:	74 3d                	je     801900 <ltostr+0xc3>
		start = 1 ;
  8018c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018ca:	eb 34                	jmp    801900 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d2:	01 d0                	add    %edx,%eax
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 c2                	add    %eax,%edx
  8018e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 c8                	add    %ecx,%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 c2                	add    %eax,%edx
  8018f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8018fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801906:	7c c4                	jl     8018cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801908:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 c4 f9 ff ff       	call   8012e8 <strlen>
  801924:	83 c4 04             	add    $0x4,%esp
  801927:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 b6 f9 ff ff       	call   8012e8 <strlen>
  801932:	83 c4 04             	add    $0x4,%esp
  801935:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801938:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80193f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801946:	eb 17                	jmp    80195f <strcconcat+0x49>
		final[s] = str1[s] ;
  801948:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194b:	8b 45 10             	mov    0x10(%ebp),%eax
  80194e:	01 c2                	add    %eax,%edx
  801950:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	01 c8                	add    %ecx,%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80195c:	ff 45 fc             	incl   -0x4(%ebp)
  80195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801965:	7c e1                	jl     801948 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801967:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80196e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801975:	eb 1f                	jmp    801996 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197a:	8d 50 01             	lea    0x1(%eax),%edx
  80197d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801980:	89 c2                	mov    %eax,%edx
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	01 c2                	add    %eax,%edx
  801987:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	01 c8                	add    %ecx,%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801993:	ff 45 f8             	incl   -0x8(%ebp)
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199c:	7c d9                	jl     801977 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80199e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019af:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bb:	8b 00                	mov    (%eax),%eax
  8019bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c7:	01 d0                	add    %edx,%eax
  8019c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019cf:	eb 0c                	jmp    8019dd <strsplit+0x31>
			*string++ = 0;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8d 50 01             	lea    0x1(%eax),%edx
  8019d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8019da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8a 00                	mov    (%eax),%al
  8019e2:	84 c0                	test   %al,%al
  8019e4:	74 18                	je     8019fe <strsplit+0x52>
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	0f be c0             	movsbl %al,%eax
  8019ee:	50                   	push   %eax
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 83 fa ff ff       	call   80147a <strchr>
  8019f7:	83 c4 08             	add    $0x8,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	75 d3                	jne    8019d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	8a 00                	mov    (%eax),%al
  801a03:	84 c0                	test   %al,%al
  801a05:	74 5a                	je     801a61 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	83 f8 0f             	cmp    $0xf,%eax
  801a0f:	75 07                	jne    801a18 <strsplit+0x6c>
		{
			return 0;
  801a11:	b8 00 00 00 00       	mov    $0x0,%eax
  801a16:	eb 66                	jmp    801a7e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	8b 00                	mov    (%eax),%eax
  801a1d:	8d 48 01             	lea    0x1(%eax),%ecx
  801a20:	8b 55 14             	mov    0x14(%ebp),%edx
  801a23:	89 0a                	mov    %ecx,(%edx)
  801a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	01 c2                	add    %eax,%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a36:	eb 03                	jmp    801a3b <strsplit+0x8f>
			string++;
  801a38:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8a 00                	mov    (%eax),%al
  801a40:	84 c0                	test   %al,%al
  801a42:	74 8b                	je     8019cf <strsplit+0x23>
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f be c0             	movsbl %al,%eax
  801a4c:	50                   	push   %eax
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	e8 25 fa ff ff       	call   80147a <strchr>
  801a55:	83 c4 08             	add    $0x8,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	74 dc                	je     801a38 <strsplit+0x8c>
			string++;
	}
  801a5c:	e9 6e ff ff ff       	jmp    8019cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a61:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a62:	8b 45 14             	mov    0x14(%ebp),%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	01 d0                	add    %edx,%eax
  801a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a93:	eb 4a                	jmp    801adf <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	01 c2                	add    %eax,%edx
  801a9d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	01 c8                	add    %ecx,%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801aa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	3c 40                	cmp    $0x40,%al
  801ab5:	7e 25                	jle    801adc <str2lower+0x5c>
  801ab7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	01 d0                	add    %edx,%eax
  801abf:	8a 00                	mov    (%eax),%al
  801ac1:	3c 5a                	cmp    $0x5a,%al
  801ac3:	7f 17                	jg     801adc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ac5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad3:	01 ca                	add    %ecx,%edx
  801ad5:	8a 12                	mov    (%edx),%dl
  801ad7:	83 c2 20             	add    $0x20,%edx
  801ada:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801adc:	ff 45 fc             	incl   -0x4(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	e8 01 f8 ff ff       	call   8012e8 <strlen>
  801ae7:	83 c4 04             	add    $0x4,%esp
  801aea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801aed:	7f a6                	jg     801a95 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801afa:	a1 08 40 80 00       	mov    0x804008,%eax
  801aff:	85 c0                	test   %eax,%eax
  801b01:	74 42                	je     801b45 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	68 00 00 00 82       	push   $0x82000000
  801b0b:	68 00 00 00 80       	push   $0x80000000
  801b10:	e8 8c 07 00 00       	call   8022a1 <initialize_dynamic_allocator>
  801b15:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b18:	e8 e7 05 00 00       	call   802104 <sys_get_uheap_strategy>
  801b1d:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b22:	a1 40 40 80 00       	mov    0x804040,%eax
  801b27:	05 00 10 00 00       	add    $0x1000,%eax
  801b2c:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b31:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b36:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b3b:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b42:	00 00 00 
	}
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b5c:	83 ec 08             	sub    $0x8,%esp
  801b5f:	68 06 04 00 00       	push   $0x406
  801b64:	50                   	push   %eax
  801b65:	e8 e4 01 00 00       	call   801d4e <__sys_allocate_page>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b74:	79 14                	jns    801b8a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 28 2f 80 00       	push   $0x802f28
  801b7e:	6a 1f                	push   $0x1f
  801b80:	68 64 2f 80 00       	push   $0x802f64
  801b85:	e8 b7 ed ff ff       	call   800941 <_panic>
	return 0;
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	50                   	push   %eax
  801ba9:	e8 e7 01 00 00       	call   801d95 <__sys_unmap_frame>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb8:	79 14                	jns    801bce <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 70 2f 80 00       	push   $0x802f70
  801bc2:	6a 2a                	push   $0x2a
  801bc4:	68 64 2f 80 00       	push   $0x802f64
  801bc9:	e8 73 ed ff ff       	call   800941 <_panic>
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bd7:	e8 18 ff ff ff       	call   801af4 <uheap_init>
	if (size == 0) return NULL ;
  801bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be0:	75 07                	jne    801be9 <malloc+0x18>
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	eb 14                	jmp    801bfd <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	68 b0 2f 80 00       	push   $0x802fb0
  801bf1:	6a 3e                	push   $0x3e
  801bf3:	68 64 2f 80 00       	push   $0x802f64
  801bf8:	e8 44 ed ff ff       	call   800941 <_panic>
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	68 d8 2f 80 00       	push   $0x802fd8
  801c0d:	6a 49                	push   $0x49
  801c0f:	68 64 2f 80 00       	push   $0x802f64
  801c14:	e8 28 ed ff ff       	call   800941 <_panic>

00801c19 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 18             	sub    $0x18,%esp
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c25:	e8 ca fe ff ff       	call   801af4 <uheap_init>
	if (size == 0) return NULL ;
  801c2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c2e:	75 07                	jne    801c37 <smalloc+0x1e>
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	eb 14                	jmp    801c4b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 fc 2f 80 00       	push   $0x802ffc
  801c3f:	6a 5a                	push   $0x5a
  801c41:	68 64 2f 80 00       	push   $0x802f64
  801c46:	e8 f6 ec ff ff       	call   800941 <_panic>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c53:	e8 9c fe ff ff       	call   801af4 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	68 24 30 80 00       	push   $0x803024
  801c60:	6a 6a                	push   $0x6a
  801c62:	68 64 2f 80 00       	push   $0x802f64
  801c67:	e8 d5 ec ff ff       	call   800941 <_panic>

00801c6c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c72:	e8 7d fe ff ff       	call   801af4 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	68 48 30 80 00       	push   $0x803048
  801c7f:	68 88 00 00 00       	push   $0x88
  801c84:	68 64 2f 80 00       	push   $0x802f64
  801c89:	e8 b3 ec ff ff       	call   800941 <_panic>

00801c8e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	68 70 30 80 00       	push   $0x803070
  801c9c:	68 9b 00 00 00       	push   $0x9b
  801ca1:	68 64 2f 80 00       	push   $0x802f64
  801ca6:	e8 96 ec ff ff       	call   800941 <_panic>

00801cab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	57                   	push   %edi
  801caf:	56                   	push   %esi
  801cb0:	53                   	push   %ebx
  801cb1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cc3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cc6:	cd 30                	int    $0x30
  801cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	5b                   	pop    %ebx
  801cd2:	5e                   	pop    %esi
  801cd3:	5f                   	pop    %edi
  801cd4:	5d                   	pop    %ebp
  801cd5:	c3                   	ret    

00801cd6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ce2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	51                   	push   %ecx
  801cef:	52                   	push   %edx
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	e8 b0 ff ff ff       	call   801cab <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	90                   	nop
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 02                	push   $0x2
  801d10:	e8 96 ff ff ff       	call   801cab <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 03                	push   $0x3
  801d29:	e8 7d ff ff ff       	call   801cab <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	90                   	nop
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 04                	push   $0x4
  801d43:	e8 63 ff ff ff       	call   801cab <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	90                   	nop
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 08                	push   $0x8
  801d61:	e8 45 ff ff ff       	call   801cab <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d70:	8b 75 18             	mov    0x18(%ebp),%esi
  801d73:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	51                   	push   %ecx
  801d82:	52                   	push   %edx
  801d83:	50                   	push   %eax
  801d84:	6a 09                	push   $0x9
  801d86:	e8 20 ff ff ff       	call   801cab <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	6a 0a                	push   $0xa
  801da5:	e8 01 ff ff ff       	call   801cab <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	ff 75 08             	pushl  0x8(%ebp)
  801dbe:	6a 0b                	push   $0xb
  801dc0:	e8 e6 fe ff ff       	call   801cab <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 0c                	push   $0xc
  801dd9:	e8 cd fe ff ff       	call   801cab <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 0d                	push   $0xd
  801df2:	e8 b4 fe ff ff       	call   801cab <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 0e                	push   $0xe
  801e0b:	e8 9b fe ff ff       	call   801cab <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 0f                	push   $0xf
  801e24:	e8 82 fe ff ff       	call   801cab <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 10                	push   $0x10
  801e3e:	e8 68 fe ff ff       	call   801cab <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 11                	push   $0x11
  801e57:	e8 4f fe ff ff       	call   801cab <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e6e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	50                   	push   %eax
  801e7b:	6a 01                	push   $0x1
  801e7d:	e8 29 fe ff ff       	call   801cab <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	90                   	nop
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 14                	push   $0x14
  801e97:	e8 0f fe ff ff       	call   801cab <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	90                   	nop
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	51                   	push   %ecx
  801ebb:	52                   	push   %edx
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	6a 15                	push   $0x15
  801ec2:	e8 e4 fd ff ff       	call   801cab <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	6a 16                	push   $0x16
  801edf:	e8 c7 fd ff ff       	call   801cab <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801eec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	51                   	push   %ecx
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 17                	push   $0x17
  801efe:	e8 a8 fd ff ff       	call   801cab <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 18                	push   $0x18
  801f1b:	e8 8b fd ff ff       	call   801cab <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	ff 75 14             	pushl  0x14(%ebp)
  801f30:	ff 75 10             	pushl  0x10(%ebp)
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	50                   	push   %eax
  801f37:	6a 19                	push   $0x19
  801f39:	e8 6d fd ff ff       	call   801cab <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	50                   	push   %eax
  801f52:	6a 1a                	push   $0x1a
  801f54:	e8 52 fd ff ff       	call   801cab <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	90                   	nop
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	50                   	push   %eax
  801f6e:	6a 1b                	push   $0x1b
  801f70:	e8 36 fd ff ff       	call   801cab <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 05                	push   $0x5
  801f89:	e8 1d fd ff ff       	call   801cab <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 06                	push   $0x6
  801fa2:	e8 04 fd ff ff       	call   801cab <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 07                	push   $0x7
  801fbb:	e8 eb fc ff ff       	call   801cab <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_exit_env>:


void sys_exit_env(void)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 1c                	push   $0x1c
  801fd4:	e8 d2 fc ff ff       	call   801cab <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fe5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fe8:	8d 50 04             	lea    0x4(%eax),%edx
  801feb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 1d                	push   $0x1d
  801ff8:	e8 ae fc ff ff       	call   801cab <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return result;
  802000:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802006:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802009:	89 01                	mov    %eax,(%ecx)
  80200b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	c9                   	leave  
  802012:	c2 04 00             	ret    $0x4

00802015 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 10             	pushl  0x10(%ebp)
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	6a 13                	push   $0x13
  802027:	e8 7f fc ff ff       	call   801cab <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
	return ;
  80202f:	90                   	nop
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_rcr2>:
uint32 sys_rcr2()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 1e                	push   $0x1e
  802041:	e8 65 fc ff ff       	call   801cab <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 04             	sub    $0x4,%esp
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802057:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	50                   	push   %eax
  802064:	6a 1f                	push   $0x1f
  802066:	e8 40 fc ff ff       	call   801cab <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return ;
  80206e:	90                   	nop
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <rsttst>:
void rsttst()
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 21                	push   $0x21
  802080:	e8 26 fc ff ff       	call   801cab <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
	return ;
  802088:	90                   	nop
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	8b 45 14             	mov    0x14(%ebp),%eax
  802094:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802097:	8b 55 18             	mov    0x18(%ebp),%edx
  80209a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	ff 75 10             	pushl  0x10(%ebp)
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	6a 20                	push   $0x20
  8020ab:	e8 fb fb ff ff       	call   801cab <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b3:	90                   	nop
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <chktst>:
void chktst(uint32 n)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	6a 22                	push   $0x22
  8020c6:	e8 e0 fb ff ff       	call   801cab <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ce:	90                   	nop
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <inctst>:

void inctst()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 23                	push   $0x23
  8020e0:	e8 c6 fb ff ff       	call   801cab <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e8:	90                   	nop
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <gettst>:
uint32 gettst()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 24                	push   $0x24
  8020fa:	e8 ac fb ff ff       	call   801cab <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 25                	push   $0x25
  802113:	e8 93 fb ff ff       	call   801cab <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
  80211b:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802120:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	6a 26                	push   $0x26
  80213f:	e8 67 fb ff ff       	call   801cab <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
	return ;
  802147:	90                   	nop
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802151:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802154:	8b 55 0c             	mov    0xc(%ebp),%edx
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	6a 00                	push   $0x0
  80215c:	53                   	push   %ebx
  80215d:	51                   	push   %ecx
  80215e:	52                   	push   %edx
  80215f:	50                   	push   %eax
  802160:	6a 27                	push   $0x27
  802162:	e8 44 fb ff ff       	call   801cab <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	52                   	push   %edx
  80217f:	50                   	push   %eax
  802180:	6a 28                	push   $0x28
  802182:	e8 24 fb ff ff       	call   801cab <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80218f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802192:	8b 55 0c             	mov    0xc(%ebp),%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	6a 00                	push   $0x0
  80219a:	51                   	push   %ecx
  80219b:	ff 75 10             	pushl  0x10(%ebp)
  80219e:	52                   	push   %edx
  80219f:	50                   	push   %eax
  8021a0:	6a 29                	push   $0x29
  8021a2:	e8 04 fb ff ff       	call   801cab <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 10             	pushl  0x10(%ebp)
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	6a 12                	push   $0x12
  8021be:	e8 e8 fa ff ff       	call   801cab <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c6:	90                   	nop
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	6a 2a                	push   $0x2a
  8021dc:	e8 ca fa ff ff       	call   801cab <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 2b                	push   $0x2b
  8021f6:	e8 b0 fa ff ff       	call   801cab <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	ff 75 0c             	pushl  0xc(%ebp)
  80220c:	ff 75 08             	pushl  0x8(%ebp)
  80220f:	6a 2d                	push   $0x2d
  802211:	e8 95 fa ff ff       	call   801cab <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
	return;
  802219:	90                   	nop
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	ff 75 0c             	pushl  0xc(%ebp)
  802228:	ff 75 08             	pushl  0x8(%ebp)
  80222b:	6a 2c                	push   $0x2c
  80222d:	e8 79 fa ff ff       	call   801cab <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
	return ;
  802235:	90                   	nop
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	68 94 30 80 00       	push   $0x803094
  802246:	68 25 01 00 00       	push   $0x125
  80224b:	68 c7 30 80 00       	push   $0x8030c7
  802250:	e8 ec e6 ff ff       	call   800941 <_panic>

00802255 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	ba 60 40 80 00       	mov    $0x804060,%edx
  802263:	29 d0                	sub    %edx,%eax
  802265:	c1 f8 02             	sar    $0x2,%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	89 d0                	mov    %edx,%eax
  80226c:	c1 e0 02             	shl    $0x2,%eax
  80226f:	01 d0                	add    %edx,%eax
  802271:	c1 e0 02             	shl    $0x2,%eax
  802274:	01 d0                	add    %edx,%eax
  802276:	c1 e0 02             	shl    $0x2,%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	89 c1                	mov    %eax,%ecx
  80227d:	c1 e1 08             	shl    $0x8,%ecx
  802280:	01 c8                	add    %ecx,%eax
  802282:	89 c1                	mov    %eax,%ecx
  802284:	c1 e1 10             	shl    $0x10,%ecx
  802287:	01 c8                	add    %ecx,%eax
  802289:	01 c0                	add    %eax,%eax
  80228b:	01 d0                	add    %edx,%eax
  80228d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802290:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802293:	c1 e0 0c             	shl    $0xc,%eax
  802296:	89 c2                	mov    %eax,%edx
  802298:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80229d:	01 d0                	add    %edx,%eax
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	05 00 00 00 02       	add    $0x2000000,%eax
  8022af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022b2:	73 16                	jae    8022ca <initialize_dynamic_allocator+0x29>
  8022b4:	68 d8 30 80 00       	push   $0x8030d8
  8022b9:	68 fe 30 80 00       	push   $0x8030fe
  8022be:	6a 26                	push   $0x26
  8022c0:	68 13 31 80 00       	push   $0x803113
  8022c5:	e8 77 e6 ff ff       	call   800941 <_panic>
		is_initialized = 1;
  8022ca:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  8022d1:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 2c 31 80 00       	push   $0x80312c
  8022dc:	6a 2e                	push   $0x2e
  8022de:	68 13 31 80 00       	push   $0x803113
  8022e3:	e8 59 e6 ff ff       	call   800941 <_panic>

008022e8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 60 31 80 00       	push   $0x803160
  8022f6:	6a 3a                	push   $0x3a
  8022f8:	68 13 31 80 00       	push   $0x803113
  8022fd:	e8 3f e6 ff ff       	call   800941 <_panic>

00802302 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802308:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80230f:	76 16                	jbe    802327 <alloc_block+0x25>
  802311:	68 88 31 80 00       	push   $0x803188
  802316:	68 fe 30 80 00       	push   $0x8030fe
  80231b:	6a 46                	push   $0x46
  80231d:	68 13 31 80 00       	push   $0x803113
  802322:	e8 1a e6 ff ff       	call   800941 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 ac 31 80 00       	push   $0x8031ac
  80232f:	6a 4d                	push   $0x4d
  802331:	68 13 31 80 00       	push   $0x803113
  802336:	e8 06 e6 ff ff       	call   800941 <_panic>

0080233b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802341:	8b 55 08             	mov    0x8(%ebp),%edx
  802344:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802349:	39 c2                	cmp    %eax,%edx
  80234b:	72 0c                	jb     802359 <free_block+0x1e>
  80234d:	8b 55 08             	mov    0x8(%ebp),%edx
  802350:	a1 40 40 80 00       	mov    0x804040,%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	72 16                	jb     80236f <free_block+0x34>
  802359:	68 d0 31 80 00       	push   $0x8031d0
  80235e:	68 fe 30 80 00       	push   $0x8030fe
  802363:	6a 5b                	push   $0x5b
  802365:	68 13 31 80 00       	push   $0x803113
  80236a:	e8 d2 e5 ff ff       	call   800941 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 08 32 80 00       	push   $0x803208
  802377:	6a 63                	push   $0x63
  802379:	68 13 31 80 00       	push   $0x803113
  80237e:	e8 be e5 ff ff       	call   800941 <_panic>

00802383 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	68 2c 32 80 00       	push   $0x80322c
  802391:	6a 72                	push   $0x72
  802393:	68 13 31 80 00       	push   $0x803113
  802398:	e8 a4 e5 ff ff       	call   800941 <_panic>

0080239d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 50 32 80 00       	push   $0x803250
  8023ab:	6a 07                	push   $0x7
  8023ad:	68 7f 32 80 00       	push   $0x80327f
  8023b2:	e8 8a e5 ff ff       	call   800941 <_panic>

008023b7 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	68 90 32 80 00       	push   $0x803290
  8023c5:	6a 0b                	push   $0xb
  8023c7:	68 7f 32 80 00       	push   $0x80327f
  8023cc:	e8 70 e5 ff ff       	call   800941 <_panic>

008023d1 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 bc 32 80 00       	push   $0x8032bc
  8023df:	6a 10                	push   $0x10
  8023e1:	68 7f 32 80 00       	push   $0x80327f
  8023e6:	e8 56 e5 ff ff       	call   800941 <_panic>

008023eb <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	68 ec 32 80 00       	push   $0x8032ec
  8023f9:	6a 15                	push   $0x15
  8023fb:	68 7f 32 80 00       	push   $0x80327f
  802400:	e8 3c e5 ff ff       	call   800941 <_panic>

00802405 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80241b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80241f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802423:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802427:	89 ca                	mov    %ecx,%edx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80242f:	85 f6                	test   %esi,%esi
  802431:	75 2d                	jne    802460 <__udivdi3+0x50>
  802433:	39 cf                	cmp    %ecx,%edi
  802435:	77 65                	ja     80249c <__udivdi3+0x8c>
  802437:	89 fd                	mov    %edi,%ebp
  802439:	85 ff                	test   %edi,%edi
  80243b:	75 0b                	jne    802448 <__udivdi3+0x38>
  80243d:	b8 01 00 00 00       	mov    $0x1,%eax
  802442:	31 d2                	xor    %edx,%edx
  802444:	f7 f7                	div    %edi
  802446:	89 c5                	mov    %eax,%ebp
  802448:	31 d2                	xor    %edx,%edx
  80244a:	89 c8                	mov    %ecx,%eax
  80244c:	f7 f5                	div    %ebp
  80244e:	89 c1                	mov    %eax,%ecx
  802450:	89 d8                	mov    %ebx,%eax
  802452:	f7 f5                	div    %ebp
  802454:	89 cf                	mov    %ecx,%edi
  802456:	89 fa                	mov    %edi,%edx
  802458:	83 c4 1c             	add    $0x1c,%esp
  80245b:	5b                   	pop    %ebx
  80245c:	5e                   	pop    %esi
  80245d:	5f                   	pop    %edi
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    
  802460:	39 ce                	cmp    %ecx,%esi
  802462:	77 28                	ja     80248c <__udivdi3+0x7c>
  802464:	0f bd fe             	bsr    %esi,%edi
  802467:	83 f7 1f             	xor    $0x1f,%edi
  80246a:	75 40                	jne    8024ac <__udivdi3+0x9c>
  80246c:	39 ce                	cmp    %ecx,%esi
  80246e:	72 0a                	jb     80247a <__udivdi3+0x6a>
  802470:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802474:	0f 87 9e 00 00 00    	ja     802518 <__udivdi3+0x108>
  80247a:	b8 01 00 00 00       	mov    $0x1,%eax
  80247f:	89 fa                	mov    %edi,%edx
  802481:	83 c4 1c             	add    $0x1c,%esp
  802484:	5b                   	pop    %ebx
  802485:	5e                   	pop    %esi
  802486:	5f                   	pop    %edi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    
  802489:	8d 76 00             	lea    0x0(%esi),%esi
  80248c:	31 ff                	xor    %edi,%edi
  80248e:	31 c0                	xor    %eax,%eax
  802490:	89 fa                	mov    %edi,%edx
  802492:	83 c4 1c             	add    $0x1c,%esp
  802495:	5b                   	pop    %ebx
  802496:	5e                   	pop    %esi
  802497:	5f                   	pop    %edi
  802498:	5d                   	pop    %ebp
  802499:	c3                   	ret    
  80249a:	66 90                	xchg   %ax,%ax
  80249c:	89 d8                	mov    %ebx,%eax
  80249e:	f7 f7                	div    %edi
  8024a0:	31 ff                	xor    %edi,%edi
  8024a2:	89 fa                	mov    %edi,%edx
  8024a4:	83 c4 1c             	add    $0x1c,%esp
  8024a7:	5b                   	pop    %ebx
  8024a8:	5e                   	pop    %esi
  8024a9:	5f                   	pop    %edi
  8024aa:	5d                   	pop    %ebp
  8024ab:	c3                   	ret    
  8024ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024b1:	89 eb                	mov    %ebp,%ebx
  8024b3:	29 fb                	sub    %edi,%ebx
  8024b5:	89 f9                	mov    %edi,%ecx
  8024b7:	d3 e6                	shl    %cl,%esi
  8024b9:	89 c5                	mov    %eax,%ebp
  8024bb:	88 d9                	mov    %bl,%cl
  8024bd:	d3 ed                	shr    %cl,%ebp
  8024bf:	89 e9                	mov    %ebp,%ecx
  8024c1:	09 f1                	or     %esi,%ecx
  8024c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024c7:	89 f9                	mov    %edi,%ecx
  8024c9:	d3 e0                	shl    %cl,%eax
  8024cb:	89 c5                	mov    %eax,%ebp
  8024cd:	89 d6                	mov    %edx,%esi
  8024cf:	88 d9                	mov    %bl,%cl
  8024d1:	d3 ee                	shr    %cl,%esi
  8024d3:	89 f9                	mov    %edi,%ecx
  8024d5:	d3 e2                	shl    %cl,%edx
  8024d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024db:	88 d9                	mov    %bl,%cl
  8024dd:	d3 e8                	shr    %cl,%eax
  8024df:	09 c2                	or     %eax,%edx
  8024e1:	89 d0                	mov    %edx,%eax
  8024e3:	89 f2                	mov    %esi,%edx
  8024e5:	f7 74 24 0c          	divl   0xc(%esp)
  8024e9:	89 d6                	mov    %edx,%esi
  8024eb:	89 c3                	mov    %eax,%ebx
  8024ed:	f7 e5                	mul    %ebp
  8024ef:	39 d6                	cmp    %edx,%esi
  8024f1:	72 19                	jb     80250c <__udivdi3+0xfc>
  8024f3:	74 0b                	je     802500 <__udivdi3+0xf0>
  8024f5:	89 d8                	mov    %ebx,%eax
  8024f7:	31 ff                	xor    %edi,%edi
  8024f9:	e9 58 ff ff ff       	jmp    802456 <__udivdi3+0x46>
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	8b 54 24 08          	mov    0x8(%esp),%edx
  802504:	89 f9                	mov    %edi,%ecx
  802506:	d3 e2                	shl    %cl,%edx
  802508:	39 c2                	cmp    %eax,%edx
  80250a:	73 e9                	jae    8024f5 <__udivdi3+0xe5>
  80250c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80250f:	31 ff                	xor    %edi,%edi
  802511:	e9 40 ff ff ff       	jmp    802456 <__udivdi3+0x46>
  802516:	66 90                	xchg   %ax,%ax
  802518:	31 c0                	xor    %eax,%eax
  80251a:	e9 37 ff ff ff       	jmp    802456 <__udivdi3+0x46>
  80251f:	90                   	nop

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80252b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80252f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802533:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802537:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80253b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80253f:	89 f3                	mov    %esi,%ebx
  802541:	89 fa                	mov    %edi,%edx
  802543:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802547:	89 34 24             	mov    %esi,(%esp)
  80254a:	85 c0                	test   %eax,%eax
  80254c:	75 1a                	jne    802568 <__umoddi3+0x48>
  80254e:	39 f7                	cmp    %esi,%edi
  802550:	0f 86 a2 00 00 00    	jbe    8025f8 <__umoddi3+0xd8>
  802556:	89 c8                	mov    %ecx,%eax
  802558:	89 f2                	mov    %esi,%edx
  80255a:	f7 f7                	div    %edi
  80255c:	89 d0                	mov    %edx,%eax
  80255e:	31 d2                	xor    %edx,%edx
  802560:	83 c4 1c             	add    $0x1c,%esp
  802563:	5b                   	pop    %ebx
  802564:	5e                   	pop    %esi
  802565:	5f                   	pop    %edi
  802566:	5d                   	pop    %ebp
  802567:	c3                   	ret    
  802568:	39 f0                	cmp    %esi,%eax
  80256a:	0f 87 ac 00 00 00    	ja     80261c <__umoddi3+0xfc>
  802570:	0f bd e8             	bsr    %eax,%ebp
  802573:	83 f5 1f             	xor    $0x1f,%ebp
  802576:	0f 84 ac 00 00 00    	je     802628 <__umoddi3+0x108>
  80257c:	bf 20 00 00 00       	mov    $0x20,%edi
  802581:	29 ef                	sub    %ebp,%edi
  802583:	89 fe                	mov    %edi,%esi
  802585:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	d3 e0                	shl    %cl,%eax
  80258d:	89 d7                	mov    %edx,%edi
  80258f:	89 f1                	mov    %esi,%ecx
  802591:	d3 ef                	shr    %cl,%edi
  802593:	09 c7                	or     %eax,%edi
  802595:	89 e9                	mov    %ebp,%ecx
  802597:	d3 e2                	shl    %cl,%edx
  802599:	89 14 24             	mov    %edx,(%esp)
  80259c:	89 d8                	mov    %ebx,%eax
  80259e:	d3 e0                	shl    %cl,%eax
  8025a0:	89 c2                	mov    %eax,%edx
  8025a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025a6:	d3 e0                	shl    %cl,%eax
  8025a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025b0:	89 f1                	mov    %esi,%ecx
  8025b2:	d3 e8                	shr    %cl,%eax
  8025b4:	09 d0                	or     %edx,%eax
  8025b6:	d3 eb                	shr    %cl,%ebx
  8025b8:	89 da                	mov    %ebx,%edx
  8025ba:	f7 f7                	div    %edi
  8025bc:	89 d3                	mov    %edx,%ebx
  8025be:	f7 24 24             	mull   (%esp)
  8025c1:	89 c6                	mov    %eax,%esi
  8025c3:	89 d1                	mov    %edx,%ecx
  8025c5:	39 d3                	cmp    %edx,%ebx
  8025c7:	0f 82 87 00 00 00    	jb     802654 <__umoddi3+0x134>
  8025cd:	0f 84 91 00 00 00    	je     802664 <__umoddi3+0x144>
  8025d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025d7:	29 f2                	sub    %esi,%edx
  8025d9:	19 cb                	sbb    %ecx,%ebx
  8025db:	89 d8                	mov    %ebx,%eax
  8025dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025e1:	d3 e0                	shl    %cl,%eax
  8025e3:	89 e9                	mov    %ebp,%ecx
  8025e5:	d3 ea                	shr    %cl,%edx
  8025e7:	09 d0                	or     %edx,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	d3 eb                	shr    %cl,%ebx
  8025ed:	89 da                	mov    %ebx,%edx
  8025ef:	83 c4 1c             	add    $0x1c,%esp
  8025f2:	5b                   	pop    %ebx
  8025f3:	5e                   	pop    %esi
  8025f4:	5f                   	pop    %edi
  8025f5:	5d                   	pop    %ebp
  8025f6:	c3                   	ret    
  8025f7:	90                   	nop
  8025f8:	89 fd                	mov    %edi,%ebp
  8025fa:	85 ff                	test   %edi,%edi
  8025fc:	75 0b                	jne    802609 <__umoddi3+0xe9>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f7                	div    %edi
  802607:	89 c5                	mov    %eax,%ebp
  802609:	89 f0                	mov    %esi,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f5                	div    %ebp
  80260f:	89 c8                	mov    %ecx,%eax
  802611:	f7 f5                	div    %ebp
  802613:	89 d0                	mov    %edx,%eax
  802615:	e9 44 ff ff ff       	jmp    80255e <__umoddi3+0x3e>
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	89 c8                	mov    %ecx,%eax
  80261e:	89 f2                	mov    %esi,%edx
  802620:	83 c4 1c             	add    $0x1c,%esp
  802623:	5b                   	pop    %ebx
  802624:	5e                   	pop    %esi
  802625:	5f                   	pop    %edi
  802626:	5d                   	pop    %ebp
  802627:	c3                   	ret    
  802628:	3b 04 24             	cmp    (%esp),%eax
  80262b:	72 06                	jb     802633 <__umoddi3+0x113>
  80262d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802631:	77 0f                	ja     802642 <__umoddi3+0x122>
  802633:	89 f2                	mov    %esi,%edx
  802635:	29 f9                	sub    %edi,%ecx
  802637:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80263b:	89 14 24             	mov    %edx,(%esp)
  80263e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802642:	8b 44 24 04          	mov    0x4(%esp),%eax
  802646:	8b 14 24             	mov    (%esp),%edx
  802649:	83 c4 1c             	add    $0x1c,%esp
  80264c:	5b                   	pop    %ebx
  80264d:	5e                   	pop    %esi
  80264e:	5f                   	pop    %edi
  80264f:	5d                   	pop    %ebp
  802650:	c3                   	ret    
  802651:	8d 76 00             	lea    0x0(%esi),%esi
  802654:	2b 04 24             	sub    (%esp),%eax
  802657:	19 fa                	sbb    %edi,%edx
  802659:	89 d1                	mov    %edx,%ecx
  80265b:	89 c6                	mov    %eax,%esi
  80265d:	e9 71 ff ff ff       	jmp    8025d3 <__umoddi3+0xb3>
  802662:	66 90                	xchg   %ax,%ax
  802664:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802668:	72 ea                	jb     802654 <__umoddi3+0x134>
  80266a:	89 d9                	mov    %ebx,%ecx
  80266c:	e9 62 ff ff ff       	jmp    8025d3 <__umoddi3+0xb3>

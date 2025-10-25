
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 3a 06 00 00       	call   800670 <libmain>
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
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  80004b:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  80004e:	e8 4a 1c 00 00       	call   801c9d <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _agentCapacity[] = "agentCapacity";
  800056:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800059:	bb 69 26 80 00       	mov    $0x802669,%ebx
  80005e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006e:	bb 77 26 80 00       	mov    $0x802677,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800083:	bb 81 26 80 00       	mov    $0x802681,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 85 7d ff ff ff    	lea    -0x83(%ebp),%eax
  80009b:	bb 8d 26 80 00       	mov    $0x80268d,%ebx
  8000a0:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 de                	mov    %ebx,%esi
  8000a9:	89 d1                	mov    %edx,%ecx
  8000ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000ad:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000b3:	bb 9c 26 80 00       	mov    $0x80269c,%ebx
  8000b8:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 de                	mov    %ebx,%esi
  8000c1:	89 d1                	mov    %edx,%ecx
  8000c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c5:	8d 85 59 ff ff ff    	lea    -0xa7(%ebp),%eax
  8000cb:	bb ab 26 80 00       	mov    $0x8026ab,%ebx
  8000d0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d5:	89 c7                	mov    %eax,%edi
  8000d7:	89 de                	mov    %ebx,%esi
  8000d9:	89 d1                	mov    %edx,%ecx
  8000db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000dd:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8000e3:	bb c0 26 80 00       	mov    $0x8026c0,%ebx
  8000e8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 de                	mov    %ebx,%esi
  8000f1:	89 d1                	mov    %edx,%ecx
  8000f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f5:	8d 85 33 ff ff ff    	lea    -0xcd(%ebp),%eax
  8000fb:	bb d5 26 80 00       	mov    $0x8026d5,%ebx
  800100:	ba 11 00 00 00       	mov    $0x11,%edx
  800105:	89 c7                	mov    %eax,%edi
  800107:	89 de                	mov    %ebx,%esi
  800109:	89 d1                	mov    %edx,%ecx
  80010b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010d:	8d 85 22 ff ff ff    	lea    -0xde(%ebp),%eax
  800113:	bb e6 26 80 00       	mov    $0x8026e6,%ebx
  800118:	ba 11 00 00 00       	mov    $0x11,%edx
  80011d:	89 c7                	mov    %eax,%edi
  80011f:	89 de                	mov    %ebx,%esi
  800121:	89 d1                	mov    %edx,%ecx
  800123:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800125:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80012b:	bb f7 26 80 00       	mov    $0x8026f7,%ebx
  800130:	ba 11 00 00 00       	mov    $0x11,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	89 de                	mov    %ebx,%esi
  800139:	89 d1                	mov    %edx,%ecx
  80013b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013d:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  800143:	bb 08 27 80 00       	mov    $0x802708,%ebx
  800148:	ba 09 00 00 00       	mov    $0x9,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800155:	8d 85 fe fe ff ff    	lea    -0x102(%ebp),%eax
  80015b:	bb 11 27 80 00       	mov    $0x802711,%ebx
  800160:	ba 0a 00 00 00       	mov    $0xa,%edx
  800165:	89 c7                	mov    %eax,%edi
  800167:	89 de                	mov    %ebx,%esi
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800173:	bb 1b 27 80 00       	mov    $0x80271b,%ebx
  800178:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800185:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
  80018b:	bb 26 27 80 00       	mov    $0x802726,%ebx
  800190:	ba 03 00 00 00       	mov    $0x3,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8001a3:	bb 32 27 80 00       	mov    $0x802732,%ebx
  8001a8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001ad:	89 c7                	mov    %eax,%edi
  8001af:	89 de                	mov    %ebx,%esi
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b5:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001bb:	bb 3c 27 80 00       	mov    $0x80273c,%ebx
  8001c0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001cd:	c7 85 cd fe ff ff 63 	movl   $0x72656c63,-0x133(%ebp)
  8001d4:	6c 65 72 
  8001d7:	66 c7 85 d1 fe ff ff 	movw   $0x6b,-0x12f(%ebp)
  8001de:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001e0:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001e6:	bb 46 27 80 00       	mov    $0x802746,%ebx
  8001eb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f8:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  8001fe:	bb 54 27 80 00       	mov    $0x802754,%ebx
  800203:	ba 0f 00 00 00       	mov    $0xf,%edx
  800208:	89 c7                	mov    %eax,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800210:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800216:	bb 63 27 80 00       	mov    $0x802763,%ebx
  80021b:	ba 07 00 00 00       	mov    $0x7,%edx
  800220:	89 c7                	mov    %eax,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	89 d1                	mov    %edx,%ecx
  800226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800228:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022e:	bb 6a 27 80 00       	mov    $0x80276a,%ebx
  800233:	ba 07 00 00 00       	mov    $0x7,%edx
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 de                	mov    %ebx,%esi
  80023c:	89 d1                	mov    %edx,%ecx
  80023e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _flight1Customers[] = "flight1Customers";
  800240:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800246:	bb 71 27 80 00       	mov    $0x802771,%ebx
  80024b:	ba 11 00 00 00       	mov    $0x11,%edx
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	89 d1                	mov    %edx,%ecx
  800256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  800258:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  80025e:	bb 82 27 80 00       	mov    $0x802782,%ebx
  800263:	ba 11 00 00 00       	mov    $0x11,%edx
  800268:	89 c7                	mov    %eax,%edi
  80026a:	89 de                	mov    %ebx,%esi
  80026c:	89 d1                	mov    %edx,%ecx
  80026e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800270:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  800276:	bb 93 27 80 00       	mov    $0x802793,%ebx
  80027b:	ba 11 00 00 00       	mov    $0x11,%edx
  800280:	89 c7                	mov    %eax,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	89 d1                	mov    %edx,%ecx
  800286:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	e8 a7 16 00 00       	call   80193e <sget>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	e8 92 16 00 00       	call   80193e <sget>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	e8 7a 16 00 00       	call   80193e <sget>
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	e8 62 16 00 00       	call   80193e <sget>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1Customers = sget(parentenvID, _flight1Customers);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	e8 4a 16 00 00       	call   80193e <sget>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2Customers = sget(parentenvID, _flight2Customers);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	e8 32 16 00 00       	call   80193e <sget>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight3Customers = sget(parentenvID, _flight3Customers);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 1a 16 00 00       	call   80193e <sget>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 c8             	mov    %eax,-0x38(%ebp)

	// Get the shared semaphores from the main program ***********************************

	struct semaphore capacity = get_semaphore(parentenvID, _agentCapacity);
  80032a:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800336:	52                   	push   %edx
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	50                   	push   %eax
  80033b:	e8 68 1d 00 00       	call   8020a8 <get_semaphore>
  800340:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800343:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 95 bf fe ff ff    	lea    -0x141(%ebp),%edx
  800352:	52                   	push   %edx
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 4c 1d 00 00       	call   8020a8 <get_semaphore>
  80035c:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035f:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	8d 95 cd fe ff ff    	lea    -0x133(%ebp),%edx
  80036e:	52                   	push   %edx
  80036f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800372:	50                   	push   %eax
  800373:	e8 30 1d 00 00       	call   8020a8 <get_semaphore>
  800378:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  80037b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	8d 95 e7 fe ff ff    	lea    -0x119(%ebp),%edx
  80038a:	52                   	push   %edx
  80038b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 14 1d 00 00       	call   8020a8 <get_semaphore>
  800394:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  800397:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  8003a6:	52                   	push   %edx
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	50                   	push   %eax
  8003ab:	e8 f8 1c 00 00       	call   8020a8 <get_semaphore>
  8003b0:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8003b3:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	8d 95 b0 fe ff ff    	lea    -0x150(%ebp),%edx
  8003c2:	52                   	push   %edx
  8003c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	e8 dc 1c 00 00       	call   8020a8 <get_semaphore>
  8003cc:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8003d8:	e8 e5 1c 00 00       	call   8020c2 <wait_semaphore>
  8003dd:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  8003e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 01             	lea    0x1(%eax),%edx
  8003f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8003f5:	0f 31                	rdtsc  
  8003f7:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
  8003fd:	89 95 48 fe ff ff    	mov    %edx,-0x1b8(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800403:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
  800409:	8b 95 48 fe ff ff    	mov    -0x1b8(%ebp),%edx
  80040f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800412:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		repFlightSel:
		//get random flight
		flightType = RANDU(1, 4);
  800415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800418:	b9 03 00 00 00       	mov    $0x3,%ecx
  80041d:	ba 00 00 00 00       	mov    $0x0,%edx
  800422:	f7 f1                	div    %ecx
  800424:	89 d0                	mov    %edx,%eax
  800426:	40                   	inc    %eax
  800427:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if(flightType == 1 && *flight1Customers > 0)		(*flight1Customers)--;
  80042a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80042e:	75 18                	jne    800448 <_main+0x410>
  800430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	85 c0                	test   %eax,%eax
  800437:	7e 0f                	jle    800448 <_main+0x410>
  800439:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800441:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	eb 3a                	jmp    800482 <_main+0x44a>
		else if(flightType == 2 && *flight2Customers > 0)	(*flight2Customers)--;
  800448:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  80044c:	75 18                	jne    800466 <_main+0x42e>
  80044e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	7e 0f                	jle    800466 <_main+0x42e>
  800457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80045f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	eb 1c                	jmp    800482 <_main+0x44a>
		else if(flightType == 3 && *flight3Customers > 0)	(*flight3Customers)--;
  800466:	83 7d c0 03          	cmpl   $0x3,-0x40(%ebp)
  80046a:	75 89                	jne    8003f5 <_main+0x3bd>
  80046c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	7e 80                	jle    8003f5 <_main+0x3bd>
  800475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
		else goto repFlightSel;
	}
	signal_semaphore(custCounterCS);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  80048b:	e8 4c 1c 00 00       	call   8020dc <signal_semaphore>
  800490:	83 c4 10             	add    $0x10,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800493:	0f 31                	rdtsc  
  800495:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  80049b:	89 95 50 fe ff ff    	mov    %edx,-0x1b0(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004a1:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8004a7:	8b 95 50 fe ff ff    	mov    -0x1b0(%ebp),%edx
  8004ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8004b0:	89 55 bc             	mov    %edx,-0x44(%ebp)

	//delay for a random time
	env_sleep(RANDU(100, 10000));
  8004b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b6:	b9 ac 26 00 00       	mov    $0x26ac,%ecx
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	f7 f1                	div    %ecx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	83 c0 64             	add    $0x64,%eax
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	50                   	push   %eax
  8004cb:	e8 31 1c 00 00       	call   802101 <env_sleep>
  8004d0:	83 c4 10             	add    $0x10,%esp

	//enter the agent if there's a space
	wait_semaphore(capacity);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  8004dc:	e8 e1 1b 00 00       	call   8020c2 <wait_semaphore>
  8004e1:	83 c4 10             	add    $0x10,%esp
	{
		//wait on one of the clerks
		wait_semaphore(clerk);
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8004ed:	e8 d0 1b 00 00       	call   8020c2 <wait_semaphore>
  8004f2:	83 c4 10             	add    $0x10,%esp

		//enqueue the request
		customers[custId].booked = 0 ;
  8004f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		customers[custId].flightType = flightType ;
  80050b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	01 c2                	add    %eax,%edx
  80051a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80051d:	89 02                	mov    %eax,(%edx)
		wait_semaphore(custQueueCS);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800528:	e8 95 1b 00 00       	call   8020c2 <wait_semaphore>
  80052d:	83 c4 10             	add    $0x10,%esp
		{
			cust_ready_queue[*queue_in] = custId;
  800530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053f:	01 c2                	add    %eax,%edx
  800541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800544:	89 02                	mov    %eax,(%edx)
			*queue_in = *queue_in +1;
  800546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	8d 50 01             	lea    0x1(%eax),%edx
  80054e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800551:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  80055c:	e8 7b 1b 00 00       	call   8020dc <signal_semaphore>
  800561:	83 c4 10             	add    $0x10,%esp

		//signal ready
		signal_semaphore(cust_ready);
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  80056d:	e8 6a 1b 00 00       	call   8020dc <signal_semaphore>
  800572:	83 c4 10             	add    $0x10,%esp

		//wait on finished
		char prefix[30]="cust_finished";
  800575:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80057b:	bb a4 27 80 00       	mov    $0x8027a4,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 34 fe ff ff    	lea    -0x1cc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005ae:	e8 7b 0f 00 00       	call   80152e <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 34 10 00 00       	call   801607 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_waitSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  8005d6:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	8d 95 ea fd ff ff    	lea    -0x216(%ebp),%edx
  8005e5:	52                   	push   %edx
  8005e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 b9 1a 00 00       	call   8020a8 <get_semaphore>
  8005ef:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(cust_finished);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff b5 1c fe ff ff    	pushl  -0x1e4(%ebp)
  8005fb:	e8 c2 1a 00 00       	call   8020c2 <wait_semaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//print the customer status
		if(customers[custId].booked == 1)
  800603:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800606:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	8b 40 04             	mov    0x4(%eax),%eax
  800615:	83 f8 01             	cmp    $0x1,%eax
  800618:	75 18                	jne    800632 <_main+0x5fa>
		{
			cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 c0             	pushl  -0x40(%ebp)
  800620:	ff 75 c4             	pushl  -0x3c(%ebp)
  800623:	68 20 26 80 00       	push   $0x802620
  800628:	e8 d3 02 00 00       	call   800900 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb 13                	jmp    800645 <_main+0x60d>
		}
		else
		{
			cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 c4             	pushl  -0x3c(%ebp)
  800638:	68 48 26 80 00       	push   $0x802648
  80063d:	e8 be 02 00 00       	call   800900 <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
		}
	}
	//exit the agent
	signal_semaphore(capacity);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80064e:	e8 89 1a 00 00       	call   8020dc <signal_semaphore>
  800653:	83 c4 10             	add    $0x10,%esp

	//customer is terminated
	signal_semaphore(custTerminated);
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  80065f:	e8 78 1a 00 00       	call   8020dc <signal_semaphore>
  800664:	83 c4 10             	add    $0x10,%esp

	return;
  800667:	90                   	nop
}
  800668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066b:	5b                   	pop    %ebx
  80066c:	5e                   	pop    %esi
  80066d:	5f                   	pop    %edi
  80066e:	5d                   	pop    %ebp
  80066f:	c3                   	ret    

00800670 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800679:	e8 06 16 00 00       	call   801c84 <sys_getenvindex>
  80067e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800681:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	c1 e0 03             	shl    $0x3,%eax
  80068e:	01 d0                	add    %edx,%eax
  800690:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800697:	01 d0                	add    %edx,%eax
  800699:	c1 e0 02             	shl    $0x2,%eax
  80069c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a1:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ab:	8a 40 20             	mov    0x20(%eax),%al
  8006ae:	84 c0                	test   %al,%al
  8006b0:	74 0d                	je     8006bf <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b7:	83 c0 20             	add    $0x20,%eax
  8006ba:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c3:	7e 0a                	jle    8006cf <libmain+0x5f>
		binaryname = argv[0];
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 5b f9 ff ff       	call   800038 <_main>
  8006dd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e0:	a1 00 40 80 00       	mov    0x804000,%eax
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	0f 84 01 01 00 00    	je     8007ee <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f3:	bb bc 28 80 00       	mov    $0x8028bc,%ebx
  8006f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fd:	89 c7                	mov    %eax,%edi
  8006ff:	89 de                	mov    %ebx,%esi
  800701:	89 d1                	mov    %edx,%ecx
  800703:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800705:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800708:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070d:	b0 00                	mov    $0x0,%al
  80070f:	89 d7                	mov    %edx,%edi
  800711:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800713:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 8d 17 00 00       	call   801eba <sys_utilities>
  80072d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800730:	e8 d6 12 00 00       	call   801a0b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	68 dc 27 80 00       	push   $0x8027dc
  80073d:	e8 be 01 00 00       	call   800900 <cprintf>
  800742:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800748:	85 c0                	test   %eax,%eax
  80074a:	74 18                	je     800764 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074c:	e8 87 17 00 00       	call   801ed8 <sys_get_optimal_num_faults>
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	50                   	push   %eax
  800755:	68 04 28 80 00       	push   $0x802804
  80075a:	e8 a1 01 00 00       	call   800900 <cprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	eb 59                	jmp    8007bd <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800764:	a1 20 40 80 00       	mov    0x804020,%eax
  800769:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80076f:	a1 20 40 80 00       	mov    0x804020,%eax
  800774:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	52                   	push   %edx
  80077e:	50                   	push   %eax
  80077f:	68 28 28 80 00       	push   $0x802828
  800784:	e8 77 01 00 00       	call   800900 <cprintf>
  800789:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078c:	a1 20 40 80 00       	mov    0x804020,%eax
  800791:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800797:	a1 20 40 80 00       	mov    0x804020,%eax
  80079c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8007a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8007a7:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8007ad:	51                   	push   %ecx
  8007ae:	52                   	push   %edx
  8007af:	50                   	push   %eax
  8007b0:	68 50 28 80 00       	push   $0x802850
  8007b5:	e8 46 01 00 00       	call   800900 <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c2:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	50                   	push   %eax
  8007cc:	68 a8 28 80 00       	push   $0x8028a8
  8007d1:	e8 2a 01 00 00       	call   800900 <cprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	68 dc 27 80 00       	push   $0x8027dc
  8007e1:	e8 1a 01 00 00       	call   800900 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007e9:	e8 37 12 00 00       	call   801a25 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ee:	e8 1f 00 00 00       	call   800812 <exit>
}
  8007f3:	90                   	nop
  8007f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	6a 00                	push   $0x0
  800807:	e8 44 14 00 00       	call   801c50 <sys_destroy_env>
  80080c:	83 c4 10             	add    $0x10,%esp
}
  80080f:	90                   	nop
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <exit>:

void
exit(void)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800818:	e8 99 14 00 00       	call   801cb6 <sys_exit_env>
}
  80081d:	90                   	nop
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	8d 48 01             	lea    0x1(%eax),%ecx
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	89 0a                	mov    %ecx,(%edx)
  800834:	8b 55 08             	mov    0x8(%ebp),%edx
  800837:	88 d1                	mov    %dl,%cl
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	3d ff 00 00 00       	cmp    $0xff,%eax
  80084a:	75 30                	jne    80087c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80084c:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800852:	a0 44 40 80 00       	mov    0x804044,%al
  800857:	0f b6 c0             	movzbl %al,%eax
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	8b 09                	mov    (%ecx),%ecx
  80085f:	89 cb                	mov    %ecx,%ebx
  800861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800864:	83 c1 08             	add    $0x8,%ecx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	53                   	push   %ebx
  80086a:	51                   	push   %ecx
  80086b:	e8 57 11 00 00       	call   8019c7 <sys_cputs>
  800870:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	8b 40 04             	mov    0x4(%eax),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	89 50 04             	mov    %edx,0x4(%eax)
}
  80088b:	90                   	nop
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80089a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008a1:	00 00 00 
	b.cnt = 0;
  8008a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	68 20 08 80 00       	push   $0x800820
  8008c0:	e8 5a 02 00 00       	call   800b1f <vprintfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008c8:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8008ce:	a0 44 40 80 00       	mov    0x804044,%al
  8008d3:	0f b6 c0             	movzbl %al,%eax
  8008d6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008dc:	52                   	push   %edx
  8008dd:	50                   	push   %eax
  8008de:	51                   	push   %ecx
  8008df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008e5:	83 c0 08             	add    $0x8,%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 d9 10 00 00       	call   8019c7 <sys_cputs>
  8008ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008f1:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8008f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800906:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  80090d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	e8 6f ff ff ff       	call   800891 <vcprintf>
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800928:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800933:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	c1 e0 08             	shl    $0x8,%eax
  800940:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800945:	8d 45 0c             	lea    0xc(%ebp),%eax
  800948:	83 c0 04             	add    $0x4,%eax
  80094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 f4             	pushl  -0xc(%ebp)
  800957:	50                   	push   %eax
  800958:	e8 34 ff ff ff       	call   800891 <vcprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800963:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  80096a:	07 00 00 

	return cnt;
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800978:	e8 8e 10 00 00       	call   801a0b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80097d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800980:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 f4             	pushl  -0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	e8 ff fe ff ff       	call   800891 <vcprintf>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800998:	e8 88 10 00 00       	call   801a25 <sys_unlock_cons>
	return cnt;
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	83 ec 14             	sub    $0x14,%esp
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8009b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c0:	77 55                	ja     800a17 <printnum+0x75>
  8009c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c5:	72 05                	jb     8009cc <printnum+0x2a>
  8009c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ca:	77 4b                	ja     800a17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009cf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	52                   	push   %edx
  8009db:	50                   	push   %eax
  8009dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009df:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e2:	e8 c9 19 00 00       	call   8023b0 <__udivdi3>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	83 ec 04             	sub    $0x4,%esp
  8009ed:	ff 75 20             	pushl  0x20(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	ff 75 18             	pushl  0x18(%ebp)
  8009f4:	52                   	push   %edx
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 a1 ff ff ff       	call   8009a2 <printnum>
  800a01:	83 c4 20             	add    $0x20,%esp
  800a04:	eb 1a                	jmp    800a20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 20             	pushl  0x20(%ebp)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a17:	ff 4d 1c             	decl   0x1c(%ebp)
  800a1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a1e:	7f e6                	jg     800a06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2e:	53                   	push   %ebx
  800a2f:	51                   	push   %ecx
  800a30:	52                   	push   %edx
  800a31:	50                   	push   %eax
  800a32:	e8 89 1a 00 00       	call   8024c0 <__umoddi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	05 34 2b 80 00       	add    $0x802b34,%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	0f be c0             	movsbl %al,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	50                   	push   %eax
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
}
  800a53:	90                   	nop
  800a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a60:	7e 1c                	jle    800a7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	8d 50 08             	lea    0x8(%eax),%edx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	89 10                	mov    %edx,(%eax)
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	83 e8 08             	sub    $0x8,%eax
  800a77:	8b 50 04             	mov    0x4(%eax),%edx
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	eb 40                	jmp    800abe <getuint+0x65>
	else if (lflag)
  800a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a82:	74 1e                	je     800aa2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 04             	lea    0x4(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	eb 1c                	jmp    800abe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	8d 50 04             	lea    0x4(%eax),%edx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 10                	mov    %edx,(%eax)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	83 e8 04             	sub    $0x4,%eax
  800ab7:	8b 00                	mov    (%eax),%eax
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ac3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac7:	7e 1c                	jle    800ae5 <getint+0x25>
		return va_arg(*ap, long long);
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	8d 50 08             	lea    0x8(%eax),%edx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	89 10                	mov    %edx,(%eax)
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	83 e8 08             	sub    $0x8,%eax
  800ade:	8b 50 04             	mov    0x4(%eax),%edx
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	eb 38                	jmp    800b1d <getint+0x5d>
	else if (lflag)
  800ae5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae9:	74 1a                	je     800b05 <getint+0x45>
		return va_arg(*ap, long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 04             	lea    0x4(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	99                   	cltd   
  800b03:	eb 18                	jmp    800b1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 50 04             	lea    0x4(%eax),%edx
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	89 10                	mov    %edx,(%eax)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	99                   	cltd   
}
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b27:	eb 17                	jmp    800b40 <vprintfmt+0x21>
			if (ch == '\0')
  800b29:	85 db                	test   %ebx,%ebx
  800b2b:	0f 84 c1 03 00 00    	je     800ef2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	89 55 10             	mov    %edx,0x10(%ebp)
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d8             	movzbl %al,%ebx
  800b4e:	83 fb 25             	cmp    $0x25,%ebx
  800b51:	75 d6                	jne    800b29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b73:	8b 45 10             	mov    0x10(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d8             	movzbl %al,%ebx
  800b81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b84:	83 f8 5b             	cmp    $0x5b,%eax
  800b87:	0f 87 3d 03 00 00    	ja     800eca <vprintfmt+0x3ab>
  800b8d:	8b 04 85 58 2b 80 00 	mov    0x802b58(,%eax,4),%eax
  800b94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b9a:	eb d7                	jmp    800b73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ba0:	eb d1                	jmp    800b73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bac:	89 d0                	mov    %edx,%eax
  800bae:	c1 e0 02             	shl    $0x2,%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	01 c0                	add    %eax,%eax
  800bb5:	01 d8                	add    %ebx,%eax
  800bb7:	83 e8 30             	sub    $0x30,%eax
  800bba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800bc8:	7e 3e                	jle    800c08 <vprintfmt+0xe9>
  800bca:	83 fb 39             	cmp    $0x39,%ebx
  800bcd:	7f 39                	jg     800c08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bd2:	eb d5                	jmp    800ba9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 c0 04             	add    $0x4,%eax
  800bda:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 e8 04             	sub    $0x4,%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800be8:	eb 1f                	jmp    800c09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bee:	79 83                	jns    800b73 <vprintfmt+0x54>
				width = 0;
  800bf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bf7:	e9 77 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c03:	e9 6b ff ff ff       	jmp    800b73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0d:	0f 89 60 ff ff ff    	jns    800b73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c20:	e9 4e ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c28:	e9 46 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 e8 04             	sub    $0x4,%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	50                   	push   %eax
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			break;
  800c4d:	e9 9b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	79 02                	jns    800c69 <vprintfmt+0x14a>
				err = -err;
  800c67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c69:	83 fb 64             	cmp    $0x64,%ebx
  800c6c:	7f 0b                	jg     800c79 <vprintfmt+0x15a>
  800c6e:	8b 34 9d a0 29 80 00 	mov    0x8029a0(,%ebx,4),%esi
  800c75:	85 f6                	test   %esi,%esi
  800c77:	75 19                	jne    800c92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c79:	53                   	push   %ebx
  800c7a:	68 45 2b 80 00       	push   $0x802b45
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 70 02 00 00       	call   800efa <printfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c8d:	e9 5b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c92:	56                   	push   %esi
  800c93:	68 4e 2b 80 00       	push   $0x802b4e
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 57 02 00 00       	call   800efa <printfmt>
  800ca3:	83 c4 10             	add    $0x10,%esp
			break;
  800ca6:	e9 42 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 c0 04             	add    $0x4,%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 30                	mov    (%eax),%esi
  800cbc:	85 f6                	test   %esi,%esi
  800cbe:	75 05                	jne    800cc5 <vprintfmt+0x1a6>
				p = "(null)";
  800cc0:	be 51 2b 80 00       	mov    $0x802b51,%esi
			if (width > 0 && padc != '-')
  800cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc9:	7e 6d                	jle    800d38 <vprintfmt+0x219>
  800ccb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ccf:	74 67                	je     800d38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	50                   	push   %eax
  800cd8:	56                   	push   %esi
  800cd9:	e8 1e 03 00 00       	call   800ffc <strnlen>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ce4:	eb 16                	jmp    800cfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ce6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800cfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d00:	7f e4                	jg     800ce6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d02:	eb 34                	jmp    800d38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d08:	74 1c                	je     800d26 <vprintfmt+0x207>
  800d0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d0d:	7e 05                	jle    800d14 <vprintfmt+0x1f5>
  800d0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d12:	7e 12                	jle    800d26 <vprintfmt+0x207>
					putch('?', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	6a 3f                	push   $0x3f
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	eb 0f                	jmp    800d35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	53                   	push   %ebx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff d0                	call   *%eax
  800d32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d35:	ff 4d e4             	decl   -0x1c(%ebp)
  800d38:	89 f0                	mov    %esi,%eax
  800d3a:	8d 70 01             	lea    0x1(%eax),%esi
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f be d8             	movsbl %al,%ebx
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	74 24                	je     800d6a <vprintfmt+0x24b>
  800d46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4a:	78 b8                	js     800d04 <vprintfmt+0x1e5>
  800d4c:	ff 4d e0             	decl   -0x20(%ebp)
  800d4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d53:	79 af                	jns    800d04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d55:	eb 13                	jmp    800d6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	6a 20                	push   $0x20
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6e:	7f e7                	jg     800d57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d70:	e9 78 01 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 e8             	pushl  -0x18(%ebp)
  800d7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7e:	50                   	push   %eax
  800d7f:	e8 3c fd ff ff       	call   800ac0 <getint>
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d93:	85 d2                	test   %edx,%edx
  800d95:	79 23                	jns    800dba <vprintfmt+0x29b>
				putch('-', putdat);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	6a 2d                	push   $0x2d
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dad:	f7 d8                	neg    %eax
  800daf:	83 d2 00             	adc    $0x0,%edx
  800db2:	f7 da                	neg    %edx
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dc1:	e9 bc 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800dcf:	50                   	push   %eax
  800dd0:	e8 84 fc ff ff       	call   800a59 <getuint>
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dde:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de5:	e9 98 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	6a 58                	push   $0x58
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	ff d0                	call   *%eax
  800df7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	6a 58                	push   $0x58
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	6a 58                	push   $0x58
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	ff d0                	call   *%eax
  800e17:	83 c4 10             	add    $0x10,%esp
			break;
  800e1a:	e9 ce 00 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 30                	push   $0x30
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	6a 78                	push   $0x78
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 c0 04             	add    $0x4,%eax
  800e45:	89 45 14             	mov    %eax,0x14(%ebp)
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 e8 04             	sub    $0x4,%eax
  800e4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e61:	eb 1f                	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 e8             	pushl  -0x18(%ebp)
  800e69:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6c:	50                   	push   %eax
  800e6d:	e8 e7 fb ff ff       	call   800a59 <getuint>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e89:	83 ec 04             	sub    $0x4,%esp
  800e8c:	52                   	push   %edx
  800e8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e90:	50                   	push   %eax
  800e91:	ff 75 f4             	pushl  -0xc(%ebp)
  800e94:	ff 75 f0             	pushl  -0x10(%ebp)
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 00 fb ff ff       	call   8009a2 <printnum>
  800ea2:	83 c4 20             	add    $0x20,%esp
			break;
  800ea5:	eb 46                	jmp    800eed <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	53                   	push   %ebx
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	ff d0                	call   *%eax
  800eb3:	83 c4 10             	add    $0x10,%esp
			break;
  800eb6:	eb 35                	jmp    800eed <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800eb8:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800ebf:	eb 2c                	jmp    800eed <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ec1:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ec8:	eb 23                	jmp    800eed <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	ff 75 0c             	pushl  0xc(%ebp)
  800ed0:	6a 25                	push   $0x25
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	ff d0                	call   *%eax
  800ed7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eda:	ff 4d 10             	decl   0x10(%ebp)
  800edd:	eb 03                	jmp    800ee2 <vprintfmt+0x3c3>
  800edf:	ff 4d 10             	decl   0x10(%ebp)
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	48                   	dec    %eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3c 25                	cmp    $0x25,%al
  800eea:	75 f3                	jne    800edf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800eec:	90                   	nop
		}
	}
  800eed:	e9 35 fc ff ff       	jmp    800b27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f00:	8d 45 10             	lea    0x10(%ebp),%eax
  800f03:	83 c0 04             	add    $0x4,%eax
  800f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0f:	50                   	push   %eax
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	e8 04 fc ff ff       	call   800b1f <vprintfmt>
  800f1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f1e:	90                   	nop
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	8b 40 08             	mov    0x8(%eax),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	8b 10                	mov    (%eax),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8b 40 04             	mov    0x4(%eax),%eax
  800f3e:	39 c2                	cmp    %eax,%edx
  800f40:	73 12                	jae    800f54 <sprintputch+0x33>
		*b->buf++ = ch;
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	89 0a                	mov    %ecx,(%edx)
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	88 10                	mov    %dl,(%eax)
}
  800f54:	90                   	nop
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	01 d0                	add    %edx,%eax
  800f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7c:	74 06                	je     800f84 <vsnprintf+0x2d>
  800f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f82:	7f 07                	jg     800f8b <vsnprintf+0x34>
		return -E_INVAL;
  800f84:	b8 03 00 00 00       	mov    $0x3,%eax
  800f89:	eb 20                	jmp    800fab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f8b:	ff 75 14             	pushl  0x14(%ebp)
  800f8e:	ff 75 10             	pushl  0x10(%ebp)
  800f91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f94:	50                   	push   %eax
  800f95:	68 21 0f 80 00       	push   $0x800f21
  800f9a:	e8 80 fb ff ff       	call   800b1f <vprintfmt>
  800f9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb6:	83 c0 04             	add    $0x4,%eax
  800fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc2:	50                   	push   %eax
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	ff 75 08             	pushl  0x8(%ebp)
  800fc9:	e8 89 ff ff ff       	call   800f57 <vsnprintf>
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe6:	eb 06                	jmp    800fee <strlen+0x15>
		n++;
  800fe8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 f1                	jne    800fe8 <strlen+0xf>
		n++;
	return n;
  800ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801009:	eb 09                	jmp    801014 <strnlen+0x18>
		n++;
  80100b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	ff 4d 0c             	decl   0xc(%ebp)
  801014:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801018:	74 09                	je     801023 <strnlen+0x27>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 e8                	jne    80100b <strnlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801034:	90                   	nop
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8d 50 01             	lea    0x1(%eax),%edx
  80103b:	89 55 08             	mov    %edx,0x8(%ebp)
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	8d 4a 01             	lea    0x1(%edx),%ecx
  801044:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801047:	8a 12                	mov    (%edx),%dl
  801049:	88 10                	mov    %dl,(%eax)
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	84 c0                	test   %al,%al
  80104f:	75 e4                	jne    801035 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801069:	eb 1f                	jmp    80108a <strncpy+0x34>
		*dst++ = *src;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8d 50 01             	lea    0x1(%eax),%edx
  801071:	89 55 08             	mov    %edx,0x8(%ebp)
  801074:	8b 55 0c             	mov    0xc(%ebp),%edx
  801077:	8a 12                	mov    (%edx),%dl
  801079:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 03                	je     801087 <strncpy+0x31>
			src++;
  801084:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801090:	72 d9                	jb     80106b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a7:	74 30                	je     8010d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a9:	eb 16                	jmp    8010c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c1:	ff 4d 10             	decl   0x10(%ebp)
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 09                	je     8010d3 <strlcpy+0x3c>
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 d8                	jne    8010ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	29 c2                	sub    %eax,%edx
  8010e1:	89 d0                	mov    %edx,%eax
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010e8:	eb 06                	jmp    8010f0 <strcmp+0xb>
		p++, q++;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	84 c0                	test   %al,%al
  8010f7:	74 0e                	je     801107 <strcmp+0x22>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 10                	mov    (%eax),%dl
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	38 c2                	cmp    %al,%dl
  801105:	74 e3                	je     8010ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f b6 d0             	movzbl %al,%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	0f b6 c0             	movzbl %al,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
}
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801120:	eb 09                	jmp    80112b <strncmp+0xe>
		n--, p++, q++;
  801122:	ff 4d 10             	decl   0x10(%ebp)
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 17                	je     801148 <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 0e                	je     801148 <strncmp+0x2b>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 10                	mov    (%eax),%dl
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 da                	je     801122 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	75 07                	jne    801155 <strncmp+0x38>
		return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
  801153:	eb 14                	jmp    801169 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f b6 d0             	movzbl %al,%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f b6 c0             	movzbl %al,%eax
  801165:	29 c2                	sub    %eax,%edx
  801167:	89 d0                	mov    %edx,%eax
}
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801177:	eb 12                	jmp    80118b <strchr+0x20>
		if (*s == c)
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801181:	75 05                	jne    801188 <strchr+0x1d>
			return (char *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	eb 11                	jmp    801199 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	84 c0                	test   %al,%al
  801192:	75 e5                	jne    801179 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a7:	eb 0d                	jmp    8011b6 <strfind+0x1b>
		if (*s == c)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b1:	74 0e                	je     8011c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	75 ea                	jne    8011a9 <strfind+0xe>
  8011bf:	eb 01                	jmp    8011c2 <strfind+0x27>
		if (*s == c)
			break;
  8011c1:	90                   	nop
	return (char *) s;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d7:	76 63                	jbe    80123c <memset+0x75>
		uint64 data_block = c;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	99                   	cltd   
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011ed:	c1 e0 08             	shl    $0x8,%eax
  8011f0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011f3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801200:	c1 e0 10             	shl    $0x10,%eax
  801203:	09 45 f0             	or     %eax,-0x10(%ebp)
  801206:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120f:	89 c2                	mov    %eax,%edx
  801211:	b8 00 00 00 00       	mov    $0x0,%eax
  801216:	09 45 f0             	or     %eax,-0x10(%ebp)
  801219:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80121c:	eb 18                	jmp    801236 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80121e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801221:	8d 41 08             	lea    0x8(%ecx),%eax
  801224:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	89 01                	mov    %eax,(%ecx)
  80122f:	89 51 04             	mov    %edx,0x4(%ecx)
  801232:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801236:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80123a:	77 e2                	ja     80121e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80123c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801240:	74 23                	je     801265 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801248:	eb 0e                	jmp    801258 <memset+0x91>
			*p8++ = (uint8)c;
  80124a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125e:	89 55 10             	mov    %edx,0x10(%ebp)
  801261:	85 c0                	test   %eax,%eax
  801263:	75 e5                	jne    80124a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80127c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801280:	76 24                	jbe    8012a6 <memcpy+0x3c>
		while(n >= 8){
  801282:	eb 1c                	jmp    8012a0 <memcpy+0x36>
			*d64 = *s64;
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	8b 50 04             	mov    0x4(%eax),%edx
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80128f:	89 01                	mov    %eax,(%ecx)
  801291:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801294:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801298:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80129c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a4:	77 de                	ja     801284 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012aa:	74 31                	je     8012dd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012b8:	eb 16                	jmp    8012d0 <memcpy+0x66>
			*d8++ = *s8++;
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	8d 50 01             	lea    0x1(%eax),%edx
  8012c0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012cc:	8a 12                	mov    (%edx),%dl
  8012ce:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 dd                	jne    8012ba <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012fa:	73 50                	jae    80134c <memmove+0x6a>
  8012fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801307:	76 43                	jbe    80134c <memmove+0x6a>
		s += n;
  801309:	8b 45 10             	mov    0x10(%ebp),%eax
  80130c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801315:	eb 10                	jmp    801327 <memmove+0x45>
			*--d = *--s;
  801317:	ff 4d f8             	decl   -0x8(%ebp)
  80131a:	ff 4d fc             	decl   -0x4(%ebp)
  80131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801320:	8a 10                	mov    (%eax),%dl
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801325:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132d:	89 55 10             	mov    %edx,0x10(%ebp)
  801330:	85 c0                	test   %eax,%eax
  801332:	75 e3                	jne    801317 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801334:	eb 23                	jmp    801359 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801342:	8d 4a 01             	lea    0x1(%edx),%ecx
  801345:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801348:	8a 12                	mov    (%edx),%dl
  80134a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801352:	89 55 10             	mov    %edx,0x10(%ebp)
  801355:	85 c0                	test   %eax,%eax
  801357:	75 dd                	jne    801336 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801370:	eb 2a                	jmp    80139c <memcmp+0x3e>
		if (*s1 != *s2)
  801372:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801375:	8a 10                	mov    (%eax),%dl
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	38 c2                	cmp    %al,%dl
  80137e:	74 16                	je     801396 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f b6 d0             	movzbl %al,%edx
  801388:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	0f b6 c0             	movzbl %al,%eax
  801390:	29 c2                	sub    %eax,%edx
  801392:	89 d0                	mov    %edx,%eax
  801394:	eb 18                	jmp    8013ae <memcmp+0x50>
		s1++, s2++;
  801396:	ff 45 fc             	incl   -0x4(%ebp)
  801399:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80139c:	8b 45 10             	mov    0x10(%ebp),%eax
  80139f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 c9                	jne    801372 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c1:	eb 15                	jmp    8013d8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	0f b6 d0             	movzbl %al,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	0f b6 c0             	movzbl %al,%eax
  8013d1:	39 c2                	cmp    %eax,%edx
  8013d3:	74 0d                	je     8013e2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013d5:	ff 45 08             	incl   0x8(%ebp)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013de:	72 e3                	jb     8013c3 <memfind+0x13>
  8013e0:	eb 01                	jmp    8013e3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e2:	90                   	nop
	return (void *) s;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fc:	eb 03                	jmp    801401 <strtol+0x19>
		s++;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 20                	cmp    $0x20,%al
  801408:	74 f4                	je     8013fe <strtol+0x16>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 09                	cmp    $0x9,%al
  801411:	74 eb                	je     8013fe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 2b                	cmp    $0x2b,%al
  80141a:	75 05                	jne    801421 <strtol+0x39>
		s++;
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	eb 13                	jmp    801434 <strtol+0x4c>
	else if (*s == '-')
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 2d                	cmp    $0x2d,%al
  801428:	75 0a                	jne    801434 <strtol+0x4c>
		s++, neg = 1;
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801434:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801438:	74 06                	je     801440 <strtol+0x58>
  80143a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80143e:	75 20                	jne    801460 <strtol+0x78>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 30                	cmp    $0x30,%al
  801447:	75 17                	jne    801460 <strtol+0x78>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	40                   	inc    %eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 78                	cmp    $0x78,%al
  801451:	75 0d                	jne    801460 <strtol+0x78>
		s += 2, base = 16;
  801453:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801457:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80145e:	eb 28                	jmp    801488 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801460:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801464:	75 15                	jne    80147b <strtol+0x93>
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 30                	cmp    $0x30,%al
  80146d:	75 0c                	jne    80147b <strtol+0x93>
		s++, base = 8;
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801479:	eb 0d                	jmp    801488 <strtol+0xa0>
	else if (base == 0)
  80147b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147f:	75 07                	jne    801488 <strtol+0xa0>
		base = 10;
  801481:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 2f                	cmp    $0x2f,%al
  80148f:	7e 19                	jle    8014aa <strtol+0xc2>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3c 39                	cmp    $0x39,%al
  801498:	7f 10                	jg     8014aa <strtol+0xc2>
			dig = *s - '0';
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 30             	sub    $0x30,%eax
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a8:	eb 42                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 60                	cmp    $0x60,%al
  8014b1:	7e 19                	jle    8014cc <strtol+0xe4>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 7a                	cmp    $0x7a,%al
  8014ba:	7f 10                	jg     8014cc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	0f be c0             	movsbl %al,%eax
  8014c4:	83 e8 57             	sub    $0x57,%eax
  8014c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ca:	eb 20                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 40                	cmp    $0x40,%al
  8014d3:	7e 39                	jle    80150e <strtol+0x126>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 5a                	cmp    $0x5a,%al
  8014dc:	7f 30                	jg     80150e <strtol+0x126>
			dig = *s - 'A' + 10;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	0f be c0             	movsbl %al,%eax
  8014e6:	83 e8 37             	sub    $0x37,%eax
  8014e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f2:	7d 19                	jge    80150d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014f4:	ff 45 08             	incl   0x8(%ebp)
  8014f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014fe:	89 c2                	mov    %eax,%edx
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801508:	e9 7b ff ff ff       	jmp    801488 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80150d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80150e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801512:	74 08                	je     80151c <strtol+0x134>
		*endptr = (char *) s;
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80151c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801520:	74 07                	je     801529 <strtol+0x141>
  801522:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801525:	f7 d8                	neg    %eax
  801527:	eb 03                	jmp    80152c <strtol+0x144>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <ltostr>:

void
ltostr(long value, char *str)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80153b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801546:	79 13                	jns    80155b <ltostr+0x2d>
	{
		neg = 1;
  801548:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801555:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801558:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801563:	99                   	cltd   
  801564:	f7 f9                	idiv   %ecx
  801566:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156c:	8d 50 01             	lea    0x1(%eax),%edx
  80156f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801572:	89 c2                	mov    %eax,%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157c:	83 c2 30             	add    $0x30,%edx
  80157f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801581:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801584:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801589:	f7 e9                	imul   %ecx
  80158b:	c1 fa 02             	sar    $0x2,%edx
  80158e:	89 c8                	mov    %ecx,%eax
  801590:	c1 f8 1f             	sar    $0x1f,%eax
  801593:	29 c2                	sub    %eax,%edx
  801595:	89 d0                	mov    %edx,%eax
  801597:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80159a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80159e:	75 bb                	jne    80155b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b2:	74 3d                	je     8015f1 <ltostr+0xc3>
		start = 1 ;
  8015b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015bb:	eb 34                	jmp    8015f1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 c2                	add    %eax,%edx
  8015d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 c8                	add    %ecx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c2                	add    %eax,%edx
  8015e6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e9:	88 02                	mov    %al,(%edx)
		start++ ;
  8015eb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f7:	7c c4                	jl     8015bd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801604:	90                   	nop
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 c4 f9 ff ff       	call   800fd9 <strlen>
  801615:	83 c4 04             	add    $0x4,%esp
  801618:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	e8 b6 f9 ff ff       	call   800fd9 <strlen>
  801623:	83 c4 04             	add    $0x4,%esp
  801626:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801637:	eb 17                	jmp    801650 <strcconcat+0x49>
		final[s] = str1[s] ;
  801639:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	01 c2                	add    %eax,%edx
  801641:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	01 c8                	add    %ecx,%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80164d:	ff 45 fc             	incl   -0x4(%ebp)
  801650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801653:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801656:	7c e1                	jl     801639 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801658:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80165f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801666:	eb 1f                	jmp    801687 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8d 50 01             	lea    0x1(%eax),%edx
  80166e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801671:	89 c2                	mov    %eax,%edx
  801673:	8b 45 10             	mov    0x10(%ebp),%eax
  801676:	01 c2                	add    %eax,%edx
  801678:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	01 c8                	add    %ecx,%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801684:	ff 45 f8             	incl   -0x8(%ebp)
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168d:	7c d9                	jl     801668 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80168f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	c6 00 00             	movb   $0x0,(%eax)
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c0:	eb 0c                	jmp    8016ce <strsplit+0x31>
			*string++ = 0;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8d 50 01             	lea    0x1(%eax),%edx
  8016c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016cb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	84 c0                	test   %al,%al
  8016d5:	74 18                	je     8016ef <strsplit+0x52>
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	0f be c0             	movsbl %al,%eax
  8016df:	50                   	push   %eax
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	e8 83 fa ff ff       	call   80116b <strchr>
  8016e8:	83 c4 08             	add    $0x8,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	75 d3                	jne    8016c2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	84 c0                	test   %al,%al
  8016f6:	74 5a                	je     801752 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 00                	mov    (%eax),%eax
  8016fd:	83 f8 0f             	cmp    $0xf,%eax
  801700:	75 07                	jne    801709 <strsplit+0x6c>
		{
			return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	eb 66                	jmp    80176f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801709:	8b 45 14             	mov    0x14(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8d 48 01             	lea    0x1(%eax),%ecx
  801711:	8b 55 14             	mov    0x14(%ebp),%edx
  801714:	89 0a                	mov    %ecx,(%edx)
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 c2                	add    %eax,%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801727:	eb 03                	jmp    80172c <strsplit+0x8f>
			string++;
  801729:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	74 8b                	je     8016c0 <strsplit+0x23>
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	50                   	push   %eax
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	e8 25 fa ff ff       	call   80116b <strchr>
  801746:	83 c4 08             	add    $0x8,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 dc                	je     801729 <strsplit+0x8c>
			string++;
	}
  80174d:	e9 6e ff ff ff       	jmp    8016c0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801752:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80176a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80177d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801784:	eb 4a                	jmp    8017d0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801786:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	01 c2                	add    %eax,%edx
  80178e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	01 c8                	add    %ecx,%eax
  801796:	8a 00                	mov    (%eax),%al
  801798:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80179a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 40                	cmp    $0x40,%al
  8017a6:	7e 25                	jle    8017cd <str2lower+0x5c>
  8017a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 5a                	cmp    $0x5a,%al
  8017b4:	7f 17                	jg     8017cd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	01 ca                	add    %ecx,%edx
  8017c6:	8a 12                	mov    (%edx),%dl
  8017c8:	83 c2 20             	add    $0x20,%edx
  8017cb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017cd:	ff 45 fc             	incl   -0x4(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	e8 01 f8 ff ff       	call   800fd9 <strlen>
  8017d8:	83 c4 04             	add    $0x4,%esp
  8017db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017de:	7f a6                	jg     801786 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	74 42                	je     801836 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	68 00 00 00 82       	push   $0x82000000
  8017fc:	68 00 00 00 80       	push   $0x80000000
  801801:	e8 8c 07 00 00       	call   801f92 <initialize_dynamic_allocator>
  801806:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801809:	e8 e7 05 00 00       	call   801df5 <sys_get_uheap_strategy>
  80180e:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801813:	a1 40 40 80 00       	mov    0x804040,%eax
  801818:	05 00 10 00 00       	add    $0x1000,%eax
  80181d:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801822:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801827:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80182c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801833:	00 00 00 
	}
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	68 06 04 00 00       	push   $0x406
  801855:	50                   	push   %eax
  801856:	e8 e4 01 00 00       	call   801a3f <__sys_allocate_page>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801865:	79 14                	jns    80187b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	68 c8 2c 80 00       	push   $0x802cc8
  80186f:	6a 1f                	push   $0x1f
  801871:	68 04 2d 80 00       	push   $0x802d04
  801876:	e8 44 09 00 00       	call   8021bf <_panic>
	return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	50                   	push   %eax
  80189a:	e8 e7 01 00 00       	call   801a86 <__sys_unmap_frame>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018a9:	79 14                	jns    8018bf <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 10 2d 80 00       	push   $0x802d10
  8018b3:	6a 2a                	push   $0x2a
  8018b5:	68 04 2d 80 00       	push   $0x802d04
  8018ba:	e8 00 09 00 00       	call   8021bf <_panic>
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018c8:	e8 18 ff ff ff       	call   8017e5 <uheap_init>
	if (size == 0) return NULL ;
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	75 07                	jne    8018da <malloc+0x18>
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	eb 14                	jmp    8018ee <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 50 2d 80 00       	push   $0x802d50
  8018e2:	6a 3e                	push   $0x3e
  8018e4:	68 04 2d 80 00       	push   $0x802d04
  8018e9:	e8 d1 08 00 00       	call   8021bf <_panic>
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8018f6:	83 ec 04             	sub    $0x4,%esp
  8018f9:	68 78 2d 80 00       	push   $0x802d78
  8018fe:	6a 49                	push   $0x49
  801900:	68 04 2d 80 00       	push   $0x802d04
  801905:	e8 b5 08 00 00       	call   8021bf <_panic>

0080190a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 18             	sub    $0x18,%esp
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801916:	e8 ca fe ff ff       	call   8017e5 <uheap_init>
	if (size == 0) return NULL ;
  80191b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80191f:	75 07                	jne    801928 <smalloc+0x1e>
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
  801926:	eb 14                	jmp    80193c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	68 9c 2d 80 00       	push   $0x802d9c
  801930:	6a 5a                	push   $0x5a
  801932:	68 04 2d 80 00       	push   $0x802d04
  801937:	e8 83 08 00 00       	call   8021bf <_panic>
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801944:	e8 9c fe ff ff       	call   8017e5 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 c4 2d 80 00       	push   $0x802dc4
  801951:	6a 6a                	push   $0x6a
  801953:	68 04 2d 80 00       	push   $0x802d04
  801958:	e8 62 08 00 00       	call   8021bf <_panic>

0080195d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801963:	e8 7d fe ff ff       	call   8017e5 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	68 e8 2d 80 00       	push   $0x802de8
  801970:	68 88 00 00 00       	push   $0x88
  801975:	68 04 2d 80 00       	push   $0x802d04
  80197a:	e8 40 08 00 00       	call   8021bf <_panic>

0080197f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 10 2e 80 00       	push   $0x802e10
  80198d:	68 9b 00 00 00       	push   $0x9b
  801992:	68 04 2d 80 00       	push   $0x802d04
  801997:	e8 23 08 00 00       	call   8021bf <_panic>

0080199c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	57                   	push   %edi
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019b7:	cd 30                	int    $0x30
  8019b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5f                   	pop    %edi
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    

008019c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	51                   	push   %ecx
  8019e0:	52                   	push   %edx
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	50                   	push   %eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 b0 ff ff ff       	call   80199c <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 02                	push   $0x2
  801a01:	e8 96 ff ff ff       	call   80199c <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 03                	push   $0x3
  801a1a:	e8 7d ff ff ff       	call   80199c <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 04                	push   $0x4
  801a34:	e8 63 ff ff ff       	call   80199c <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 08                	push   $0x8
  801a52:	e8 45 ff ff ff       	call   80199c <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a61:	8b 75 18             	mov    0x18(%ebp),%esi
  801a64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	51                   	push   %ecx
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 09                	push   $0x9
  801a77:	e8 20 ff ff ff       	call   80199c <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a82:	5b                   	pop    %ebx
  801a83:	5e                   	pop    %esi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	ff 75 08             	pushl  0x8(%ebp)
  801a94:	6a 0a                	push   $0xa
  801a96:	e8 01 ff ff ff       	call   80199c <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 0b                	push   $0xb
  801ab1:	e8 e6 fe ff ff       	call   80199c <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 0c                	push   $0xc
  801aca:	e8 cd fe ff ff       	call   80199c <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 0d                	push   $0xd
  801ae3:	e8 b4 fe ff ff       	call   80199c <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 0e                	push   $0xe
  801afc:	e8 9b fe ff ff       	call   80199c <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 0f                	push   $0xf
  801b15:	e8 82 fe ff ff       	call   80199c <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 10                	push   $0x10
  801b2f:	e8 68 fe ff ff       	call   80199c <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 11                	push   $0x11
  801b48:	e8 4f fe ff ff       	call   80199c <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	50                   	push   %eax
  801b6c:	6a 01                	push   $0x1
  801b6e:	e8 29 fe ff ff       	call   80199c <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	90                   	nop
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 14                	push   $0x14
  801b88:	e8 0f fe ff ff       	call   80199c <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	51                   	push   %ecx
  801bac:	52                   	push   %edx
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	50                   	push   %eax
  801bb1:	6a 15                	push   $0x15
  801bb3:	e8 e4 fd ff ff       	call   80199c <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 16                	push   $0x16
  801bd0:	e8 c7 fd ff ff       	call   80199c <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	51                   	push   %ecx
  801beb:	52                   	push   %edx
  801bec:	50                   	push   %eax
  801bed:	6a 17                	push   $0x17
  801bef:	e8 a8 fd ff ff       	call   80199c <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 18                	push   $0x18
  801c0c:	e8 8b fd ff ff       	call   80199c <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 14             	pushl  0x14(%ebp)
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	6a 19                	push   $0x19
  801c2a:	e8 6d fd ff ff       	call   80199c <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	50                   	push   %eax
  801c43:	6a 1a                	push   $0x1a
  801c45:	e8 52 fd ff ff       	call   80199c <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	50                   	push   %eax
  801c5f:	6a 1b                	push   $0x1b
  801c61:	e8 36 fd ff ff       	call   80199c <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 05                	push   $0x5
  801c7a:	e8 1d fd ff ff       	call   80199c <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 06                	push   $0x6
  801c93:	e8 04 fd ff ff       	call   80199c <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 07                	push   $0x7
  801cac:	e8 eb fc ff ff       	call   80199c <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 1c                	push   $0x1c
  801cc5:	e8 d2 fc ff ff       	call   80199c <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd9:	8d 50 04             	lea    0x4(%eax),%edx
  801cdc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 1d                	push   $0x1d
  801ce9:	e8 ae fc ff ff       	call   80199c <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfa:	89 01                	mov    %eax,(%ecx)
  801cfc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	c9                   	leave  
  801d03:	c2 04 00             	ret    $0x4

00801d06 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 13                	push   $0x13
  801d18:	e8 7f fc ff ff       	call   80199c <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 1e                	push   $0x1e
  801d32:	e8 65 fc ff ff       	call   80199c <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	50                   	push   %eax
  801d55:	6a 1f                	push   $0x1f
  801d57:	e8 40 fc ff ff       	call   80199c <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <rsttst>:
void rsttst()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 21                	push   $0x21
  801d71:	e8 26 fc ff ff       	call   80199c <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return ;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 14             	mov    0x14(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d88:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 20                	push   $0x20
  801d9c:	e8 fb fb ff ff       	call   80199c <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <chktst>:
void chktst(uint32 n)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 22                	push   $0x22
  801db7:	e8 e0 fb ff ff       	call   80199c <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <inctst>:

void inctst()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 23                	push   $0x23
  801dd1:	e8 c6 fb ff ff       	call   80199c <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd9:	90                   	nop
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <gettst>:
uint32 gettst()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 24                	push   $0x24
  801deb:	e8 ac fb ff ff       	call   80199c <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 25                	push   $0x25
  801e04:	e8 93 fb ff ff       	call   80199c <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
  801e0c:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801e11:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	6a 26                	push   $0x26
  801e30:	e8 67 fb ff ff       	call   80199c <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return ;
  801e38:	90                   	nop
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	53                   	push   %ebx
  801e4e:	51                   	push   %ecx
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 27                	push   $0x27
  801e53:	e8 44 fb ff ff       	call   80199c <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	52                   	push   %edx
  801e70:	50                   	push   %eax
  801e71:	6a 28                	push   $0x28
  801e73:	e8 24 fb ff ff       	call   80199c <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	51                   	push   %ecx
  801e8c:	ff 75 10             	pushl  0x10(%ebp)
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	6a 29                	push   $0x29
  801e93:	e8 04 fb ff ff       	call   80199c <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 10             	pushl  0x10(%ebp)
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	ff 75 08             	pushl  0x8(%ebp)
  801ead:	6a 12                	push   $0x12
  801eaf:	e8 e8 fa ff ff       	call   80199c <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb7:	90                   	nop
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 2a                	push   $0x2a
  801ecd:	e8 ca fa ff ff       	call   80199c <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 2b                	push   $0x2b
  801ee7:	e8 b0 fa ff ff       	call   80199c <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	ff 75 0c             	pushl  0xc(%ebp)
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	6a 2d                	push   $0x2d
  801f02:	e8 95 fa ff ff       	call   80199c <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
	return;
  801f0a:	90                   	nop
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	ff 75 08             	pushl  0x8(%ebp)
  801f1c:	6a 2c                	push   $0x2c
  801f1e:	e8 79 fa ff ff       	call   80199c <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
	return ;
  801f26:	90                   	nop
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	68 34 2e 80 00       	push   $0x802e34
  801f37:	68 25 01 00 00       	push   $0x125
  801f3c:	68 67 2e 80 00       	push   $0x802e67
  801f41:	e8 79 02 00 00       	call   8021bf <_panic>

00801f46 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	ba 60 40 80 00       	mov    $0x804060,%edx
  801f54:	29 d0                	sub    %edx,%eax
  801f56:	c1 f8 02             	sar    $0x2,%eax
  801f59:	89 c2                	mov    %eax,%edx
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	c1 e0 02             	shl    $0x2,%eax
  801f60:	01 d0                	add    %edx,%eax
  801f62:	c1 e0 02             	shl    $0x2,%eax
  801f65:	01 d0                	add    %edx,%eax
  801f67:	c1 e0 02             	shl    $0x2,%eax
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	89 c1                	mov    %eax,%ecx
  801f6e:	c1 e1 08             	shl    $0x8,%ecx
  801f71:	01 c8                	add    %ecx,%eax
  801f73:	89 c1                	mov    %eax,%ecx
  801f75:	c1 e1 10             	shl    $0x10,%ecx
  801f78:	01 c8                	add    %ecx,%eax
  801f7a:	01 c0                	add    %eax,%eax
  801f7c:	01 d0                	add    %edx,%eax
  801f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f84:	c1 e0 0c             	shl    $0xc,%eax
  801f87:	89 c2                	mov    %eax,%edx
  801f89:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801f8e:	01 d0                	add    %edx,%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	05 00 00 00 02       	add    $0x2000000,%eax
  801fa0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fa3:	73 16                	jae    801fbb <initialize_dynamic_allocator+0x29>
  801fa5:	68 78 2e 80 00       	push   $0x802e78
  801faa:	68 9e 2e 80 00       	push   $0x802e9e
  801faf:	6a 26                	push   $0x26
  801fb1:	68 b3 2e 80 00       	push   $0x802eb3
  801fb6:	e8 04 02 00 00       	call   8021bf <_panic>
		is_initialized = 1;
  801fbb:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801fc2:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	68 cc 2e 80 00       	push   $0x802ecc
  801fcd:	6a 2e                	push   $0x2e
  801fcf:	68 b3 2e 80 00       	push   $0x802eb3
  801fd4:	e8 e6 01 00 00       	call   8021bf <_panic>

00801fd9 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 00 2f 80 00       	push   $0x802f00
  801fe7:	6a 3a                	push   $0x3a
  801fe9:	68 b3 2e 80 00       	push   $0x802eb3
  801fee:	e8 cc 01 00 00       	call   8021bf <_panic>

00801ff3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801ff9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802000:	76 16                	jbe    802018 <alloc_block+0x25>
  802002:	68 28 2f 80 00       	push   $0x802f28
  802007:	68 9e 2e 80 00       	push   $0x802e9e
  80200c:	6a 46                	push   $0x46
  80200e:	68 b3 2e 80 00       	push   $0x802eb3
  802013:	e8 a7 01 00 00       	call   8021bf <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	68 4c 2f 80 00       	push   $0x802f4c
  802020:	6a 4d                	push   $0x4d
  802022:	68 b3 2e 80 00       	push   $0x802eb3
  802027:	e8 93 01 00 00       	call   8021bf <_panic>

0080202c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802032:	8b 55 08             	mov    0x8(%ebp),%edx
  802035:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	72 0c                	jb     80204a <free_block+0x1e>
  80203e:	8b 55 08             	mov    0x8(%ebp),%edx
  802041:	a1 40 40 80 00       	mov    0x804040,%eax
  802046:	39 c2                	cmp    %eax,%edx
  802048:	72 16                	jb     802060 <free_block+0x34>
  80204a:	68 70 2f 80 00       	push   $0x802f70
  80204f:	68 9e 2e 80 00       	push   $0x802e9e
  802054:	6a 5b                	push   $0x5b
  802056:	68 b3 2e 80 00       	push   $0x802eb3
  80205b:	e8 5f 01 00 00       	call   8021bf <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	68 a8 2f 80 00       	push   $0x802fa8
  802068:	6a 63                	push   $0x63
  80206a:	68 b3 2e 80 00       	push   $0x802eb3
  80206f:	e8 4b 01 00 00       	call   8021bf <_panic>

00802074 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	68 cc 2f 80 00       	push   $0x802fcc
  802082:	6a 72                	push   $0x72
  802084:	68 b3 2e 80 00       	push   $0x802eb3
  802089:	e8 31 01 00 00       	call   8021bf <_panic>

0080208e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802094:	83 ec 04             	sub    $0x4,%esp
  802097:	68 f0 2f 80 00       	push   $0x802ff0
  80209c:	6a 07                	push   $0x7
  80209e:	68 1f 30 80 00       	push   $0x80301f
  8020a3:	e8 17 01 00 00       	call   8021bf <_panic>

008020a8 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 30 30 80 00       	push   $0x803030
  8020b6:	6a 0b                	push   $0xb
  8020b8:	68 1f 30 80 00       	push   $0x80301f
  8020bd:	e8 fd 00 00 00       	call   8021bf <_panic>

008020c2 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	68 5c 30 80 00       	push   $0x80305c
  8020d0:	6a 10                	push   $0x10
  8020d2:	68 1f 30 80 00       	push   $0x80301f
  8020d7:	e8 e3 00 00 00       	call   8021bf <_panic>

008020dc <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	68 8c 30 80 00       	push   $0x80308c
  8020ea:	6a 15                	push   $0x15
  8020ec:	68 1f 30 80 00       	push   $0x80301f
  8020f1:	e8 c9 00 00 00       	call   8021bf <_panic>

008020f6 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 40 10             	mov    0x10(%eax),%eax
}
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    

00802101 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802107:	8b 55 08             	mov    0x8(%ebp),%edx
  80210a:	89 d0                	mov    %edx,%eax
  80210c:	c1 e0 02             	shl    $0x2,%eax
  80210f:	01 d0                	add    %edx,%eax
  802111:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802118:	01 d0                	add    %edx,%eax
  80211a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80212a:	01 d0                	add    %edx,%eax
  80212c:	c1 e0 04             	shl    $0x4,%eax
  80212f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802139:	0f 31                	rdtsc  
  80213b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80213e:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802144:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802147:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80214a:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80214d:	eb 46                	jmp    802195 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80214f:	0f 31                	rdtsc  
  802151:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802154:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802157:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80215a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80215d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802160:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802163:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802169:	29 c2                	sub    %eax,%edx
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802170:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	89 d1                	mov    %edx,%ecx
  802178:	29 c1                	sub    %eax,%ecx
  80217a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80217d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802180:	39 c2                	cmp    %eax,%edx
  802182:	0f 97 c0             	seta   %al
  802185:	0f b6 c0             	movzbl %al,%eax
  802188:	29 c1                	sub    %eax,%ecx
  80218a:	89 c8                	mov    %ecx,%eax
  80218c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80218f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802192:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802198:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80219b:	72 b2                	jb     80214f <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80219d:	90                   	nop
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8021a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8021ad:	eb 03                	jmp    8021b2 <busy_wait+0x12>
  8021af:	ff 45 fc             	incl   -0x4(%ebp)
  8021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b8:	72 f5                	jb     8021af <busy_wait+0xf>
	return i;
  8021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8021c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8021c8:	83 c0 04             	add    $0x4,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8021ce:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 16                	je     8021ed <_panic+0x2e>
		cprintf("%s: ", argv0);
  8021d7:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8021dc:	83 ec 08             	sub    $0x8,%esp
  8021df:	50                   	push   %eax
  8021e0:	68 bc 30 80 00       	push   $0x8030bc
  8021e5:	e8 16 e7 ff ff       	call   800900 <cprintf>
  8021ea:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8021ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	50                   	push   %eax
  8021fc:	68 c4 30 80 00       	push   $0x8030c4
  802201:	6a 74                	push   $0x74
  802203:	e8 25 e7 ff ff       	call   80092d <cprintf_colored>
  802208:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	83 ec 08             	sub    $0x8,%esp
  802211:	ff 75 f4             	pushl  -0xc(%ebp)
  802214:	50                   	push   %eax
  802215:	e8 77 e6 ff ff       	call   800891 <vcprintf>
  80221a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80221d:	83 ec 08             	sub    $0x8,%esp
  802220:	6a 00                	push   $0x0
  802222:	68 ec 30 80 00       	push   $0x8030ec
  802227:	e8 65 e6 ff ff       	call   800891 <vcprintf>
  80222c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80222f:	e8 de e5 ff ff       	call   800812 <exit>

	// should not return here
	while (1) ;
  802234:	eb fe                	jmp    802234 <_panic+0x75>

00802236 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80223c:	a1 20 40 80 00       	mov    0x804020,%eax
  802241:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	39 c2                	cmp    %eax,%edx
  80224c:	74 14                	je     802262 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 f0 30 80 00       	push   $0x8030f0
  802256:	6a 26                	push   $0x26
  802258:	68 3c 31 80 00       	push   $0x80313c
  80225d:	e8 5d ff ff ff       	call   8021bf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802269:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802270:	e9 c5 00 00 00       	jmp    80233a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802278:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	01 d0                	add    %edx,%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	75 08                	jne    802292 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80228a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80228d:	e9 a5 00 00 00       	jmp    802337 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802292:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802299:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8022a0:	eb 69                	jmp    80230b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8022a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8022a7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8022ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022b0:	89 d0                	mov    %edx,%eax
  8022b2:	01 c0                	add    %eax,%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	c1 e0 03             	shl    $0x3,%eax
  8022b9:	01 c8                	add    %ecx,%eax
  8022bb:	8a 40 04             	mov    0x4(%eax),%al
  8022be:	84 c0                	test   %al,%al
  8022c0:	75 46                	jne    802308 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8022c7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8022cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022d0:	89 d0                	mov    %edx,%eax
  8022d2:	01 c0                	add    %eax,%eax
  8022d4:	01 d0                	add    %edx,%eax
  8022d6:	c1 e0 03             	shl    $0x3,%eax
  8022d9:	01 c8                	add    %ecx,%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8022e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022e8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	01 c8                	add    %ecx,%eax
  8022f9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022fb:	39 c2                	cmp    %eax,%edx
  8022fd:	75 09                	jne    802308 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8022ff:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802306:	eb 15                	jmp    80231d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802308:	ff 45 e8             	incl   -0x18(%ebp)
  80230b:	a1 20 40 80 00       	mov    0x804020,%eax
  802310:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802319:	39 c2                	cmp    %eax,%edx
  80231b:	77 85                	ja     8022a2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80231d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802321:	75 14                	jne    802337 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 48 31 80 00       	push   $0x803148
  80232b:	6a 3a                	push   $0x3a
  80232d:	68 3c 31 80 00       	push   $0x80313c
  802332:	e8 88 fe ff ff       	call   8021bf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802337:	ff 45 f0             	incl   -0x10(%ebp)
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802340:	0f 8c 2f ff ff ff    	jl     802275 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802346:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80234d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802354:	eb 26                	jmp    80237c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802356:	a1 20 40 80 00       	mov    0x804020,%eax
  80235b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802361:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802364:	89 d0                	mov    %edx,%eax
  802366:	01 c0                	add    %eax,%eax
  802368:	01 d0                	add    %edx,%eax
  80236a:	c1 e0 03             	shl    $0x3,%eax
  80236d:	01 c8                	add    %ecx,%eax
  80236f:	8a 40 04             	mov    0x4(%eax),%al
  802372:	3c 01                	cmp    $0x1,%al
  802374:	75 03                	jne    802379 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802376:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802379:	ff 45 e0             	incl   -0x20(%ebp)
  80237c:	a1 20 40 80 00       	mov    0x804020,%eax
  802381:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238a:	39 c2                	cmp    %eax,%edx
  80238c:	77 c8                	ja     802356 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802394:	74 14                	je     8023aa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 9c 31 80 00       	push   $0x80319c
  80239e:	6a 44                	push   $0x44
  8023a0:	68 3c 31 80 00       	push   $0x80313c
  8023a5:	e8 15 fe ff ff       	call   8021bf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8023aa:	90                   	nop
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    
  8023ad:	66 90                	xchg   %ax,%ax
  8023af:	90                   	nop

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c7:	89 ca                	mov    %ecx,%edx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023cf:	85 f6                	test   %esi,%esi
  8023d1:	75 2d                	jne    802400 <__udivdi3+0x50>
  8023d3:	39 cf                	cmp    %ecx,%edi
  8023d5:	77 65                	ja     80243c <__udivdi3+0x8c>
  8023d7:	89 fd                	mov    %edi,%ebp
  8023d9:	85 ff                	test   %edi,%edi
  8023db:	75 0b                	jne    8023e8 <__udivdi3+0x38>
  8023dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e2:	31 d2                	xor    %edx,%edx
  8023e4:	f7 f7                	div    %edi
  8023e6:	89 c5                	mov    %eax,%ebp
  8023e8:	31 d2                	xor    %edx,%edx
  8023ea:	89 c8                	mov    %ecx,%eax
  8023ec:	f7 f5                	div    %ebp
  8023ee:	89 c1                	mov    %eax,%ecx
  8023f0:	89 d8                	mov    %ebx,%eax
  8023f2:	f7 f5                	div    %ebp
  8023f4:	89 cf                	mov    %ecx,%edi
  8023f6:	89 fa                	mov    %edi,%edx
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	39 ce                	cmp    %ecx,%esi
  802402:	77 28                	ja     80242c <__udivdi3+0x7c>
  802404:	0f bd fe             	bsr    %esi,%edi
  802407:	83 f7 1f             	xor    $0x1f,%edi
  80240a:	75 40                	jne    80244c <__udivdi3+0x9c>
  80240c:	39 ce                	cmp    %ecx,%esi
  80240e:	72 0a                	jb     80241a <__udivdi3+0x6a>
  802410:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802414:	0f 87 9e 00 00 00    	ja     8024b8 <__udivdi3+0x108>
  80241a:	b8 01 00 00 00       	mov    $0x1,%eax
  80241f:	89 fa                	mov    %edi,%edx
  802421:	83 c4 1c             	add    $0x1c,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	8d 76 00             	lea    0x0(%esi),%esi
  80242c:	31 ff                	xor    %edi,%edi
  80242e:	31 c0                	xor    %eax,%eax
  802430:	89 fa                	mov    %edi,%edx
  802432:	83 c4 1c             	add    $0x1c,%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	89 d8                	mov    %ebx,%eax
  80243e:	f7 f7                	div    %edi
  802440:	31 ff                	xor    %edi,%edi
  802442:	89 fa                	mov    %edi,%edx
  802444:	83 c4 1c             	add    $0x1c,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    
  80244c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802451:	89 eb                	mov    %ebp,%ebx
  802453:	29 fb                	sub    %edi,%ebx
  802455:	89 f9                	mov    %edi,%ecx
  802457:	d3 e6                	shl    %cl,%esi
  802459:	89 c5                	mov    %eax,%ebp
  80245b:	88 d9                	mov    %bl,%cl
  80245d:	d3 ed                	shr    %cl,%ebp
  80245f:	89 e9                	mov    %ebp,%ecx
  802461:	09 f1                	or     %esi,%ecx
  802463:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802467:	89 f9                	mov    %edi,%ecx
  802469:	d3 e0                	shl    %cl,%eax
  80246b:	89 c5                	mov    %eax,%ebp
  80246d:	89 d6                	mov    %edx,%esi
  80246f:	88 d9                	mov    %bl,%cl
  802471:	d3 ee                	shr    %cl,%esi
  802473:	89 f9                	mov    %edi,%ecx
  802475:	d3 e2                	shl    %cl,%edx
  802477:	8b 44 24 08          	mov    0x8(%esp),%eax
  80247b:	88 d9                	mov    %bl,%cl
  80247d:	d3 e8                	shr    %cl,%eax
  80247f:	09 c2                	or     %eax,%edx
  802481:	89 d0                	mov    %edx,%eax
  802483:	89 f2                	mov    %esi,%edx
  802485:	f7 74 24 0c          	divl   0xc(%esp)
  802489:	89 d6                	mov    %edx,%esi
  80248b:	89 c3                	mov    %eax,%ebx
  80248d:	f7 e5                	mul    %ebp
  80248f:	39 d6                	cmp    %edx,%esi
  802491:	72 19                	jb     8024ac <__udivdi3+0xfc>
  802493:	74 0b                	je     8024a0 <__udivdi3+0xf0>
  802495:	89 d8                	mov    %ebx,%eax
  802497:	31 ff                	xor    %edi,%edi
  802499:	e9 58 ff ff ff       	jmp    8023f6 <__udivdi3+0x46>
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024a4:	89 f9                	mov    %edi,%ecx
  8024a6:	d3 e2                	shl    %cl,%edx
  8024a8:	39 c2                	cmp    %eax,%edx
  8024aa:	73 e9                	jae    802495 <__udivdi3+0xe5>
  8024ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024af:	31 ff                	xor    %edi,%edi
  8024b1:	e9 40 ff ff ff       	jmp    8023f6 <__udivdi3+0x46>
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	31 c0                	xor    %eax,%eax
  8024ba:	e9 37 ff ff ff       	jmp    8023f6 <__udivdi3+0x46>
  8024bf:	90                   	nop

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024df:	89 f3                	mov    %esi,%ebx
  8024e1:	89 fa                	mov    %edi,%edx
  8024e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024e7:	89 34 24             	mov    %esi,(%esp)
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	75 1a                	jne    802508 <__umoddi3+0x48>
  8024ee:	39 f7                	cmp    %esi,%edi
  8024f0:	0f 86 a2 00 00 00    	jbe    802598 <__umoddi3+0xd8>
  8024f6:	89 c8                	mov    %ecx,%eax
  8024f8:	89 f2                	mov    %esi,%edx
  8024fa:	f7 f7                	div    %edi
  8024fc:	89 d0                	mov    %edx,%eax
  8024fe:	31 d2                	xor    %edx,%edx
  802500:	83 c4 1c             	add    $0x1c,%esp
  802503:	5b                   	pop    %ebx
  802504:	5e                   	pop    %esi
  802505:	5f                   	pop    %edi
  802506:	5d                   	pop    %ebp
  802507:	c3                   	ret    
  802508:	39 f0                	cmp    %esi,%eax
  80250a:	0f 87 ac 00 00 00    	ja     8025bc <__umoddi3+0xfc>
  802510:	0f bd e8             	bsr    %eax,%ebp
  802513:	83 f5 1f             	xor    $0x1f,%ebp
  802516:	0f 84 ac 00 00 00    	je     8025c8 <__umoddi3+0x108>
  80251c:	bf 20 00 00 00       	mov    $0x20,%edi
  802521:	29 ef                	sub    %ebp,%edi
  802523:	89 fe                	mov    %edi,%esi
  802525:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	d3 e0                	shl    %cl,%eax
  80252d:	89 d7                	mov    %edx,%edi
  80252f:	89 f1                	mov    %esi,%ecx
  802531:	d3 ef                	shr    %cl,%edi
  802533:	09 c7                	or     %eax,%edi
  802535:	89 e9                	mov    %ebp,%ecx
  802537:	d3 e2                	shl    %cl,%edx
  802539:	89 14 24             	mov    %edx,(%esp)
  80253c:	89 d8                	mov    %ebx,%eax
  80253e:	d3 e0                	shl    %cl,%eax
  802540:	89 c2                	mov    %eax,%edx
  802542:	8b 44 24 08          	mov    0x8(%esp),%eax
  802546:	d3 e0                	shl    %cl,%eax
  802548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802550:	89 f1                	mov    %esi,%ecx
  802552:	d3 e8                	shr    %cl,%eax
  802554:	09 d0                	or     %edx,%eax
  802556:	d3 eb                	shr    %cl,%ebx
  802558:	89 da                	mov    %ebx,%edx
  80255a:	f7 f7                	div    %edi
  80255c:	89 d3                	mov    %edx,%ebx
  80255e:	f7 24 24             	mull   (%esp)
  802561:	89 c6                	mov    %eax,%esi
  802563:	89 d1                	mov    %edx,%ecx
  802565:	39 d3                	cmp    %edx,%ebx
  802567:	0f 82 87 00 00 00    	jb     8025f4 <__umoddi3+0x134>
  80256d:	0f 84 91 00 00 00    	je     802604 <__umoddi3+0x144>
  802573:	8b 54 24 04          	mov    0x4(%esp),%edx
  802577:	29 f2                	sub    %esi,%edx
  802579:	19 cb                	sbb    %ecx,%ebx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 e9                	mov    %ebp,%ecx
  802585:	d3 ea                	shr    %cl,%edx
  802587:	09 d0                	or     %edx,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	d3 eb                	shr    %cl,%ebx
  80258d:	89 da                	mov    %ebx,%edx
  80258f:	83 c4 1c             	add    $0x1c,%esp
  802592:	5b                   	pop    %ebx
  802593:	5e                   	pop    %esi
  802594:	5f                   	pop    %edi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    
  802597:	90                   	nop
  802598:	89 fd                	mov    %edi,%ebp
  80259a:	85 ff                	test   %edi,%edi
  80259c:	75 0b                	jne    8025a9 <__umoddi3+0xe9>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	31 d2                	xor    %edx,%edx
  8025a5:	f7 f7                	div    %edi
  8025a7:	89 c5                	mov    %eax,%ebp
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f5                	div    %ebp
  8025af:	89 c8                	mov    %ecx,%eax
  8025b1:	f7 f5                	div    %ebp
  8025b3:	89 d0                	mov    %edx,%eax
  8025b5:	e9 44 ff ff ff       	jmp    8024fe <__umoddi3+0x3e>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	89 c8                	mov    %ecx,%eax
  8025be:	89 f2                	mov    %esi,%edx
  8025c0:	83 c4 1c             	add    $0x1c,%esp
  8025c3:	5b                   	pop    %ebx
  8025c4:	5e                   	pop    %esi
  8025c5:	5f                   	pop    %edi
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    
  8025c8:	3b 04 24             	cmp    (%esp),%eax
  8025cb:	72 06                	jb     8025d3 <__umoddi3+0x113>
  8025cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025d1:	77 0f                	ja     8025e2 <__umoddi3+0x122>
  8025d3:	89 f2                	mov    %esi,%edx
  8025d5:	29 f9                	sub    %edi,%ecx
  8025d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025db:	89 14 24             	mov    %edx,(%esp)
  8025de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025e6:	8b 14 24             	mov    (%esp),%edx
  8025e9:	83 c4 1c             	add    $0x1c,%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    
  8025f1:	8d 76 00             	lea    0x0(%esi),%esi
  8025f4:	2b 04 24             	sub    (%esp),%eax
  8025f7:	19 fa                	sbb    %edi,%edx
  8025f9:	89 d1                	mov    %edx,%ecx
  8025fb:	89 c6                	mov    %eax,%esi
  8025fd:	e9 71 ff ff ff       	jmp    802573 <__umoddi3+0xb3>
  802602:	66 90                	xchg   %ax,%ax
  802604:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802608:	72 ea                	jb     8025f4 <__umoddi3+0x134>
  80260a:	89 d9                	mov    %ebx,%ecx
  80260c:	e9 62 ff ff ff       	jmp    802573 <__umoddi3+0xb3>

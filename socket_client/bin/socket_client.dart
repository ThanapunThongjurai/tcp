import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Future<void> sendMessage(Socket socket, String message) async {}

List<String> SplitData(String data) {
    LineSplitter ls = new LineSplitter();
    List<String> decode = ls.convert(data);

    for (int i = 0; i < decode.length; i++) {
      //TODO CHECKSUM
      if (decode[i] == null) {
        decode.removeAt(i);
      }
    }
    
    return decode;
}

bool checkSum(String dataMessage)
{ 
  int checksumResult = 0;
  List<int> messageBytes = utf8.encode(dataMessage.toUpperCase());
  List<int> messageBytesCut = messageBytes.sublist(1, messageBytes.length - 3);
  int sum  = int.parse("0x"+dataMessage.substring(messageBytes.length - 2, messageBytes.length));
  
  
  for (int i = 0; i < messageBytesCut.length; i++) { 
      checksumResult = checksumResult ^ messageBytesCut[i]; 
  }
  print("data : ${dataMessage}");
  print(utf8.decode(messageBytesCut));
  print("sum : ${sum}");
  print("checksumResult : ${checksumResult}");
  if((checksumResult == sum)){
    
    print("check : true");
    print("");
    return true;
  } 
  else{ 
    print("check : false");
    print("");
    return false; 
  }
}

Future<void> checkSumCalulator(String message) async { 
  List<String> splitDataMessage = SplitData(message);
  //print(splitDataMessage);
  for(int i = 0; i < splitDataMessage.length ; i++)
  {
    checkSum(splitDataMessage[i]);
  }
  //param
  

  //checkSum
  // for (int i = 0; i < messageBytesCut.length; i++) { 
  //     //print("$checksum \t [${checksum.toRadixString(2)}] ^\t ${messageBytesCut[i]}[${String.fromCharCode(messageBytesCut[i])}] \t ${messageBytesCut[2].toRadixString(2)} : ${(checksum ^ messageBytesCut[i]) /*.toRadixString(2)*/}");
  //     checksum = checksum ^ messageBytesCut[i]; 
  // }

  //print("messaage assice code : ${message.toUpperCase()}");
  // print("messaage assice code : ${messageBytes}");
  // print("messaage assice codecut : ${messageBytesCut}");
  // print("messaage codecut : ${utf8.decode(messageBytesCut)}");
  // print("checksum : ${checksum.toRadixString(16)}");
  
}

void main() async {
  // connect to the socket server
  final socket = await Socket.connect('192.168.137.7', 9000);
  print(
      'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}\n\n');

  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      checkSumCalulator(serverResponse);
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('ServerLeft.');
      socket.destroy();
    },
  );

  // send messages to the server
  // print('EnterDataToServer : ');
  // String? text = stdin.readLineSync();
  //await sendMessage(socket, text!);
}

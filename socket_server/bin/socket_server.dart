import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

void main() async {
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9000);
  List<String> splitDataMessage = [];

  var readAsStringSync = File('testdata.txt').readAsStringSync();
  splitDataMessage.addAll(SplitData(readAsStringSync));
  for(int i = 0 ; i < splitDataMessage.length ; i ++)
  {
    print("${i} ${splitDataMessage[i]}");
  }

  // listen for clent connections to the server
  server.listen((client) async {
    handleConnection(client);
    while(true){
      for(int i = 0 ; i < splitDataMessage.length ; i ++)
      {
        await Future.delayed(Duration(milliseconds: 10));
        client.write("${splitDataMessage[i]}\r\n");
      }
    }
  });
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}\n\n');

  // listen for events from the client
  client.listen(
    // handle data from the client
    (Uint8List data) async {
      final message = String.fromCharCodes(data);
      client.write('ServerSave ${message}');
      print('Receive Client Data : ${message}');
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}

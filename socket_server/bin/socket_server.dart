import 'dart:io';
import 'dart:typed_data';

void main() async {
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 10160);

  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
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

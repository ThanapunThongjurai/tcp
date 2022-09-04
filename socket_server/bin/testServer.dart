import 'dart:core';
import 'dart:async';
import 'dart:io';

void startServer() {
  Future<ServerSocket> serverFuture = ServerSocket.bind('0.0.0.0', 55555);
  serverFuture.then((ServerSocket server) {
    server.listen((Socket socket) {
      socket.listen((List<int> data) {
        String result = new String.fromCharCodes(data);
        print(result.substring(0, result.length - 1));
      });
    });
  });
}

void main() {
  startServer();
}
// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.
import 'dart:io';

class Sevr {
  // Connect(int port) {
  //   this.port = port;
  // }

  var server;
  String messageReturn;

  Future host(int port, String message) async {
    var bind = await HttpServer.bind(
      InternetAddress.loopbackIPv6,
      port,
    );

    server = bind;

    print(message);

    messageReturn = message;

    await for (HttpRequest request in bind) {
      request.response.write('Hello, world!');
      await request.response.close();
    }

    // await for (HttpRequest request in server) {
    //   request.response.write('Hello, world!');
    //   await request.response.close();
    // }

    return bind;
  }
}

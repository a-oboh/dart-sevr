import 'dart:io';

File targetFile = File('example/web/index.html');

Future main() async {
  var server;

  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
    print('listening on: ${server.port}');
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {
    if (await targetFile.exists()) {
      print('Serving ${targetFile.path}.');
      req.response.headers.contentType = ContentType.html;
      try {
        await req.response.addStream(targetFile.openRead());
      } catch (e) {
        print("Couldn't read file: $e");
        exit(-1);
      }
    } else {
      print("Can't open ${targetFile.path}.");
      req.response.statusCode = HttpStatus.notFound;
    }
    await req.response.close();
  }

  // var staticFiles = VirtualDirectory('example/web');
  // staticFiles.allowDirectoryListing = true; /*1*/
  // staticFiles.directoryHandler = (dir, request) /*2*/ {
  //   var indexUri = Uri.file(dir.path).resolve('index.html');
  //   staticFiles.serveFile(File(indexUri.toFilePath()), request); /*3*/
  // };

  // var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
  // print('Listening on port 4044');
  // await server.forEach(staticFiles.serveRequest); /*4*/
}

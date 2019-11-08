// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:sevr/src/serv_router/serv_router.dart';

/// Checks if you are awesome. Spoiler: you are.

void main(List<String> args) {
  print("starting point");
}

class Serv {
  bool get isAwesome => true;
  static final Serv _serv = Serv._internal();
  final Router router = Router();
  
    //Exposes a singleton Instance of the class through out its use
    factory Serv(){
      return _serv;
    }
  
    Serv._internal();

    //listens for connection on the specified port
    listen(int port,{Function callback,SecurityContext context})async{
      callback();
      HttpServer server;
      if(context == null){
          server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

      } else {
        server = await HttpServer.bindSecure(InternetAddress.loopbackIPv4, port, context);
      }


      await for (var request in server){
        //calls the class as a function to handle incoming requests: calling _serv(request) runs the call method in the Serv singleton instance class
        _serv(request);
      }
      

    }

    call(HttpRequest request){
        print(request.uri);
        // if(request.method == 'GET'){
        //   if(router.getRoutes.contains(request.uri.path)){
        //     int index = router.getRoutes.indexOf(request.uri.path);
        //     router.gets[index][]
        //   }
        // }
        request.response
                  ..statusCode = 200
                  ..write(request.uri)
                  ..close();
    }
  
  }
  

// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:sevr/src/serv_router/serv_router.dart';

class Sevr {
  String messageReturn='';
  static final Sevr _serv = Sevr._internal();
  final Router router = Router();
  
    //Exposes a singleton Instance of the class through out its use
    factory Sevr(){
      return _serv;
    }
  
    Sevr._internal();

    //listens for connection on the specified port
    listen(int port,{Function callback,SecurityContext context,String messageReturn})async{
      this.messageReturn = messageReturn;
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


    call(HttpRequest request)async{
        if(request.method == 'GET'){
          _handleGet(request);
                  }
              }
          
            void _handleGet(HttpRequest request)async {
               if(router.getRoutes.contains(request.uri.toString())){
            int index = router.getRoutes.indexOf(request.uri.path);
            List<Function(HttpRequest req,{bool next})> callbacks = router.gets[index][request.uri.toString()];
            callbacks.forEach((Function(HttpRequest req,{bool next}) func){
                //we can create a wrapper around the http request we are passing here so we make it much more simpler to use
                func(request);
            });
          } else {
            request.response.statusCode = HttpStatus.notFound;
            await request.response.close();
          }
            }
  
  }
  

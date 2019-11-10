// TODO: Put public facing types in this file.

import 'dart:io';
import 'dart:convert';
import 'package:sevr/src/serv_content_types/serv_content_types.dart';
import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';
import 'package:sevr/src/serv_router/serv_router.dart';

class Sevr {
  String messageReturn = '';
  static final Sevr _serv = Sevr._internal();
  final Router router = Router();

  //Exposes a singleton Instance of the class through out its use
  factory Sevr() {
    return _serv;
  }

  Sevr._internal();

  //listens for connection on the specified port
  listen(int port,
      {Function callback,
      SecurityContext context,
      String messageReturn}) async {
    this.messageReturn = messageReturn;
    if (callback != null) {
      callback();
    }
    HttpServer server;
    if (context == null) {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    } else {
      server = await HttpServer.bindSecure(
          InternetAddress.loopbackIPv4, port, context);
    }

    await for (var request in server) {
      //calls the class as a function to handle incoming requests: calling _serv(request) runs the call method in the Serv singleton instance class
      _serv(request);
    }
  }

  call(HttpRequest request) async {
    print(request.headers.contentType);
    ServRequest req = ServRequest(request);
    ServResponse res = ServResponse(request);
      request.listen((onData)async{
        switch (ServContentType(req.header.contentType.toString())) {
          case ServContentTypeEnum.ApplicationJson:
            String s = String.fromCharCodes(onData);
            Map<String,dynamic> jsonData = json.decode(s);
            req.body = jsonData;
            break;
        
          default:
            //Todo handle other content types
            print(req.header.contentType.toString());
        }
        
       
      },onDone: (){
        if (request.method == 'GET') {
              _handleGet(req,res);
    
        }
      });
    
  }

  void _handleGet(ServRequest req, ServResponse res) async {
  List<Function(ServRequest, ServResponse, [bool next])> selectedCallbacks = router.gets.containsKey(req.path) ||  router.gets.containsKey('${req.path}/')? router.gets[req.path]:null;
    if (selectedCallbacks!=null) {
      selectedCallbacks.forEach((Function(ServRequest req,ServResponse res, [bool next]) func) async{
        //we can create a wrapper around the http request we are passing here so we make it much more simpler to use
      await func(req,res,true);

      });
    } else {
      res.status(HttpStatus.notFound).json({'error':'method not found'});
    }
  }

  get(String route,List<Function(ServRequest req,ServResponse res, [bool next])> callbacks){
    this.router.gets[route] = callbacks;

       }
  void _handlePost(){

  }

  void _handleDelete(){

  }

  void _handlePut(){

  }

  void _handlePatch(){

  }


}

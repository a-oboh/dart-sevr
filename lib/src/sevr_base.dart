// TODO: Put public facing types in this file.

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:sevr/src/serv_content_types/serv_content_types.dart';
import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';
import 'package:sevr/src/serv_router/serv_router.dart';
import 'package:http_server/http_server.dart';
import 'package:pedantic/pedantic.dart';

class Sevr {
  String messageReturn = '';
  static final Sevr _serv = Sevr._internal();
  final Router router = Router();
  int port;
  var host;

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
    var server;
    if (context == null) {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    } else {
      server = await HttpServer.bindSecure(
          InternetAddress.loopbackIPv4, port, context);
    }
    

    this.port = port;
    this.host = InternetAddress.loopbackIPv4;

    await for (var request in server) {
      //calls the class as a function to handle incoming requests: calling _serv(request) runs the call method in the Serv singleton instance class
      _serv(request);
    }
  }

  call(HttpRequest request) async {
    print(request.headers.contentType);

    ServRequest req = ServRequest(request);
    ServResponse res = ServResponse(request);
    String contentType = req.headers.contentType.toString();
    Map<String, dynamic> jsonData = {};
    dynamic downloadData = List<int>();
    List<dynamic> tempOnData = List<int>();
    if (contentType.contains('multipart/form-data')) {
      contentType = 'multipart/form-data';
    }

    switch (ServContentType(contentType)) {
      case ServContentTypeEnum.ApplicationJson:
        StreamSubscription _sub;
        _sub = request.listen((Uint8List onData) {
          downloadData.addAll(onData);
        }, onDone: () {
          String s = String.fromCharCodes(downloadData);
          jsonData.addAll(json.decode(s));
          req.body = jsonData;

          switch (request.method) {
            case 'GET':
              _handleGet(req, res);
              break;
            default:
          }
        });

        break;
      case ServContentTypeEnum.MultipartFormData:
        String boundary = request.headers.contentType.parameters['boundary'];
        List fileKeys = [];
        request.transform(MimeMultipartTransformer(boundary)).listen(
            (MimeMultipart onData) async {
          HttpMultipartFormData formDataObject =
              HttpMultipartFormData.parse(onData);
          if (formDataObject.isBinary ||
              formDataObject.contentDisposition.parameters
                  .containsKey('filename')) {
            print('isBinary');
            print('${formDataObject.contentDisposition.parameters}');
            if (!fileKeys.contains(
                formDataObject.contentDisposition.parameters['name'])) {
              fileKeys
                  .add(formDataObject.contentDisposition.parameters['name']);
              StreamController _fileStreamController = StreamController();
              SevrFile requestFileObject = SevrFile(
                  formDataObject.contentDisposition.parameters['name'],
                  formDataObject.contentDisposition.parameters['filename'],
                  _fileStreamController);
              req.files[formDataObject.contentDisposition.parameters['name']] =
                  requestFileObject;
            }
            StreamController _fcont = req
                .files[formDataObject.contentDisposition.parameters['name']]
                .streamController;
              unawaited(
                  _fcont.sink.addStream(formDataObject).then((dynamic c) async {
                return _fcont.close();
              }));
          } else {
            // formDataObject.listen((onData) {
            jsonData.addAll({
              formDataObject.contentDisposition.parameters['name']:
                  await formDataObject.join()
            });
            req.body = jsonData;
            // });
          }
        }, onDone: () {});
        Future.delayed(Duration.zero, () {
          switch (request.method) {
            case 'GET':
              _handleGet(req, res);
              break;
          }
        });
        break;

      case ServContentTypeEnum.ApplicationFormUrlEncoded:
        // Yet to be implememnted
        break;

      default:
        break;
    }
  }

  void _handleGet(ServRequest req, ServResponse res) async {
    List<Function(ServRequest, ServResponse)> selectedCallbacks =
        router.gets.containsKey(req.path) ||
                router.gets.containsKey('${req.path}/')
            ? router.gets[req.path]
            : null;
    if (selectedCallbacks != null && selectedCallbacks.isNotEmpty) {
      for (var func in selectedCallbacks) {
        var result = await func(req, res);
        print(result.runtimeType);
        if (result is ServResponse) {
          if (req.files.isNotEmpty){
            for (int i = 0; i < req.files.keys.length; i++) {
        File file = File(req.files[req.files.keys.toList()[i]].filename);
        StreamController fileC = req.files[req.files.keys.toList()[i]].streamController;
        if(!fileC.isClosed){
          await for (var data
            in req.files[req.files.keys.toList()[i]].streamController.stream) {
                //do nothing, consume file stream incase it wasn't consumed before to avoid throwing errors
         
        }
        }
        
      }
          }
          await res.response.close();
          break;
        }
      }
    } else {
      res.status(HttpStatus.notFound).json({'error': 'method not found'});
    }
  }

  get(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.gets[route] = callbacks;
  }

  void _handlePost(HttpRequest request) async {}

  void _handleDelete() {}

  void _handlePut() {}

  void _handlePatch() {}

  String parseUrlEncodedValuesToString(String keyVal) {
    return null;
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sevr/src/build_data.dart';
import 'package:sevr/src/mime/mime.dart';
import 'package:sevr/src/serv_content_types/serv_content_types.dart';
import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';
import 'package:sevr/src/serv_router/serv_router.dart';
import 'package:sevr/src/http_server/http_server.dart';
import 'package:pedantic/pedantic.dart';

import 'serv_content_types/serv_content_types.dart';

class Sevr {
  String messageReturn = '';
  static final Sevr _serv = Sevr._internal();
  final Router router = Router();
  int port;
  var host;
  List<SevrDir> servDirs = [];

  static SevrDir static(String dir) {
    return SevrDir(dir);
  }

  //Exposes a singleton Instance of the class through out its use
  factory Sevr() {
    return _serv;
  }

  Sevr._internal();

  /// listens for connection on the specified port
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

  dynamic call(HttpRequest request) async {
    ServRequest req = ServRequest(request);
    ServResponse res = ServResponse(request);
    String contentType = req.headers.contentType.toString();
    Map<String, dynamic> jsonData = {};
    dynamic downloadData = List<int>();

    if (contentType.contains('multipart/form-data')) {
      contentType = 'multipart/form-data';
    }

    switch (ServContentType(contentType)) {
      case ServContentTypeEnum.ApplicationJson:
        StreamSubscription _sub;
        _sub = request.listen((Uint8List onData) {
          downloadData.addAll(onData);
        }, onDone: (){
          try{
            String s = String.fromCharCodes(downloadData);
          if (s.isNotEmpty) {
            jsonData.addAll(json.decode(s));
            req.tempBody = jsonData; 
          }
         
          } catch (e){
              req.currentException = e;
          }
           _handleRequests(req, res, request.method);

          
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
            // print('isBinary');
            // print('${formDataObject.contentDisposition.parameters}');
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
              _fcont.sink.addStream(formDataObject).then(
                (dynamic c) async {
                  return _fcont.close();
                },
              ),
            );
          } else {
            // formDataObject.listen((onData) {
            jsonData.addAll({
              formDataObject.contentDisposition.parameters['name']:
                  await formDataObject.join()
            });
            // print(':;;;;;;;;;;;');
            req.tempBody = jsonData;
            // print(jsonData);
            // });
          }
        }, onDone: () {});
        Future.delayed(Duration.zero, () {
          _handleRequests(req, res, request.method);
        });
        break;

      case ServContentTypeEnum.ApplicationFormUrlEncoded:
        // get data from form
        var body = await request
            .transform(utf8.decoder.cast<Uint8List, dynamic>())
            .join();

        Map<String, dynamic> result = {};

        buildMapFromUri(result, body);

        req.tempBody = result;

        Future.delayed(Duration.zero, () {
          _handleRequests(req, res, request.method);
        });
        break;

      case ServContentTypeEnum.TextHtml:
        request.listen((onData) {
          print(String.fromCharCodes(onData));
        });

        Future.delayed(Duration.zero, () {
          _handleRequests(req, res, request.method);
        });
        break;

      default:
        Future.delayed(Duration.zero, () {
          _handleRequests(req, res, request.method);
        });
        break;
    }
  }

  Map get getAllRoutes {
    return {
      'GET': router.gets,
      'POST': router.posts,
      'PATCH': router.patchs,
      'PUT': router.puts,
      'DELETE': router.deletes,
      'COPY': router.copys,
      'HEAD': router.heads,
      'OPTIONS': router.optionss,
      'LINK': router.links,
      'UNLINK': router.unlinks,
      'PURGE': router.purges,
      'LOCK': router.locks,
      'UNLOCK': router.unlocks,
      'PROPFIND': router.propfinds,
      'VIEW': router.views
    };
  }

  ///create a `get` request, route: uri, callbacks: list of callback functions to run.
  get(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.gets[route] = callbacks;
  }

  ///create a `post` request, route: uri, callbacks: list of callback functions to run.
  post(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.posts[route] = callbacks;
  }

  ///create a `patch` request, route: uri, callbacks: list of callback functions to run.
  patch(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.patchs[route] = callbacks;
  }

  ///create a `put` request, route: uri, callbacks: list of callback functions to run.
  put(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.puts[route] = callbacks;
  }

  ///create a `delete` request, route: uri, callbacks: list of callback functions to run.
  delete(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.deletes[route] = callbacks;
  }

  ///create a `copy` request, route: uri, callbacks: list of callback functions to run.
  copy(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.copys[route] = callbacks;
  }

  ///create a `head` request, route: uri, callbacks: list of callback functions to run.
  head(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.heads[route] = callbacks;
  }

  ///create a `options` request, route: uri, callbacks: list of callback functions to run.
  options(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.optionss[route] = callbacks;
  }

  ///create a `link` request, route: uri, callbacks: list of callback functions to run.
  link(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.links[route] = callbacks;
  }

  ///create a `unlink` request, route: uri, callbacks: list of callback functions to run.
  unlink(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.unlinks[route] = callbacks;
  }

  ///create a `purge` request, route: uri, callbacks: list of callback functions to run.
  purge(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.purges[route] = callbacks;
  }

  ///create a `lock` request, route: uri, callbacks: list of callback functions to run.
  lock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.locks[route] = callbacks;
  }

  ///create a `unlock` request, route: uri, callbacks: list of callback functions to run.
  unlock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.unlocks[route] = callbacks;
  }

  ///create a `propfind` request, route: uri, callbacks: list of callback functions to run.
  propfind(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.propfinds[route] = callbacks;
  }

  ///create a `view` request, route: uri, callbacks: list of callback functions to run.
  view(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    this.router.views[route] = callbacks;
  }

  void _handleRequests(
      ServRequest req, ServResponse res, String reqType) async {
    Map reqTypeMap = getAllRoutes[reqType];
    String path = req.path.endsWith('/')
        ? req.path.replaceRange(req.path.length - 1, req.path.length, '')
        : req.path;
    // print(path);
    Map mapRes = getRouteParams(path, router.gets);
    Map params = mapRes.containsKey('params') ? mapRes['params'] : null;
    req.params = params.cast<String, String>() ?? {};
    String matched = mapRes['route'];
    print(matched);
    List<Function(ServRequest, ServResponse)> selectedCallbacks =
        reqTypeMap.containsKey(path)
            ? reqTypeMap[path]
            : matched != null ? reqTypeMap[matched] : null;
    if (selectedCallbacks != null && selectedCallbacks.isNotEmpty) {
      for (var func in selectedCallbacks) {
        var result = await func(req, res);
        // print(result.runtimeType);
        if (result is ServResponse) {
          await _consumeOpenFileStreams(req);
          await res.close();
          break;
        }
      }
    } else {
      await _consumeOpenFileStreams(req);
      for (SevrDir directory in servDirs) {
        String filePath = '${directory.dir.path}${req.path}';
        print(filePath);
        if (await File(filePath).exists()) {
          (await res.status(HttpStatus.ok).sendFile(filePath)).close();
          return;
        }
      }

      res
          .status(HttpStatus.notFound)
          .json({'error': 'method not found'}).close();
      print(res.response.connectionInfo);
    }
  }

  Map<String, dynamic> getRouteParams(String route, Map<String, List> query) {
    Map<String, dynamic> compareMap = {'params': {}, 'route': null};
    String matched = query.keys.firstWhere((String key) {
      List<String> routeArr = route.split('/');
      List<String> keyArr = key.split('/');
      if (routeArr.length != keyArr.length) return false;
      for (int i = 0; i < routeArr.length; i++) {
        if (routeArr[i].toLowerCase() == keyArr[i].toLowerCase() ||
            keyArr[i].toLowerCase().startsWith(':')) {
          if (keyArr[i].toLowerCase().startsWith(':')) {
            compareMap['params'][keyArr[i].replaceFirst(':', '')] = routeArr[i];
          }
        } else {
          return false;
        }
      }
      return true;
    }, orElse: () {
      return null;
    });
    compareMap['route'] = matched;
    return compareMap;
  }

  Future<void> _consumeOpenFileStreams(ServRequest req) async {
    if (req.files.isNotEmpty) {
      for (int i = 0; i < req.files.keys.length; i++) {
        // File file = File(req.files[req.files.keys.toList()[i]].filename);
        SevrFile fileC = req.files[req.files.keys.toList()[i]];
        if (!fileC.streamController.isClosed) {
          await for (var data in fileC.streamController.stream) {
            //do nothing, consume file stream incase it wasn't consumed before to avoid throwing errors

          }
        }
      }
    }
    return;
  }

  use(dynamic obj) {
    switch (obj.runtimeType) {
      case SevrDir:
        servDirs.add(obj);
        break;

      case Router:
        this.router.join(obj);
        break;

        break;
      default:
    }
  }
}

class SevrDir {
  Directory dir;
  SevrDir(String dirString) {
    this.dir = Directory(dirString);
  }
}

class UpperCase extends Converter<String, String> {
  @override
  String convert(String input) => input.toUpperCase();
}

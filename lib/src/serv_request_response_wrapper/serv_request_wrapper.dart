import 'dart:async';
import 'dart:convert' as json_helper;
import 'dart:io';

import 'package:sevr/src/mime/mime.dart';

///wrapper for [HttpRequest]
class ServRequest {
  HttpRequest request;
  Map<dynamic, dynamic> tempBody = {};
  Map<String, SevrFile> files = {};

  /// A map of parameters [:param] attached to requests
  Map<String, String> params = {};
  List currentExceptionList;
  ServException _exceptionThrower;
  ServRequest(HttpRequest request) {
    this.request = request;
  }

  Map get body {
    if ( currentExceptionList == null){
      return tempBody;
    } else {
      _exceptionThrower = ServException.from(currentExceptionList);
    currentExceptionList = null;
    _exceptionThrower.throwException();
    }
    return {};
    
  }

  /// the uri/path for an endpoint
  String get path {
    return request.uri.path;
  }

  ///get a Map containing query parameters with `req.query`
  Map get query {
    return request.uri.queryParameters;
  }

  /// request headers
  HttpHeaders get headers {
    return request.headers;
  }

  /// type of request, e.g `application/json`
  String get type {
    return request.headers.contentType.value;
  }
}

///Wrapper for the [HttpRequest request.response]
class ServResponse {
  HttpRequest request;
  bool isClosed = false;
  Map<String, dynamic> locals = {};
  ServResponse(HttpRequest request) {
    this.request = request;
  }

  // send(){

  // }

  /// gets response from HttpRequest Stream
  HttpResponse get response {
    return request.response;
  }

  ///Set [response.statusCode]
  ServResponse status(int statusCode) {
    response.statusCode = statusCode;
    return this;
  }

  /// Return data in json format. data = a map to be converted to json
  ServResponse json(Map<String, dynamic> data) {
    response
      ..headers.contentType = ContentType.json
      ..write(json_helper.json.encode(data));

    return this;
  }

  /// Serve static  file
  Future<ServResponse> sendFile(String returnFile) async {
    // VirtualDirectory vd = VirtualDirectory('.');
    // vd.serveFile(File(returnFile),request);

    File file;
    file = File(returnFile);
    String mimeType;
    mimeType = lookupMimeType(file.path);
    response.headers.contentType =
        mimeType != null ? ContentType.parse(mimeType) : ContentType.binary;
    await response.addStream(file.openRead());

    return this;
  }

  /// Close Stream
  ServResponse close() {
    response.close();
    isClosed = true;
    return this;
  }

  ServResponse set(String name, Object value) {
    response.headers.set(name, value);
    return this;
  }
}

class SevrFile {
  StreamController streamController;
  String filename;
  String name;

  SevrFile(this.name, this.filename, this.streamController);
}

class ServException {

  final List _exception; // A List of the exception and the stacktrace
  ServException(this._exception);

  static ServException from(List e){
    return ServException(e);
  }

  void throwException(){
    print(_exception[1]);
    throw _exception[0];
  }
}

import 'dart:async';
import 'dart:convert' as json_helper;
import 'dart:io';

import 'package:sevr/src/http_server/http_server.dart';
import 'package:sevr/src/mime/mime.dart';

///wrapper for [HttpRequest]
class ServRequest {
  HttpRequest request;
  Map<String, dynamic> body = {};
  Map<String, dynamic> files = {};
  Map<String, String> params = {};
  ServRequest(HttpRequest request) {
    this.request = request;
  }

  /// the uri/path for an endpoint
  String get path {
    return request.uri.path;
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

  HttpResponse get response {
    return this.request.response;
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

    File file = File(returnFile);
    String mimeType = lookupMimeType(file.path);
    response.headers.contentType = mimeType != null?ContentType.parse(mimeType):ContentType.binary;
    await response.addStream(file.openRead());

    return this;
  }



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

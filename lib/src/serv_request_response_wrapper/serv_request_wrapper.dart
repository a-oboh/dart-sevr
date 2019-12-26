import 'dart:async';
import 'dart:convert' as json_helper;
import 'dart:io';

///wrapper for [HttpRequest]
class ServRequest {
  HttpRequest request;
 Map<String,dynamic> body = {};
 Map<String,dynamic> files = {};
 Map<String,String> params = {};
  ServRequest(HttpRequest request){
    this.request = request;
  }

  /// the uri/path for an endpoint
  String get path {
    return request.uri.path;
  }

  /// request headers
  get headers {
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
    // print('you just called me');
    // print(data);
    response
      ..headers.contentType = ContentType.json
      ..write(json_helper.json.encode(data));
      // ..close();

    return this;
  }

  Future<ServResponse> sendFile(File file, ContentType contentType)async{
    response.headers.contentType = contentType;
    await response.addStream(file.readAsBytes().asStream());


    return this;
  }

  ServResponse close(){
    response.close();
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

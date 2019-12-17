import 'dart:async';
import 'dart:convert' as json_helper;
import 'dart:io';

class ServRequest {
  HttpRequest request;
 Map<String,dynamic> body = {};
 Map<String,dynamic> files = {};
  ServRequest(HttpRequest request){
    this.request = request;
    
    
      }

      String get path {
        return request.uri.path;
      }
    
       get headers{
        return request.headers;
      } 
    
      String get type {
        return request.headers.contentType.value;
      }
  
}

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

  ServResponse status(int statusCode) {
    response.statusCode = statusCode;
    return this;
  }

  ServResponse json(Map<String, dynamic> data) {
    // print('you just called me');
    // print(data);
    response
          ..headers.contentType =ContentType.json
          ..write(json_helper.json.encode(data));
          // ..close();
    
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

  SevrFile(this.name,this.filename,this.streamController);
}


import 'dart:convert' as json_helper;
import 'dart:io';
import 'package:body_parser/body_parser.dart';
class ServRequest{
  HttpRequest request;
 Map<String,dynamic> body = {};
  ServRequest(HttpRequest request){
    this.request = request;
    
      }
    
    
      // Future<Map<String,dynamic>> get body async{
      //   // return request.
      //   var b = await parseBody(request);
      //     // request.listen((onData){
      //     //   // print(onData.toString() + '\n');
      //     //   String s = String.fromCharCodes(onData);
      //     //   print(s);
      //     //   Map<String,dynamic> jsonData = json.decode(s);
      //     //   print(jsonData['name']);
      //     // });
      //   return b.body;
      // }
    
      String get path {
        return request.uri.path;
      }
    
       get header{
        return request.headers;
      } 
    
      String get type {
        return request.headers.contentType.value;
      }
    
      






}


class ServResponse{
  HttpRequest request;
  Map<String,dynamic> locals = {};
  ServResponse(HttpRequest request){
    this.request = request;
  }

  // send(){

  // }

  HttpResponse get response{
    return this.request.response;
  }

  ServResponse status(int statusCode){
    response.statusCode = statusCode;
    return this;

  }

  ServResponse json(Map<String,dynamic> data){
    // print('you just called me');
    // print(data);
    response
          ..headers.contentType =ContentType.json
          ..write(json_helper.json.encode(data))
          ..close();
    
    return this;
  }

  ServResponse set(String name, Object value){
      response.headers.set(name, value);
      return this;
  }



}
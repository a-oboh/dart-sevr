
import 'dart:convert' as json_helper;
import 'dart:io';

class ServRequest{
  HttpRequest request;

  ServRequest(HttpRequest request){
    this.request = request;
  }

  Map<String,dynamic> body(){
    // return request.
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
    response
          ..write(json_helper.json.encode(data))
          ..close();
    
    return this;
  }

  ServResponse set(String name, Object value){
      response.headers.set(name, value);
      return this;
  }


}
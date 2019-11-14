import 'dart:convert' as json_helper;
import 'dart:io';

///wrapper for [HttpRequest]
class ServRequest {
  HttpRequest request;

  Map<String, dynamic> body = {};

  ServRequest(HttpRequest request) {
    this.request = request;
  }

  ///The path of the [request] Uri
  String get path {
    return request.uri.path;
  }

  ///information about [request] headers
  get headers {
    return request.headers;
  }

  ///Getting [ContentType] of the [request]
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

  ///Send Json data to be written as response body
  ServResponse json(Map<String, dynamic> data) {
    // print('you just called me');
    // print(data);
    response
      ..headers.contentType = ContentType.json
      ..write(json_helper.json.encode(data))
      ..close();

    return this;
  }

  ServResponse set(String name, Object value) {
    response.headers.set(name, value);
    return this;
  }
}

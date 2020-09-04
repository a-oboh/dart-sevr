import 'package:meta/meta.dart';
import 'package:sevr/src/open_api/props.dart';
import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';

class Route {
  /// route url
  final String url;
  /// route method
  final String method;
  ///open api tag
  final String tag;
  ///route body specification for Open Api Generation
  ///{
  ///"username":{
  ///"type": "String",
  ///"description": "Username for registration",
  ///"required":
  ///}
  ///}
  final OpenApiReqBody openApiBodyDef;

  final OpenApiResp openApiResponseDef;

  final String summary;

  final List<OpenApiParamObject> openApiParamDef;


  final List<Function(ServRequest, ServResponse)> middlewares;
  const Route({@required this.url, this.method,this.middlewares = const [],this.openApiResponseDef, this.openApiBodyDef, @required this.tag, this.summary, this.openApiParamDef});
}
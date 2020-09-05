import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:sevr/src/logger/logger.dart';
import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';
import 'package:sevr/src/serv_router/routes.dart';
import 'package:sevr/src/extensions/extensions.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:sevr/src/open_api/props.dart';

class Router {
  Map<String, List<Function(ServRequest req, ServResponse res)>> gets = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> posts = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> patchs = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> puts = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> deletes = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> copys = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> heads = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> optionss = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> links = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> unlinks = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> purges = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> locks = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> unlocks = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> propfinds = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> views = {};

  ///controllers to be attached to these router
  final List controllers;

  dynamic get(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    gets[route] = callbacks;
  }

  dynamic post(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    posts[route] = callbacks;
  }

  dynamic patch(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    patchs[route] = callbacks;
  }

  dynamic put(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    puts[route] = callbacks;
  }

  dynamic delete(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    deletes[route] = callbacks;
  }

  dynamic copy(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    copys[route] = callbacks;
  }

  dynamic head(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    heads[route] = callbacks;
  }

  dynamic options(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    optionss[route] = callbacks;
  }

  dynamic link(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    links[route] = callbacks;
  }

  dynamic unlink(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    unlinks[route] = callbacks;
  }

  dynamic purge(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    purges[route] = callbacks;
  }

  dynamic lock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    locks[route] = callbacks;
  }

  dynamic unlock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    unlocks[route] = callbacks;
  }

  dynamic propfind(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    propfinds[route] = callbacks;
  }

  dynamic view(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    views[route] = callbacks;
  }

  void join(Router rter) {
    gets.addAll(rter.gets);
    posts.addAll(rter.posts);
    patchs.addAll(rter.patchs);
    puts.addAll(rter.puts);
    deletes.addAll(rter.deletes);
    copys.addAll(rter.copys);
    heads.addAll(rter.heads);
    optionss.addAll(rter.optionss);
    links.addAll(rter.links);
    unlinks.addAll(rter.unlinks);
    purges.addAll(rter.purges);
    locks.addAll(rter.locks);
    unlocks.addAll(rter.unlocks);
    propfinds.addAll(rter.propfinds);
    views.addAll(rter.views);
  }

  void registerViaMetaDatas() async {
    //register controllers and generate
    for (var i = 0; i < controllers.length; i++) {
      var ref = reflect(controllers[i]);
      var controllerRouteAnnottation = ref.type.metadata
          .lastWhere((element) => element.reflectee is Route,
              orElse: () => null)
          ?.reflectee as Route;
      var classUrl = controllerRouteAnnottation.url;
      var tag = controllerRouteAnnottation.tag;
      for (var j in [...ref.type.staticMembers.entries ]) {
        LogService.logger.i('registernnfdgnfgd odbnfol');
        // var key = j.key;
        var value = j.value;
        var methodRouteAnnotation = value.metadata
            .lastWhere((element) => element.reflectee is Route,
                orElse: () => null)
            ?.reflectee as Route;
        if (methodRouteAnnotation.isEmptyObj) {
          continue;
        }
        var methodUrl = p.join(classUrl, methodRouteAnnotation.url);
        var method = methodRouteAnnotation.method.toUpperCase();
        var bodyDef = methodRouteAnnotation.openApiBodyDef;
        var paramDef = methodRouteAnnotation.openApiParamDef??[];
        var respDef = methodRouteAnnotation.openApiResponseDef;
        var summary = methodRouteAnnotation.summary;
        var operationId = '${MirrorSystem.getName(value.simpleName)}Id';
        var pathSegment = value.location.sourceUri.pathSegments[0];
        switch (method) {
          case 'POST':
            post(methodUrl, [
              ...methodRouteAnnotation.middlewares,
              (ServRequest req, ServResponse res) {
                print('accessing ${methodUrl}');
                return ref.type.invoke(value.simpleName, [req, res]).reflectee;
              }
            ]);
            break;
          case 'GET':
            get(methodUrl, [
              ...methodRouteAnnotation.middlewares,
              (ServRequest req, ServResponse res) {
                return ref.type.invoke(value.simpleName, [req, res]);
              }
            ]);
            break;
          case 'PUT':
            put(methodUrl, [
              ...methodRouteAnnotation.middlewares,
              (ServRequest req, ServResponse res) {
                return ref.type.invoke(value.simpleName, [req, res]).reflectee;
              }
            ]);
            break;
          case 'DELETE':
            delete(methodUrl, [
              ...methodRouteAnnotation.middlewares,
              (ServRequest req, ServResponse res) {
                return ref.type.invoke(value.simpleName, [req, res]).reflectee;
              }
            ]);
            break;
          case 'PATCH':
            patch(methodUrl, [
              ...methodRouteAnnotation.middlewares,
              (ServRequest req, ServResponse res) {
                return ref.type.invoke(value.simpleName, [req, res]).reflectee;
              }
            ]);
            break;
          default:
            break;
        }
        generateMethodPathApi(
            methodUrl, method.toLowerCase(), bodyDef, respDef, tag, operationId,
            summary: summary, parameters: paramDef);
        formatRouteConsoleOutput(
            method: method,
            methodName: value.simpleName,
            methodPath:
                '${value.location.sourceUri.path.replaceFirst('${pathSegment}', '')}:${value.location.line}:${value.location.column}',
            methodUrl: methodUrl);
      }
    }
    paths.forEach((key, value) {
      LogService.logger.i(value.toJsonEntry);
    });
    generateOpenApi();
  }

  Router({this.controllers = const [],this.serverObjs = const[], this.openApiMainInfo});

  static List<OpenApiSchemaObj> schemaObjs = [];

  final OpenApiMainInfo openApiMainInfo;

  final List<OpenApiServerObject> serverObjs;

  void generateOpenApi() {
    mainPathObj.paths.addAll(paths.values);
    mainComponentObj.schemas.addAll(schemaObjs);
    var mainOpenApi = OpenApiMainObj(
        path: mainPathObj, component: mainComponentObj, info: openApiMainInfo, servers: serverObjs, );

    var file = File('./openapi.json');
    var encoder = JsonEncoder.withIndent('     ');
    file.writeAsStringSync(encoder.convert(mainOpenApi.toJson));
    get('/openapi.json', [
      (ServRequest req, ServResponse res)async{
        return (await res.status(200).sendFile(file.path)).close();
      }
    ]);
  }

  var mainPathObj = OpenApiMainPathObj(paths: []);
  var mainComponentObj =
      OpenApiMainComponentObj(schemas: [], securitySchemes: []);
  Map<String, OpenApiPath> paths = {};

  void generateMethodPathApi(String path, String method, OpenApiReqBody body,
      OpenApiResp resp, String tag, String operationId,
      {String summary = '',List<OpenApiParamObject> parameters}) {
    var thisPathMethod = OpenApiMethod(
        method: toOpenApiMethod(method.toLowerCase()),
        parameters: parameters,
        tags: [tag],
        summary: summary,
        operationId: operationId,
        requestBody: body,
        responses: resp);
    paths.putIfAbsent(path, () => OpenApiPath(path: path, methods: []))
      ..methods.add(thisPathMethod);
  }

  void formatRouteConsoleOutput(
      {@required Symbol methodName,
      @required method,
      @required methodUrl,
      @required methodPath}) {
    LogService.logger.i(
        '${MirrorSystem.getName(methodName)}\n${method}\n${methodUrl}\n${methodPath}');
  }
}

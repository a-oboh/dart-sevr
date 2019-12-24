import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';

class Router {
  Map<String, List<Function(ServRequest req, ServResponse res)>> gets = {};

  Map<String, List<Function(ServRequest req, ServResponse res)>> posts = {};
  // List<String> getRoutes = [];

  get(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    gets[route] = callbacks;
  }

  post(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    posts[route] = callbacks;
  }

  patch() {}

  put() {}

  delete() {}
}

import 'dart:io';

class Router {
  //Mapping get request routes to callbacks
  List<Map<String, List<Function(HttpRequest req, {bool next})>>> gets = [];

  //list of get routes
  List<String> getRoutes = [];

  //Mapping post request routes to callbacks
  List<Map<String, List<Function(HttpRequest req, {bool next})>>> posts = [];

  //list of post routes
  List<String> postRoutes = [];

  get(String route, List<Function(HttpRequest req, {bool next})> callbacks) {
    getRoutes.add(route);
    gets.add({route: callbacks});
  }

  post(String route, List<Function(HttpRequest req, {bool next})> callbacks) {
    postRoutes.add(route);
    posts.add({route: callbacks});
  }

  patch() {}

  put() {}

  delete() {}
}

class AwesomeRequest {}

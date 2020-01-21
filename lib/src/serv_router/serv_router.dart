import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';

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
  // List<String> getRoutes = [];

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
}

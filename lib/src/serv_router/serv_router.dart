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

  void get(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    gets[route] = callbacks;
  }

  void post(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    posts[route] = callbacks;
  }

  void patch(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    patchs[route] = callbacks;
  }

  void put(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    puts[route] = callbacks;
  }

 void delete(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    deletes[route] = callbacks;
  }

   void copy(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    copys[route] = callbacks;
  }

  void head(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    heads[route] = callbacks;
  }

  void options(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    optionss[route] = callbacks;
  }

  void link(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    links[route] = callbacks;
  }

  void unlink(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    unlinks[route] = callbacks;
  }

  void purge(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    purges[route] = callbacks;
  }

  void lock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    locks[route] = callbacks;
  }

  void unlock(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    unlocks[route] = callbacks;
  }

  void propfind(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    propfinds[route] = callbacks;
  }

  void view(String route,
      List<Function(ServRequest req, ServResponse res)> callbacks) {
    views[route] = callbacks;
  }

  void join(Router rter){
    this.gets.addAll(rter.gets);
    this.posts.addAll(rter.posts);
    this.patchs.addAll(rter.patchs);
    this.puts.addAll(rter.puts);
    this.deletes.addAll(rter.deletes);
    this.copys.addAll(rter.copys);
    this.heads.addAll(rter.heads);
    this.optionss.addAll(rter.optionss);
    this.links.addAll(rter.links);
    this.unlinks.addAll(rter.unlinks);
    this.purges.addAll(rter.purges);
    this.locks.addAll(rter.locks);
    this.unlocks.addAll(rter.unlocks);
    this.propfinds.addAll(rter.propfinds);
    this.views.addAll(rter.views);
  }

}

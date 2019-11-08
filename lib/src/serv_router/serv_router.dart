  import 'dart:io';

class Router {
  List<Map<String,List<Function(HttpRequest req,{bool next})>>> gets = [];
  List<String> getRoutes = [];
    

    get(String route,List<Function(HttpRequest req,{bool next})> callbacks){
      getRoutes.add(route);
      gets.add({
        route:callbacks
      });

       }
    
        post(){
    
    
        }
    
    
        patch(){
    
    
        }
    
        put(){
    
    
        }
    
        delete(){
    
    
        }
    
    
    
    
    
    
    
    
      }
    
    class AwesomeRequest {
}

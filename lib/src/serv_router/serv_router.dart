import 'package:sevr/src/serv_request_response_wrapper/serv_request_wrapper.dart';

class Router {
  Map<String,List<Function(ServRequest req,ServResponse res,[bool next])>> gets = {};
  // List<String> getRoutes = [];
    

    get(String route,List<Function(ServRequest req,ServResponse res,[bool next])> callbacks){
      gets[route] = callbacks;

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

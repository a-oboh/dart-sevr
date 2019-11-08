import 'package:sevr/sevr.dart';


main() {
  var serv = Sevr();
  var router = serv.router;

  //so like express we can create controller,middleware classes etc and then put them in a list and then pass them into the router methods
  router.get('/test',[(req,{next=false})async{
    final res = req.response;
     res
         ..statusCode = 200
          ..write(req.uri);
        await res.close();
    
  }]);
  // router.put();
  // router.patch();
  // router.delete();
  // router.post();
  serv.listen(3000,callback: (){
    print('Listening on ${3000}');
  });
}
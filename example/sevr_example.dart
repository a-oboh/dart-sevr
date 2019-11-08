import 'package:sevr/sevr.dart';

main() {
  var serv = Serv();
  var router = serv.router;

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
  serv.listen(8000,callback: (){
    print('Listening on ${8000}');
  });
}

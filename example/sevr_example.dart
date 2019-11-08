import 'dart:io';

import 'package:sevr/sevr.dart';

main() {
  var serv = Serv();
  var router = serv.router;

  router.get('/test',[(HttpRequest req,{next=false}){
    final res = req.response;
    res.statusCode = HttpStatus.ok;
    
  }]);
  // router.put();
  // router.patch();
  // router.delete();
  // router.post();
  serv.listen(8000,callback: (){
    print('Listening on ${8000}');
  });
}

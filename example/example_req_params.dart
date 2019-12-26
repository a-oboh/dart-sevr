import 'dart:io';

import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();

  //so like express we can create controller,middleware classes etc and then put them in a list and then pass them into the router methods
  serv.get('/test/:username', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'params': req.params});
    }
  ]);

  serv.get('/html', [
    (ServRequest req, ServResponse res){
      return res.status(200).sendFile(File('./example.html'), ContentType.html);
    }
  ]);

  serv.listen(3000, callback: () {
    print('Listening on ${3000}');
  });
  
}

//  controllerClassOne(req,res)async{
//   res.locals['response'] = req.body;
// }

// controllerReturn(req,res){
//   print('running the second function');
//   return res.status(200).json(res.locals['response']);
// }

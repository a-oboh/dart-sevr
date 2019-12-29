import 'dart:io';
import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();
  serv.use(Sevr.static('./web'));

  //We can create controller,middleware classes etc, put them in a list and pass them into the router methods
  serv.get('/file', [
    (ServRequest req, ServResponse res) {
      return res.status(200).sendFile('./index.html');
    }
  ]);

  serv.get('/test', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'status': 'ok'});
    }
  ]);

  serv.post('/post', [
    (ServRequest req, ServResponse res) async {
      return res.status(200).json(req.body);
    }
  ]);

  serv.listen(4000, callback: () {
    print('Listening on port: ${4000}');
  });
}

//  controllerClassOne(req,res)async{
//   res.locals['response'] = req.body;
// }

// controllerReturn(req,res){
//   print('running the second function');
//   return res.status(200).json(res.locals['response']);
// }

import 'package:sevr/sevr.dart';

dynamic main() {
  var serv = Sevr();

  serv.get('/test/:username', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'params': req.params});
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

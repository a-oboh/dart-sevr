import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();

  //so like express we can create controller,middleware classes etc and then put them in a list and then pass them into the router methods
  serv.get('/test', [
    (req, res) {
      return res.status(200).json({'status': 'ok'});
    }
  ]);

  serv.post('/post', [
    (req, res) {
      return res.status(200);
    }
  ]);

  serv.listen(4000, callback: () {
    print('Listening on ${4000}');
  });
}

//  controllerClassOne(req,res)async{
//   res.locals['response'] = req.body;
// }

// controllerReturn(req,res){
//   print('running the second function');
//   return res.status(200).json(res.locals['response']);
// }

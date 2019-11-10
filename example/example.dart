import 'package:sevr/sevr.dart';


main() {
  var serv = Sevr();

  //so like express we can create controller,middleware classes etc and then put them in a list and then pass them into the router methods
  serv.get('/test',[controllerClassOne,controllerReturn]);
  
  serv.listen(3000,callback: (){
    print('Listening on ${3000}');
  });
}

 controllerClassOne(req,res,[bool next])async{
  Map<String, dynamic> response ={};
  print(req.body);
  res.locals['response'] = req.body;
}

controllerReturn(req,res,[bool next]){
  res.status(200).json(res.locals['response']);
}
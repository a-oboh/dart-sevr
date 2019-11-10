import 'dart:convert';
import 'dart:io';

import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();
  var router = serv.router;

  //so like express we can create controller,middleware classes etc and then put them in a list and then pass them into the router methods
  router.get('/test', [
    (req, {next = false}) async {
      final res = req.response;
      res
        ..statusCode = 200
        ..write(req.uri);
      await res.close();
    }
  ]);

  router.post('/post', [
    (req, {next = false}) async {
      final res = req.response;
      print('post request');

      req.listen((onData) {
        // print(onData.toString() + '\n');
        String s = String.fromCharCodes(onData);
        // print(s);
        Map<String, dynamic> jsonData = json.decode(s);
        print(jsonData);
      });

      res
        ..statusCode = 200
        ..write({'test': 'response'});
      await res.close();
    }
  ]);

  // router.put();
  // router.patch();
  // router.delete();
  serv.listen(4000, callback: () {
    print('Listening on ${4000}');
  });
}

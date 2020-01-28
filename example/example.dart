import 'dart:io';

import 'package:sevr/sevr.dart';
import 'package:path/path.dart' as p;

dynamic main() {
  var serv = Sevr();

  //let sevr know to serve from the /web directory
  serv.use(Sevr.static('example/web'));

  //Use path to get directory of the files to serve on that route
  serv.get('/serve', [
    (ServRequest req, ServResponse res) {
      return res.status(200).sendFile(p.absolute('example/web/index.html'));
    }
  ]);

  //get request
  serv.get('/test', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'status': 'ok'});
    }
  ]);

  //post request
  serv.post('/post', [
    (ServRequest req, ServResponse res) async {
      return res.status(200).json(req.body);
    }
  ]);

  // request parameters
  serv.get('/param/:username', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'params': req.params});
    }
  ]);

  // query parameters
  serv.get('/query', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json(req.query);
    }
  ]);

  //Upload Files
  serv.get('/upload', [
    (req, res) async {
      for (var i = 0; i < req.files.keys.length; i++) {
        //Handle your file stream as you see fit, write to file, pipe to a cdn etc --->
        var file = File(req.files[req.files.keys.toList()[i]].filename);
        await for (var data
            in req.files[req.files.keys.toList()[i]].streamController.stream) {
          if (data is String) {
            await file.writeAsString(data, mode: FileMode.append);
          } else {
            await file.writeAsBytes(data, mode: FileMode.append);
          }
        }
      }

      return res.status(200).json(req.body);
    }
  ]);

  //Bind server to port 4000
  serv.listen(4000, callback: () {
    print('Listening on port: ${4000}');
  });
}

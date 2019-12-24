import 'dart:io';
import 'dart:typed_data';

import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();
  serv.get('/test', [
    (req, res) async {
      for (int i = 0; i < req.files.keys.length; i++) {
        //Handle your file stream as you see fit, write to file, pipe to a cdn etc --->
        File file = File(req.files[req.files.keys.toList()[i]].filename);
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

  serv.listen(3000, callback: () {
    print('Listening on ${3000}');
  });
}

import 'dart:io';
import 'package:sevr/sevr.dart';
void main(List<String> arguments) {
  print(arguments);
  var serv = Sevr();
  serv.post('/upload', [
    (req, res) async {
      for (var sevrFile in req.files.values){
        var file = File(sevrFile.filename);
        if (await file.exists()){ file.deleteSync();}
        await for (var data in sevrFile.streamController.stream){
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

  serv.listen(8000, callback: () {
    print('Listening on port: ${8000}');
  });
}

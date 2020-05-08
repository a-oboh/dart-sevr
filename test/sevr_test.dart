import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sevr/sevr.dart';
import 'package:sevr/src/serv_content_types/serv_content_types.dart';
import 'package:sevr/src/sevr_base.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  Sevr sevr;
  var port = 8078;

  var url = 'http://127.0.0.1:${port}';
  group('Test host connection', () {
    setUp(() {
      sevr = Sevr();
      sevr.use(Sevr.static('example/web'));
      sevr.listen(port, messageReturn: 'Listening on port: ${port}');
    });

    test('check if port is binded', () {
      expect(sevr.messageReturn, 'Listening on port: ${port}');
    });

    test('test port value', () {
      expect(sevr.port, port);
    });

    test('test body for json', () async {
      var path = '/test';
      var svrq;
      sevr.post(path, [
        (req, res) {
          svrq = req;
          return res.status(200).json({'data': ''});
        }
      ]);
      var url = 'http://127.0.0.1:${port}';
      var body = {'name': 'doodle', 'color': 'blue'};
      var response = await http.post('${url}${path}',
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});
      expect(json.encode(svrq.body), json.encode(body));
    });

    test('', () async {
      sevr.get('/serve', [
        (ServRequest req, ServResponse res) {
          return res.status(200).sendFile(p.absolute('example/web/index.html'));
        }
      ]);
      var path = '/serve';
      var url = 'http://127.0.0.1:${port}';
      var response = await http.get('${url}${path}');
      expect(response.body, File(p.absolute('example/web/index.html')).readAsStringSync());


    });

///TODO: test file upload, it keeps failing
//     test('test body for url formencoded parsing', () async {
//       var path = '/test';
//       ServRequest svrq;
//       sevr.post(path, [
//         (req, res) {
//           svrq = req;
//           print(req.files);
//           if(req.files.isNotEmpty){
//             print(req.files['upload'].filename);
//           }
//           return res.status(200).json({'data': ''});
//         }
//       ]);

//       var body = {'name': 'doodle', 'color': 'blue'};
//       var response = await http.post('${url}${path}',
//           body: body,
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'});
//       expect(json.encode(svrq.body), json.encode(body));
//     });
//     test('test file upload', ()async {
//       var path = '/upload';
//       ServRequest svrq;
//       sevr.post(path, [ (req, res) async{
//           for (var i = 0; i < req.files.keys.length; i++) {
//         //Handle your file stream as you see fit, write to file, pipe to a cdn etc --->
//         // var file = File(req.files[req.files.keys.toList()[i]].filename);
//         await for (var data
//             in req.files[req.files.keys.toList()[i]].streamController.stream) {
//           if (data is String) {
//             // await file.writeAsString(data, mode: FileMode.append);
//             print(data);
//           } else {
//             // await file.writeAsBytes(data, mode: FileMode.append);
//           }
//         }
//       }
//       svrq = req;

//       return res.status(200).json(req.body);
//           // return res.status(200).json(req.body);
//         }]);
//       var uri = Uri.parse('${url}${path}');
//       var filePath = './test.txt';
//       print(p.relative(filePath));
//       var formData = FormData.fromMap({
//     "name": "wendux",
//     "age": 25,
//     "file": await MultipartFile.fromFile(filePath,filename: "upload.txt"),
//     "files": [
//       await MultipartFile.fromFile(filePath, filename: "text1.txt"),
//       await MultipartFile.fromFile(filePath, filename: "text2.txt"),
//     ]
// });
// var options = BaseOptions(
//   baseUrl: url,
// );
// var dio = Dio(options);
// var response = await dio.post(path, data: formData);
//       if (response.statusCode == 200) print('Uploaded!');
//       expect(svrq.files.containsKey('upload'), true);

//           });

    tearDown(() {
      sevr.close();
    });
  });
}

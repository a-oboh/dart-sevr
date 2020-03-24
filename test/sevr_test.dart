import 'package:sevr/sevr.dart';
import 'package:sevr/src/sevr_base.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  Sevr sevr = Sevr();

  var port = 4040;
  sevr.listen(port, messageReturn: 'Listening on port: ${port}');
  group('Test host connection', () {
    var port = 4040;

    // setUp(() {
    //   sevr = Sevr();
    //   sevr.listen(port, messageReturn: 'Listening on port: ${port}');
    // });

    test('check if port is binded', () {
      expect(sevr.messageReturn, 'Listening on port: ${port}');
    });
  });

  group('', () async {
    sevr.use(Sevr.static('example/web'));

    sevr.get('/serve', [
      (ServRequest req, ServResponse res) {
        return res.status(200).sendFile(p.absolute('example/web/index.html'));
      }
    ]);
  });
}

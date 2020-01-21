import 'package:sevr/sevr.dart';
import 'package:sevr/src/sevr_base.dart';
import 'package:test/test.dart';

void main() {
  group('Test host connection', () {
    Sevr sevr;
    var port = 4040;

    setUp(() {
      sevr = Sevr();
      sevr.listen(port, messageReturn: 'Listening on port: ${port}');
    });

    test('First Test', () {
      expect(sevr.messageReturn, 'Listening on port: ${port}');
    });
  });
}

import 'package:sevr/sevr.dart';
import 'package:sevr/src/sevr_base.dart';
import 'package:test/test.dart';

void main() {
  group('Test host connection', () {
    Sevr sevr;
    int port = 4040;

    setUp(() {
      sevr = Sevr();
      sevr.host(port, 'Listening on port: ${port}');
    });

    test('First Test', () {
      expect(sevr.messageReturn, 'Listening on port: ${port}');
    });
  });
}

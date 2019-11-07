import 'package:sevr/sevr.dart';
import 'package:sevr/src/sevr_base.dart';
import 'package:test/test.dart';

void main() {
  group('Test host connection', () {
    Connect connect;
    int port = 4040;

    setUp(() {
      connect = Connect();
      connect.host(port, 'Listening on port: ${port}');
    });

    test('First Test', () {
      expect(connect.messageReturn, 'Listening on port: ${port}');
    });
  });
}

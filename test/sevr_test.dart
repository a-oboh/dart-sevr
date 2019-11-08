import 'package:sevr/sevr.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Serv serv;

    setUp(() {
      serv = Serv();
    });

    test('First Test', () {
      expect(serv.isAwesome, isTrue);
    });
  });
}

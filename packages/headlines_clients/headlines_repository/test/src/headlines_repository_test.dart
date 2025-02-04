// ignore_for_file: prefer_const_constructors
import 'package:headlines_repository/headlines_repository.dart';
import 'package:test/test.dart';

void main() {
  group('HeadlinesClientRepository', () {
    test('can be instantiated', () {
      expect(HeadlinesRepository(), isNotNull);
    });
  });
}

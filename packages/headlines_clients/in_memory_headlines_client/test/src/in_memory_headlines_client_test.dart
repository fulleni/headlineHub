// ignore_for_file: prefer_const_constructors
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryHeadlinesClient', () {
    test('can be instantiated', () {
      expect(InMemoryHeadlinesClient(), isNotNull);
    });
  });
}

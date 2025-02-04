import 'package:headlines_client/src/models/country.dart';
import 'package:headlines_client/src/models/language.dart';
import 'package:headlines_client/src/models/source.dart';
import 'package:test/test.dart';

void main() {
  group('Source', () {
    const country = Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://example.com/flag.jpg',
    );
    const language = Language(
      code: 'en',
      name: 'English',
    );
    const source = Source(
      id: 'source-id',
      name: 'Test Source',
      description: 'Test Description',
      url: 'https://example.com',
      language: language,
      country: country,
    );

    test('can be instantiated', () {
      expect(source, isNotNull);
      expect(source.id, equals('source-id'));
      expect(source.name, equals('Test Source'));
      expect(source.description, equals('Test Description'));
      expect(source.url, equals('https://example.com'));
      expect(source.language, equals(language));
      expect(source.country, equals(country));
    });

    test('supports value equality', () {
      expect(
        source,
        equals(
          const Source(
            id: 'source-id',
            name: 'Test Source',
            description: 'Test Description',
            url: 'https://example.com',
            language: language,
            country: country,
          ),
        ),
      );
    });

    test('copyWith creates new instance with updated values', () {
      final newSource = source.copyWith(
        name: 'New Source',
      );

      expect(newSource.name, equals('New Source'));
      expect(newSource.id, equals(source.id));
      expect(newSource.description, equals(source.description));
    });

    group('JSON serialization', () {
      test('fromJson/toJson are inverse operations', () {
        final json = source.toJson();
        final fromJson = Source.fromJson(json);
        expect(fromJson, equals(source));
      });
    });
  });
}

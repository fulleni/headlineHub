import 'package:headlines_client/src/models/language.dart';
import 'package:test/test.dart';

void main() {
  group('Language', () {
    const language = Language(
      code: 'en',
      name: 'English',
    );

    test('can be instantiated', () {
      expect(language, isNotNull);
      expect(language.code, equals('en'));
      expect(language.name, equals('English'));
    });

    test('supports value equality', () {
      expect(
        language,
        equals(
          const Language(
            code: 'en',
            name: 'English',
          ),
        ),
      );
    });

    test('copyWith creates new instance with updated values', () {
      final newLanguage = language.copyWith(
        name: 'Spanish',
      );

      expect(newLanguage.name, equals('Spanish'));
      expect(newLanguage.code, equals(language.code));
    });

    group('JSON serialization', () {
      test('fromJson/toJson are inverse operations', () {
        final json = language.toJson();
        final fromJson = Language.fromJson(json);
        expect(fromJson, equals(language));
      });
    });
  });
}

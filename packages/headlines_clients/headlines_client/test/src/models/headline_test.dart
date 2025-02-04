import 'package:headlines_client/src/models/country.dart';
import 'package:headlines_client/src/models/headline.dart';
import 'package:headlines_client/src/models/language.dart';
import 'package:headlines_client/src/models/source.dart';
import 'package:test/test.dart';

void main() {
  group('Headline', () {
    final timestamp = DateTime(2023, 1, 1, 12, 0);
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
    final headline = Headline(
      id: 'test-id',
      title: 'Test Title',
      content: 'Test Content',
      publishedBy: source,
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: timestamp,
      happenedIn: country,
      language: language,
      category: HeadlineCategory.technology,
      isActive: true,
    );

    test('can be instantiated', () {
      expect(headline, isNotNull);
      expect(headline.id, equals('test-id'));
      expect(headline.title, equals('Test Title'));
      expect(headline.content, equals('Test Content'));
      expect(headline.publishedBy, equals(source));
      expect(headline.imageUrl, equals('https://example.com/image.jpg'));
      expect(headline.publishedAt, equals(timestamp));
      expect(headline.happenedIn, equals(country));
      expect(headline.language, equals(language));
      expect(headline.category, equals(HeadlineCategory.technology));
      expect(headline.isActive, isTrue);
    });

    test('supports value equality', () {
      expect(
        headline,
        equals(
          Headline(
            id: 'test-id',
            title: 'Test Title',
            content: 'Test Content',
            publishedBy: source,
            imageUrl: 'https://example.com/image.jpg',
            publishedAt: timestamp,
            happenedIn: country,
            language: language,
            category: HeadlineCategory.technology,
            isActive: true,
          ),
        ),
      );
    });

    test('copyWith creates new instance with updated values', () {
      final newHeadline = headline.copyWith(
        title: 'New Title',
        category: HeadlineCategory.sports,
      );

      expect(newHeadline.title, equals('New Title'));
      expect(newHeadline.category, equals(HeadlineCategory.sports));
      expect(newHeadline.id, equals(headline.id));
      expect(newHeadline.content, equals(headline.content));
    });

    group('JSON serialization', () {
      test('fromJson/toJson are inverse operations', () {
        final json = headline.toJson();
        final fromJson = Headline.fromJson(json);
        expect(fromJson, equals(headline));
      });

      test('handles category serialization', () {
        final json = headline.toJson();
        expect(json['category'], equals('technology'));

        final fromJson = Headline.fromJson({
          ...json,
          'category': 'sports',
        });
        expect(fromJson.category, equals(HeadlineCategory.sports));
      });

      test('uses default category for invalid values', () {
        final fromJson = Headline.fromJson({
          ...headline.toJson(),
          'category': 'invalid_category',
        });
        expect(fromJson.category, equals(HeadlineCategory.general));
      });
    });
  });
}

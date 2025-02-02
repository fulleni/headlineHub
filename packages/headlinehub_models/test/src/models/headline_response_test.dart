import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:test/test.dart';

void main() {
  final testHeadline = Headline(
    id: '1',
    title: 'Test Headline',
    content: 'Test Content',
    source: 'Test Source',
    imageUrl: 'https://test.com/image.jpg',
    publishedAt: DateTime(2023),
    // ignore: avoid_redundant_argument_values
    category: HeadlineCategory.general,
    // ignore: avoid_redundant_argument_values
    isActive: true,
  );

  final testResponse = HeadlineResponse(
    headlines: [testHeadline],
    total: 100,
    page: 1,
    perPage: 20,
    message: 'Test message',
  );

  group('HeadlineResponse', () {
    test('can be instantiated', () {
      expect(testResponse, isNotNull);
      expect(testResponse.headlines.length, equals(1));
      expect(testResponse.total, equals(100));
      expect(testResponse.page, equals(1));
      expect(testResponse.perPage, equals(20));
      expect(testResponse.message, equals('Test message'));
    });

    test('supports value equality', () {
      expect(
        testResponse,
        equals(
          HeadlineResponse(
            headlines: [testHeadline],
            total: 100,
            page: 1,
            perPage: 20,
            message: 'Test message',
          ),
        ),
      );
    });

    test('json serialization', () {
      final json = testResponse.toJson();
      final fromJson = HeadlineResponse.fromJson(json);

      expect(fromJson.headlines.first.id, equals(testHeadline.id));
      expect(fromJson.headlines.first.title, equals(testHeadline.title));
      expect(fromJson.headlines.first.content, equals(testHeadline.content));
      expect(fromJson.headlines.first.imageUrl, equals(testHeadline.imageUrl));
      expect(fromJson.headlines.first.category, equals(testHeadline.category));
      expect(fromJson.headlines.first.isActive, equals(testHeadline.isActive));
      expect(fromJson, equals(testResponse));
    });

    test('copyWith returns new instance with updated values', () {
      final copied = testResponse.copyWith(
        total: 200,
        message: 'Updated message',
      );

      expect(copied.total, equals(200));
      expect(copied.message, equals('Updated message'));
      expect(copied.headlines, equals(testResponse.headlines));
      expect(copied.page, equals(testResponse.page));
      expect(copied.perPage, equals(testResponse.perPage));
    });
  });
}

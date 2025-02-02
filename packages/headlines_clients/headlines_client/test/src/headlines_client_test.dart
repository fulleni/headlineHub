// ignore_for_file: prefer_const_constructors
import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:headlines_client/headlines_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHeadlinesClient extends Mock implements HeadlinesClient {}

void main() {
  setUpAll(() {
    // HeadlineCategory is Placed before the Headline registration 
    // since Headline depends on HeadlineCategory
    registerFallbackValue(HeadlineCategory.general);
    registerFallbackValue(
      Headline(
        id: 'fallback-id',
        title: 'Fallback Title',
        content: 'Fallback Content',
        source: 'Fallback Source',
        imageUrl: 'https://example.com/fallback.jpg',
        publishedAt: DateTime(2023),
        // ignore: avoid_redundant_argument_values
        category: HeadlineCategory.general,
      ),
    );
  });

  group('HeadlinesClient', () {
    late MockHeadlinesClient client;
    late Headline testHeadline;

    setUp(() {
      client = MockHeadlinesClient();
      testHeadline = Headline(
        id: '1',
        title: 'Test Headline',
        content: 'Test Content',
        source: 'Test Source',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime(2023),
        category: HeadlineCategory.technology,
        // ignore: avoid_redundant_argument_values
        isActive: true,
      );
    });

    test('getHeadlines returns list of headlines', () async {
      when(() => client.getHeadlines()).thenAnswer((_) async => [testHeadline]);

      final headlines = await client.getHeadlines();
      expect(headlines, isA<List<Headline>>());
      expect(headlines.length, 1);
      expect(headlines.first, equals(testHeadline));
      verify(() => client.getHeadlines()).called(1);
    });

    test('getHeadline returns single headline', () async {
      when(() => client.getHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final headline = await client.getHeadline('1');
      expect(headline, isA<Headline>());
      expect(headline, equals(testHeadline));
      verify(() => client.getHeadline('1')).called(1);
    });

    test('createHeadline creates new headline', () async {
      when(() => client.createHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final created = await client.createHeadline(testHeadline);
      expect(created, isA<Headline>());
      verify(() => client.createHeadline(testHeadline)).called(1);
    });

    test('updateHeadline updates existing headline', () async {
      when(() => client.updateHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final updated = await client.updateHeadline(testHeadline);
      expect(updated, isA<Headline>());
      verify(() => client.updateHeadline(testHeadline)).called(1);
    });

    test('deleteHeadline deletes headline', () async {
      when(() => client.deleteHeadline(any())).thenAnswer((_) async {});

      await client.deleteHeadline('1');
      verify(() => client.deleteHeadline('1')).called(1);
    });

    test('getHeadlinesByCategory returns filtered headlines', () async {
      when(() => client.getHeadlinesByCategory(any()))
          .thenAnswer((_) async => [testHeadline]);

      final headlines =
          await client.getHeadlinesByCategory(HeadlineCategory.technology);
      expect(headlines, isA<List<Headline>>());
      verify(() => client.getHeadlinesByCategory(HeadlineCategory.technology))
          .called(1);
    });

    test('searchHeadlines returns matching headlines', () async {
      when(() => client.searchHeadlines(any()))
          .thenAnswer((_) async => [testHeadline]);

      final headlines = await client.searchHeadlines('test');
      expect(headlines, isA<List<Headline>>());
      verify(() => client.searchHeadlines('test')).called(1);
    });
  });
}

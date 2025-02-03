// ignore_for_file: lines_longer_than_80_chars

import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:headlines_client/headlines_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHeadlinesClient extends Mock implements HeadlinesClient {}

class FakeHeadline extends Fake implements Headline {}

class FakeHeadlineQueryOptions extends Fake implements HeadlineQueryOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeHeadline());
    registerFallbackValue(FakeHeadlineQueryOptions());
    registerFallbackValue(HeadlineCategory.general);
  });

  group('HeadlinesClient', () {
    late MockHeadlinesClient client;

    setUp(() {
      client = MockHeadlinesClient();
    });

    test('getHeadlines returns empty list', () async {
      when(() => client.getHeadlines(any()))
          .thenAnswer((_) async => const PaginatedResponse<Headline>(
                items: [],
                currentPage: 1,
                totalPages: 1,
                totalItems: 0,
                hasNextPage: false,
                hasPreviousPage: false,
              ));

      final response = await client.getHeadlines();
      expect(response.items, isEmpty);
    });

    test('getHeadline returns null for non-existent headline', () async {
      when(() => client.getHeadline(any())).thenAnswer((_) async => null);

      final headline = await client.getHeadline('non-existent-id');
      expect(headline, isNull);
    });

    test('createHeadline returns the created headline', () async {
      final headline = Headline(
        id: '1',
        title: 'Test Headline',
        content: 'Test Content',
        publishedBy: const Source(
          id: 'source-1',
          name: 'Test Source',
          description: 'Test Description',
          url: 'https://test.com',
          language: Language(code: 'en', name: 'English'),
          country: Country(
              code: 'US',
              name: 'United States',
              flagUrl: 'https://test.com/flag.png'),
        ),
        imageUrl: 'https://test.com/image.png',
        publishedAt: DateTime.now(),
        happenedIn: const Country(
            code: 'US',
            name: 'United States',
            flagUrl: 'https://test.com/flag.png'),
        language: const Language(code: 'en', name: 'English'),
      );

      when(() => client.createHeadline(any()))
          .thenAnswer((_) async => headline);

      final createdHeadline = await client.createHeadline(headline);
      expect(createdHeadline, equals(headline));
    });

    test('updateHeadline returns the updated headline', () async {
      final headline = Headline(
        id: '1',
        title: 'Updated Headline',
        content: 'Updated Content',
        publishedBy: const Source(
          id: 'source-1',
          name: 'Test Source',
          description: 'Test Description',
          url: 'https://test.com',
          language: Language(code: 'en', name: 'English'),
          country: Country(
              code: 'US',
              name: 'United States',
              flagUrl: 'https://test.com/flag.png'),
        ),
        imageUrl: 'https://test.com/image.png',
        publishedAt: DateTime.now(),
        happenedIn: const Country(
            code: 'US',
            name: 'United States',
            flagUrl: 'https://test.com/flag.png'),
        language: const Language(code: 'en', name: 'English'),
      );

      when(() => client.updateHeadline(any()))
          .thenAnswer((_) async => headline);

      final updatedHeadline = await client.updateHeadline(headline);
      expect(updatedHeadline, equals(headline));
    });

    test('deleteHeadline completes without error', () async {
      when(() => client.deleteHeadline(any())).thenAnswer((_) async {});

      await client.deleteHeadline('1');
    });

    test('getHeadlinesByQuery returns empty list', () async {
      when(() => client.getHeadlinesByQuery(any(), any()))
          .thenAnswer((_) async => const PaginatedResponse<Headline>(
                items: [],
                currentPage: 1,
                totalPages: 1,
                totalItems: 0,
                hasNextPage: false,
                hasPreviousPage: false,
              ));

      final response = await client.getHeadlinesByQuery('test');
      expect(response.items, isEmpty);
    });

    test('getHeadlinesByCategory returns empty list', () async {
      when(() => client.getHeadlinesByCategory(any(), any()))
          .thenAnswer((_) async => const PaginatedResponse<Headline>(
                items: [],
                currentPage: 1,
                totalPages: 1,
                totalItems: 0,
                hasNextPage: false,
                hasPreviousPage: false,
              ));

      final response =
          await client.getHeadlinesByCategory(HeadlineCategory.general);
      expect(response.items, isEmpty);
    });

    test('getHeadlinesByDateRange returns empty list', () async {
      when(() => client.getHeadlinesByDateRange(any(), any(), any()))
          .thenAnswer((_) async => const PaginatedResponse<Headline>(
                items: [],
                currentPage: 1,
                totalPages: 1,
                totalItems: 0,
                hasNextPage: false,
                hasPreviousPage: false,
              ));

      final response =
          await client.getHeadlinesByDateRange(DateTime.now(), DateTime.now());
      expect(response.items, isEmpty);
    });
  });
}

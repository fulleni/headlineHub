// ignore_for_file: lines_longer_than_80_chars

import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:headlines_client/headlines_client.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHeadline extends Mock implements Headline {}

class MockHeadlineQueryOptions extends Mock implements HeadlineQueryOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockHeadline());
    registerFallbackValue(MockHeadlineQueryOptions());
  });

  group('InMemoryHeadlinesClient', () {
    late InMemoryHeadlinesClient client;

    setUp(() {
      client = InMemoryHeadlinesClient();
    });

    test('getHeadlines returns all headlines', () async {
      final response = await client.getHeadlines();
      expect(response.items.length, equals(10));
    });

    test('getHeadline returns the correct headline', () async {
      final headline = await client.getHeadline('headline_1');
      expect(headline, isNotNull);
      expect(headline?.id, equals('headline_1'));
    });

    test('getHeadline throws HeadlineNotFoundException for non-existent headline', () async {
      expect(() => client.getHeadline('non-existent-id'), throwsA(isA<HeadlineNotFoundException>()));
    });

    test('createHeadline adds a new headline', () async {
      final newHeadline = Headline(
        id: 'headline_11',
        title: 'New Headline',
        content: 'New Content',
        publishedBy: const Source(
          id: 'source_11',
          name: 'New Source',
          description: 'New Description',
          url: 'https://newsource.com',
          language: Language(code: 'en', name: 'English'),
          country: Country(code: 'US', name: 'United States', flagUrl: 'https://newsource.com/flag.png'),
        ),
        imageUrl: 'https://newsource.com/image.png',
        publishedAt: DateTime.now(),
        happenedIn: const Country(code: 'US', name: 'United States', flagUrl: 'https://newsource.com/flag.png'),
        language: const Language(code: 'en', name: 'English'),
      );

      final createdHeadline = await client.createHeadline(newHeadline);
      expect(createdHeadline, equals(newHeadline));
      final response = await client.getHeadlines();
      expect(response.items.length, equals(11));
    });

    test('updateHeadline updates an existing headline', () async {
      final updatedHeadline = Headline(
        id: 'headline_1',
        title: 'Updated Headline',
        content: 'Updated Content',
        publishedBy: const Source(
          id: 'source_1',
          name: 'Updated Source',
          description: 'Updated Description',
          url: 'https://updatedsource.com',
          language: Language(code: 'en', name: 'English'),
          country: Country(code: 'US', name: 'United States', flagUrl: 'https://updatedsource.com/flag.png'),
        ),
        imageUrl: 'https://updatedsource.com/image.png',
        publishedAt: DateTime.now(),
        happenedIn: const Country(code: 'US', name: 'United States', flagUrl: 'https://updatedsource.com/flag.png'),
        language: const Language(code: 'en', name: 'English'),
      );

      final result = await client.updateHeadline(updatedHeadline);
      expect(result, equals(updatedHeadline));
      final headline = await client.getHeadline('headline_1');
      expect(headline?.title, equals('Updated Headline'));
    });

    test('deleteHeadline removes the headline', () async {
      await client.deleteHeadline('headline_1');
      final response = await client.getHeadlines();
      expect(response.items.length, equals(9));
      expect(() => client.getHeadline('headline_1'), throwsA(isA<HeadlineNotFoundException>()));
    });

    test('getHeadlinesByQuery returns matching headlines', () async {
      final response = await client.getHeadlinesByQuery('Market');
      expect(response.items.length, equals(1));
      expect(response.items.first.title, contains('Market'));
    });

    test('getHeadlinesByCategory returns matching headlines', () async {
      final response = await client.getHeadlinesByCategory(HeadlineCategory.general);
      expect(response.items.length, equals(10));
    });

    test('getHeadlinesByDateRange returns matching headlines', () async {
      final startDate = DateTime.now().subtract(const Duration(days: 5));
      final endDate = DateTime.now();
      final response = await client.getHeadlinesByDateRange(startDate, endDate);
      expect(response.items.length, equals(5));
    });
  });
}

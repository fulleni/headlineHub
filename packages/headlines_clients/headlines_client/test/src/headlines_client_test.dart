// ignore_for_file: avoid_redundant_argument_values

import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:headlines_client/src/headlines_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHeadlinesClient extends Mock implements HeadlinesClient {}

class FakeHeadline extends Fake implements Headline {}

class FakeHeadlineQueryOptions extends Fake implements HeadlineQueryOptions {}

void main() {
  late MockHeadlinesClient client;
  late Headline testHeadline;
  late PaginatedResponse testResponse;

  setUpAll(() {
    registerFallbackValue(FakeHeadline());
    registerFallbackValue(FakeHeadlineQueryOptions());
    registerFallbackValue(HeadlineCategory.general);
  });

  setUp(() {
    client = MockHeadlinesClient();
    testHeadline = Headline(
      id: '1',
      title: 'Test Headline',
      content: 'Test Content',
      publishedBy: 'Test Source',
      publishedIn: 'https://example.com/image.jpg',
      publishedAt: DateTime.now(),
      category: HeadlineCategory.technology,
      isActive: true,
    );
    testResponse = PaginatedResponse(
      items: [testHeadline],
      paginationMetadata: const PaginationMetadata(
        currentPage: 1,
        totalPages: 1,
        totalItems: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
  });

  group('HeadlinesClient CRUD operations', () {
    test('getHeadlines returns stream of HeadlineResponse', () {
      when(() => client.getHeadlines(any()))
          .thenAnswer((_) => Stream.value(testResponse));

      expect(
        client.getHeadlines(),
        emits(testResponse),
      );
    });

    test('getHeadline returns specific headline', () async {
      when(() => client.getHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final result = await client.getHeadline('1');
      expect(result, equals(testHeadline));
    });

    test('createHeadline creates new headline', () async {
      when(() => client.createHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final result = await client.createHeadline(testHeadline);
      expect(result, equals(testHeadline));
    });

    test('updateHeadline updates existing headline', () async {
      when(() => client.updateHeadline(any()))
          .thenAnswer((_) async => testHeadline);

      final result = await client.updateHeadline(testHeadline);
      expect(result, equals(testHeadline));
    });

    test('deleteHeadline completes successfully', () async {
      when(() => client.deleteHeadline(any())).thenAnswer((_) async {});

      expect(client.deleteHeadline('1'), completes);
    });
  });

  group('HeadlinesClient search and filter operations', () {
    test('getHeadlinesByQuery returns filtered stream', () {
      when(() => client.getHeadlinesByQuery(any(), any()))
          .thenAnswer((_) => Stream.value(testResponse));

      expect(
        client.getHeadlinesByQuery('test'),
        emits(testResponse),
      );
    });

    test('getHeadlinesByCategory returns category-filtered stream', () {
      when(() => client.getHeadlinesByCategory(any(), any()))
          .thenAnswer((_) => Stream.value(testResponse));

      expect(
        client.getHeadlinesByCategory(HeadlineCategory.technology),
        emits(testResponse),
      );
    });

    test('getHeadlinesByDateRange returns date-filtered stream', () {
      when(() => client.getHeadlinesByDateRange(any(), any(), any()))
          .thenAnswer((_) => Stream.value(testResponse));

      final now = DateTime.now();
      expect(
        client.getHeadlinesByDateRange(
          now.subtract(const Duration(days: 1)),
          now,
        ),
        emits(testResponse),
      );
    });
  });

  group('HeadlinesClient stream lifecycle', () {
    test('pauseAllStreams completes without error', () {
      expect(() => client.pauseAllStreams(), returnsNormally);
    });

    test('resumeAllStreams completes without error', () {
      expect(() => client.resumeAllStreams(), returnsNormally);
    });

    test('dispose completes successfully', () {
      when(() => client.dispose()).thenAnswer((_) async {});
      expect(client.dispose(), completes);
    });
  });
}

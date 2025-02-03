// ignore_for_file: lines_longer_than_80_chars

import 'package:headlinehub_models/src/models/paginated_response.dart';
import 'package:test/test.dart';

void main() {
  group('PaginatedResponse', () {
    const paginatedResponse = PaginatedResponse<String>(
      items: ['item1', 'item2', 'item3'],
      currentPage: 1,
      totalPages: 5,
      totalItems: 100,
      hasNextPage: true,
      hasPreviousPage: false,
    );

    test('can be instantiated', () {
      expect(paginatedResponse, isNotNull);
      expect(paginatedResponse.items, equals(['item1', 'item2', 'item3']));
      expect(paginatedResponse.currentPage, equals(1));
      expect(paginatedResponse.totalPages, equals(5));
      expect(paginatedResponse.totalItems, equals(100));
      expect(paginatedResponse.hasNextPage, isTrue);
      expect(paginatedResponse.hasPreviousPage, isFalse);
    });

    test('supports value equality', () {
      expect(
        paginatedResponse,
        equals(
          const PaginatedResponse<String>(
            items: ['item1', 'item2', 'item3'],
            currentPage: 1,
            totalPages: 5,
            totalItems: 100,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        ),
      );
    });

    test('copyWith creates new instance with updated values', () {
      final newPaginatedResponse = paginatedResponse.copyWith(
        items: ['item4', 'item5'],
      );

      expect(newPaginatedResponse.items, equals(['item4', 'item5']));
      expect(newPaginatedResponse.currentPage, equals(paginatedResponse.currentPage));
      expect(newPaginatedResponse.totalPages, equals(paginatedResponse.totalPages));
      expect(newPaginatedResponse.totalItems, equals(paginatedResponse.totalItems));
      expect(newPaginatedResponse.hasNextPage, equals(paginatedResponse.hasNextPage));
      expect(newPaginatedResponse.hasPreviousPage, equals(paginatedResponse.hasPreviousPage));
    });

    group('JSON serialization', () {
      test('fromJson/toJson are inverse operations', () {
        final json = paginatedResponse.toJson((item) => item);
        final fromJson = PaginatedResponse<String>.fromJson(json, (json) => json! as String);
        expect(fromJson, equals(paginatedResponse));
      });
    });
  });
}


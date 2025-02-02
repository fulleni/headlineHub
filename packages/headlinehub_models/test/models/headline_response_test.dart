// ignore_for_file: avoid_redundant_argument_values, avoid_dynamic_calls

import 'package:test/test.dart';
import 'package:headlinehub_models/headlinehub_models.dart';

void main() {
  group('PaginationMetadata', () {
    test('creates instance with required values', () {
      const metadata = PaginationMetadata(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      expect(metadata.currentPage, equals(1));
      expect(metadata.totalPages, equals(10));
      expect(metadata.totalItems, equals(100));
      expect(metadata.hasNextPage, isTrue);
      expect(metadata.hasPreviousPage, isFalse);
    });

    test('supports value equality', () {
      const metadata1 = PaginationMetadata(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      const metadata2 = PaginationMetadata(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      expect(metadata1, equals(metadata2));
    });

    test('serializes to JSON', () {
      const metadata = PaginationMetadata(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final json = metadata.toJson();
      
      expect(json, {
        'currentPage': 1,
        'totalPages': 10,
        'totalItems': 100,
        'hasNextPage': true,
        'hasPreviousPage': false,
      });
    });

    test('deserializes from JSON', () {
      final json = {
        'currentPage': 1,
        'totalPages': 10,
        'totalItems': 100,
        'hasNextPage': true,
        'hasPreviousPage': false,
      };

      final metadata = PaginationMetadata.fromJson(json);

      expect(metadata.currentPage, equals(1));
      expect(metadata.totalPages, equals(10));
      expect(metadata.totalItems, equals(100));
      expect(metadata.hasNextPage, isTrue);
      expect(metadata.hasPreviousPage, isFalse);
    });
  });

  group('HeadlineResponse', () {
    const testMetadata = PaginationMetadata(
      currentPage: 1,
      totalPages: 10,
      totalItems: 100,
      hasNextPage: true,
      hasPreviousPage: false,
    );

    final testHeadline = Headline(
      id: '1',
      title: 'Test Title',
      content: 'Test Content',
      source: 'Test Source',
      imageUrl: 'https://test.com/image.jpg',
      publishedAt: DateTime(2023),
      category: HeadlineCategory.general,
      isActive: true,
    );

    test('creates instance with required values', () {
      final response = HeadlineResponse(
        headlines: [testHeadline],
        paginationMetadata: testMetadata,
      );

      expect(response.headlines, equals([testHeadline]));
      expect(response.paginationMetadata, equals(testMetadata));
    });

    test('supports value equality', () {
      final response1 = HeadlineResponse(
        headlines: [testHeadline],
        paginationMetadata: testMetadata,
      );

      final response2 = HeadlineResponse(
        headlines: [testHeadline],
        paginationMetadata: testMetadata,
      );

      expect(response1, equals(response2));
    });

    test('copyWith creates new instance with updated values', () {
      final response = HeadlineResponse(
        headlines: [testHeadline],
        paginationMetadata: testMetadata,
      );

      const newMetadata = PaginationMetadata(
        currentPage: 2,
        totalPages: 10,
        totalItems: 100,
        hasNextPage: true,
        hasPreviousPage: true,
      );

      final updated = response.copyWith(
        paginationMetadata: newMetadata,
      );

      expect(updated.headlines, equals([testHeadline]));
      expect(updated.paginationMetadata, equals(newMetadata));
      expect(updated, isNot(equals(response)));
    });

    test('serializes to JSON', () {
      final response = HeadlineResponse(
        headlines: [testHeadline],
        paginationMetadata: testMetadata,
      );

      final json = response.toJson();
      expect(json['headlines'], isA<List<dynamic>>());
      expect(json['headlines'].first['imageUrl'], equals('https://test.com/image.jpg'));
      expect(json['headlines'].first['category'], equals('general'));
      expect(json['headlines'].first['isActive'], isTrue);
      expect(json['paginationMetadata'], isNotNull);
    });

    test('deserializes from JSON', () {
      final json = {
        'headlines': [
          {
            'id': '1',
            'title': 'Test Title',
            'content': 'Test Content',
            'source': 'Test Source',
            'imageUrl': 'https://test.com/image.jpg',
            'publishedAt': '2023-01-01T00:00:00.000',
            'category': 'general',
            'isActive': true,
          }
        ],
        'paginationMetadata': {
          'currentPage': 1,
          'totalPages': 10,
          'totalItems': 100,
          'hasNextPage': true,
          'hasPreviousPage': false,
        },
      };

      final response = HeadlineResponse.fromJson(json);

      expect(response.headlines.length, equals(1));
      expect(response.headlines.first.imageUrl, equals('https://test.com/image.jpg'));
      expect(response.headlines.first.category, equals(HeadlineCategory.general));
      expect(response.headlines.first.isActive, isTrue);
      expect(response.paginationMetadata.currentPage, equals(1));
    });
  });
}

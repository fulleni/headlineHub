// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:headlines_client/headlines_client.dart';
import 'package:http/http.dart' as http;

/// {@template headlinehub_headlines_client}
/// headlinHub API implementation of the [HeadlinesClient] abstract class
/// {@endtemplate}
class HeadlinehubHeadlinesClient extends HeadlinesClient {
  /// {@macro headlinehub_headlines_client}
  const HeadlinehubHeadlinesClient(this.baseUrl, this.httpClient);

  /// The base URL of the HeadlineHub API.
  final String baseUrl;

  /// The HTTP client used to make requests.
  final http.Client httpClient;

  List<Headline> _applyFilters(
    List<Headline> headlines,
    HeadlineQueryOptions? options,
  ) {
    var filteredHeadlines = headlines;

    if (options != null) {
      if (options.startDate != null) {
        filteredHeadlines = filteredHeadlines
            .where(
              (headline) => headline.publishedAt.isAfter(options.startDate!),
            )
            .toList();
      }
      if (options.endDate != null) {
        filteredHeadlines = filteredHeadlines
            .where(
              (headline) => headline.publishedAt.isBefore(options.endDate!),
            )
            .toList();
      }
      if (options.isActive != null) {
        filteredHeadlines = filteredHeadlines
            .where((headline) => headline.isActive == options.isActive)
            .toList();
      }
      filteredHeadlines.sort((a, b) {
        int comparison;
        switch (options.sortBy) {
          case HeadlineSortBy.title:
            comparison = a.title.compareTo(b.title);
          case HeadlineSortBy.source:
            comparison = a.publishedBy.name.compareTo(b.publishedBy.name);
          case HeadlineSortBy.publishedAt:
            comparison = a.publishedAt.compareTo(b.publishedAt);
          case HeadlineSortBy.category:
            comparison = a.title.compareTo(b.category.name);
          case HeadlineSortBy.status:
            comparison = a.title.compareTo(b.isActive.toString());
        }
        return options.sortDirection == SortDirection.ascending
            ? comparison
            : -comparison;
      });

      final startIndex = (options.page - 1) * options.limit;
      final endIndex = startIndex + options.limit;
      filteredHeadlines = filteredHeadlines.sublist(
        startIndex,
        endIndex > filteredHeadlines.length
            ? filteredHeadlines.length
            : endIndex,
      );
    }

    return filteredHeadlines;
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/headlines'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        var headlines = (data['items'] as List)
            .map((json) => Headline.fromJson(json as Map<String, dynamic>))
            .toList();

        headlines = _applyFilters(headlines, options);

        final totalItems = data['totalItems'] as int;
        final totalPages = (totalItems / options!.limit).ceil();
        final hasNextPage = options.page < totalPages;

        return PaginatedResponse<Headline>(
          items: headlines,
          currentPage: options.page,
          totalPages: totalPages,
          totalItems: totalItems,
          hasNextPage: hasNextPage,
          hasPreviousPage: options.page > 1,
        );
      } else {
        throw const HeadlineCategoryException('Failed to fetch headlines');
      }
    } catch (e) {
      throw const HeadlineCategoryException('Failed to fetch headlines');
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response =
          await httpClient.get(Uri.parse('$baseUrl/headlines?query=$query'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        var headlines = (data['items'] as List)
            .map((json) => Headline.fromJson(json as Map<String, dynamic>))
            .toList();
        headlines = _applyFilters(headlines, options);

        final totalItems = data['totalItems'] as int;
        final totalPages = (totalItems / options!.limit).ceil();
        final hasNextPage = options.page < totalPages;

        return PaginatedResponse<Headline>(
          items: headlines,
          currentPage: options.page,
          totalPages: totalPages,
          totalItems: totalItems,
          hasNextPage: hasNextPage,
          hasPreviousPage: options.page > 1,
        );
      } else {
        throw const HeadlineSearchingException('Failed to search headlines');
      }
    } catch (e) {
      throw const HeadlineSearchingException('Failed to search headlines');
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/headlines?category=${category.name}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        var headlines = (data['items'] as List)
            .map((json) => Headline.fromJson(json as Map<String, dynamic>))
            .toList();
        headlines = _applyFilters(headlines, options);

        final totalItems = data['totalItems'] as int;
        final totalPages = (totalItems / options!.limit).ceil();
        final hasNextPage = options.page < totalPages;

        return PaginatedResponse<Headline>(
          items: headlines,
          currentPage: options.page,
          totalPages: totalPages,
          totalItems: totalItems,
          hasNextPage: hasNextPage,
          hasPreviousPage: options.page > 1,
        );
      } else {
        throw const HeadlineCategoryException(
          'Failed to fetch headlines for category',
        );
      }
    } catch (e) {
      throw const HeadlineCategoryException(
        'Failed to fetch headlines for category',
      );
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
          '$baseUrl/headlines?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        var headlines = (data['items'] as List)
            .map((json) => Headline.fromJson(json as Map<String, dynamic>))
            .toList();
        headlines = _applyFilters(headlines, options);

        final totalItems = data['totalItems'] as int;
        final totalPages = (totalItems / options!.limit).ceil();
        final hasNextPage = options.page < totalPages;

        return PaginatedResponse<Headline>(
          items: headlines,
          currentPage: options.page,
          totalPages: totalPages,
          totalItems: totalItems,
          hasNextPage: hasNextPage,
          hasPreviousPage: options.page > 1,
        );
      } else {
        throw const HeadlineDateRangeException(
          'Failed to fetch headlines for date range',
        );
      }
    } catch (e) {
      throw const HeadlineDateRangeException(
        'Failed to fetch headlines for date range',
      );
    }
  }

  @override
  Future<Headline?> getHeadline(String id) async {
    try {
      final response =
          await httpClient.get(Uri.parse('$baseUrl/headlines/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const HeadlineNotFoundException('Headline not found');
      } else {
        throw const HeadlineNotFoundException('Failed to fetch headline');
      }
    } catch (e) {
      throw const HeadlineNotFoundException('Failed to fetch headline');
    }
  }

  @override
  Future<Headline> createHeadline(Headline headline) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/headlines'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(headline.toJson()),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else {
        throw const HeadlineCreationException('Failed to create headline');
      }
    } catch (e) {
      throw const HeadlineCreationException('Failed to create headline');
    }
  }

  @override
  Future<Headline> updateHeadline(Headline headline) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/headlines/${headline.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(headline.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const HeadlineNotFoundException('Headline not found');
      } else {
        throw const HeadlineUpdateException('Failed to update headline');
      }
    } catch (e) {
      throw const HeadlineUpdateException('Failed to update headline');
    }
  }

  @override
  Future<void> deleteHeadline(String id) async {
    try {
      final response =
          await httpClient.delete(Uri.parse('$baseUrl/headlines/$id'));
      if (response.statusCode != 204) {
        throw const HeadlineDeletionException('Failed to delete headline');
      }
    } catch (e) {
      throw const HeadlineDeletionException('Failed to delete headline');
    }
  }
}

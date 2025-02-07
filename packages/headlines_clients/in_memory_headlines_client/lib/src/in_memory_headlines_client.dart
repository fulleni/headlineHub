// ignore_for_file: avoid_redundant_argument_values

import 'package:headlines_client/headlines_client.dart';
import 'package:in_memory_headlines_client/src/mock_data.dart';

/// {@template in_memory_headlines_client}
/// An in-memory implementation of the [HeadlinesClient] that uses
/// a predefined list of headlines.
/// {@endtemplate}
class InMemoryHeadlinesClient extends HeadlinesClient {
  /// {@macro in_memory_headlines_client}
  InMemoryHeadlinesClient() : _headlines = headlines;

  final List<Headline> _headlines;

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
      final filteredHeadlines = _applyFilters(_headlines, options);
      final totalItems = filteredHeadlines.length;
      final totalPages = (totalItems / (options?.limit ?? 20)).ceil();
      final hasNextPage = (options?.page ?? 1) < totalPages;

      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: options?.page ?? 1,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: hasNextPage,
        hasPreviousPage: (options?.page ?? 1) > 1,
      );
    } catch (e) {
      throw const HeadlineSearchingException('Failed to fetch headlines');
    }
  }

  @override
  Future<Headline?> getHeadline(String id) async {
    try {
      return _headlines.firstWhere(
        (headline) => headline.id == id,
        orElse: () => throw const HeadlineNotFoundException(),
      );
    } catch (e) {
      throw const HeadlineNotFoundException('Headline not found');
    }
  }

  @override
  Future<Headline> createHeadline(Headline headline) async {
    try {
      _headlines.add(headline);
      return headline;
    } catch (e) {
      throw const HeadlineCreationException('Failed to create headline');
    }
  }

  @override
  Future<Headline> updateHeadline(Headline headline) async {
    try {
      final index = _headlines.indexWhere((h) => h.id == headline.id);
      if (index == -1) throw const HeadlineNotFoundException();
      _headlines[index] = headline;
      return headline;
    } catch (e) {
      throw const HeadlineUpdateException('Failed to update headline');
    }
  }

  @override
  Future<void> deleteHeadline(String id) async {
    try {
      final index = _headlines.indexWhere((h) => h.id == id);
      if (index == -1) throw const HeadlineNotFoundException();
      _headlines.removeAt(index);
    } catch (e) {
      throw const HeadlineDeletionException('Failed to delete headline');
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      var filteredHeadlines = _headlines
          .where((headline) => headline.title.contains(query))
          .toList();
      filteredHeadlines = _applyFilters(filteredHeadlines, options);
      final totalItems = filteredHeadlines.length;
      final totalPages = (totalItems / (options?.limit ?? 20)).ceil();
      final hasNextPage = (options?.page ?? 1) < totalPages;

      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: options?.page ?? 1,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: hasNextPage,
        hasPreviousPage: (options?.page ?? 1) > 1,
      );
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
      var filteredHeadlines = _headlines
          .where((headline) => headline.category == category)
          .toList();
      filteredHeadlines = _applyFilters(filteredHeadlines, options);
      final totalItems = filteredHeadlines.length;
      final totalPages = (totalItems / (options?.limit ?? 20)).ceil();
      final hasNextPage = (options?.page ?? 1) < totalPages;

      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: options?.page ?? 1,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: hasNextPage,
        hasPreviousPage: (options?.page ?? 1) > 1,
      );
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
      var filteredHeadlines = _headlines
          .where(
            (headline) =>
                headline.publishedAt.isAfter(startDate) &&
                headline.publishedAt.isBefore(endDate),
          )
          .toList();
      filteredHeadlines = _applyFilters(filteredHeadlines, options);
      final totalItems = filteredHeadlines.length;
      final totalPages = (totalItems / (options?.limit ?? 20)).ceil();
      final hasNextPage = (options?.page ?? 1) < totalPages;

      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: options?.page ?? 1,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: hasNextPage,
        hasPreviousPage: (options?.page ?? 1) > 1,
      );
    } catch (e) {
      throw const HeadlineDateRangeException(
        'Failed to fetch headlines for date range',
      );
    }
  }
}

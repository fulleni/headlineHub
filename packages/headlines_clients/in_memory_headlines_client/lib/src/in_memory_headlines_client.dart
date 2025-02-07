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
    if (options == null) return headlines;

    var filteredHeadlines = headlines;

    // Apply all filters simultaneously
    filteredHeadlines = filteredHeadlines.where((headline) {
      bool matchesFilters = true;

      // Date range filter
      if (options.dateRange != null) {
        matchesFilters = matchesFilters &&
            headline.publishedAt.isAfter(options.dateRange!.start) &&
            headline.publishedAt.isBefore(options.dateRange!.end);
      }

      // Status filter
      if (options.status != null) {
        matchesFilters = matchesFilters && headline.status == options.status;
      }

      // Category filter
      if (options.category != null) {
        matchesFilters =
            matchesFilters && headline.category == options.category;
      }

      // Search query filter
      if (options.searchQuery != null && options.searchQuery!.isNotEmpty) {
        final query = options.searchQuery!.toLowerCase();
        matchesFilters = matchesFilters &&
            (headline.title.toLowerCase().contains(query) ||
                headline.content.toLowerCase().contains(query) ||
                headline.publishedBy.name.toLowerCase().contains(query));
      }

      return matchesFilters;
    }).toList();

    // Apply sorting
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
          comparison = a.category.name.compareTo(b.category.name);
        case HeadlineSortBy.status:
          comparison = a.status.name.compareTo(b.status.name);
      }
      return options.sortDirection == SortDirection.ascending
          ? comparison
          : -comparison;
    });

    // Apply pagination
    final startIndex = (options.page - 1) * options.limit;
    final endIndex = startIndex + options.limit;
    return filteredHeadlines.sublist(
      startIndex,
      endIndex > filteredHeadlines.length ? filteredHeadlines.length : endIndex,
    );
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
}

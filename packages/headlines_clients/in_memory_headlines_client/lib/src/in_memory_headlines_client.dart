// ignore_for_file: avoid_redundant_argument_values

import 'package:headlinehub_models/headlinehub_models.dart';
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

  @override
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async {
    try {
      // Apply filtering and pagination logic here
      final filteredHeadlines = _headlines; // Simplified for brevity
      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: 1,
        totalPages: 1,
        totalItems: filteredHeadlines.length,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    } catch (e) {
      throw const HeadlineCategoryException('Failed to fetch headlines');
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
      final filteredHeadlines = _headlines
          .where((headline) => headline.title.contains(query))
          .toList();
      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: 1,
        totalPages: 1,
        totalItems: filteredHeadlines.length,
        hasNextPage: false,
        hasPreviousPage: false,
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
      final filteredHeadlines = _headlines
          .where((headline) => headline.category == category)
          .toList();
      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: 1,
        totalPages: 1,
        totalItems: filteredHeadlines.length,
        hasNextPage: false,
        hasPreviousPage: false,
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
      final filteredHeadlines = _headlines
          .where(
            (headline) =>
                headline.publishedAt.isAfter(startDate) &&
                headline.publishedAt.isBefore(endDate),
          )
          .toList();
      return PaginatedResponse<Headline>(
        items: filteredHeadlines,
        currentPage: 1,
        totalPages: 1,
        totalItems: filteredHeadlines.length,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    } catch (e) {
      throw const HeadlineDateRangeException(
        'Failed to fetch headlines for date range',
      );
    }
  }
}

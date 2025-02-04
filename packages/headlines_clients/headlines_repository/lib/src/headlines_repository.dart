import 'package:headlines_client/headlines_client.dart';

/// {@template headlines_repository}
/// Manages the headlines domain
/// {@endtemplate}
class HeadlinesRepository {
  /// {@macro headlines_repository}
  const HeadlinesRepository(this.client);

  /// The headlines client
  final HeadlinesClient client;

  /// Streams a paginated list of all headlines
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async {
    try {
      return await client.getHeadlines(options);
    } catch (e) {
      throw const HeadlineCategoryException();
    }
  }

  /// Fetches a specific headline by ID
  Future<Headline?> getHeadline(String id) async {
    try {
      return await client.getHeadline(id);
    } catch (e) {
      throw const HeadlineNotFoundException();
    }
  }

  /// Creates a new headline
  Future<Headline> createHeadline(Headline headline) async {
    try {
      return await client.createHeadline(headline);
    } catch (e) {
      throw const HeadlineCreationException();
    }
  }

  /// Updates an existing headline
  Future<Headline> updateHeadline(Headline headline) async {
    try {
      return await client.updateHeadline(headline);
    } catch (e) {
      throw const HeadlineUpdateException();
    }
  }

  /// Deletes a headline by ID
  Future<void> deleteHeadline(String id) async {
    try {
      return await client.deleteHeadline(id);
    } catch (e) {
      throw const HeadlineDeletionException();
    }
  }

  /// Headlines matching the query string
  Future<PaginatedResponse<Headline>> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      return await client.getHeadlinesByQuery(query, options);
    } catch (e) {
      throw const HeadlineSearchingException();
    }
  }

  /// Headlines for a specific category
  Future<PaginatedResponse<Headline>> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      return await client.getHeadlinesByCategory(category, options);
    } catch (e) {
      throw const HeadlineCategoryException();
    }
  }

  /// Headlines within a date range
  Future<PaginatedResponse<Headline>> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      return await client.getHeadlinesByDateRange(startDate, endDate, options);
    } catch (e) {
      throw const HeadlineDateRangeException();
    }
  }
}

import 'package:headlinehub_models/headlinehub_models.dart';

// Keep only core exceptions
/// Exception thrown when a headline is not found
class HeadlineNotFoundException implements Exception {
  /// Creates a new [HeadlineNotFoundException]
  const HeadlineNotFoundException([this.message = 'Headline not found']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error creating a headline
class HeadlineCreationException implements Exception {
  /// Creates a new [HeadlineCreationException]
  const HeadlineCreationException([this.message = 'Failed to create headline']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error updating a headline
class HeadlineUpdateException implements Exception {
  /// Creates a new [HeadlineUpdateException]
  const HeadlineUpdateException([this.message = 'Failed to update headline']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error deleting a headline
class HeadlineDeletionException implements Exception {
  /// Creates a new [HeadlineDeletionException]
  const HeadlineDeletionException([this.message = 'Failed to delete headline']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error fetching headlines by category
class HeadlineCategoryException implements Exception {
  /// Creates a new [HeadlineCategoryException]
  const HeadlineCategoryException(
      [this.message = 'Failed to fetch headlines for category']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error searching headlines
class HeadlineSearchingException implements Exception {
  /// Creates a new [HeadlineSearchingException]
  const HeadlineSearchingException(
      [this.message = 'Failed to search headlines']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when fetching headlines by date range fails
class HeadlineDateRangeException implements Exception {
  /// Creates a new [HeadlineDateRangeException]
  const HeadlineDateRangeException([
    this.message = 'Failed to fetch headlines for date range',
    this.startDate,
    this.endDate,
  ]);

  /// The error message
  final String message;

  /// Start date of the range
  final DateTime? startDate;

  /// End date of the range
  final DateTime? endDate;

  @override
  String toString() =>
      '$message${startDate != null ? ' ($startDate to $endDate)' : ''}';
}



/// Options for filtering and paginating headline results
class HeadlineQueryOptions {
  /// Creates a new [HeadlineQueryOptions]
  const HeadlineQueryOptions({
    this.page = 1,
    this.limit = 20,
    this.startDate,
    this.endDate,
    this.isActive,
    this.sortBy = HeadlineSortBy.publishedAt,
    this.sortDirection = SortDirection.descending,
  });

  /// The page number to fetch (1-based)
  final int page;

  /// The number of items per page
  final int limit;

  /// Filter headlines published after this date
  final DateTime? startDate;

  /// Filter headlines published before this date
  final DateTime? endDate;

  /// Filter headlines by active status
  final bool? isActive;

  /// The field to sort results by
  final HeadlineSortBy sortBy;

  /// The direction to sort results
  final SortDirection sortDirection;
}

/// Available fields for sorting headlines
enum HeadlineSortBy {
  /// Sort by publication date
  publishedAt,

  /// Sort by title
  title,

  /// Sort by source
  source
}

/// Direction for sorting results
enum SortDirection {
  /// Sort in ascending order
  ascending,

  /// Sort in descending order
  descending
}

/// {@template headlines_client}
/// Abstract headlines client that handles headline operations with streaming support
/// {@endtemplate}
abstract class HeadlinesClient {
  /// {@macro headlines_client}
  const HeadlinesClient();

  // CORE CRUD OPERATIONS

  /// Streams a paginated list of all headlines
  Stream<HeadlineResponse> getHeadlines([
    HeadlineQueryOptions? options,
  ]);

  /// Fetches a specific headline by ID
  Future<Headline?> getHeadline(String id);

  /// Creates a new headline
  Future<Headline> createHeadline(Headline headline);

  /// Updates an existing headline
  Future<Headline> updateHeadline(Headline headline);

  /// Deletes a headline by ID
  Future<void> deleteHeadline(String id);

  // SEARCH AND FILTER OPERATIONS

  /// Streams headlines matching the query string
  Stream<HeadlineResponse> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]);

  /// Streams headlines for a specific category
  Stream<HeadlineResponse> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
  ]);

  /// Streams headlines within a date range
  Stream<HeadlineResponse> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
  ]);

  // STREAM LIFECYCLE CONTROL

  /// Pauses all active streams
  /// 
  /// Call this when the app goes to background to conserve resources
  /// and prevent unnecessary network calls
  void pauseAllStreams();

  /// Resumes all previously paused streams
  /// 
  /// Call this when the app returns to foreground to restore
  /// real-time updates
  void resumeAllStreams();

  /// Cleanup resources when done
  /// 
  /// Call this when the client is no longer needed
  /// Cancels all active streams and releases resources
  Future<void> dispose();
}

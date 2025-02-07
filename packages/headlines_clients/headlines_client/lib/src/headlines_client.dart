import 'package:headlines_client/src/models/models.dart';

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
  const HeadlineCategoryException([
    this.message = 'Failed to fetch headlines for category',
  ]);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when there's an error searching headlines
class HeadlineSearchingException implements Exception {
  /// Creates a new [HeadlineSearchingException]
  const HeadlineSearchingException([
    this.message = 'Failed to search headlines',
  ]);

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
    this.dateRange,
    this.status,
    this.category,
    this.searchQuery,
    this.sortBy = HeadlineSortBy.publishedAt,
    this.sortDirection = SortDirection.descending,
  });

  /// The page number to fetch (1-based)
  final int page;

  /// The number of items per page
  final int limit;

  /// Filter headlines by date range
  final DateTimeRange? dateRange;

  /// Filter headlines by status
  final HeadlineStatus? status;

  /// Filter headlines by category
  final HeadlineCategory? category;

  /// Search query to filter headlines
  final String? searchQuery;

  /// The field to sort results by
  final HeadlineSortBy sortBy;

  /// The direction to sort results
  final SortDirection sortDirection;

  /// Creates a copy of this [HeadlineQueryOptions] with the given fields replaced
  HeadlineQueryOptions copyWith({
    int? page,
    int? limit,
    DateTimeRange? dateRange,
    HeadlineStatus? status,
    HeadlineCategory? category,
    String? searchQuery,
    HeadlineSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    return HeadlineQueryOptions(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      dateRange: dateRange ?? this.dateRange,
      status: status ?? this.status,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

/// Date range for filtering headlines
class DateTimeRange {
  /// Creates a new [DateTimeRange]
  const DateTimeRange({
    required this.start,
    required this.end,
  });

  /// Start date of the range
  final DateTime start;

  /// End date of the range
  final DateTime end;
}

/// Available fields for sorting headlines
enum HeadlineSortBy {
  /// Sort by title
  title,

  /// Sort by source
  source,

  /// Sort by category
  category,

  /// Sort by publication date
  publishedAt,

  /// Sort by status
  status,
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

  /// Retrieves a paginated list of headlines with optional filtering
  ///
  /// All filtering is handled through the [options] parameter:
  /// - Pagination through [page] and [limit]
  /// - Date filtering through [dateRange]
  /// - Status filtering through [status]
  /// - Category filtering through [category]
  /// - Search through [searchQuery]
  /// - Sorting through [sortBy] and [sortDirection]
  ///
  /// Throws a [HeadlineSearchingException] if there's an error fetching headlines.
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]);

  /// Fetches a specific headline by ID
  ///
  /// Throws a [HeadlineNotFoundException] if the headline is not found.
  Future<Headline?> getHeadline(String id);

  /// Creates a new headline
  ///
  /// Throws a [HeadlineCreationException] if there's an error creating the headline.
  Future<Headline> createHeadline(Headline headline);

  /// Updates an existing headline
  ///
  /// Throws a [HeadlineUpdateException] if there's an error updating the headline.
  Future<Headline> updateHeadline(Headline headline);

  /// Deletes a headline by ID
  ///
  /// Throws a [HeadlineDeletionException] if there's an error deleting the headline.
  Future<void> deleteHeadline(String id);
}

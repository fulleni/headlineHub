import 'package:headlinehub_models/headlinehub_models.dart';

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

/// Exception thrown when headline validation fails
class HeadlineValidationException implements Exception {
  /// Creates a new [HeadlineValidationException]
  const HeadlineValidationException([
    this.message = 'Headline validation failed',
    this.errors = const {},
  ]);

  /// The error message
  final String message;

  /// Map of field-specific validation errors
  final Map<String, String> errors;

  @override
  String toString() => '$message${errors.isEmpty ? '' : ': $errors'}';
}

/// Exception thrown when rate limit is exceeded
class HeadlineRateLimitException implements Exception {
  /// Creates a new [HeadlineRateLimitException]
  const HeadlineRateLimitException({
    this.message = 'Rate limit exceeded',
    required this.remainingRequests,
    required this.resetsAt,
  });

  /// The error message
  final String message;

  /// Number of remaining requests
  final int remainingRequests;

  /// When the rate limit resets
  final DateTime resetsAt;

  @override
  String toString() => '$message. Remaining requests: $remainingRequests, '
      'Resets at: $resetsAt';
}

/// Exception thrown when cache operations fail
class HeadlineCacheException implements Exception {
  /// Creates a new [HeadlineCacheException]
  const HeadlineCacheException([this.message = 'Cache operation failed']);

  /// The error message
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when network/connection issues occur
class HeadlineConnectionException implements Exception {
  /// Creates a new [HeadlineConnectionException]
  const HeadlineConnectionException([
    this.message = 'Connection failed',
    this.statusCode,
  ]);

  /// The error message
  final String message;

  /// Optional HTTP status code
  final int? statusCode;

  @override
  String toString() =>
      '$message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when a request times out
class HeadlineTimeoutException implements Exception {
  /// Creates a new [HeadlineTimeoutException]
  const HeadlineTimeoutException([
    this.message = 'Request timed out',
    this.duration,
  ]);

  /// The error message
  final String message;

  /// The duration after which the request timed out
  final Duration? duration;

  @override
  String toString() =>
      '$message${duration != null ? ' after ${duration!.inSeconds}s' : ''}';
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

/// Response metadata for paginated results
class PaginationMetadata {
  /// Creates new [PaginationMetadata]
  const PaginationMetadata({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Current page number
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Whether there is a next page
  final bool hasNextPage;

  /// Whether there is a previous page
  final bool hasPreviousPage;
}

/// Response wrapper for paginated results
class PaginatedResponse<T> {
  /// Creates new [PaginatedResponse]
  const PaginatedResponse({
    required this.items,
    required this.metadata,
  });

  /// The items for the current page
  final List<T> items;

  /// Pagination metadata
  final PaginationMetadata metadata;
}

/// Status of a batch operation
class BatchOperationStatus {
  /// Creates new [BatchOperationStatus]
  const BatchOperationStatus({
    required this.successful,
    required this.failed,
    this.errors = const {},
  });

  /// Successfully processed items
  final List<String> successful;

  /// Failed items
  final List<String> failed;

  /// Error messages by item ID
  final Map<String, String> errors;
}

/// Cache control hints for responses
enum CachePolicy {
  /// Do not use caching.
  /// Always fetch fresh data from the source.
  noCache,

  /// Cache the response after fetching it..
  cache,

  /// Use the cached response if available;
  /// otherwise, fetch fresh data and cache it.
  cacheFirst,
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

/// Client configuration options
class HeadlineClientConfig {
  /// Creates new [HeadlineClientConfig]
  const HeadlineClientConfig({
    this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.apiKey,
  });

  /// Base URL for the API
  final String? baseUrl;

  /// Request timeout duration
  final Duration timeout;

  /// Maximum number of retries for failed requests
  final int maxRetries;

  /// Optional API key
  final String? apiKey;
}

/// Server status information
class ServerStatus {
  /// Creates new [ServerStatus]
  const ServerStatus({
    required this.isAvailable,
    required this.version,
    this.message,
  });

  /// Whether the server is available
  final bool isAvailable;

  /// Server version
  final String version;

  /// Optional status message
  final String? message;
}

/// {@template headlines_client}
/// Abstract headlines client that all future clients will implement
/// {@endtemplate}
abstract class HeadlinesClient {
  /// {@macro headlines_client}
  const HeadlinesClient();

  // CORE CRUD OPERATIONS

  /// Fetches a paginated list of all headlines
  ///
  /// [options] controls pagination, filtering and sorting
  /// [cachePolicy] determines caching behavior
  ///
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
    CachePolicy cachePolicy = CachePolicy.cache,
  ]);

  /// Fetches a specific headline by ID
  ///
  /// Returns null if no headline is found with the given ID
  ///
  /// Throws [HeadlineNotFoundException] if the headline lookup fails
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<Headline?> getHeadline(
    String id, [
    CachePolicy cachePolicy = CachePolicy.cache,
  ]);

  /// Creates a new headline
  ///
  /// Throws [HeadlineValidationException] if validation fails
  /// Throws [HeadlineCreationException] if creation fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<Headline> createHeadline(Headline headline);

  /// Updates an existing headline
  ///
  /// Throws [HeadlineValidationException] if validation fails
  /// Throws [HeadlineNotFoundException] if headline doesn't exist
  /// Throws [HeadlineUpdateException] if update fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<Headline> updateHeadline(Headline headline);

  /// Deletes a headline by ID
  ///
  /// Throws [HeadlineNotFoundException] if headline doesn't exist
  /// Throws [HeadlineDeletionException] if deletion fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<void> deleteHeadline(String id);

  // SEARCH AND FILTER OPERATIONS

  /// Fetches headlines matching the query string with pagination
  ///
  /// [options] controls pagination, filtering and sorting
  /// [cachePolicy] determines caching behavior
  ///
  /// Throws [HeadlineSearchingException] if query fetch fails
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<PaginatedResponse<Headline>> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
    CachePolicy cachePolicy = CachePolicy.noCache,
  ]);

  /// Fetches headlines by category with pagination
  ///
  /// [options] controls pagination, filtering and sorting
  /// [cachePolicy] determines caching behavior
  ///
  /// Throws [HeadlineCategoryException] if category fetch fails
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<PaginatedResponse<Headline>> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
    CachePolicy cachePolicy = CachePolicy.cache,
  ]);

  /// Fetches headlines within a specific date range
  ///
  /// [options] controls pagination, filtering and sorting
  /// [cachePolicy] determines caching behavior
  ///
  /// Throws [HeadlineDateRangeException] if date range is invalid
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<PaginatedResponse<Headline>> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
    CachePolicy cachePolicy = CachePolicy.cache,
  ]);

  // BATCH OPERATIONS

  /// Creates multiple headlines in a single operation
  ///
  /// Throws [HeadlineValidationException] if any headline is invalid
  /// Throws [HeadlineCreationException] if bulk creation fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<BatchOperationStatus> createHeadlines(List<Headline> headlines);

  /// Updates multiple headlines in a single operation
  ///
  /// Throws [HeadlineValidationException] if any headline is invalid
  /// Throws [HeadlineNotFoundException] if any headline doesn't exist
  /// Throws [HeadlineUpdateException] if bulk update fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<BatchOperationStatus> updateHeadlines(List<Headline> headlines);

  /// Deletes multiple headlines in a single operation
  ///
  /// Throws [HeadlineNotFoundException] if any headline doesn't exist
  /// Throws [HeadlineDeletionException] if bulk deletion fails
  /// Throws [HeadlineConnectionException] if network request fails
  /// Throws [HeadlineTimeoutException] if request times out
  Future<BatchOperationStatus> deleteHeadlines(List<String> ids);

  // UTILITY OPERATIONS

  /// Validates a headline before creation/update
  ///
  /// Returns true if the headline is valid
  ///
  /// Throws [HeadlineValidationException] if validation fails
  /// Throws [HeadlineConnectionException] if validation service is unreachable
  /// Throws [HeadlineTimeoutException] if request times out
  Future<bool> validateHeadline(
    Headline headline, [
    CachePolicy cachePolicy = CachePolicy.noCache,
  ]);

  /// Get current rate limit status
  ///
  /// Returns remaining requests and reset time
  ///
  /// Throws [HeadlineRateLimitException] if rate limit is exceeded
  /// Throws [HeadlineCacheException] if cache operations fail
  /// Throws [HeadlineConnectionException] if rate limit service is unreachable
  /// Throws [HeadlineTimeoutException] if request times out
  Future<({int remaining, DateTime resetsAt})> getRateLimitStatus([
    CachePolicy cachePolicy = CachePolicy.noCache,
  ]);

  /// Clears the client's cache
  ///
  /// Throws [HeadlineCacheException] if cache operation fails
  Future<void> clearCache();

  /// Gets the current client configuration
  ///
  /// This is a synchronous operation that doesn't throw exceptions
  HeadlineClientConfig getConfig();

  /// Gets the current server status
  ///
  /// Throws [HeadlineConnectionException] if server is unreachable
  /// Throws [HeadlineTimeoutException] if request times out
  /// Throws [HeadlineCacheException] if cache operations fail
  Future<ServerStatus> getServerStatus([
    CachePolicy cachePolicy = CachePolicy.noCache,
  ]);
}

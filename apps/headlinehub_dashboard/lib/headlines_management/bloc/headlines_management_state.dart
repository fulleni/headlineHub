part of 'headlines_management_bloc.dart';

/// The status of the headlines management page.
enum HeadlinesManagementStatus { initial, loading, success, failure }

/// The state of the headlines management page.
@immutable
class HeadlinesManagementState {
  /// Creates a new [HeadlinesManagementState] instance.
  const HeadlinesManagementState({
    this.fetchStatus = HeadlinesManagementStatus.initial,
    this.createStatus = HeadlinesManagementStatus.initial,
    this.updateStatus = HeadlinesManagementStatus.initial,
    this.deleteStatus = HeadlinesManagementStatus.initial,
    this.headlines = const [],
    this.hasNextPage = false,
    this.headline,
    this.currentPage = 1,
    this.totalPages = 1,
    this.perPage = 10,
    this.sortBy = HeadlineSortBy.publishedAt,
    this.sortDirection = SortDirection.descending,
  });

  /// The current status of the headlines management page.
  final HeadlinesManagementStatus fetchStatus;
  final HeadlinesManagementStatus createStatus;
  final HeadlinesManagementStatus updateStatus;
  final HeadlinesManagementStatus deleteStatus;

  /// The list of headlines.
  final List<Headline> headlines;

  /// Whether there is a next page of headlines.
  final bool hasNextPage;

  /// The headline fetched by ID.
  final Headline? headline;

  /// The current page of headlines.
  final int currentPage;

  /// The total number of pages of headlines.
  final int totalPages;

  /// nuumber of headlines to fetch and show.
  final int perPage;

  /// The current sort field
  final HeadlineSortBy sortBy;

  /// The current sort direction
  final SortDirection sortDirection;

  /// Creates a copy of this [HeadlinesManagementState] with the given
  /// fields replaced with new values.
  HeadlinesManagementState copyWith({
    HeadlinesManagementStatus? fetchStatus,
    HeadlinesManagementStatus? createStatus,
    HeadlinesManagementStatus? updateStatus,
    HeadlinesManagementStatus? deleteStatus,
    List<Headline>? headlines,
    bool? hasNextPage,
    Headline? headline,
    int? currentPage,
    int? totalPages,
    int? perPage,
    HeadlineSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    return HeadlinesManagementState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      headlines: headlines ?? this.headlines,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      headline: headline ?? this.headline,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      perPage: perPage ?? this.perPage,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

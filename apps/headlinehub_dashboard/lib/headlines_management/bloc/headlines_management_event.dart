part of 'headlines_management_bloc.dart';

@immutable
sealed class HeadlinesManagementEvent {
  const HeadlinesManagementEvent();
}

final class HeadlinesFetchRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchRequested({
    this.page = 1,
    this.perPage,
    this.category,
    this.dateRange,
    this.status,
    this.searchQuery,
    this.sortBy,
    this.sortDirection,
  });

  final int page;
  final int? perPage;
  final HeadlineCategory? category;
  final DateTimeRange? dateRange;
  final HeadlineStatus? status;
  final String? searchQuery;
  final HeadlineSortBy? sortBy;
  final SortDirection? sortDirection;
}

final class HeadlineFetchByIdRequested extends HeadlinesManagementEvent {
  const HeadlineFetchByIdRequested(this.id);

  final String id;
}

final class HeadlineCreateRequested extends HeadlinesManagementEvent {
  const HeadlineCreateRequested(this.headline);

  final Headline headline;
}

final class HeadlineUpdateRequested extends HeadlinesManagementEvent {
  const HeadlineUpdateRequested(this.headline);

  final Headline headline;
}

final class HeadlineDeleteRequested extends HeadlinesManagementEvent {
  const HeadlineDeleteRequested(this.id);

  final String id;
}

final class HeadlineUndoDeleteRequested extends HeadlinesManagementEvent {
  const HeadlineUndoDeleteRequested();
}

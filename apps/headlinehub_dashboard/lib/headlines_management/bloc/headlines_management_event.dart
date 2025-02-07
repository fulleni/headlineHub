part of 'headlines_management_bloc.dart';

@immutable
sealed class HeadlinesManagementEvent {
  const HeadlinesManagementEvent();
}

final class HeadlinesFetchRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchRequested({
    this.page = 1,
  });

  final int page;
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

final class HeadlinesFetchByQueryRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchByQueryRequested(this.query);

  final String query;
}

final class HeadlinesFetchByCategoryRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchByCategoryRequested(this.category);

  final HeadlineCategory category;
}

final class HeadlinesFetchByDateRangeRequested
    extends HeadlinesManagementEvent {
  const HeadlinesFetchByDateRangeRequested(
    this.startDate,
    this.endDate,
  );

  final DateTime startDate;
  final DateTime endDate;
}

final class HeadlinesPerPageUpdated extends HeadlinesManagementEvent {
  const HeadlinesPerPageUpdated(this.perPage);

  final int perPage;
}

final class HeadlinesSortRequested extends HeadlinesManagementEvent {
  const HeadlinesSortRequested({
    required this.sortBy,
    required this.sortDirection,
  });

  final HeadlineSortBy sortBy;
  final SortDirection sortDirection;
}

final class HeadlineUndoDeleteRequested extends HeadlinesManagementEvent {
  const HeadlineUndoDeleteRequested();
}

// Add these new events
final class HeadlinesFetchByFiltersRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchByFiltersRequested({
    this.category,
    this.startDate,
    this.endDate,
    this.status,
  });

  final HeadlineCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? status;
}

final class HeadlinesCategoryFilterChanged extends HeadlinesManagementEvent {
  const HeadlinesCategoryFilterChanged(this.category);
  final HeadlineCategory? category;
}

final class HeadlinesStartDateFilterChanged extends HeadlinesManagementEvent {
  const HeadlinesStartDateFilterChanged(this.date);
  final DateTime date;
}

final class HeadlinesEndDateFilterChanged extends HeadlinesManagementEvent {
  const HeadlinesEndDateFilterChanged(this.date);
  final DateTime date;
}

final class HeadlinesStatusFilterChanged extends HeadlinesManagementEvent {
  const HeadlinesStatusFilterChanged(this.status);
  final bool? status;
}

final class HeadlinesFilterReset extends HeadlinesManagementEvent {
  const HeadlinesFilterReset();
}

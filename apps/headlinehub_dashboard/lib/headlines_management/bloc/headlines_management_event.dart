part of 'headlines_management_bloc.dart';

@immutable
sealed class HeadlinesManagementEvent {
  const HeadlinesManagementEvent();
}

final class HeadlinesFetchRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchRequested({
    this.page = 1,
    this.limit = 5,
  });

  final int page;
  final int limit;
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
  const HeadlinesFetchByQueryRequested(this.query, {this.limit = 5});

  final String query;
  final int limit;
}

final class HeadlinesFetchByCategoryRequested extends HeadlinesManagementEvent {
  const HeadlinesFetchByCategoryRequested(this.category, {this.limit = 5});

  final HeadlineCategory category;
  final int limit;
}

final class HeadlinesFetchByDateRangeRequested
    extends HeadlinesManagementEvent {
  const HeadlinesFetchByDateRangeRequested(
    this.startDate,
    this.endDate, {
    this.limit = 5,
  });

  final DateTime startDate;
  final DateTime endDate;
  final int limit;
}

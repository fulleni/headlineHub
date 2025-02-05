part of 'headlines_feed_bloc.dart';

@immutable
sealed class HeadlinesFeedEvent {
  const HeadlinesFeedEvent();
}

final class HeadlinesFetchRequested extends HeadlinesFeedEvent {
  const HeadlinesFetchRequested({this.limit = 10});

  final int limit;
}

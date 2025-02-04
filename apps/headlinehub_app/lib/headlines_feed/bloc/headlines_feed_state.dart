part of 'headlines_feed_bloc.dart';

/// The status of the headlines feed.
enum HeadlinesFeedStatus { initial, loading, success, failure }

/// The state of the headlines feed.
@immutable
class HeadlinesFeedState {
  /// Creates a new [HeadlinesFeedState] instance.
  const HeadlinesFeedState({
    this.status = HeadlinesFeedStatus.initial,
    this.headlines = const [],
    this.hasNextPage = false,
  });

  /// The current status of the headlines feed.
  final HeadlinesFeedStatus status;

  /// The list of headlines.
  final List<Headline> headlines;

  /// Whether there is a next page of headlines.
  final bool hasNextPage;

  /// Creates a copy of this [HeadlinesFeedState] with the given fields replaced
  /// with new values.
  HeadlinesFeedState copyWith({
    HeadlinesFeedStatus? status,
    List<Headline>? headlines,
    bool? hasNextPage,
  }) {
    return HeadlinesFeedState(
      status: status ?? this.status,
      headlines: headlines ?? this.headlines,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

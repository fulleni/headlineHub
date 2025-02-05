import 'package:bloc/bloc.dart';
import 'package:headlines_repository/headlines_repository.dart';
import 'package:meta/meta.dart';

part 'headlines_feed_event.dart';
part 'headlines_feed_state.dart';

/// A Bloc that manages the state of the headlines feed.
class HeadlinesFeedBloc extends Bloc<HeadlinesFeedEvent, HeadlinesFeedState> {
  HeadlinesFeedBloc(this.headlinesRepository)
      : super(const HeadlinesFeedState()) {
    on<HeadlinesFetchRequested>(_onHeadlinesFetchRequested);
  }

  final HeadlinesRepository headlinesRepository;

  /// Handles the [HeadlinesFetchRequested] event.
  ///
  /// Fetches headlines from the [headlinesRepository] and updates the state.
  Future<void> _onHeadlinesFetchRequested(
    HeadlinesFetchRequested event,
    Emitter<HeadlinesFeedState> emit,
  ) async {
    if (state.status == HeadlinesFeedStatus.loading) return;
    emit(state.copyWith(status: HeadlinesFeedStatus.loading));
    try {
      final options = HeadlineQueryOptions(
        page: (state.headlines.length ~/ event.limit) + 1,
        limit: event.limit,
      );
      final headlines = await headlinesRepository.getHeadlines(options);
      emit(
        state.copyWith(
          status: HeadlinesFeedStatus.success,
          headlines: List.of(state.headlines)..addAll(headlines.items),
          hasNextPage: headlines.hasNextPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesFeedStatus.failure));
    }
  }
}

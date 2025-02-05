import 'package:bloc/bloc.dart';
import 'package:headlines_repository/headlines_repository.dart';
import 'package:meta/meta.dart';

part 'headlines_management_event.dart';
part 'headlines_management_state.dart';

/// A Bloc that manages the state of the headlines management pafe.
class HeadlinesManagementBloc
    extends Bloc<HeadlinesManagementEvent, HeadlinesManagementState> {
  HeadlinesManagementBloc(this.headlinesRepository)
      : super(const HeadlinesManagementState()) {
    on<HeadlinesFetchRequested>(_onHeadlinesFetchRequested);
    on<HeadlineFetchByIdRequested>(_onHeadlineFetchByIdRequested);
    on<HeadlineCreateRequested>(_onHeadlineCreateRequested);
    on<HeadlineUpdateRequested>(_onHeadlineUpdateRequested);
    on<HeadlineDeleteRequested>(_onHeadlineDeleteRequested);
    on<HeadlinesFetchByQueryRequested>(_onHeadlinesFetchByQueryRequested);
    on<HeadlinesFetchByCategoryRequested>(_onHeadlinesFetchByCategoryRequested);
    on<HeadlinesFetchByDateRangeRequested>(
      _onHeadlinesFetchByDateRangeRequested,
    );
  }

  final HeadlinesRepository headlinesRepository;

  /// Handles the [HeadlinesFetchRequested] event.
  ///
  /// Fetches headlines from the [headlinesRepository] and updates the state.
  Future<void> _onHeadlinesFetchRequested(
    HeadlinesFetchRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    if (state.status == HeadlinesManagementStatus.loading) return;
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final options = HeadlineQueryOptions(
        page: event.page,
        limit: event.limit,
      );
      final headlines = await headlinesRepository.getHeadlines(options);
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: headlines.items,
          hasNextPage: headlines.hasNextPage,
          currentPage: event.page,
          totalPages: (headlines.totalItems / event.limit).ceil(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineFetchByIdRequested(
    HeadlineFetchByIdRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final headline = await headlinesRepository.getHeadline(event.id);
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headline: headline,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineCreateRequested(
    HeadlineCreateRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final headline = await headlinesRepository.createHeadline(event.headline);
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: List.of(state.headlines)..add(headline),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineUpdateRequested(
    HeadlineUpdateRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final updatedHeadline =
          await headlinesRepository.updateHeadline(event.headline);
      final updatedHeadlines = state.headlines.map((headline) {
        return headline.id == updatedHeadline.id ? updatedHeadline : headline;
      }).toList();
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: updatedHeadlines,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineDeleteRequested(
    HeadlineDeleteRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      await headlinesRepository.deleteHeadline(event.id);
      final updatedHeadlines =
          state.headlines.where((headline) => headline.id != event.id).toList();
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: updatedHeadlines,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlinesFetchByQueryRequested(
    HeadlinesFetchByQueryRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final options = HeadlineQueryOptions(
        page: (state.headlines.length ~/ event.limit) + 1,
        limit: event.limit,
      );
      final headlines =
          await headlinesRepository.getHeadlinesByQuery(event.query, options);
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: List.of(state.headlines)..addAll(headlines.items),
          hasNextPage: headlines.hasNextPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlinesFetchByCategoryRequested(
    HeadlinesFetchByCategoryRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final options = HeadlineQueryOptions(
        page: (state.headlines.length ~/ event.limit) + 1,
        limit: event.limit,
      );
      final headlines = await headlinesRepository.getHeadlinesByCategory(
        event.category,
        options,
      );
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: List.of(state.headlines)..addAll(headlines.items),
          hasNextPage: headlines.hasNextPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlinesFetchByDateRangeRequested(
    HeadlinesFetchByDateRangeRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(status: HeadlinesManagementStatus.loading));
    try {
      final options = HeadlineQueryOptions(
        page: (state.headlines.length ~/ event.limit) + 1,
        limit: event.limit,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      final headlines = await headlinesRepository.getHeadlinesByDateRange(
        event.startDate,
        event.endDate,
        options,
      );
      emit(
        state.copyWith(
          status: HeadlinesManagementStatus.success,
          headlines: List.of(state.headlines)..addAll(headlines.items),
          hasNextPage: headlines.hasNextPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HeadlinesManagementStatus.failure));
    }
  }
}

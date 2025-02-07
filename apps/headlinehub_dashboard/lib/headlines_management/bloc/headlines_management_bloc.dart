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
    on<HeadlineUndoDeleteRequested>(_onHeadlineUndoDeleteRequested);
    // Remove HeadlinesSortRequested handler
  }

  final HeadlinesRepository headlinesRepository;

  /// Handles the [HeadlinesFetchRequested] event.
  ///
  /// Fetches headlines from the [headlinesRepository] and updates the state.
  Future<void> _onHeadlinesFetchRequested(
    HeadlinesFetchRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: HeadlinesManagementStatus.loading));
    try {
      // Update state with filter values, including nulls for reset
      emit(state.copyWith(
        selectedCategory: event.category,
        filterDateRange: event.dateRange,
        filterStatus: event.status,
        searchQuery: event.searchQuery,
        sortBy: event.sortBy ?? state.sortBy,
        sortDirection: event.sortDirection ?? state.sortDirection,
        perPage: event.perPage ?? state.perPage,
      ));

      final options = HeadlineQueryOptions(
        page: event.page,
        limit: state.perPage,
        category: state.selectedCategory,
        status: state.filterStatus,
        dateRange: state.filterDateRange,
        searchQuery: state.searchQuery,
        sortBy: state.sortBy,
        sortDirection: state.sortDirection,
      );

      final headlines = await headlinesRepository.getHeadlines(options);

      emit(state.copyWith(
        fetchStatus: HeadlinesManagementStatus.success,
        headlines: headlines.items,
        hasNextPage: headlines.hasNextPage,
        currentPage: event.page,
        totalPages: headlines.totalPages,
      ));
    } catch (_) {
      emit(state.copyWith(fetchStatus: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineFetchByIdRequested(
    HeadlineFetchByIdRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: HeadlinesManagementStatus.loading));
    try {
      final headline = await headlinesRepository.getHeadline(event.id);
      emit(
        state.copyWith(
          fetchStatus: HeadlinesManagementStatus.success,
          headline: headline,
        ),
      );
    } catch (_) {
      emit(state.copyWith(fetchStatus: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineCreateRequested(
    HeadlineCreateRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(createStatus: HeadlinesManagementStatus.loading));
    try {
      final headline = await headlinesRepository.createHeadline(event.headline);
      emit(
        state.copyWith(
          createStatus: HeadlinesManagementStatus.success,
          headlines: List.of(state.headlines)..add(headline),
        ),
      );
    } catch (_) {
      emit(state.copyWith(createStatus: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineUpdateRequested(
    HeadlineUpdateRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(updateStatus: HeadlinesManagementStatus.loading));
    try {
      final updatedHeadline =
          await headlinesRepository.updateHeadline(event.headline);
      final updatedHeadlines = state.headlines.map((headline) {
        return headline.id == updatedHeadline.id ? updatedHeadline : headline;
      }).toList();
      emit(
        state.copyWith(
          updateStatus: HeadlinesManagementStatus.success,
          headlines: updatedHeadlines,
        ),
      );
    } catch (_) {
      emit(state.copyWith(updateStatus: HeadlinesManagementStatus.failure));
    }
  }

  Future<void> _onHeadlineDeleteRequested(
    HeadlineDeleteRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: HeadlinesManagementStatus.loading));
    try {
      // Store the headline before deleting it
      final deletedHeadline =
          state.headlines.firstWhere((h) => h.id == event.id);
      await headlinesRepository.deleteHeadline(event.id);

      final options = HeadlineQueryOptions(
        page: state.currentPage,
        limit: state.perPage,
        sortBy: state.sortBy,
        sortDirection: state.sortDirection,
      );
      final headlines = await headlinesRepository.getHeadlines(options);
      emit(
        state.copyWith(
          deleteStatus: HeadlinesManagementStatus.success,
          fetchStatus: HeadlinesManagementStatus.success,
          headlines: headlines.items,
          hasNextPage: headlines.hasNextPage,
          totalPages: (headlines.totalItems / state.perPage).ceil(),
          deletedHeadline: deletedHeadline,
        ),
      );
    } catch (_) {
      emit(state.copyWith(
        deleteStatus: HeadlinesManagementStatus.failure,
        deletedHeadline: null,
      ));
    }
  }

  Future<void> _onHeadlineUndoDeleteRequested(
    HeadlineUndoDeleteRequested event,
    Emitter<HeadlinesManagementState> emit,
  ) async {
    if (state.deletedHeadline == null) return;

    try {
      final restoredHeadline = await headlinesRepository.createHeadline(
        state.deletedHeadline!,
      );

      final options = HeadlineQueryOptions(
        page: state.currentPage,
        limit: state.perPage,
        sortBy: state.sortBy,
        sortDirection: state.sortDirection,
      );
      final headlines = await headlinesRepository.getHeadlines(options);

      emit(state.copyWith(
        headlines: headlines.items,
        deletedHeadline: null,
        hasNextPage: headlines.hasNextPage,
        totalPages: (headlines.totalItems / state.perPage).ceil(),
      ));
    } catch (_) {
      emit(state.copyWith(deletedHeadline: null));
    }
  }
}

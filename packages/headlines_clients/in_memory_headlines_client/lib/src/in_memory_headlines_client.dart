import 'dart:async';
import 'package:headlinehub_models/headlinehub_models.dart';
import 'package:headlines_client/headlines_client.dart';

/// {@template in_memory_headlines_client}
/// InMemory implementation of the headlines client
///
/// This client stores headlines in memory and periodically generates
/// new headlines.
/// It supports CRUD operations and streaming of headlines with various
/// query options.
/// {@endtemplate}
class InMemoryHeadlinesClient extends HeadlinesClient {
  /// {@macro in_memory_headlines_client}
  InMemoryHeadlinesClient() : _headlines = _mockHeadlines {
    _startHeadlineGenerator();
  }

  final List<Headline> _headlines;
  final _controller = StreamController<PaginatedResponse>.broadcast();
  Timer? _timer;

  /// Initial mock headlines data
  static final List<Headline> _mockHeadlines = List.generate(20, (index) {
    final now = DateTime.now();
    return Headline(
      id: '$index',
      title: 'Headline $index',
      content: 'Content for headline $index...',
      publishedBy: 'Source $index',
      publishedIn: 'https://example.com/image$index.jpg',
      publishedAt: now.subtract(Duration(days: index)),
      category: HeadlineCategory.values[index % HeadlineCategory.values.length],
    );
  });

  /// Starts a timer that periodically generates new headlines
  void _startHeadlineGenerator() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      final newHeadline = Headline(
        id: '${_headlines.length}',
        title: 'New Headline ${_headlines.length}',
        content: 'Content for new headline ${_headlines.length}...',
        publishedBy: 'New Source',
        publishedIn: 'https://example.com/new_image${_headlines.length}.jpg',
        publishedAt: now,
        category: HeadlineCategory
            .values[_headlines.length % HeadlineCategory.values.length],
      );
      _headlines.add(newHeadline);
      _controller.add(_createHeadlineResponse(_headlines));
    });
  }

  @override
  Stream<PaginatedResponse> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async* {
    yield _createHeadlineResponse(_headlines, options);
  }

  @override
  Future<Headline?> getHeadline(String id) async {
    try {
      return _headlines.firstWhere((headline) => headline.id == id);
    } catch (e) {
      throw const HeadlineNotFoundException();
    }
  }

  @override
  Future<Headline> createHeadline(Headline headline) async {
    try {
      _headlines.add(headline);
      _controller.add(_createHeadlineResponse(_headlines));
      return headline;
    } catch (e) {
      throw const HeadlineCreationException();
    }
  }

  @override
  Future<Headline> updateHeadline(Headline headline) async {
    final index = _headlines.indexWhere((h) => h.id == headline.id);
    if (index == -1) throw const HeadlineNotFoundException();
    try {
      _headlines[index] = headline;
      _controller.add(_createHeadlineResponse(_headlines));
      return headline;
    } catch (e) {
      throw const HeadlineUpdateException();
    }
  }

  @override
  Future<void> deleteHeadline(String id) async {
    final index = _headlines.indexWhere((h) => h.id == id);
    if (index == -1) throw const HeadlineNotFoundException();
    try {
      _headlines.removeAt(index);
      _controller.add(_createHeadlineResponse(_headlines));
    } catch (e) {
      throw const HeadlineDeletionException();
    }
  }

  @override
  Stream<PaginatedResponse> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]) async* {
    try {
      final filtered = _headlines
          .where((headline) => headline.title.contains(query))
          .toList();
      yield _createHeadlineResponse(filtered, options);
    } catch (e) {
      throw const HeadlineSearchingException();
    }
  }

  @override
  Stream<PaginatedResponse> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
  ]) async* {
    try {
      final filtered = _headlines
          .where((headline) => headline.category == category)
          .toList();
      yield _createHeadlineResponse(filtered, options);
    } catch (e) {
      throw const HeadlineCategoryException();
    }
  }

  @override
  Stream<PaginatedResponse> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
  ]) async* {
    try {
      final filtered = _headlines
          .where(
            (headline) =>
                headline.publishedAt.isAfter(startDate) &&
                headline.publishedAt.isBefore(endDate),
          )
          .toList();
      yield _createHeadlineResponse(filtered, options);
    } catch (e) {
      throw const HeadlineDateRangeException();
    }
  }

  @override
  void pauseAllStreams() {
    _controller.onPause!();
  }

  @override
  void resumeAllStreams() {
    _controller.onResume!();
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
    _timer?.cancel();
  }

  /// Creates a [PaginatedResponse] from the list of headlines
  ///
  /// This method handles pagination and sorting based on the provided options.
  PaginatedResponse _createHeadlineResponse(
    List<Headline> headlines, [
    HeadlineQueryOptions? options,
  ]) {
    var sortedHeadlines = List<Headline>.from(headlines);

    // Apply sorting
    if (options != null) {
      sortedHeadlines.sort((a, b) {
        int comparison;
        switch (options.sortBy) {
          case HeadlineSortBy.title:
            comparison = a.title.compareTo(b.title);
          case HeadlineSortBy.source:
            comparison = a.publishedBy.compareTo(b.publishedBy);
          case HeadlineSortBy.publishedAt:
            comparison = a.publishedAt.compareTo(b.publishedAt);
        }
        return options.sortDirection == SortDirection.ascending
            ? comparison
            : -comparison;
      });

      // Apply pagination
      final startIndex = (options.page - 1) * options.limit;
      final endIndex = startIndex + options.limit;
      sortedHeadlines = sortedHeadlines.sublist(
        startIndex,
        endIndex > sortedHeadlines.length ? sortedHeadlines.length : endIndex,
      );
    }

    return PaginatedResponse(
      items: sortedHeadlines,
      paginationMetadata: PaginationMetadata(
        currentPage: options?.page ?? 1,
        totalPages: (headlines.length / (options?.limit ?? 20)).ceil(),
        totalItems: headlines.length,
        hasNextPage:
            (options?.page ?? 1) * (options?.limit ?? 20) < headlines.length,
        hasPreviousPage: (options?.page ?? 1) > 1,
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

/// A response model that wraps a paginated list of items.
///
/// This model is used for API responses that return multiple 
/// items including pagination metadata .
class PaginatedResponse<T> extends Equatable {
  /// Creates a new [PaginatedResponse] instance.
  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// The list of items for the current page.
  final List<T> items;

  /// Current page number
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Whether there is a next page
  final bool hasNextPage;

  /// Whether there is a previous page
  final bool hasPreviousPage;

  /// Creates a copy of this PaginationResponse with the given fields replaced
  /// with new values.
  PaginatedResponse<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedResponse(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
        hasPreviousPage,
      ];
}

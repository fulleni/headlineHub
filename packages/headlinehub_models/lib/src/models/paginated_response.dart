import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

/// A response model that wraps a paginated list,
/// and provides pagination metadata and optional status messages.
@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class PaginatedResponse<T> extends Equatable {
  /// Creates a new [PaginatedResponse] instance.
  ///
  /// [items] is the list of items for the current page.
  /// [currentPage] is the current page number.
  /// [totalPages] is the total number of pages.
  /// [totalItems] is the total number of items across all pages.
  /// [hasNextPage] indicates whether there is a next page.
  /// [hasPreviousPage] indicates whether there is a previous page.
  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Creates a [PaginatedResponse] instance from a JSON map.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  /// The list of items for the current page.
  final List<T> items;

  /// Current page number.
  final int currentPage;

  /// Total number of pages.
  final int totalPages;

  /// Total number of items across all pages.
  final int totalItems;

  /// Whether there is a next page.
  final bool hasNextPage;

  /// Whether there is a previous page.
  final bool hasPreviousPage;

  /// Converts this [PaginatedResponse] instance to a JSON map.
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  /// Creates a copy of this [PaginatedResponse] with the given fields replaced
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

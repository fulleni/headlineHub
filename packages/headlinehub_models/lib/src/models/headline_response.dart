import 'package:equatable/equatable.dart';
import 'package:headlinehub_models/src/models/headline.dart';
import 'package:json_annotation/json_annotation.dart';

part 'headline_response.g.dart';

/// A model that represents the metadata for paginated responses.
@JsonSerializable(explicitToJson: true)
class PaginationMetadata extends Equatable {
  /// Creates new [PaginationMetadata]
  const PaginationMetadata({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Creates a [PaginationMetadata] instance from JSON
  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);

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

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() => _$PaginationMetadataToJson(this);

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
        hasPreviousPage,
      ];
}

/// A response model that wraps a paginated list of headlines.
///
/// This model is used for API responses that return multiple headlines,
/// including pagination metadata and optional status messages.
@JsonSerializable(explicitToJson: true)
class HeadlineResponse extends Equatable {
  
  /// Creates a new [HeadlineResponse] instance.
  ///
  /// [headlines] is the list of headlines for the current page.
  /// [paginationMetadata] is the pagination metadata for the response.
  const HeadlineResponse({
    required this.headlines,
    required this.paginationMetadata,
  });

  /// Creates a [HeadlineResponse] instance from a JSON map.
  ///
  /// The [json] parameter must contain valid keys that match
  /// the property names of [HeadlineResponse].
  factory HeadlineResponse.fromJson(Map<String, dynamic> json) => 
      _$HeadlineResponseFromJson(json);

  /// The list of headlines for the current page.
  final List<Headline> headlines;

  /// The pagination metadata for the response.
  final PaginationMetadata paginationMetadata;

  /// Converts this [HeadlineResponse] instance to a JSON map.
  ///
  /// Returns a [Map] containing all properties in a JSON-compatible format.
  Map<String, dynamic> toJson() => _$HeadlineResponseToJson(this);

  /// Creates a copy of this HeadlineResponse with the given fields replaced 
  /// with new values.
  HeadlineResponse copyWith({
    List<Headline>? headlines,
    PaginationMetadata? paginationMetadata,
  }) {
    return HeadlineResponse(
      headlines: headlines ?? this.headlines,
      paginationMetadata: paginationMetadata ?? this.paginationMetadata,
    );
  }

  @override
  List<Object?> get props => [
        headlines,
        paginationMetadata,
      ];
}

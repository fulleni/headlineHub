import 'package:equatable/equatable.dart';
import 'package:headlinehub_models/src/models/headline.dart';
import 'package:json_annotation/json_annotation.dart';

part 'headline_response.g.dart';

/// A response model that wraps a paginated list of headlines.
///
/// This model is used for API responses that return multiple headlines,
/// including pagination metadata and optional status messages.
@JsonSerializable(explicitToJson: true)
class HeadlineResponse extends Equatable {
  
  /// Creates a new [HeadlineResponse] instance.
  ///
  /// [headlines] is the list of headlines for the current page.
  /// [total] is the total number of headlines available.
  /// [page] is the current page number.
  /// [perPage] is the number of headlines per page.
  /// [message] is an optional status or information message.
  const HeadlineResponse({
    required this.headlines,
    required this.total,
    required this.page,
    required this.perPage,
    this.message,
  });

  /// Creates a [HeadlineResponse] instance from a JSON map.
  ///
  /// The [json] parameter must contain valid keys that match
  /// the property names of [HeadlineResponse].
  factory HeadlineResponse.fromJson(Map<String, dynamic> json) => 
      _$HeadlineResponseFromJson(json);

  /// The list of headlines for the current page.
  final List<Headline> headlines;

  /// The total number of headlines available across all pages.
  final int total;

  /// The current page number (1-based indexing).
  final int page;

  /// The number of headlines per page.
  final int perPage;

  /// Optional status or information message.
  final String? message;
  
  /// Converts this [HeadlineResponse] instance to a JSON map.
  ///
  /// Returns a [Map] containing all properties in a JSON-compatible format.
  Map<String, dynamic> toJson() => _$HeadlineResponseToJson(this);

  /// Creates a copy of this HeadlineResponse with the given fields replaced 
  /// with new values.
  HeadlineResponse copyWith({
    List<Headline>? headlines,
    int? total,
    int? page,
    int? perPage,
    String? message,
  }) {
    return HeadlineResponse(
      headlines: headlines ?? this.headlines,
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        headlines,
        total,
        page,
        perPage,
        message,
      ];
}

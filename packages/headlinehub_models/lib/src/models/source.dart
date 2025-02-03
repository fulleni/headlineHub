import 'package:equatable/equatable.dart';
import 'package:headlinehub_models/src/models/country.dart';
import 'package:headlinehub_models/src/models/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

/// A model that represents a headline source.
@JsonSerializable(explicitToJson: true)
class Source extends Equatable {
  /// Creates a new [Source] instance.
  const Source({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.language,
    required this.country,
  });

  /// Creates a [Source] instance from a JSON map.
  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  /// The unique identifier of the source.
  final String id;

  /// The name of the source.
  final String name;

  /// A description of the source.
  final String description;

  /// The URL of the source.
  final String url;

  /// The language of the source.
  final Language language;

  /// The country of the source.
  final Country country;

  /// Converts this [Source] instance to a JSON map.
  Map<String, dynamic> toJson() => _$SourceToJson(this);

  /// Creates a copy of this [Source] but with the given fields 
  /// replaced with the new values.
  Source copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    Language? language,
    Country? country,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      language: language ?? this.language,
      country: country ?? this.country,
      
      );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        url,
        language,
        country,
      ];
}

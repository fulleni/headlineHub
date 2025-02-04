import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

/// A model that represents a language.
@JsonSerializable(explicitToJson: true)
class Language extends Equatable {
  /// Creates a new [Language] instance.
  const Language({
    required this.code,
    required this.name,
  });

  /// Creates a [Language] instance from a JSON map.
  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  /// The unique code of the language.
  final String code;

  /// The name of the language.
  final String name;

  /// Converts this [Language] instance to a JSON map.
  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  /// Creates a copy of this [Language] but with the given fields 
  /// replaced with the new values.
  Language copyWith({
    String? code,
    String? name,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        code,
        name,
      ];
}

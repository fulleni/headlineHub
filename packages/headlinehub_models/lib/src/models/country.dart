import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

/// A model that represents a country.
@JsonSerializable(explicitToJson: true)
class Country extends Equatable {
  /// Creates a new [Country] instance.
  const Country({
    required this.code,
    required this.name,
    required this.flagUrl,
  });

  /// Creates a [Country] instance from a JSON map.
  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  /// The unique code of the country.
  final String code;

  /// The name of the country.
  final String name;

  /// The name of the country.
  final String flagUrl;

  /// Creates a copy of this [Country] but with the given fields  
  /// replaced with the new values.
  Country copyWith({
    String? code,
    String? name,
    String? flagUrl,
  }) {
    return Country(
      code: code ?? this.code,
      name: name ?? this.name,
      flagUrl: flagUrl ?? this.flagUrl,
    );
  }
  /// Converts this [Country] instance to a JSON map.
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  List<Object?> get props => [
        code,
        name,
        flagUrl,
      ];
}

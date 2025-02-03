import 'package:equatable/equatable.dart';
import 'package:headlinehub_models/src/models/country.dart';
import 'package:headlinehub_models/src/models/source.dart';
import 'package:headlinehub_models/src/models/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'headline.g.dart';

/// Available categories for news headlines
enum HeadlineCategory {
  /// General news category for miscellaneous news
  general,

  /// Business and financial news
  business,

  /// Technology and innovation news
  technology,

  /// Entertainment and media news
  entertainment,

  /// Health and medical news
  health,

  /// Scientific discoveries and research news
  science,

  /// Sports and athletics news
  sports,

  /// Political and government news
  politics
}

/// A model representing a news headline article.
///
/// Contains all the essential information about a news article including
/// its content, source, and metadata.
@JsonSerializable(explicitToJson: true)
class Headline extends Equatable {
  /// Creates a new [Headline] instance.
  const Headline({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedBy,
    required this.imageUrl,
    required this.publishedAt,
    required this.happenedIn,
    required this.language,
    this.category = HeadlineCategory.general,
    this.isActive = true,
  });

  /// Creates a new [Headline] instance from a JSON object.
  factory Headline.fromJson(Map<String, dynamic> json) =>
      _$HeadlineFromJson(json);

  /// Unique identifier for the headline.
  final String id;

  /// The main title of the news article.
  final String title;

  /// The full content/body of the news article.
  final String content;

  /// URL to the headline's featured image.
  final String imageUrl;

  /// The category/topic of the news article
  /// Defaults to HeadlineCategory.general if not specified.
  @JsonKey(
    fromJson: _categoryFromJson,
    toJson: _categoryToJson,
  )
  final HeadlineCategory category;

  /// The country where the headline has happened.
  final Country happenedIn;

  /// The language in which the headline is written.
  final Language language;

  /// Indicates if the headline is currently active/visible.
  /// Defaults to true.
  final bool isActive;

  /// The source or publisher of the news article.
  final Source publishedBy;

  /// The date and time when the article was published.
  final DateTime publishedAt;

  /// Converts this Headline instance to a JSON object.
  Map<String, dynamic> toJson() => _$HeadlineToJson(this);

  /// Creates a copy of this Headline with the given fields replaced
  /// with new values.
  Headline copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    HeadlineCategory? category,
    Country? happenedIn,
    Source? publishedBy,
    DateTime? publishedAt,
    Language? language,
    bool? isActive,
  }) {
    return Headline(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      publishedBy: publishedBy ?? this.publishedBy,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      happenedIn: happenedIn ?? this.happenedIn,
      language: language ?? this.language,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Helper method to convert string to HeadlineCategory
  ///
  /// If the provided value doesn't match any category, returns [HeadlineCategory.general].
  ///
  /// @param value The string value to convert
  /// @return The corresponding HeadlineCategory
  static HeadlineCategory _categoryFromJson(String value) {
    return HeadlineCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => HeadlineCategory.general,
    );
  }

  /// Helper method to convert HeadlineCategory to string
  ///
  /// @param category The HeadlineCategory to convert
  /// @return The string name of the category
  static String _categoryToJson(HeadlineCategory category) => category.name;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        imageUrl,
        category,
        happenedIn,
        language,
        isActive,
        publishedAt,
        publishedBy,
      ];
}

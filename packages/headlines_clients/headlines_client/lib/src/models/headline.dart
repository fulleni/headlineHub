import 'package:equatable/equatable.dart';
import 'package:headlines_client/src/models/country.dart';
import 'package:headlines_client/src/models/language.dart';
import 'package:headlines_client/src/models/source.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'headline.g.dart';

/// Status values for headlines
enum HeadlineStatus {
  /// Published and visible to users
  published,

  /// Draft state, not visible to users
  draft,

  /// Archived headlines
  archived,

  /// Headlines pending review
  pending
}

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
  Headline({
    required this.title,
    required this.content,
    required this.publishedBy,
    required this.imageUrl,
    required this.publishedAt,
    required this.happenedIn,
    required this.language,
    this.category = HeadlineCategory.general,
    this.status = HeadlineStatus.draft,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Creates a new [Headline] instance from a JSON object.
  factory Headline.fromJson(Map<String, dynamic> json) =>
      _$HeadlineFromJson(json);

  /// Unique identifier for the headline.
  @JsonKey(includeIfNull: false)
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

  /// The status of the headline
  /// Defaults to HeadlineStatus.draft if not specified.
  @JsonKey(
    fromJson: _statusFromJson,
    toJson: _statusToJson,
  )
  final HeadlineStatus status;

  /// The country where the headline has happened.
  final Country happenedIn;

  /// The language in which the headline is written.
  final Language language;

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
    HeadlineStatus? status,
    Country? happenedIn,
    Source? publishedBy,
    DateTime? publishedAt,
    Language? language,
    bool? isActive,
  }) {
    return Headline(
      id: id ?? this.id, // Keep existing ID if not specified
      title: title ?? this.title,
      content: content ?? this.content,
      publishedBy: publishedBy ?? this.publishedBy,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      happenedIn: happenedIn ?? this.happenedIn,
      language: language ?? this.language,
      category: category ?? this.category,
      status: status ?? this.status,
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

  /// Helper method to convert string to HeadlineStatus
  static HeadlineStatus _statusFromJson(String value) {
    return HeadlineStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => HeadlineStatus.draft,
    );
  }

  /// Helper method to convert HeadlineStatus to string
  static String _statusToJson(HeadlineStatus status) => status.name;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        imageUrl,
        category,
        happenedIn,
        language,
        status,
        publishedAt,
        publishedBy,
      ];
}

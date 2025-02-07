// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Headline _$HeadlineFromJson(Map<String, dynamic> json) => Headline(
      title: json['title'] as String,
      content: json['content'] as String,
      publishedBy: Source.fromJson(json['publishedBy'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      happenedIn: Country.fromJson(json['happenedIn'] as Map<String, dynamic>),
      language: Language.fromJson(json['language'] as Map<String, dynamic>),
      category: json['category'] == null
          ? HeadlineCategory.general
          : Headline._categoryFromJson(json['category'] as String),
      status: json['status'] == null
          ? HeadlineStatus.draft
          : Headline._statusFromJson(json['status'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$HeadlineToJson(Headline instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'category': Headline._categoryToJson(instance.category),
      'status': Headline._statusToJson(instance.status),
      'happenedIn': instance.happenedIn.toJson(),
      'language': instance.language.toJson(),
      'publishedBy': instance.publishedBy.toJson(),
      'publishedAt': instance.publishedAt.toIso8601String(),
    };

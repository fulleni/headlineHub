// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Headline _$HeadlineFromJson(Map<String, dynamic> json) => Headline(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      source: json['source'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      category: json['category'] == null
          ? HeadlineCategory.general
          : Headline._categoryFromJson(json['category'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$HeadlineToJson(Headline instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'source': instance.source,
      'imageUrl': instance.imageUrl,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'category': Headline._categoryToJson(instance.category),
      'isActive': instance.isActive,
    };

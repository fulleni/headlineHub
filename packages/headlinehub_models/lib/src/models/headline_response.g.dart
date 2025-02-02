// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headline_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeadlineResponse _$HeadlineResponseFromJson(Map<String, dynamic> json) =>
    HeadlineResponse(
      headlines: (json['headlines'] as List<dynamic>)
          .map((e) => Headline.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$HeadlineResponseToJson(HeadlineResponse instance) =>
    <String, dynamic>{
      'headlines': instance.headlines.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'perPage': instance.perPage,
      'message': instance.message,
    };

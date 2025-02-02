// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headline_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMetadata _$PaginationMetadataFromJson(Map<String, dynamic> json) =>
    PaginationMetadata(
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );

Map<String, dynamic> _$PaginationMetadataToJson(PaginationMetadata instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalItems': instance.totalItems,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };

HeadlineResponse _$HeadlineResponseFromJson(Map<String, dynamic> json) =>
    HeadlineResponse(
      headlines: (json['headlines'] as List<dynamic>)
          .map((e) => Headline.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginationMetadata: PaginationMetadata.fromJson(
          json['paginationMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeadlineResponseToJson(HeadlineResponse instance) =>
    <String, dynamic>{
      'headlines': instance.headlines.map((e) => e.toJson()).toList(),
      'paginationMetadata': instance.paginationMetadata.toJson(),
    };

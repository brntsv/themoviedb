// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_serial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularSerialResponse _$PopularSerialResponseFromJson(
        Map<String, dynamic> json) =>
    PopularSerialResponse(
      page: json['page'] as int,
      serials: (json['results'] as List<dynamic>)
          .map((e) => Serial.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['total_results'] as int,
      totalPages: json['total_pages'] as int,
    );

Map<String, dynamic> _$PopularSerialResponseToJson(
        PopularSerialResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.serials.map((e) => e.toJson()).toList(),
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
    };

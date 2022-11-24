import 'package:flutter_themoviedb/domain/entity/serials.dart';
import 'package:json_annotation/json_annotation.dart';

part 'popular_serial_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularSerialResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<Serial> serials;
  final int totalResults;
  final int totalPages;

  PopularSerialResponse({
    required this.page,
    required this.serials,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularSerialResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularSerialResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularSerialResponseToJson(this);
}

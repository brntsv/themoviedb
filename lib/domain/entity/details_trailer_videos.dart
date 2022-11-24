import 'package:json_annotation/json_annotation.dart';

part 'details_trailer_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DetailsTrailerVideo {
  final List<TrailerResult> results;
  DetailsTrailerVideo({required this.results});

  factory DetailsTrailerVideo.fromJson(Map<String, dynamic> json) =>
      _$DetailsTrailerVideoFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsTrailerVideoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrailerResult {
  @JsonKey(name: 'iso_639_1')
  final String iso639;
  @JsonKey(name: 'iso_3166_1')
  final String iso3166;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;
  TrailerResult({
    required this.iso639,
    required this.iso3166,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory TrailerResult.fromJson(Map<String, dynamic> json) =>
      _$TrailerResultFromJson(json);

  Map<String, dynamic> toJson() => _$TrailerResultToJson(this);
}

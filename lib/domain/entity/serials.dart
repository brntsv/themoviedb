import 'package:flutter_themoviedb/domain/entity/date_parser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'serials.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Serial {
  final String? posterPath;
  final double popularity;
  final int id;
  final String? backdropPath;
  final double voteAverage;
  final String overview;
  @JsonKey(fromJson: parseDateFromString)
  final DateTime? firstAirDate;
  final List<String> originCountry;
  final List<int> genreIds;
  final String originalLanguage;
  final int voteCount;
  final String name;
  final String originalName;

  Serial({
    required this.posterPath,
    required this.popularity,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
    required this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  factory Serial.fromJson(Map<String, dynamic> json) => _$SerialFromJson(json);

  Map<String, dynamic> toJson() => _$SerialToJson(this);
}

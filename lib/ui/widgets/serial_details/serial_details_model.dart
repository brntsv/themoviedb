import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/services/serial_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client_exception.dart';
import 'package:flutter_themoviedb/domain/entity/serial_details.dart';
import 'package:flutter_themoviedb/domain/services/auth_service.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';

class SerialDetailsPosterData {
  final String? posterPath;
  final String? backdropPath;
  final bool isFavorite;

  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  SerialDetailsPosterData({
    this.posterPath,
    this.backdropPath,
    this.isFavorite = false,
  });

  SerialDetailsPosterData copyWith({
    String? posterPath,
    String? backdropPath,
    bool? isFavorite,
  }) {
    return SerialDetailsPosterData(
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SerialDetailsSerialNameData {
  final String name;
  final String year;

  SerialDetailsSerialNameData({
    required this.name,
    required this.year,
  });
}

class SerialDetailsSerialRatingAndTrailerData {
  final double voteAverage;
  final String? trailerKey;
  SerialDetailsSerialRatingAndTrailerData({
    required this.voteAverage,
    this.trailerKey,
  });
}

class SerialDetailsEpisodeRunTimeAndGenresData {
  final String runTime;
  final List<String> genres;
  SerialDetailsEpisodeRunTimeAndGenresData({
    required this.runTime,
    required this.genres,
  });
}

class SerialDetailsOverviewData {
  final String? overview;
  final String? tagline;
  final String overviewTitle;
  SerialDetailsOverviewData({
    this.overview,
    this.tagline,
    required this.overviewTitle,
  });
}

class SerialDetailsCreatorsData {
  final String name;
  SerialDetailsCreatorsData({
    required this.name,
  });
}

class SerialDetailsActorListData {
  final String name;
  final String character;
  final String? profilePath;
  SerialDetailsActorListData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class SerialDetailsData {
  String title = '';
  bool isLoading = true;

  SerialDetailsPosterData posterData = SerialDetailsPosterData();

  SerialDetailsSerialNameData nameData = SerialDetailsSerialNameData(
    name: '',
    year: '',
  );

  SerialDetailsSerialRatingAndTrailerData ratingData =
      SerialDetailsSerialRatingAndTrailerData(
    voteAverage: 0,
  );
  SerialDetailsEpisodeRunTimeAndGenresData dataGenres =
      SerialDetailsEpisodeRunTimeAndGenresData(
    runTime: '',
    genres: [],
  );

  SerialDetailsOverviewData dataOverview = SerialDetailsOverviewData(
    overviewTitle: '',
  );

  List<List<SerialDetailsCreatorsData>> dataCreators =
      <List<SerialDetailsCreatorsData>>[];

  List<SerialDetailsActorListData> dataActors = <SerialDetailsActorListData>[];
}

class SerialDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _serialService = SerialService();

  final int serialId;
  final data = SerialDetailsData();
  String _locale = '';
  late DateFormat dateFormat;

  SerialDetailsModel(this.serialId);

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    dateFormat = DateFormat.yMMMMd(locale);
    updateData(null, false);
    await loadDetails(context);
  }

  /// Большой метод по обновлению данных, далее есть пояснения
  void updateData(SerialDetails? details, bool isFavorite) {
    data.title = details?.name ?? 'load...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }

    /// Обновление данных постера
    data.posterData = SerialDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      isFavorite: isFavorite,
    );

    /// Обновление данных названия и года выхода
    var year = details.firstAirDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = SerialDetailsSerialNameData(name: details.name, year: year);

    /// Обновление данных рейтинга и трейлера
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.ratingData = SerialDetailsSerialRatingAndTrailerData(
      voteAverage: details.voteAverage * 10,
      trailerKey: trailerKey,
    );

    /// Обновление данных среднего времени эпизода
    String runTime;
    final episodeRunTime = details.episodeRunTime;
    if (episodeRunTime.isNotEmpty) {
      int sum = episodeRunTime.fold<int>(
          0, (previousValue, element) => previousValue + element);
      final averageValue = sum ~/ episodeRunTime.length;
      final duration = Duration(minutes: averageValue);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      if (hours == 0) {
        runTime = '~ $minutes m';
      } else if (minutes == 0) {
        runTime = '~ $hours h';
      } else {
        runTime = '~ $hours h $minutes m';
      }
    } else {
      runTime = '';
    }
    // Обновление данных жанров
    var texts = <String>[];
    final genres = details.genres;
    if (genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    data.dataGenres = SerialDetailsEpisodeRunTimeAndGenresData(
        runTime: runTime, genres: texts);

    /// Обновление описания и слогана
    final overview = details.overview;
    final tagline = details.tagline;
    String overviewTitle;
    if (overview.isNotEmpty) {
      overviewTitle = 'Overview';
    } else {
      overviewTitle = 'no description here';
    }
    data.dataOverview = SerialDetailsOverviewData(
      overviewTitle: overviewTitle,
      overview: overview,
      tagline: tagline,
    );

    /// Обновление списка создателей
    data.dataCreators = makeCreatorsData(details);

    /// Обновление списка актёров
    data.dataActors = details.credits.cast
        .map((e) => SerialDetailsActorListData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();

    ///
    notifyListeners();
  }

  List<List<SerialDetailsCreatorsData>> makeCreatorsData(
      SerialDetails details) {
    var createdBy = details.createdBy
        .map((e) => SerialDetailsCreatorsData(name: e.name))
        .toList();

    createdBy = createdBy.length > 4 ? createdBy.sublist(0, 4) : createdBy;
    var createdByChunks = <List<SerialDetailsCreatorsData>>[];
    for (var i = 0; i < createdBy.length; i += 2) {
      createdByChunks.add(createdBy.sublist(
          i, i + 2 > createdBy.length ? createdBy.length : i + 2));
    }
    return createdByChunks;
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await _serialService.loadDetails(
        serialId: serialId,
        locale: _locale,
      );
      updateData(details.details, details.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await _serialService.updateFavorite(
        serialId: serialId,
        isFavorite: data.posterData.isFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}

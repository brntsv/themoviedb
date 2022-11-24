import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/domain/entity/serial_details.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/ui/theme/app_colors.dart';
import 'package:flutter_themoviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';

class SerialDetailsMainInfoWidget extends StatelessWidget {
  const SerialDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopPosterWidget(),
        _SerialNameWidget(),
        _RatingAndTrailer(),
        _EpisodeRunTimeAndGenresWidget(),
        _OverviewWidget(),
        _CreatorsWidget(),
      ],
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    final backdropPath = model?.serialDetails?.backdropPath;
    final posterPath = model?.serialDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Container(
            height: 225,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment(3, 0),
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: posterPath != null
                  ? Image.network(ApiClient.imageUrl(posterPath))
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Stack(
              children: [
                const Positioned(
                    top: 12,
                    left: 12,
                    child: Icon(Icons.favorite,
                        color: Color.fromARGB(178, 3, 50, 88))),
                IconButton(
                  icon: Icon(
                    model?.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: Colors.white,
                    shadows: const [
                      BoxShadow(color: AppColors.mainDarkBlue, blurRadius: 25)
                    ],
                  ),
                  onPressed: () => model?.toggleFavorite(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SerialNameWidget extends StatelessWidget {
  const _SerialNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    final year = model?.serialDetails?.firstAirDate?.year.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: model?.serialDetails?.name ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 23,
              )),
          TextSpan(
              text: '  ($year)',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              )),
        ]),
        maxLines: 3,
      ),
    );
  }
}

class _RatingAndTrailer extends StatelessWidget {
  const _RatingAndTrailer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    final voteAverage = model?.serialDetails?.voteAverage ?? 0;

    final videos = model?.serialDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: RadialPercentWidget(
                      percent: voteAverage / 10,
                      fillColor: const Color.fromRGBO(24, 23, 27, 1.0),
                      lineColor: const Color.fromARGB(255, 46, 214, 133),
                      freeColor: const Color.fromARGB(255, 38, 77, 58),
                      lineWidth: 3,
                      child: Text((voteAverage * 10).toStringAsFixed(0),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 21))),
                ),
                const Text('  Rating', style: TextStyle(color: Colors.white)),
              ],
            )),
        Container(width: 1, height: 20, color: Colors.grey),
        trailerKey != null
            ? TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.trailer,
                    arguments: trailerKey),
                child: Row(
                  children: const [
                    Icon(Icons.play_arrow, color: Colors.white),
                    Text('  Trailer', style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _EpisodeRunTimeAndGenresWidget extends StatelessWidget {
  final textStyle = const TextStyle(
      fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white);

  const _EpisodeRunTimeAndGenresWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);

    String runTime;
    final episodeRunTime = model?.serialDetails?.episodeRunTime;
    if (episodeRunTime != null && episodeRunTime.isNotEmpty) {
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

    var texts = <String>[];
    final genres = model?.serialDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                child: Text(runTime, style: textStyle),
              ),
              const SizedBox(height: 3.5),
              Text(
                texts.join(' '),
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    final overview = model?.serialDetails?.overview ?? '';
    final tagline = model?.serialDetails?.tagline ?? '';

    String overviewTitle;
    if (overview.isNotEmpty) {
      overviewTitle = 'Overview';
    } else {
      overviewTitle = 'no description here';
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tagline,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            overviewTitle,
            style: const TextStyle(
              fontSize: 21,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            overview,
            style: const TextStyle(
              fontSize: 17.1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorsWidget extends StatelessWidget {
  const _CreatorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialDetailsModel>(context);
    var createdBy = model?.serialDetails?.createdBy;

    if (createdBy == null || createdBy.isEmpty) return const SizedBox.shrink();

    createdBy = createdBy.length > 4 ? createdBy.sublist(0, 4) : createdBy;
    var createdByChunks = <List<CreatedBy>>[];
    for (var i = 0; i < createdBy.length; i += 2) {
      createdByChunks.add(createdBy.sublist(
          i, i + 2 > createdBy.length ? createdBy.length : i + 2));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        children: createdByChunks
            .map((chunk) => _CreatorsWidgetRow(creatorsRow: chunk))
            .toList(),
        // _CreatorsWidgetColumn(),
        // const SizedBox(width: 60),
        // _CreatorsWidgetColumn(),
      ),
    );
  }
}

class _CreatorsWidgetRow extends StatelessWidget {
  final List<CreatedBy> creatorsRow;
  const _CreatorsWidgetRow({Key? key, required this.creatorsRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: creatorsRow
          .map((creator) => _CreatorWidgetItem(creator: creator))
          .toList(),
      // _PeopleWidgetItem(creator: ),
      // const SizedBox(height: 20),
      // _PeopleWidgetItem(creator: ),
    );
  }
}

class _CreatorWidgetItem extends StatelessWidget {
  final CreatedBy creator;
  const _CreatorWidgetItem({Key? key, required this.creator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
    const jobStyle = TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(creator.name, style: nameStyle),
            const Text('Creator', style: jobStyle),
          ],
        ),
      ),
    );
  }
}

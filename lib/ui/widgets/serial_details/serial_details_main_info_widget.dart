import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/image_downloader.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/ui/theme/app_colors.dart';
import 'package:flutter_themoviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:provider/provider.dart';

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
    final posterData =
        context.select((SerialDetailsModel model) => model.data.posterData);
    final model = context.read<SerialDetailsModel>();
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
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
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(ImageDownloader.imageUrl(posterPath)),
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
                    posterData.favoriteIcon,
                    color: Colors.white,
                    shadows: const [
                      BoxShadow(color: AppColors.mainDarkBlue, blurRadius: 25)
                    ],
                  ),
                  onPressed: () => model.toggleFavorite(context),
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
    final nameData =
        context.select((SerialDetailsModel model) => model.data.nameData);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: nameData.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 23,
              )),
          TextSpan(
              text: nameData.year,
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
    final ratingData =
        context.select((SerialDetailsModel model) => model.data.ratingData);

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
                      percent: ratingData.voteAverage / 10,
                      fillColor: const Color.fromRGBO(24, 23, 27, 1.0),
                      lineColor: const Color.fromARGB(255, 46, 214, 133),
                      freeColor: const Color.fromARGB(255, 38, 77, 58),
                      lineWidth: 3,
                      child: Text((ratingData.voteAverage).toStringAsFixed(0),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 21))),
                ),
                const Text('  Rating', style: TextStyle(color: Colors.white)),
              ],
            )),
        Container(width: 1, height: 20, color: Colors.grey),
        if (ratingData.trailerKey != null)
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
                MainNavigationRouteNames.trailer,
                arguments: ratingData.trailerKey),
            child: Row(
              children: const [
                Icon(Icons.play_arrow, color: Colors.white),
                Text('  Trailer', style: TextStyle(color: Colors.white)),
              ],
            ),
          )
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
    final dataGenres =
        context.select((SerialDetailsModel model) => model.data.dataGenres);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                child: Text(dataGenres.runTime, style: textStyle),
              ),
              const SizedBox(height: 3.5),
              Text(
                dataGenres.genres.join(),
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
    final dataOverview =
        context.select((SerialDetailsModel model) => model.data.dataOverview);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataOverview.tagline ?? '',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dataOverview.overviewTitle,
            style: const TextStyle(
              fontSize: 21,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            dataOverview.overview ?? '',
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
    var creatorsData =
        context.select((SerialDetailsModel model) => model.data.dataCreators);

    if (creatorsData.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        children: creatorsData
            .map((chunk) => _CreatorsWidgetRow(creatorsRow: chunk))
            .toList(),
      ),
    );
  }
}

class _CreatorsWidgetRow extends StatelessWidget {
  final List<SerialDetailsCreatorsData> creatorsRow;
  const _CreatorsWidgetRow({Key? key, required this.creatorsRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: creatorsRow
          .map((creator) => _CreatorWidgetItem(creator: creator))
          .toList(),
    );
  }
}

class _CreatorWidgetItem extends StatelessWidget {
  final SerialDetailsCreatorsData creator;
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

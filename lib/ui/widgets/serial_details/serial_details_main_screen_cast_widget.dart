import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/image_downloader.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:provider/provider.dart';

class ActorInfo {
  final int id;
  final String avatar;
  final String nameActor;
  final String nameRole;
  final String episodes;

  ActorInfo(
      {required this.id,
      required this.avatar,
      required this.nameActor,
      required this.nameRole,
      required this.episodes});
}

class SerialDetailsMainScreenCastWidget extends StatelessWidget {
  const SerialDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Актёрский состав сериала',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 270,
            child: Scrollbar(
              child: _ActorListWidget(),
            ),
          ),
          TextButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Text(
                    'Полный актёрский и съемочный состав',
                    style: TextStyle(fontSize: 17.6, color: Colors.black),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataActors =
        context.select((SerialDetailsModel model) => model.data.dataActors);

    if (dataActors.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      itemCount: dataActors.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorItemWidget(actorIndex: index);
      },
    );
  }
}

class _ActorItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorItemWidget({Key? key, required this.actorIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<SerialDetailsModel>();
    final actor = model.data.dataActors[actorIndex];
    final profilePath = actor.profilePath;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8, //размытие тени
              offset: const Offset(0, 2), //смещение тени из под контейнера
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Column(
            children: [
              if (profilePath != null)
                Image.network(
                  ImageDownloader.imageUrl(profilePath),
                  fit: BoxFit.fitWidth,
                  height: 160,
                  width: 165,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Text(
                        actor.character,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

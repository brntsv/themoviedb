import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/image_downloader.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart';
import 'package:flutter_themoviedb/ui/widgets/movie_list/serial_list_model.dart';

class SerialListWidget extends StatelessWidget {
  const SerialListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SerialListModel>(context);
    if (model == null) return const SizedBox.shrink();
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: model.serials.length,
          itemExtent: 160,
          itemBuilder: (BuildContext context, int index) {
            model.showedSerialAtIndex(index);
            final serial = model.serials[index];
            final posterPath = serial.posterPath;
            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8, //размытие тени
                          offset: const Offset(
                              0, 2), //смещение тени из под контейнера
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        posterPath != null
                            ? Image.network(
                                ImageDownloader.imageUrl(posterPath),
                                width: 95)
                            : const SizedBox.shrink(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  serial.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  model.stringFromDate(serial.firstAirDate),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14.4, color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  serial.overview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => model.onSerialTap(context, index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: model.searchSerial,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Поиск',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
            ),
          ),
        ),
      ],
    );
  }
}




























//старый код

// class Serial {
//   final int id;
//   final String imageName;
//   final String title;
//   final String time;
//   final String description;

//   Serial(
//       {required this.id,
//       required this.description,
//       required this.imageName,
//       required this.title,
//       required this.time});
// }

// class SerialListWidget extends StatefulWidget {
//   const SerialListWidget({Key? key}) : super(key: key);

//   @override
//   State<SerialListWidget> createState() => _SerialListWidgetState();
// }

// class _SerialListWidgetState extends State<SerialListWidget> {
//   final _serials = [
//     Serial(
//         imageName: AppImages.theBoys,
//         title: 'Пацаны',
//         time: '25 июля 2019',
//         description:
//             'Действие сериала разворачивается в 2000-е в мире, где существуют супергерои. Именно они являются настоящими звёздами, которых все знают и обожают. Но за идеальным фасадом скрывается гораздо более мрачный мир наркотиков и секса, а большинство героев в жизни не самые приятные люди. Для контроля за супергероями ЦРУ создаёт специальный отряд, неофициально известный как «Пацаны», суровые члены которого всегда готовы поставить зазнавшегося героя на место самым жестоким способом.',
//         id: 1),
//     Serial(
//         imageName: AppImages.brassic,
//         title: 'Голяк',
//         time: '22 августа 2019',
//         description:
//             'Мелкий воришка Винни и его друзья живут в английской глубинке и ежедневно промышляют нелегальными делами, приносящими небольшой доход. Все меняется, когда компания переходит дорогу местному криминальному авторитету.',
//         id: 2),
//     Serial(
//         imageName: AppImages.siliconValley,
//         title: 'Кремниевая долина',
//         time: '6 апреля 2014',
//         description:
//             'История о группе гиков, готовящих к запуску собственные стартапы в высокотехнологичном центре Сан-Франциско.',
//         id: 3),
//     Serial(
//         imageName: AppImages.office,
//         title: 'Офис',
//         time: '24 марта 2005',
//         description:
//             'Сериал о трудовых буднях небольшого регионального офиса крупной компании, обитатели которого целыми днями должны терпеть закидоны своего непутёвого босса.',
//         id: 4),
//     Serial(
//         imageName: AppImages.strangerThings,
//         title: 'Очень странные дела',
//         time: '15 июля 2016',
//         description:
//             '1980-е годы, тихий провинциальный американский городок. Благоприятное течение местной жизни нарушает загадочное исчезновение подростка по имени Уилл. Выяснить обстоятельства дела полны решимости родные мальчика и местный шериф, также события затрагивают лучшего друга Уилла — Майка. Он начинает собственное расследование. Майк уверен, что близок к разгадке, и теперь ему предстоит оказаться в эпицентре ожесточённой битвы потусторонних сил.',
//         id: 5),
//   ];

//   var _filteredSerials = <Serial>[];

//   final _searchController = TextEditingController();

//   void _searchSerials() {
//     final query = _searchController.text;
//     if (query.isNotEmpty) {
//       _filteredSerials = _serials.where((Serial serial) {
//         return serial.title.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     } else {
//       _filteredSerials = _serials;
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     _filteredSerials = _serials;
//     super.initState();

//     _searchController.addListener(_searchSerials);
//   }

//   void _onSerialTap(int index) {
//     final id = _serials[index].id;
//     Navigator.of(context).pushNamed(
//       MainNavigationRouteNames.serialDetails,
//       arguments: id,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         ListView.builder(
//           padding: const EdgeInsets.only(top: 70), //отступ для поиска
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           //скрывает клавиатуру, когда начинаешь скроллить
//           itemCount: _filteredSerials.length,
//           itemExtent: 141,
//           itemBuilder: (BuildContext context, int index) {
//             final serial = _filteredSerials[index];
//             return Padding(
//               padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black.withOpacity(0.2)),
//                       borderRadius: const BorderRadius.all(Radius.circular(10)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8, //размытие тени
//                           offset: const Offset(
//                               0, 2), //смещение тени из под контейнера
//                         ),
//                       ],
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: Row(
//                       children: [
//                         Image(image: AssetImage(serial.imageName)),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   serial.title,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   serial.time,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       fontSize: 14.4, color: Colors.grey),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   serial.description,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: const BorderRadius.all(Radius.circular(10)),
//                       onTap: () => _onSerialTap(index),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               labelText: 'Поиск',
//               filled: true,
//               fillColor: Colors.white.withAlpha(235),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

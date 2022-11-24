import 'package:flutter_themoviedb/config/config.dart';

/// Класс, который предоставляет Url для постеров

class ImageDownloader {
  static String imageUrl(String path) => Config.imageUrl + path;
}

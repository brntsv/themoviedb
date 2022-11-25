import 'package:flutter_themoviedb/config/config.dart';
import 'package:flutter_themoviedb/domain/api_client/serial_api_client.dart';
import 'package:flutter_themoviedb/domain/entity/popular_serial_response.dart';

class SerialService {
  final _serialApiClient = SerialApiClient();

  Future<PopularSerialResponse> popularSerial(int page, String locale) async =>
      _serialApiClient.popularSerial(page, locale, Config.apiKey);

  Future<PopularSerialResponse> searchSerial(
          int page, String locale, String query) async =>
      _serialApiClient.searchSerial(page, locale, query, Config.apiKey);
}

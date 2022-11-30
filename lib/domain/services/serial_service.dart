import 'package:flutter_themoviedb/config/config.dart';
import 'package:flutter_themoviedb/domain/api_client/account_api_client.dart';
import 'package:flutter_themoviedb/domain/api_client/serial_api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/domain/entity/popular_serial_response.dart';
import 'package:flutter_themoviedb/domain/local_entity/serial_details_local.dart';

class SerialService {
  final _serialApiClient = SerialApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularSerialResponse> popularSerial(int page, String locale) async =>
      _serialApiClient.popularSerial(page, locale, Config.apiKey);

  Future<PopularSerialResponse> searchSerial(
          int page, String locale, String query) async =>
      _serialApiClient.searchSerial(page, locale, query, Config.apiKey);

  Future<SerialDetailsLocal> loadDetails({
    required int serialId,
    required String locale,
  }) async {
    final serialDetails =
        await _serialApiClient.serialDetails(serialId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    bool isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _serialApiClient.isFavourite(serialId, sessionId);
    }
    return SerialDetailsLocal(details: serialDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({
    required int serialId,
    required bool isFavorite,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: serialId,
      isFavorite: isFavorite,
    );
  }
}

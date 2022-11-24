import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/account_api_client.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client_exception.dart';
import 'package:flutter_themoviedb/domain/api_client/serial_api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/domain/entity/serial_details.dart';
import 'package:intl/intl.dart';

class SerialDetailsModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _serialApiClient = SerialApiClient();
  final _accountApiClient = AccountApiClient();

  final int serialId;
  SerialDetails? _serialDetails;
  bool _isFavorite = false;
  String _locale = '';
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

  SerialDetails? get serialDetails => _serialDetails;
  bool get isFavorite => _isFavorite;

  SerialDetailsModel(this.serialId);

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      _serialDetails = await _serialApiClient.serialDetails(serialId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite =
            await _serialApiClient.isFavourite(serialId, _locale, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      await _accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.tv,
        mediaId: serialId,
        isFavorite: _isFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClientException exception) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
        break;
      default:
        print(exception);
    }
  }
}

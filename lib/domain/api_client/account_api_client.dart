import 'package:flutter_themoviedb/config/config.dart';
import 'package:flutter_themoviedb/domain/api_client/network_client.dart';

/// Помогает взаимодействовать с аккаунтом

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

class AccountApiClient {
  final _networkClient = NetworkClient();

  /// Получение информации об аккаунте

  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = _networkClient.get('/account', parser, <String, dynamic>{
      'api_key': Config.apiKey,
      'session_id': sessionId,
    });
    return result;
  }

  /// Добавление в избраное

  Future<int> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    parser(dynamic json) {
      return 1;
    }

    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavorite.toString(),
    };

    final result = _networkClient.post(
      '/account/$accountId/favorite',
      parameters,
      parser,
      <String, dynamic>{
        'api_key': Config.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}

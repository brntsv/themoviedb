import 'package:flutter_themoviedb/config/config.dart';
import 'package:flutter_themoviedb/domain/api_client/network_client.dart';
import 'package:flutter_themoviedb/domain/entity/popular_movie_response.dart';
import 'package:flutter_themoviedb/domain/entity/popular_serial_response.dart';
import 'package:flutter_themoviedb/domain/entity/serial_details.dart';

/// Предоставляет все взаимодействия с сериалами

class SerialApiClient {
  final _networkClient = NetworkClient();

  Future<PopularSerialResponse> popularSerial(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularSerialResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get('/tv/popular', parser, <String, dynamic>{
      'api_key': Config.apiKey,
      'language': locale,
      'page': page.toString(),
    });
    return result;
  }

  Future<PopularSerialResponse> searchSerial(
      int page, String locale, String query) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularSerialResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get('/search/tv', parser, <String, dynamic>{
      'api_key': Config.apiKey,
      'language': locale,
      'page': page.toString(),
      'include_adult': true.toString(),
      'query': query,
    });
    return result;
  }

  Future<SerialDetails> serialDetails(int tvId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = SerialDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get('/tv/$tvId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': Config.apiKey,
      'language': locale,
    });
    return result;
  }

  Future<bool> isFavourite(
    int tvId,
    String locale,
    String sessionId,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient
        .get('/tv/$tvId/account_states', parser, <String, dynamic>{
      'api_key': Config.apiKey,
      'language': locale,
      'session_id': sessionId,
    });
    return result;
  }

  /// Это метод для фильмов, а всё, что выше для сериалов
  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result =
        _networkClient.get('/movie/popular', parser, <String, dynamic>{
      'api_key': Config.apiKey,
      'language': locale,
      'page': page.toString(),
    });
    return result;
  }
}



/*
1. нет сети
2. нет ответа, таймаут соединения

3. сервер недоступен
4. сервер не может обработать запрашиваемый запрос
5. сервер ответил не то, что мы ожидали

6. сервер ответил ожидаемой ошибкой
*/

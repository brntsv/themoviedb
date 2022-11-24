import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/serial_api_client.dart';
import 'package:flutter_themoviedb/domain/entity/popular_serial_response.dart';
import 'package:flutter_themoviedb/domain/entity/serials.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';
import 'package:intl/intl.dart';

class SerialListModel extends ChangeNotifier {
  final _apiClient = SerialApiClient();
  final _serials = <Serial>[];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingProgress = false;
  String? _searchQuery;
  String _locale = '';
  Timer? searchDebounce;

  List<Serial> get serials => List.unmodifiable(_serials);
  late DateFormat _dateFormat;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _serials.clear();
    await _loadNextPage();
  }

  Future<PopularSerialResponse> _loadSerials(
      int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularSerial(nextPage, _locale);
    } else {
      return await _apiClient.searchSerial(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingProgress || _currentPage >= _totalPage) return;
    _isLoadingProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final serialsResponse = await _loadSerials(nextPage, _locale);
      _serials.addAll(serialsResponse.serials);
      _currentPage = serialsResponse.page;
      _totalPage = serialsResponse.totalPages;
      _isLoadingProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingProgress = false;
    }
  }

  void onSerialTap(BuildContext context, int index) {
    final id = _serials[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.serialDetails,
      arguments: id,
    );
  }

  Future<void> searchSerial(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 250), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  void showedSerialAtIndex(int index) {
    if (index < _serials.length - 1) return;
    _loadNextPage();
  }
}

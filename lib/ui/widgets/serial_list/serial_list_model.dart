import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/entity/serials.dart';
import 'package:flutter_themoviedb/domain/services/serial_service.dart';
import 'package:flutter_themoviedb/library/paginator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';

class SerialListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String firstAirDate;
  final String overview;
  SerialListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.firstAirDate,
    required this.overview,
  });
}

class SerialListViewModel extends ChangeNotifier {
  final _serialService = SerialService();
  late final Paginator<Serial> _popularSerialPaginator;
  late final Paginator<Serial> _searchSerialPaginator;

  String _locale = '';
  Timer? searchDebounce;

  var _serials = <SerialListRowData>[];
  String? _searchQuery;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<SerialListRowData> get serials => List.unmodifiable(_serials);
  late DateFormat _dateFormat;

  SerialListViewModel() {
    _popularSerialPaginator = Paginator<Serial>((pageNumber) async {
      final result = await _serialService.popularSerial(pageNumber, _locale);
      return PaginatorLoadResult(
          data: result.serials,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchSerialPaginator = Paginator<Serial>((pageNumber) async {
      final result = await _serialService.searchSerial(
        pageNumber,
        _locale,
        _searchQuery ?? '',
      );
      return PaginatorLoadResult(
          data: result.serials,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularSerialPaginator.reset();
    await _searchSerialPaginator.reset();
    _serials.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchSerialPaginator.loadNextPage();
      _serials = _searchSerialPaginator.data.map(_makeRowData).toList();
    } else {
      await _popularSerialPaginator.loadNextPage();
      _serials = _popularSerialPaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  SerialListRowData _makeRowData(Serial serial) {
    final firstAir = serial.firstAirDate;
    final firstAirDate = firstAir != null ? _dateFormat.format(firstAir) : '';
    return SerialListRowData(
      id: serial.id,
      posterPath: serial.posterPath,
      title: serial.name,
      firstAirDate: firstAirDate,
      overview: serial.overview,
    );
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
      if (isSearchMode) {
        await _searchSerialPaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedSerialAtIndex(int index) {
    if (index < _serials.length - 1) return;
    _loadNextPage();
  }
}

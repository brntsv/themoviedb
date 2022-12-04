import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_themoviedb/domain/blocs/serial_list_bloc.dart';
import 'package:flutter_themoviedb/domain/entity/serials.dart';
import 'package:intl/intl.dart';

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

class SerialListCubitState {
  final List<SerialListRowData> serials;
  final String localeTag;

  const SerialListCubitState({
    required this.serials,
    required this.localeTag,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerialListCubitState &&
          runtimeType == other.runtimeType &&
          serials == other.serials &&
          localeTag == other.localeTag;

  @override
  int get hashCode => serials.hashCode ^ localeTag.hashCode;

  SerialListCubitState copyWith({
    List<SerialListRowData>? serials,
    String? localeTag,
  }) {
    return SerialListCubitState(
      serials: serials ?? this.serials,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class SerialListCubit extends Cubit<SerialListCubitState> {
  final SerialListBloc serialListBloc;
  late final StreamSubscription<SerialListState> serialListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  SerialListCubit({
    required this.serialListBloc,
  }) : super(
          const SerialListCubitState(
            serials: <SerialListRowData>[],
            localeTag: '',
          ),
        ) {
    Future.microtask(
      () {
        _onState(serialListBloc.state);
        serialListBlocSubscription = serialListBloc.stream.listen(_onState);
      },
    );
  }
  void _onState(SerialListState state) {
    final serials = state.serials.map(_makeRowData).toList();
    final newState = this.state.copyWith(serials: serials);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    serialListBloc.add(SerialListResetEvent());
    serialListBloc.add(SerialListLoadNextPageEvent(localeTag));
  }

  void showedSerialAtIndex(int index) {
    if (index < state.serials.length - 1) return;
    serialListBloc.add(SerialListLoadNextPageEvent(state.localeTag));
  }

  void searchSerial(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      serialListBloc.add(SerialListLoadSearchSerialEvent(text));
      serialListBloc.add(SerialListLoadNextPageEvent(state.localeTag));
    });
  }

  @override
  Future<void> close() {
    serialListBlocSubscription.cancel();
    return super.close();
  }

  SerialListRowData _makeRowData(Serial serial) {
    final firstAirDate = serial.firstAirDate;
    final firstAirDateTitle =
        firstAirDate != null ? _dateFormat.format(firstAirDate) : '';
    return SerialListRowData(
      id: serial.id,
      posterPath: serial.posterPath,
      title: serial.name,
      firstAirDate: firstAirDateTitle,
      overview: serial.overview,
    );
  }
}

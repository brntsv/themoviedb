import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_themoviedb/config/config.dart';
import 'package:flutter_themoviedb/domain/api_client/serial_api_client.dart';
import 'package:flutter_themoviedb/domain/entity/popular_serial_response.dart';
import 'package:flutter_themoviedb/domain/entity/serials.dart';

abstract class SerialListEvent {}

class SerialListLoadNextPageEvent extends SerialListEvent {
  final String locale;

  SerialListLoadNextPageEvent(this.locale);
}

class SerialListResetEvent extends SerialListEvent {}

class SerialListLoadSearchSerialEvent extends SerialListEvent {
  final String query;

  SerialListLoadSearchSerialEvent(this.query);
}

class SerialListContainer {
  final List<Serial> serials;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const SerialListContainer.initial()
      : serials = const <Serial>[],
        currentPage = 0,
        totalPage = 1;

  SerialListContainer({
    required this.serials,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerialListContainer &&
          runtimeType == other.runtimeType &&
          serials == other.serials &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      serials.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  SerialListContainer copyWith({
    List<Serial>? serials,
    int? currentPage,
    int? totalPage,
  }) {
    return SerialListContainer(
      serials: serials ?? this.serials,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class SerialListState {
  final SerialListContainer popularSerialContainer;
  final SerialListContainer searchSerialContainer;
  final String searchQuery;

  bool get isSearchMode => searchQuery.isNotEmpty;
  List<Serial> get serials => isSearchMode
      ? searchSerialContainer.serials
      : popularSerialContainer.serials;

  const SerialListState.initial()
      : popularSerialContainer = const SerialListContainer.initial(),
        searchSerialContainer = const SerialListContainer.initial(),
        searchQuery = '';

  SerialListState({
    required this.popularSerialContainer,
    required this.searchSerialContainer,
    required this.searchQuery,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerialListState &&
          runtimeType == other.runtimeType &&
          popularSerialContainer == other.popularSerialContainer &&
          searchSerialContainer == other.searchSerialContainer &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      popularSerialContainer.hashCode ^
      searchSerialContainer.hashCode ^
      searchQuery.hashCode;

  SerialListState copyWith({
    SerialListContainer? popularSerialContainer,
    SerialListContainer? searchSerialContainer,
    String? searchQuery,
  }) {
    return SerialListState(
      popularSerialContainer:
          popularSerialContainer ?? this.popularSerialContainer,
      searchSerialContainer:
          searchSerialContainer ?? this.searchSerialContainer,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SerialListBloc extends Bloc<SerialListEvent, SerialListState> {
  final _serialApiClient = SerialApiClient();

  SerialListBloc(SerialListState initialState) : super(initialState) {
    on<SerialListEvent>(
      (event, emit) async {
        if (event is SerialListLoadNextPageEvent) {
          await onSerialListLoadNextPage(event, emit);
        } else if (event is SerialListResetEvent) {
          await onSerialListReset(event, emit);
        } else if (event is SerialListLoadSearchSerialEvent) {
          await onSerialListLoadSearchSerial(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  Future<void> onSerialListLoadNextPage(
    SerialListLoadNextPageEvent event,
    Emitter<SerialListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchSerialContainer,
        (nextPage) async {
          final result = await _serialApiClient.searchSerial(
            nextPage,
            event.locale,
            state.searchQuery,
            Config.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(searchSerialContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularSerialContainer,
        (nextPage) async {
          final result = await _serialApiClient.popularSerial(
            nextPage,
            event.locale,
            Config.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularSerialContainer: container);
        emit(newState);
      }
    }
  }

  Future<SerialListContainer?> _loadNextPage(
    SerialListContainer container,
    Future<PopularSerialResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = List<Serial>.from(container.serials)..addAll(result.serials);
    // movies.addAll(result.serials);
    final newContainer = container.copyWith(
      serials: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onSerialListReset(
    SerialListResetEvent event,
    Emitter<SerialListState> emit,
  ) async {
    emit(const SerialListState.initial());
  }

  Future<void> onSerialListLoadSearchSerial(
    SerialListLoadSearchSerialEvent event,
    Emitter<SerialListState> emit,
  ) async {
    if (state.searchQuery == event.query) return;
    final newState = state.copyWith(
      searchQuery: event.query,
      searchSerialContainer: const SerialListContainer.initial(),
    );
    emit(newState);
  }
}

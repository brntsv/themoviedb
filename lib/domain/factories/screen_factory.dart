import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_themoviedb/domain/blocs/auth_bloc.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_model.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:flutter_themoviedb/ui/widgets/loader_widget/loader_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/news_list/news_list_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_list/serial_list_model.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_list/serial_list_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/trailers/trailer_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusProgressState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (context) =>
          LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuthWidget() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    _authBloc?.close();
    _authBloc = null;
    return const MainScreenWidget();
  }

  Widget makeSerialDetails(int serialId) {
    return ChangeNotifierProvider(
      create: (_) => SerialDetailsModel(serialId),
      child: const SerialDetailsWidget(),
    );
  }

  Widget makeTrailerWidget(String youTubeKey) {
    return TrailerWidget(youTubeKey: youTubeKey);
  }

  Widget makeNewsList() {
    return const NewsListWidget();
  }

  Widget makeSerialList() {
    return ChangeNotifierProvider(
      create: (_) => SerialListViewModel(),
      child: const SerialListWidget(),
    );
  }

  Widget makeMovieList() {
    return const MovieListWidget();
  }
}

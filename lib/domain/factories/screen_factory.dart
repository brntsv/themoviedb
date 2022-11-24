import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart'
    as old_provider;
import 'package:flutter_themoviedb/ui/widgets/auth/auth_model.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/loader_widget/loader_view_model.dart';
import 'package:flutter_themoviedb/ui/widgets/loader_widget/loader_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/main_screen/main_screen_model.dart';
import 'package:flutter_themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/trailers/trailer_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuthWidget() {
    return old_provider.NotifierProvider(
      create: () => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return old_provider.NotifierProvider(
      create: () => MainScreenModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget makeSerialDetails(int serialId) {
    return old_provider.NotifierProvider(
      create: () => SerialDetailsModel(serialId),
      child: const SerialDetailsWidget(),
    );
  }

  Widget makeTrailerWidget(String youTubeKey) {
    return TrailerWidget(youTubeKey: youTubeKey);
  }
}

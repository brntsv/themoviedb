import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_model.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/main_screen/main_screen_model.dart';
import 'package:flutter_themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_model.dart';
import 'package:flutter_themoviedb/ui/widgets/serial_details/serial_details_widget.dart';
import 'package:flutter_themoviedb/library/default_widgets/inherited/notifier_provider.dart';
import 'package:flutter_themoviedb/ui/widgets/trailers/trailer_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const serialDetails = '/serial_details_widget';
  //main screen убрал
  static const trailer = '/serial_details_widget/trailer';
  //main screen убрал
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
          create: () => AuthModel(),
          child: const AuthWidget(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
          create: () => MainScreenModel(),
          child: const MainScreenWidget(),
        )
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.serialDetails:
        final arguments = settings.arguments;
        final serialId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => SerialDetailsModel(serialId),
            child: const SerialDetailsWidget(),
          ),
        );
      case MainNavigationRouteNames.trailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => TrailerWidget(youTubeKey: youTubeKey),
        );
      default:
        const widget = Text('navigation error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

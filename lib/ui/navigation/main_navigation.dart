import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/factories/screen_factory.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const auth = '/auth';
  static const mainScreen = '/main_screen';
  static const serialDetails = '/main_screen/serial_details_widget';
  static const trailer = '/main_screen/serial_details_widget/trailer';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuthWidget(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainScreen(),
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.serialDetails:
        final arguments = settings.arguments;
        final serialId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeSerialDetails(serialId),
        );
      case MainNavigationRouteNames.trailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeTrailerWidget(youTubeKey),
        );
      default:
        const widget = Text('navigation error');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }

  static void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderWidget,
      (route) => false,
    );
  }
}

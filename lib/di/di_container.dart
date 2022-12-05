import 'package:flutter/cupertino.dart';
import 'package:flutter_themoviedb/main.dart';
import 'package:flutter_themoviedb/ui/widgets/app/my_app.dart';

AppFactory makeAppFactory() => const _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  const _AppFactoryDefault();

  @override
  Widget makeApp() => const MyApp();
}

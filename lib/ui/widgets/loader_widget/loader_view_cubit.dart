import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_themoviedb/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState { autorized, notAutorized, unknown }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscribtion;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    authBloc.add(AuthCheckStatusEvent());
    onState(authBloc.state);
    authBlocSubscribtion = authBloc.stream.listen(onState);
  }

  void onState(AuthState state) {
    if (state is AuthAutorizedState) {
      emit(LoaderViewCubitState.autorized);
    } else if (state is AuthNotAutorizedState) {
      emit(LoaderViewCubitState.notAutorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscribtion.cancel();
    return super.close();
  }
}

// class LoaderViewModel {
//   final BuildContext context;
//   final _authService = AuthService();

//   LoaderViewModel(this.context) {
//     asyncInit();
//   }

//   Future<void> asyncInit() async {
//     checkAuth();
//   }

//   Future<void> checkAuth() async {
//     final isAuth = await _authService.isAuth();
//     final nextScreen = isAuth
//         ? MainNavigationRouteNames.mainScreen
//         : MainNavigationRouteNames.auth;
//     Navigator.of(context).pushReplacementNamed(nextScreen);
//   }
// }

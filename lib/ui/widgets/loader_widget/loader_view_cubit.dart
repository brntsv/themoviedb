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
    Future.microtask(
      () {
        _onState(authBloc.state);
        authBlocSubscribtion = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckStatusEvent());
      },
    );
  }

  void _onState(AuthState state) {
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

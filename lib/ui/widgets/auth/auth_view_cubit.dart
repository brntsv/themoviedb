import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client_exception.dart';
import 'package:flutter_themoviedb/domain/blocs/auth_bloc.dart';

abstract class AuthViewCubitState {}

/// Состояние заполнения поля пользователем
class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// Состояние ошибки
class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

/// Состояние прогресса аутентификации
class AuthViewCubitAuthInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// Состояние авторизации
class AuthViewCubitAuthAutorizedState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthAutorizedState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscribtion;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc)
      : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscribtion = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthNotAutorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAutorizedState) {
      authBlocSubscribtion.cancel();
      emit(AuthViewCubitAuthAutorizedState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthInProgressState());
    } else if (state is AuthCheckStatusProgressState) {
      emit(AuthViewCubitAuthInProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Неизвестная ошибка, поторите попытку';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Сервер не доступен. Проверте подключение к интернету';
      case ApiClientExceptionType.auth:
        return 'Неправильный логин пароль!';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.other:
        return 'Произошла ошибка. Попробуйте еще раз';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscribtion.cancel();
    return super.close();
  }
}

// class AuthViewModel extends ChangeNotifier {
//   final _authService = AuthService();

//   final loginTextController = TextEditingController();
//   final passwordTextController = TextEditingController();

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   bool _isAuthProgress = false;
//   bool get canStartAuth => !_isAuthProgress;
//   bool get isAuthProgress => _isAuthProgress;

//   bool _isValid(String login, String password) =>
//       login.isNotEmpty && password.isNotEmpty;

//   Future<String?> _login(String login, String password) async {
//     try {
//       await _authService.login(login, password);
//     } on ApiClientException catch (e) {
//       switch (e.type) {
//         case ApiClientExceptionType.network:
//           return 'Сервер не доступен. Проверте подключение к интернету';
//         case ApiClientExceptionType.auth:
//           return 'Неправильный логин пароль!';
//         case ApiClientExceptionType.sessionExpired:
//         case ApiClientExceptionType.other:
//           return 'Произошла ошибка. Попробуйте еще раз';
//       }
//     } catch (e) {
//       return 'Неизвестная ошибка, поторите попытку';
//     }
//     return null;
//   }

//   void _updateState(String? errorMessage, bool isAuthProgress) {
//     if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
//       return;
//     }
//     _errorMessage = errorMessage;
//     _isAuthProgress = isAuthProgress;
//     notifyListeners();
//   }

//   Future<void> auth(BuildContext context) async {
//     final login = loginTextController.text;
//     final password = passwordTextController.text;
//     if (!_isValid(login, password)) {
//       _updateState('Заполните логин и пароль', false);
//       return;
//     }

//     _updateState(null, true);

//     _errorMessage = await _login(login, password);
//     if (_errorMessage == null) {
//       MainNavigation.resetNavigation(context);
//     } else {
//       _updateState(_errorMessage, false);
//     }
//   }
// }








































// class AuthProvider extends InheritedNotifier {
//   final AuthModel model;
//   const AuthProvider({Key? key, required this.child, required this.model})
//       : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   final Widget child;

//   static AuthProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }

//   static AuthProvider? read(BuildContext context) {
//     final widget =
//         context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider ? widget : null;
//   }
// }



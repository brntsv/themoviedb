import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_themoviedb/ui/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/ui/widgets/auth/auth_view_cubit.dart';
import 'package:provider/provider.dart';

class _AuthDataStorage {
  String login = '';
  String password = '';
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onAuthViewCubitStateChange,
      child: Provider(
        create: ((_) => _AuthDataStorage()),
        child: Scaffold(
          appBar: AppBar(title: const Center(child: Text('The Movie DB'))),
          body: ListView(
            children: const [
              _HeaderWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _onAuthViewCubitStateChange(
      BuildContext context, AuthViewCubitState state) {
    if (state is AuthViewCubitAuthAutorizedState) {
      MainNavigation.resetNavigation(context);
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 25),
          Text(
            'Войти в свою учётную запись',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
          ),
          SizedBox(height: 12),
          Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь, чтобы начать.',
              style: textStyle),
          SizedBox(height: 18),
          Text(
              'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
              style: textStyle),
          SizedBox(height: 32),
          _FormWidget(),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isCollapsed: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMassegeWidget(),
        const Text('Имя пользователя', style: textStyle),
        const SizedBox(height: 3),
        TextField(
          // controller: model.loginTextController,
          onChanged: (text) => authDataStorage.login = text,
          decoration: textFieldDecoration,
        ),
        const SizedBox(height: 16),
        const Text('Пароль', style: textStyle),
        const SizedBox(
          height: 3,
        ),
        TextField(
          // controller: model.passwordTextController,
          onChanged: (text) => authDataStorage.password = text,
          decoration: textFieldDecoration,
          obscureText: true,
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 30),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xFF01B4E4)),
              ),
              child: const Text('Сбросить пароль'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AuthViewCubit>();
    final authDataStorage = context.read<_AuthDataStorage>();
    const colorButton = Color(0xFF01B4E4);
    final canStartAuth = cubit.state is AuthViewCubitFormFillInProgressState ||
        cubit.state is AuthViewCubitErrorState;
    final onPressed = canStartAuth
        ? () => cubit.auth(
              login: authDataStorage.login,
              password: authDataStorage.password,
            )
        : null;
    final child = cubit.state is AuthViewCubitAuthInProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Войти');

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorButton),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      child: child,
    );
  }
}

class _ErrorMassegeWidget extends StatelessWidget {
  const _ErrorMassegeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewCubit c) {
      final state = c.state;
      return state is AuthViewCubitErrorState ? state.errorMessage : null;
    });

    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}



































































//это в 62 уроке начался рефакторинг, просто старый код

// class _FormWidget extends StatefulWidget {
//   const _FormWidget({Key? key}) : super(key: key);

//   @override
//   State<_FormWidget> createState() => __FormWidgetState();
// }

// class __FormWidgetState extends State<_FormWidget> {
//   final _loginTextController = TextEditingController(text: 'admin');
//   final _passwordTextController = TextEditingController(text: 'admin');
//   String? errorText = null;

//   void _auth() {
//     final login = _loginTextController.text;
//     final password = _passwordTextController.text;
//     if (login == 'admin' && password == 'admin') {
//       errorText = null;

//       //это краткая запись навигации благодаря тому, что у нас в main прописаны routes
//       Navigator.of(context).pushNamed('/main_screen');
//       //pushReplacementNamed этот метод не дает вернуться назад по кнопке <

//       // это один из способов прописать навигацию, но это считается моветоном
//       // final navigator = Navigator.of(context);
//       // navigator
//       //     .push(MaterialPageRoute(builder: (context) => MainScreenWidget()));

//       print('open app');
//     } else {
//       errorText = 'Неверный логин или пароль';
//       print('show error');
//     }
//     setState(() {});
//   }

//   void _resetPassword() {
//     print('reset password');
//   }

//   @override
//   Widget build(BuildContext context) {
//     const textStyle = TextStyle(
//       fontSize: 16,
//       color: Color(0xFF212529),
//     );
//     const colorButton = Color(0xFF01B4E4);
//     const textFieldDecoration = InputDecoration(
//       border: OutlineInputBorder(),
//       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       isCollapsed: true,
//     );
//     final errorText = this.errorText; //выводим ошибку
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (errorText != null)
//           Text(
//             errorText,
//             style: const TextStyle(color: Colors.red),
//           ),
//         const SizedBox(height: 8),
//         const Text('Имя пользователя', style: textStyle),
//         const SizedBox(height: 3),
//         TextField(
//           controller: _loginTextController,
//           decoration: textFieldDecoration,
//         ),
//         const SizedBox(height: 16),
//         const Text('Пароль', style: textStyle),
//         const SizedBox(
//           height: 3,
//         ),
//         TextField(
//           controller: _passwordTextController,
//           decoration: textFieldDecoration,
//           obscureText: true,
//         ),
//         const SizedBox(height: 25),
//         Row(
//           children: [
//             ElevatedButton(
//               onPressed: _auth,
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(colorButton),
//                 foregroundColor: MaterialStateProperty.all(Colors.white),
//                 textStyle: MaterialStateProperty.all(
//                   const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 padding: MaterialStateProperty.all(
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 ),
//               ),
//               child: const Text('Войти'),
//             ),
//             const SizedBox(width: 30),
//             TextButton(
//               onPressed: _resetPassword,
//               style: ButtonStyle(
//                 textStyle: MaterialStateProperty.all(
//                   const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 foregroundColor: MaterialStateProperty.all(colorButton),
//               ),
//               child: const Text('Сбросить пароль'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hackaton_fiap_mobile/form.dart';

const users = {
  'teste@gmail.com': '12345',
  'usuario@gmail.com': 'usuario',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const id = '/login';

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'HACKATON FIAP',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyFormPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Senha',
        loginButton: 'LOG IN',
        signupButton: 'Não tenho conta',
        forgotPasswordButton: 'Esqueci minha senha',
      ),
    );
  }
}
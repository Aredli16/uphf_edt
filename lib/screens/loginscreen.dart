import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt_v2/data/web/session.dart';
import 'package:uphf_edt_v2/screens/homescreen_online.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    Future<String?> _authUser(LoginData data) async {
      if (!await Session.instance
          .checkUsernameAndPassword(data.name, data.password)) {
        return 'Identifiant ou mot de passe incorrect';
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data.name);
      await prefs.setString('password', data.password);
      username = data.name;
      password = data.password;
      return null;
    }

    return FlutterLogin(
      onLogin: _authUser,
      onRecoverPassword: (p0) => null,
      logoTag: 'uphf_logo_tag',
      title: 'UPHF',
      logo: 'assets/2560px-UPHF_logo.svg.png',
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      messages: LoginMessages(
        userHint: "Nom d'utilisateur",
        passwordHint: "Mot de passe",
        loginButton: "Connexion".toUpperCase(),
        flushbarTitleError: "Erreur".toUpperCase(),
      ),
      onSubmitAnimationCompleted: () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => OnlineHomeScreen(
          username: username!,
          password: password!,
        ),
      )),
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    return null;
  }

  String? _userValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez entrer un nom d'utilisateur";
    }
    return null;
  }
}

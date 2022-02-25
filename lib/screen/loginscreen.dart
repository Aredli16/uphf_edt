import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/data/web/session.dart';
import 'package:uphf_edt/screen/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.isFirstTime}) : super(key: key);

  final bool isFirstTime;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username;
  String? password;

  String? _userValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez entrer un nom d'utilisateur";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    return null;
  }

  Future<String?> _authUser(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    username = data.name;
    password = data.password;
    try {
      if (!await Session.instance.isLog(username!, password!)) {
        return "Identifiant ou mot de passe incorrect";
      }
    } catch (e) {
      return e.toString().replaceAll("Exception: ", "");
    }
    await prefs.setString('username', username!);
    await prefs.setString('password', password!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'UPHF',
      logo: 'assets/2560px-UPHF_logo.svg.png',
      logoTag: 'uphf_logo_tag',
      onLogin: _authUser,
      onSignup: null,
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(username: username!, password: password!),
          ),
        );
      },
      onRecoverPassword: (p0) => Future(() => null),
      userType: LoginUserType.name,
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
      hideForgotPasswordButton: true,
      messages: LoginMessages(
        userHint: "Nom d'utilisateur",
        passwordHint: "Mot de passe",
        loginButton: "Connexion".toUpperCase(),
        flushbarTitleError: "Erreur".toUpperCase(),
      ),
    );
  }
}

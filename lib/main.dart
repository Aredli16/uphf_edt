import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt_v2/screens/homescreen_online.dart';
import 'package:uphf_edt_v2/screens/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
  final String? password = prefs.getString('password');
  runApp(MyApp(username: username, password: password));
}

class MyApp extends StatelessWidget {
  final String? username;
  final String? password;

  const MyApp({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light(),
        AppTheme.dark(),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              supportedLocales: const [
                Locale('fr', 'FR'),
                Locale('en', 'US'),
              ],
              title: 'UPHF_EDT',
              theme: ThemeProvider.themeOf(context).data,
              home: determineHomeScreen(),
            );
          },
        ),
      ),
    );
  }

  Widget determineHomeScreen() {
    if (username != null && password != null) {
      return OnlineHomeScreen(username: username!, password: password!);
    } else {
      return const LoginScreen();
    }
  }
}

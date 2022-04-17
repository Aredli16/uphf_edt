import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/screen/homescreen.dart';
import 'package:uphf_edt/screen/introscreen.dart';
import 'package:uphf_edt/screen/loginscreen.dart';
import 'package:theme_provider/theme_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? password = prefs.getString('password');
  if (prefs.getBool('first_run') == null) {
    prefs.setBool('first_run', true);
  }
  runApp(MyApp(
    username: username,
    password: password,
    firstTime: prefs.getBool('first_run')!,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.username,
    this.password,
    required this.firstTime,
  }) : super(key: key);

  final String? username;
  final String? password;
  final bool firstTime;

  //Returns the current screen to display
  Widget _getScreen() {
    if (firstTime) {
      return const IntroScreen();
    } else if (username == null || password == null) {
      return const LoginScreen(
        isFirstTime: false,
      );
    } else {
      return HomeScreen(
        username: username!,
        password: password!,
      );
    }
  }

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
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('fr', 'FR'),
              ],
              title: 'UHF_EDT',
              theme: ThemeProvider.themeOf(context).data,
              home: _getScreen(),
            );
          },
        ),
      ),
    );
  }
}

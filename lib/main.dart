import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/screen/homescreen.dart';
import 'package:uphf_edt/screen/loginscreen.dart';
import 'package:theme_provider/theme_provider.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? password = prefs.getString('password');
  runApp(MyApp(
    username: username,
    password: password,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.username,
    this.password,
  }) : super(key: key);

  final String? username;
  final String? password;

  //Returns the current screen to display
  Widget _getScreen() {
    if (username == null || password == null) {
      return const LoginScreen();
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
              ],
              supportedLocales: const [
                Locale("fr"),
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

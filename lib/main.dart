import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/screen/homescreen.dart';
import 'package:uphf_edt/screen/loginscreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fr"),
      ],
      title: 'UHF_EDT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(),
      ),
      home: username == null
          ? const LoginScreen()
          : HomeScreen(
              username: username!,
              password: password!,
            ),
    );
  }
}

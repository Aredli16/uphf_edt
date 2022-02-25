import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt/screen/loginscreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String? _currentTheme = "Mode jour";

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Université Polytechnique des Hauts-de-France',
          body:
              "Vous êtes étudiant à l'Université Polytechnique des Hauts-de-France ? Découvrez cette application pour consulter votre emploi du temps depuis votre smartphone !",
          image: Image.asset(
            'assets/2560px-UPHF_logo.svg.png',
            height: 150,
          ),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        PageViewModel(
          title: 'Personnalisation',
          bodyWidget: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Plutôt sombre ou clair ? À vous de choisir !",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Mode jour",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio<String>(
                  value: "Mode jour",
                  groupValue: _currentTheme,
                  onChanged: (value) {
                    ThemeProvider.controllerOf(context)
                        .setTheme('default_light_theme');
                    setState(() {
                      _currentTheme = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  "Mode nuit",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio<String>(
                  value: "Mode nuit",
                  groupValue: _currentTheme,
                  onChanged: (value) {
                    ThemeProvider.controllerOf(context)
                        .setTheme('default_dark_theme');
                    setState(() {
                      _currentTheme = value;
                    });
                  },
                ),
              )
            ],
          ),
          image: Image.asset('assets/intro/dark_light.png', height: 150),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PageViewModel(
          title: 'A propos'.toUpperCase(),
          body:
              "Cette application a été développée par des étudiants de l'Université Polytechnique des Hauts-de-France.\n\nSi vous avez des questions, n'hésitez pas à nous contacter à l'adresse suivante : aredlipro@gmail.com",
          image: Image.asset('assets/intro/propos-.png', height: 150),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        PageViewModel(
          title: "Faciliter l'accès".toUpperCase(),
          body:
              "Cette application vous permet de consulter votre emploi du temps sans avoir besoin de vous connecter à chaque fois à votre ENT.\n\nVos identifiants sont stockés localement sur votre téléphone. Aucunes données n'est récupéré.",
          image: Image.asset('assets/intro/access.png', height: 150),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        PageViewModel(
          title: "Sauvegarde".toUpperCase(),
          body:
              "En plus de ne plus avoir besoin de vous connecter, vos cours sont directement enregistrés sur votre téléphone. Ainsi, si vous n'avez plus de connexion ou si l'ENT est momentanément indisponible, vous pourrez accéder aux cours que vous avez consultés précédemment.",
          image: Image.asset('assets/intro/exemple_lesson.png', height: 300),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        PageViewModel(
          title: "Prêt ?".toUpperCase(),
          body: "Connectez-vous et consulter votre application !",
          image: Image.asset('assets/intro/go.png', height: 150),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        )
      ],
      showSkipButton: true,
      done: const Text("GO !", style: TextStyle(fontWeight: FontWeight.w600)),
      onSkip: () async {
        await pushLoginScreen(context);
      },
      skip: const Text("Passer"),
      next: const Text("Suivant"),
      dotsFlex: 2,
      onDone: () async {
        await pushLoginScreen(context);
      },
    );
  }

  Future pushLoginScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("first_run", false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(
          isFirstTime: true,
        ),
      ),
    );
  }
}

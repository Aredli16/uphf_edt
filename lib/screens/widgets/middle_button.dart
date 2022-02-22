import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt_v2/screens/loginscreen.dart';

class CustomeMiddleButton extends StatelessWidget {
  final BuildContext context;

  const CustomeMiddleButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      key: key,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      buttonSize: const Size(70.0, 70.0),
      childrenButtonSize: const Size(70.0, 70.0),
      spaceBetweenChildren: 25.0,
      child: Image.asset(ThemeProvider.themeOf(context).data == ThemeData.dark()
          ? 'assets/res/mipmap-xxxhdpi/ic_launcher_dark.png'
          : 'assets/res/mipmap-xxxhdpi/ic_launcher.png'),
      heroTag: 'uphf_logo_tag',
      children: [
        SpeedDialChild(
          child: const Icon(Icons.logout),
          label: "Deconnexion",
          onTap: () {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              title: "Déconnexion",
              text: "Voulez-vous vraiment vous déconnecter ?",
              confirmBtnText: "Oui",
              showCancelBtn: true,
              cancelBtnText: "Non",
              onConfirmBtnTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('username');
                prefs.remove('password');

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              onCancelBtnTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        SpeedDialChild(
          child: Icon(ThemeProvider.themeOf(context).data == ThemeData.dark()
              ? Icons.wb_sunny_sharp
              : Icons.nightlight_round_outlined),
          label: ThemeProvider.themeOf(context).data == ThemeData.dark()
              ? "Mode jour"
              : "Mode nuit",
          onTap: () {
            ThemeProvider.controllerOf(context).nextTheme();
          },
        ),
      ],
    );
  }
}

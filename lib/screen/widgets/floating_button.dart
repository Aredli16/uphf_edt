import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:uphf_edt/data/database/database_helper.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final void Function() onDisconnect;

  const CustomFloatingActionButton({Key? key, required this.onDisconnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
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
              onConfirmBtnTap: () {
                onDisconnect();
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
        SpeedDialChild(
          child: const Icon(Icons.delete_sweep),
          label: 'Vider le cache',
          onTap: () async {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.warning,
              title: "Effacer le cache",
              text:
                  "Êtes-vous sûr de vouloir effacer le cache ? (Vous perdrez vos cours enregistré. Vous ne pourrez plus les consulter hors ligne.)",
              confirmBtnText: 'Confirmer',
              showCancelBtn: true,
              cancelBtnText: 'Annuler',
              onCancelBtnTap: () => Navigator.pop(context),
              onConfirmBtnTap: () {
                DatabaseHelper.instance.delete().then(
                  (value) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      title: "Cache effacé",
                      text: "Le cache a été effacé avec succès.",
                      onConfirmBtnTap: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

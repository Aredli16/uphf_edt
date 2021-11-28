import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt/data/database/dbhelper.dart';
import 'package:uphf_edt/data/http/scrap.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/screen/lesson.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:uphf_edt/screen/loginscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username, required this.password})
      : super(key: key);

  final String username;
  final String password;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<SchoolDay> schoolDay; // List of future school days
  String currentDayTime = DateFormat('EEEE d MMMM', 'FR_fr')
      .format(DateTime.now()); // Current day time to display in the app bar
  DateTime lastDateSelectedCalendar =
      DateTime.now(); // Last date selected in the calendar
  bool isOnline = true; // Is the app online ?
  int year = DateTime.now().year; // Current year

  @override
  void initState() {
    super.initState();

    _checkForUpdates();

    schoolDay = Scrap.getSchoolDayToday(
        widget.username, widget.password); // Get the school day today
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getDay(); // Get the current day to display in the app bar
    });
  }

  void _checkForUpdates() async {
    final newVersion = NewVersion(
      androidId: 'fr.aredli.uphf.edt',
    );
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Mise à jour disponible',
        dialogText: '''
            Une nouvelle version est disponible: ${status.localVersion} -> ${status.storeVersion}\n
            Nouveautés: ${status.releaseNotes}
            ''',
        updateButtonText: 'Mettre à jour',
        dismissButtonText: 'Ignorer',
      );
    }
  }

  /// Get the current day to display in the app bar
  /// If the current day is not the same as the last day selected in the calendar,
  /// we get the school day for the current day
  void _getDay() async {
    SchoolDay _schoolDay = await schoolDay;
    setState(() {
      currentDayTime = _schoolDay.dayTime;
    });
  }

  /// Disconnect the user
  ///
  /// Delete the username and password in the shared preferences
  ///
  /// Go to the login screen
  void disconnectUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    DBHelper.instance.delete();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _tryToReconnect() async {
    schoolDay = Scrap.getSchoolDayToday(widget.username, widget.password);
    _getDay();
    lastDateSelectedCalendar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<SchoolDay>(
        future: schoolDay, // Get the school day
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isOnline = true;
            DBHelper.instance.insertCours(snapshot.data!.cours);
            return ListView.builder(
              itemCount: snapshot.data!.cours.length,
              itemBuilder: (context, index) {
                return Lesson(snapshot.data!.cours[index]);
              },
            );
          } else if (snapshot.hasError) {
            return FutureBuilder<SchoolDay>(
              future: DBHelper.instance.getSchoolDay(currentDayTime),
              builder: (context, snapshot) {
                isOnline = false;
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: _tryToReconnect,
                    child: ListView.builder(
                      itemCount: snapshot.data!.cours.length,
                      itemBuilder: (context, index) {
                        return Lesson(snapshot.data!.cours[index]);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.error
                              .toString()
                              .replaceAll('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              schoolDay = Scrap.getSchoolDayToday(
                                  widget.username, widget.password);
                              _getDay();
                            });
                          },
                          child: const Text(
                              'Cliquez ici pour essayer de vous reconnecter'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const LinearProgressIndicator();
                }
              },
            );
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: buildNavigation(),
      floatingActionButton: buildMiddleButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AnimatedBottomNavigationBar buildNavigation() {
    List<Widget> icons = [
      Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Icon(
              Icons.navigate_before,
              color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                  ? Colors.white
                  : Colors.black,
            ),
            Text(
              'Précédent',
              style: TextStyle(
                  color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Icon(
              Icons.navigate_next,
              color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                  ? Colors.white
                  : Colors.black,
            ),
            Text(
              'Suivant',
              style: TextStyle(
                color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      )
    ];
    return AnimatedBottomNavigationBar.builder(
      activeIndex: 0,
      gapLocation: GapLocation.center,
      notchMargin: 4,
      elevation:
          ThemeProvider.themeOf(context).data == ThemeData.dark() ? 0 : 8,
      backgroundColor: ThemeProvider.themeOf(context).data == ThemeData.dark()
          ? Colors.black54
          : Colors.white,
      itemCount: 2,
      height: 65,
      tabBuilder: (context, index) {
        return icons[context];
      },
      onTap: (value) {
        if (value == 1) {
          HapticFeedback.vibrate();
          if (isOnline) {
            setState(() {
              schoolDay = Scrap.getNextSchoolDay();
              _getDay();
              lastDateSelectedCalendar =
                  lastDateSelectedCalendar.add(const Duration(days: 1));
            });
          } else {
            DateTime _dateParsing = DateFormat('EEEE d MMMM yyyy', 'FR_fr')
                .parse('$currentDayTime $year'.toLowerCase());
            setState(() {
              if (_dateParsing.day == 31 && _dateParsing.month == 12) {
                year = _dateParsing.year + 1;
              }
              _dateParsing = _dateParsing.add(const Duration(days: 1));
              currentDayTime =
                  DateFormat('EEEE d MMMM', 'FR_fr').format(_dateParsing);
              _getDay();
              lastDateSelectedCalendar =
                  lastDateSelectedCalendar.add(const Duration(days: 1));
              _tryToReconnect();
            });
          }
        } else {
          HapticFeedback.vibrate();
          if (isOnline) {
            setState(() {
              schoolDay = Scrap.getPreviousSchoolDay();
              _getDay();
              lastDateSelectedCalendar =
                  lastDateSelectedCalendar.subtract(const Duration(days: 1));
            });
          } else {
            DateTime _dateParsing = DateFormat('EEEE d MMMM yyyy', 'FR_fr')
                .parse('$currentDayTime $year'.toLowerCase());
            setState(() {
              if (_dateParsing.day == 1 && _dateParsing.month == 1) {
                year = _dateParsing.year - 1;
              }
              _dateParsing = _dateParsing.subtract(const Duration(days: 1));
              currentDayTime =
                  DateFormat('EEEE d MMMM', 'FR_fr').format(_dateParsing);
              _getDay();
              lastDateSelectedCalendar =
                  lastDateSelectedCalendar.add(const Duration(days: 1));
              _tryToReconnect();
            });
          }
        }
      },
    );
  }

  SpeedDial buildMiddleButton() {
    return SpeedDial(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      buttonSize: 70.0,
      childrenButtonSize: 70.0,
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
                disconnectUser();
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
                DBHelper.instance.delete().then(
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(currentDayTime.toUpperCase()),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              locale: const Locale("fr", "FR"),
              initialDate: lastDateSelectedCalendar,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );
            if (selectedDate != null) {
              if (isOnline) {
                DateFormat format = DateFormat('d/M/y');
                String dateWithFormat = format.format(selectedDate);
                setState(() {
                  schoolDay = Scrap.getASpecifiDay(dateWithFormat);
                  _getDay();
                  lastDateSelectedCalendar = selectedDate;
                });
              } else {
                setState(() {
                  currentDayTime =
                      DateFormat('EEEE d MMMM', 'FR_fr').format(selectedDate);
                  year = selectedDate.year;
                  _getDay();
                  lastDateSelectedCalendar = selectedDate;
                  _tryToReconnect();
                });
              }
            }
          },
          icon: const Icon(Icons.calendar_today),
        ),
        kDebugMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DatabaseList()));
                  });
                },
                icon: const Icon(Icons.developer_mode),
              )
            : Container(),
      ],
      leading: IconButton(
        onPressed: () {
          if (isOnline) {
            DateFormat format = DateFormat("d/M/y");
            String todayWithFormat = format.format(DateTime.now());
            setState(() {
              schoolDay = Scrap.getASpecifiDay(todayWithFormat);
              _getDay();
              lastDateSelectedCalendar = DateTime.now();
            });
          } else {
            setState(() {
              currentDayTime =
                  DateFormat('EEEE d MMMM', 'FR_fr').format(DateTime.now());
              year = DateTime.now().year;
              _getDay();
              lastDateSelectedCalendar = DateTime.now();
              _tryToReconnect();
            });
          }
        },
        icon: const Icon(Icons.today),
      ),
    );
  }
}

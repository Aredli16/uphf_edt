import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String currentDayTime =
      'Emploi du temps'; // Current day time to display in the app bar
  DateTime lastDateSelectedCalendar =
      DateTime.now(); // Last date selected in the calendar

  @override
  void initState() {
    super.initState();
    schoolDay = Scrap.getSchoolDayToday(
        widget.username, widget.password); // Get the school day today
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getDay(); // Get the current day to display in the app bar
    });
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<SchoolDay>(
        future: schoolDay, // Get the school day
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.cours.length,
              itemBuilder: (context, index) {
                return Lesson(snapshot.data!.cours[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString().replaceAll('Exception: ', ''),
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
          children: const [
            Icon(
              Icons.navigate_before,
              color: Colors.blue,
            ),
            Text(
              'Précédent',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: const [
            Icon(
              Icons.navigate_next,
              color: Colors.blue,
            ),
            Text(
              'Suivant',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      )
    ];
    return AnimatedBottomNavigationBar.builder(
      activeIndex: 0,
      gapLocation: GapLocation.center,
      notchMargin: 4,
      itemCount: 2,
      height: 65,
      tabBuilder: (context, index) {
        return icons[context];
      },
      onTap: (value) {
        if (value == 1) {
          HapticFeedback.vibrate();
          setState(() {
            schoolDay = Scrap.getNextSchoolDay();
            _getDay();
            lastDateSelectedCalendar =
                lastDateSelectedCalendar.add(const Duration(days: 1));
          });
        } else {
          HapticFeedback.vibrate();
          setState(() {
            schoolDay = Scrap.getPreviousSchoolDay();
            _getDay();
            lastDateSelectedCalendar =
                lastDateSelectedCalendar.subtract(const Duration(days: 1));
          });
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
      child: Image.asset('assets/res/mipmap-xxxhdpi/ic_launcher.png'),
      heroTag: 'uphf_logo_tag',
      children: [
        SpeedDialChild(
          child: const Icon(Icons.logout),
          label: "Deconnexion",
          onTap: disconnectUser,
        )
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
              DateFormat format = DateFormat('d/M/y');
              String dateWithFormat = format.format(selectedDate);
              setState(() {
                schoolDay = Scrap.getASpecifiDay(dateWithFormat);
                _getDay();
                lastDateSelectedCalendar = selectedDate;
              });
            }
          },
          icon: const Icon(Icons.calendar_today),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          DateFormat format = DateFormat("d/M/y");
          String todayWithFormat = format.format(DateTime.now());
          setState(() {
            schoolDay = Scrap.getASpecifiDay(todayWithFormat);
            _getDay();
            lastDateSelectedCalendar = DateTime.now();
          });
        },
        icon: const Icon(Icons.today),
      ),
    );
  }
}

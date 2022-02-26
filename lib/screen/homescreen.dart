import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:uphf_edt/data/database/database_helper.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/data/utils/date_helper.dart';
import 'package:uphf_edt/data/web/session.dart';
import 'package:uphf_edt/screen/loginscreen.dart';
import 'package:uphf_edt/screen/widgets/bottom_bar.dart';
import 'package:uphf_edt/screen/widgets/floating_button.dart';
import 'package:http/http.dart' as http;
import 'package:uphf_edt/screen/widgets/lesson_tile.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String password;

  const HomeScreen({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<SchoolDay> schoolDay;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    http.Client client = http.Client();
    schoolDay = Session.instance.get(client, widget.username, widget.password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: CustomBottomBar(
        onNextDay: onNextDay,
        onPreviousDay: onPreviousDay,
      ),
      floatingActionButton: CustomFloatingActionButton(
        onDisconnect: onDisconnect,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title:
          Text(DateHelper.convertDateTimeToLitteral(currentDate).toUpperCase()),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => setState(() {
          currentDate = DateTime.now();
          schoolDay = Session.instance.getSpecificDay(DateTime.now());
        }),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );

            if (selectedDate != null) {
              setState(() {
                schoolDay = Session.instance.getSpecificDay(selectedDate);
                currentDate = selectedDate;
              });
            }
          },
          icon: const Icon(Icons.calendar_month),
        ),
        kDebugMode
            ? IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DatabaseList(),
                  ),
                ),
                icon: const Icon(Icons.code),
              )
            : Container(),
      ],
    );
  }

  FutureBuilder buildBody() {
    return FutureBuilder<SchoolDay>(
      future: schoolDay,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return buildOfflineSchoolDay();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LinearProgressIndicator();
          case ConnectionState.done:
            return buildOnlineSchoolDay(snapshot);
          default:
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
        }
      },
    );
  }

  ListView buildOnlineSchoolDay(AsyncSnapshot<SchoolDay> snapshot) {
    DatabaseHelper.instance.insertSchoolDay(snapshot.data!, currentDate);
    return buildSchoolDay(snapshot.data!);
  }

  FutureBuilder<SchoolDay> buildOfflineSchoolDay() {
    return FutureBuilder<SchoolDay>(
      future: DatabaseHelper.instance.getSchoolDay(currentDate),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error!.toString(),
            ),
          );
        } else if (snapshot.hasData) {
          return buildSchoolDay(snapshot.data!);
        }
        return const LinearProgressIndicator();
      },
    );
  }

  ListView buildSchoolDay(SchoolDay data) {
    return ListView.builder(
      itemCount: data.lessons.length,
      itemBuilder: (context, index) {
        return LessonTile(data.lessons[index]);
      },
    );
  }

  void onNextDay() {
    HapticFeedback.vibrate();
    setState(() {
      schoolDay = Session.instance.getNextPage();
      currentDate = currentDate.add(const Duration(days: 1));
    });
  }

  void onPreviousDay() {
    HapticFeedback.vibrate();
    setState(() {
      schoolDay = Session.instance.getPreviousPage();
      currentDate = currentDate.subtract(const Duration(days: 1));
    });
  }

  void onDisconnect() async {
    DatabaseHelper.instance.delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(isFirstTime: false),
      ),
    );
  }
}

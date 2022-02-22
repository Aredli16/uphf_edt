import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:uphf_edt_v2/data/models/school_day.dart';
import 'package:uphf_edt_v2/data/web/session.dart';
import 'package:uphf_edt_v2/screens/widgets/lesson_tile.dart';
import 'package:uphf_edt_v2/screens/widgets/middle_button.dart';
import 'package:uphf_edt_v2/screens/widgets/navigation_bar.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class OnlineHomeScreen extends StatefulWidget {
  final String username;
  final String password;

  const OnlineHomeScreen(
      {Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<OnlineHomeScreen> createState() => _OnlineHomeScreenState();
}

class _OnlineHomeScreenState extends State<OnlineHomeScreen> {
  final http.Client _httpClient = http.Client();
  DateTime currentDay = DateTime.now();
  late Future<SchoolDay> schoolDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder<SchoolDay>(
        future: schoolDay,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildBody(snapshot);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const LinearProgressIndicator();
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        context: context,
        nextDay: nextDay,
        previousDay: previousDay,
      ),
      floatingActionButton: CustomeMiddleButton(context: context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar buildAppBar() {
    initializeDateFormatting('fr_FR', null);
    return AppBar(
      title: Text(
          DateFormat('EEEE d MMMM', 'FR_fr').format(currentDay).toUpperCase()),
      centerTitle: true,
      leading: IconButton(
          tooltip: 'Retour à aujourd\'hui',
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            setState(() {
              currentDay = DateTime.now();
              schoolDay = Session.instance.getSpecificDay(DateTime.now());
            });
          }),
      actions: [
        IconButton(
          tooltip: 'Selectionner un jour',
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: currentDay,
              locale: const Locale("fr", "FR"),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              setState(() {
                currentDay = selectedDate;
                schoolDay = Session.instance.getSpecificDay(selectedDate);
              });
            }
          },
        ),
        kDebugMode
            ? IconButton(
                tooltip: 'Base de données',
                icon: const Icon(Icons.code),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DatabaseList()));
                },
              )
            : Container(),
      ],
    );
  }

  ListView buildBody(AsyncSnapshot<SchoolDay> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.lessons!.length,
      itemBuilder: (context, index) {
        return ZoomTapAnimation(
          onTap: () {},
          onLongTap: () {},
          enableLongTapRepeatEvent: false,
          longTapRepeatDuration: const Duration(milliseconds: 100),
          begin: 1.0,
          end: 0.93,
          beginDuration: const Duration(milliseconds: 20),
          endDuration: const Duration(milliseconds: 120),
          beginCurve: Curves.decelerate,
          endCurve: Curves.fastOutSlowIn,
          child: LessonTile(
            snapshot.data!.lessons![index],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    schoolDay =
        Session.instance.get(_httpClient, widget.username, widget.password);
    super.initState();
  }

  void nextDay() {
    setState(() {
      currentDay = currentDay.add(const Duration(days: 1));
      schoolDay = Session.instance.getNextDay();
    });
  }

  void previousDay() {
    setState(() {
      currentDay = currentDay.subtract(const Duration(days: 1));
      schoolDay = Session.instance.getPreviousDay();
    });
  }
}

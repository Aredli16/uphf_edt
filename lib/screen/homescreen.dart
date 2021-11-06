import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/data/http/http_request.dart';
import 'package:uphf_edt/data/http/scrap.dart';
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
  late Future<String> cas;
  String currentDay = 'Emploi du temps';
  DateTime lastDateSelected = DateTime.now();

  @override
  void initState() {
    super.initState();
    cas = HttpRequestHelper.instance.getCas(widget.username, widget.password);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getDay();
    });
  }

  void _getDay() async {
    String day = Scrap.getDay(await cas);
    setState(() {
      currentDay = day;
    });
  }

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
      body: FutureBuilder<String>(
        future: cas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, String>> cours = Scrap.getCours(snapshot.data!);
            return ListView.builder(
              itemCount: cours.length,
              itemBuilder: (context, index) {
                return Lesson(
                  cours[index]['room']!,
                  cours[index]['hour']!,
                  cours[index]['cours']!,
                  cours[index]['type']!,
                );
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
                        cas = HttpRequestHelper.instance
                            .getCas(widget.username, widget.password);
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

  BottomNavigationBar buildNavigation() {
    return BottomNavigationBar(
      iconSize: 30.0,
      unselectedFontSize: 14.0,
      unselectedItemColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.navigate_before), label: 'Précedent'),
        BottomNavigationBarItem(
            icon: Icon(Icons.navigate_next), label: 'Suivant'),
      ],
      onTap: (value) {
        if (value == 1) {
          HapticFeedback.vibrate();
          setState(() {
            cas = HttpRequestHelper.instance.getNextPage();
            _getDay();
            lastDateSelected = lastDateSelected.add(const Duration(days: 1));
          });
        } else {
          HapticFeedback.vibrate();
          setState(() {
            cas = HttpRequestHelper.instance.getPreviousPage();
            _getDay();
            lastDateSelected =
                lastDateSelected.subtract(const Duration(days: 1));
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
      title: Text(currentDay.toUpperCase()),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              locale: const Locale("fr", "FR"),
              initialDate: lastDateSelected,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
            );
            if (selectedDate != null) {
              DateFormat format = DateFormat('d/M/y');
              String dateWithFormat = format.format(selectedDate);
              setState(() {
                cas =
                    HttpRequestHelper.instance.getASpecificDay(dateWithFormat);
                _getDay();
                lastDateSelected = selectedDate;
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
            cas = HttpRequestHelper.instance.getASpecificDay(todayWithFormat);
            _getDay();
            lastDateSelected = DateTime.now();
          });
        },
        icon: const Icon(Icons.today),
      ),
    );
  }
}

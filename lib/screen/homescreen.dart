import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphf_edt/data/http/http_request.dart';
import 'package:uphf_edt/data/http/scrap.dart';
import 'package:uphf_edt/screen/lesson.dart';

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

  @override
  void initState() {
    super.initState();
    cas = HttpRequestHelper.instance.getCas(widget.username, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emploi du temps"),
      ),
      body: FutureBuilder<String>(
        future: cas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String day = Scrap.getDay(snapshot.data!);
            List<Map<String, String>> cours = Scrap.getCours(snapshot.data!);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cours.length,
                    itemBuilder: (context, index) {
                      return Lesson(
                        cours[index]['room']!,
                        cours[index]['hour']!,
                        cours[index]['cours']!,
                        cours[index]['type']!,
                      );
                    },
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            setState(() {
              cas = HttpRequestHelper.instance.getNextPage();
            });
          } else {
            setState(() {
              cas = HttpRequestHelper.instance.getPreviousPage();
            });
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uphf_edt/data/http/http_request.dart';
import 'package:uphf_edt/data/http/scrap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String day = "Emploi du temps";
  Future<String> cas =
      HttpRequestHelper.instance.getCas('clempe4_', '2486cQlp1793');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(day),
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
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(cours[index]['cours']!),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.schedule,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cours[index]['hour']!),
                            ],
                          ),
                          subtitle: Text(cours[index]['room']!),
                        ),
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
              cas = HttpRequestHelper.instance.getNextPage(
                HttpRequestHelper.userAgent,
                HttpRequestHelper.jSessionId,
                HttpRequestHelper.agimus,
              );
            });
          } else {
            setState(() {
              cas = HttpRequestHelper.instance.getPreviousPage(
                HttpRequestHelper.userAgent,
                HttpRequestHelper.jSessionId,
                HttpRequestHelper.agimus,
              );
            });
          }
        },
      ),
    );
  }
}

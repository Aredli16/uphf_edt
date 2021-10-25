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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(day),
      ),
      body: FutureBuilder<String>(
        future: HttpRequestHelper.instance.getCas('clempe4_', '2486cQlp1793'),
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
    );
  }
}

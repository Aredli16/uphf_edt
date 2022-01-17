import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uphf_edt/data/models/cours.dart';

class Lesson extends StatelessWidget {
  final Cours cours;

  List<Color> getColor(String n, BuildContext context) {
    switch (n) {
      case "TD":
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.teal[900]!,
                Colors.teal,
                Colors.teal[500]!,
                Colors.teal[700]!,
              ]
            : [
                Colors.blue[900]!,
                Colors.blue,
                Colors.lightBlue,
                Colors.lightBlue[200]!
              ];
      case "TP":
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.green[900]!,
                Colors.green,
                Colors.green[500]!,
                Colors.green[700]!,
              ]
            : [
                Colors.green[900]!,
                Colors.green,
                Colors.lightGreen,
                Colors.lightGreen[200]!
              ];
      case "CM":
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.deepPurple[900]!,
                Colors.deepPurple,
                Colors.deepPurple[500]!,
                Colors.deepPurple[700]!
              ]
            : [
                Colors.purple[900]!,
                Colors.purple,
                Colors.purple[300]!,
                Colors.purple[200]!
              ];
      case "DS":
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.deepOrange[900]!,
                Colors.deepOrange,
                Colors.deepOrange[500]!,
                Colors.deepOrange[700]!
              ]
            : [
                Colors.orange[900]!,
                Colors.orange,
                Colors.orange[300]!,
                Colors.orange[200]!
              ];
      case "RES":
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.grey[900]!,
                Colors.grey,
                Colors.grey[500]!,
                Colors.grey[700]!
              ]
            : [
                Colors.grey[900]!,
                Colors.grey,
                Colors.grey[400]!,
                Colors.grey[300]!
              ];
      default:
        return ThemeProvider.themeOf(context).data == ThemeData.dark()
            ? [
                Colors.teal[900]!,
                Colors.teal,
                Colors.teal[500]!,
                Colors.teal[700]!,
              ]
            : [
                Colors.blue[900]!,
                Colors.blue,
                Colors.lightBlue,
                Colors.lightBlue[200]!
              ];
    }
  }

  const Lesson(this.cours, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: height * 0.15,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: getColor(cours.type ?? "TD", context),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            cours.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          cours.type?.toUpperCase() ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 15,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cours.room ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  cours.prof ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          cours.hour ?? "",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(cours.information ?? "",
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.red)),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

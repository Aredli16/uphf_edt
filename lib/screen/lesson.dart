import 'package:flutter/material.dart';

class Lesson extends StatelessWidget {
  final String salle;
  final String heure;
  final String cours;
  final String type;

  List<Color> getColor(String n) {
    switch (n) {
      case "TD":
        return [
          Colors.blue[900]!,
          Colors.blue,
          Colors.lightBlue,
          Colors.lightBlue[200]!
        ];
      case "TP":
        return [
          Colors.green[900]!,
          Colors.green,
          Colors.lightGreen,
          Colors.lightGreen[200]!
        ];
      case "CM":
        return [
          Colors.purple[900]!,
          Colors.purple,
          Colors.purple[300]!,
          Colors.purple[200]!
        ];
      default:
        return [
          Colors.blue[900]!,
          Colors.blue,
          Colors.lightBlue,
          Colors.lightBlue[200]!
        ];
    }
  }

  const Lesson(this.salle, this.heure, this.cours, this.type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: height * 0.15,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: getColor(type)),
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
                    Text(
                      cours,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      type.toUpperCase(),
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
                    Text(
                      salle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    Text(
                      heure,
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
      ),
    );
  }
}

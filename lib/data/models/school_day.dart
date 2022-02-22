import 'package:uphf_edt_v2/data/models/lesson.dart';

class SchoolDay {
  DateTime? date;
  List<Lesson>? lessons;

  SchoolDay({this.date, this.lessons});

  toMap() {
    var map = <String, dynamic>{};
    map["date"] = date?.toIso8601String();
    map["lessons"] = lessons?.map((lesson) => lesson.toMap()).toList();
    return map;
  }

  factory SchoolDay.fromMap(Map<String, dynamic> map) {
    return SchoolDay(
      date: DateTime.parse(map["date"]),
      lessons: List<Lesson>.from(map["lessons"].map((x) => Lesson.fromMap(x))),
    );
  }
}

import 'package:uphf_edt/data/models/lesson.dart';

class SchoolDay {
  final DateTime date;
  final List<Lesson> lessons;

  SchoolDay(this.date, this.lessons);
}

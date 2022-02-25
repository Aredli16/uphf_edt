import 'package:uphf_edt/data/utils/date_helper.dart';

class Lesson {
  final String? title;
  final String? room;
  final String? time;
  final String? teacher;
  final String? type;
  final String? informations;
  DateTime? date;

  Lesson({
    this.title,
    this.room,
    this.time,
    this.teacher,
    this.type,
    this.informations,
    this.date,
  });

  toMap() {
    return {
      'title': title,
      'room': room,
      'time': time,
      'type': type,
      'teacher': teacher,
      'informations': informations,
      'date': DateHelper.convertDateTimeToSQLFormat(date!),
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      title: map['title'],
      room: map['room'],
      time: map['time'],
      type: map['type'],
      teacher: map['teacher'],
      informations: map['informations'],
      date: DateHelper.convertSQLDateFormatToDateTime(map['date']),
    );
  }
}

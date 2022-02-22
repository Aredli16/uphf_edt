class Lesson {
  String? title;
  String? type;
  String? room;
  String? teacher;
  String? time;
  String? informations;

  Lesson({
    this.title,
    this.type,
    this.room,
    this.teacher,
    this.time,
    this.informations,
  });

  toMap() {
    return {
      'title': title,
      'type': type,
      'room': room,
      'teacher': teacher,
      'time': time,
      'informations': informations,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      title: map['title'],
      type: map['type'],
      room: map['room'],
      teacher: map['teacher'],
      time: map['time'],
      informations: map['informations'],
    );
  }
}

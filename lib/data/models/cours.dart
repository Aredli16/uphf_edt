class Cours {
  final String? name;
  final String? room;
  final String? hour;
  final String? type;
  final String? note;
  final String? information;
  final String? date;
  final String? prof;

  Cours({
    this.name,
    this.room,
    this.hour,
    this.type,
    this.information,
    this.note,
    this.date,
    this.prof
  });

  toMap() {
    return {
      'name': name,
      'room': room,
      'hour': hour,
      'type': type,
      'information': information,
      'note': note,
      'date': date,
      'prof': prof,
    };
  }

  factory Cours.fromMap(Map<String, dynamic> map) {
    return Cours(
      name: map['name'],
      room: map['room'],
      hour: map['hour'],
      type: map['type'],
      information: map['information'],
      note: map['note'],
      date: map['date'],
      prof: map['prof']
    );
  }
}

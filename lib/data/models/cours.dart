class Cours {
  final String? name;
  final String? room;
  final String? hour;
  final String? type;
  final String? note;
  final String? information;
  final String? date;

  Cours({
    this.name,
    this.room,
    this.hour,
    this.type,
    this.information,
    this.note,
    this.date,
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
    );
  }
}

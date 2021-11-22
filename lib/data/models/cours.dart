class Cours {
  final int? id;
  final String name;
  final String room;
  final String hour;
  final String type;
  final String? notes;
  final String informations;

  Cours(this.name, this.room, this.hour, this.type, this.informations,
      {this.id, this.notes});
}

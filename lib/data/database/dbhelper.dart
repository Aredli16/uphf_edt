import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uphf_edt/data/models/cours.dart';
import 'package:uphf_edt/data/models/school_day.dart';

class DBHelper {
  DBHelper._();
  static DBHelper instance = DBHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'cours.db'),
      onCreate: (db, version) {
        return db.execute(
          """
            CREATE TABLE Cours(
              name VARCHAR(50),
              type VARCHAR(10),
              room VARCHAR(20),
              hour VARCHAR(20),
              date VARCHAR(30),
              prof VARCHAR(200),
              information VARCHAR(100),
              note VARCHAR(100),
              PRIMARY KEY(name, type, room, hour, date)
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<void> insertCours(List<Cours> cours) async {
    final db = await database;
    for (final cours in cours) {
      await db.insert(
        'Cours',
        cours.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<SchoolDay> getSchoolDay(String day) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Cours', where: 'lower(date) = ?', whereArgs: [day]);
    return SchoolDay(
      day,
      maps.map((m) => Cours.fromMap(m)).toList(),
    );
  }

  Future<void> delete() async {
    deleteDatabase(join(await getDatabasesPath(), 'cours.db'));
    _database = null;
  }
}

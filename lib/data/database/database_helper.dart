import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uphf_edt/data/models/lesson.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/data/utils/date_helper.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'lesson.db'),
      onCreate: (db, version) {
        return db.execute(
          """
            CREATE TABLE Lesson(
              title VARCHAR(50),
              type VARCHAR(10),
              room VARCHAR(20),
              teacher VARCHAR(50),
              time VARCHAR(20),
              date VARCHAR(30),
              informations VARCHAR(100),
              PRIMARY KEY(title, type, room, time, date)
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<void> insertSchoolDay(SchoolDay schoolDay, DateTime date) async {
    final db = await database;
    for (final lesson in schoolDay.lessons) {
      lesson.date = date;
      await db.insert(
        'Lesson',
        lesson.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<SchoolDay> getSchoolDay(DateTime date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Lesson',
        where: 'lower(date) = ?',
        whereArgs: [DateHelper.convertDateTimeToSQLFormat(date)]);
    return SchoolDay(
      date,
      maps.map((m) => Lesson.fromMap(m)).toList(),
    );
  }

  Future<void> delete() async {
    deleteDatabase(join(await getDatabasesPath(), 'lesson.db'));
    _database = null;
  }
}

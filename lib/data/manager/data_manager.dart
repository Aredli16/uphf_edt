import 'package:uphf_edt/data/database/database_helper.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/data/web/session.dart';
import 'package:http/http.dart' as http;

class DataManager {
  DataManager._internal();
  static final DataManager instance = DataManager._internal();

  final http.Client _client = http.Client();
  late String _username;
  late String _password;
  DateTime currentDate = DateTime.now();

  Future<SchoolDay> getSchoolDay(
    String username,
    String password,
  ) async {
    _username = username;
    _password = password;

    late SchoolDay schoolDay;

    try {
      schoolDay = await Session.instance.get(_client, _username, _password);
      await DatabaseHelper.instance.insertSchoolDay(schoolDay, currentDate);
    } catch (e) {
      try {
        schoolDay = await DatabaseHelper.instance.getSchoolDay(currentDate);
      } catch (e) {
        throw Exception('Impossible de récupérer les données');
      }
    }

    return schoolDay;
  }

  Future<SchoolDay> getNextSchoolDay() async {
    currentDate = currentDate.add(const Duration(days: 1));

    late SchoolDay schoolDay;

    try {
      schoolDay = await Session.instance.getSpecificDay(currentDate);
      await DatabaseHelper.instance.insertSchoolDay(schoolDay, currentDate);
    } catch (e) {
      schoolDay = await reloadConnectionAtCurrentDate();
    }

    return schoolDay;
  }

  Future<SchoolDay> getPreviousSchoolDay() async {
    currentDate = currentDate.subtract(const Duration(days: 1));

    late SchoolDay schoolDay;

    try {
      schoolDay = await Session.instance.getSpecificDay(currentDate);
      await DatabaseHelper.instance.insertSchoolDay(schoolDay, currentDate);
    } catch (e) {
      schoolDay = await reloadConnectionAtCurrentDate();
    }

    return schoolDay;
  }

  Future<SchoolDay> getSpecificDay(DateTime date) async {
    currentDate = date;

    late SchoolDay schoolDay;

    try {
      schoolDay = await Session.instance.getSpecificDay(date);
      await DatabaseHelper.instance.insertSchoolDay(schoolDay, currentDate);
    } catch (e) {
      schoolDay = await reloadConnectionAtCurrentDate();
    }

    return schoolDay;
  }

  Future<SchoolDay> reloadConnectionAtCurrentDate() async {
    late SchoolDay schoolDay;

    try {
      await Session.instance.get(_client, _username, _password);
      schoolDay = await Session.instance.getSpecificDay(currentDate);
    } catch (e) {
      try {
        schoolDay = await DatabaseHelper.instance.getSchoolDay(currentDate);
      } catch (e) {
        throw Exception('Impossible de récupérer les données');
      }
    }

    return schoolDay;
  }
}

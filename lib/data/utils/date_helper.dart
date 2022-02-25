import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static String convertDateTimeTwoDigit(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String convertDateTimeToSQLFormat(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime convertSQLDateFormatToDateTime(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  static DateTime convertLitteralDateToDateTime(String date) {
    initializeDateFormatting();
    return DateFormat('EEEE d MMMM', 'FR_fr').parse(date.toLowerCase());
  }

  static String convertDateTimeToLitteral(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat('EEEE d MMMM', 'FR_fr').format(dateTime);
  }
}

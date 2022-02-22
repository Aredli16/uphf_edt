import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:web_scraper/web_scraper.dart';

class DateHelper {
  static String convertDateTimeToStringUPHFFormat(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  static DateTime getDayFromHTML(String html, String address) {
    initializeDateFormatting('fr_FR', null);
    WebScraper scraper = WebScraper();

    if (scraper.loadFromString(html)) {
      String date = scraper.getElementTitle(address).first;
      date = date.toLowerCase();
      return DateFormat("EEEE dd MMMM", 'FR_fr').parse(date);
    } else {
      throw Exception('Impossible de parser la page');
    }
  }
}

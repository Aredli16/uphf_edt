import 'package:uphf_edt/data/models/cours.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:web_scraper/web_scraper.dart';

import 'http_request.dart';

/// Scrap class for scraping the website
///
/// This class is used to scrape the website and return the data
///
/// All method are static
class Scrap {
  /// Scrap the website and return the day of the current page
  ///
  /// This method is used to get the day of the current page
  ///
  /// [html] is the html code of the website
  static String _getDay(String html) {
    final webScraper = WebScraper();
    if (webScraper.loadFromString(html)) {
      return webScraper.getElementTitle('div > div > h1').first;
    } else {
      throw Exception('Failed to load day');
    }
  }

  /// Scrap the website and return the list of cours
  ///
  /// This method is used to get the list of cours
  ///
  /// [html] is the html code of the website
  static Future<SchoolDay> _getASchoolDayFromPage(String html) async {
    final webScraper = WebScraper();
    if (webScraper.loadFromString(html)) {
      List<Map<String, dynamic>> coursElements =
          webScraper.getElement('div > div > ul > li', ['data-role']);
      coursElements.removeWhere((element) {
        return element['attributes']['data-role'] == null;
      }); // Get only the cours

      List<String> typeElement = webScraper
          .getElementTitle('div > ul > li > span'); // Get the type of the cours

      List<String> hoursElements = webScraper
          .getElementTitle('p.ui-li-aside > strong'); // Get only the hours

      List<String> roomElements =
          webScraper.getElementTitle('li > h3'); // Get only the room

      List<Map<String, dynamic>> information =
          webScraper.getElement("div > ul > li > p", ['style']);
      information.removeWhere((element) =>
          element['attributes']['style'] != 'color:red;'); // Get information

      List<Cours> cours = [];
      for (int i = 0; i < coursElements.length; i++) {
        cours.add(
          Cours(
            name: coursElements[i]['title'].split("(")[0].trim(),
            room: roomElements.isEmpty
                ? ""
                : roomElements[i].split("(")[0].trim(),
            hour: hoursElements[i].trim(),
            type: typeElement[i].trim(),
            information: information[0]['title'].trim(),
            date: _getDay(html),
          ),
        );
      }
      return SchoolDay(_getDay(html), cours);
    } else {
      throw Exception('Failed to load EDT');
    }
  }

  /// Scrap the website and return the list of school day of today
  ///
  /// This method is used to get the list of school day of today
  ///
  /// [username] is the username of the user
  /// [password] is the password of the user
  static Future<SchoolDay> getSchoolDayToday(
    String username,
    String password,
  ) async {
    final String html =
        await HttpRequestHelper.instance.getCas(username, password);

    return _getASchoolDayFromPage(html);
  }

  /// Scrap the website and return the list of school day of tomorrow
  ///
  /// This method is used to get the list of school day of tomorrow
  static Future<SchoolDay> getNextSchoolDay() async {
    final String html = await HttpRequestHelper.instance.getNextPage();

    return _getASchoolDayFromPage(html);
  }

  /// Scrap the website and return the list of school day of yesterday
  ///
  /// This method is used to get the list of school day of yesterday
  static Future<SchoolDay> getPreviousSchoolDay() async {
    final String html = await HttpRequestHelper.instance.getPreviousPage();

    return _getASchoolDayFromPage(html);
  }

  /// Scrap the website and return the list of school day of the day
  ///
  /// This method is used to get the list of school day of the day
  ///
  /// [day] is the day of the school day
  static Future<SchoolDay> getASpecifiDay(String day) async {
    final String html = await HttpRequestHelper.instance.getASpecificDay(day);

    return _getASchoolDayFromPage(html);
  }
}

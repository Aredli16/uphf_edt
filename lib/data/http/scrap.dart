import 'package:web_scraper/web_scraper.dart';

/// Scrap class for scraping the website
///
/// This class is used to scrape the website and return the data
///
/// All method are static
class Scrap {
  /// Scrap the website and return the day of the current page
  static String getDay(String html) {
    final webScraper = WebScraper();
    if (webScraper.loadFromString(html)) {
      return webScraper.getElementTitle('div > div > h1').first;
    } else {
      throw Exception('Failed to load day');
    }
  }

  /// Scrap the website and return the cours list of the page
  static List<Map<String, String>> getCours(String html) {
    final webScraper = WebScraper();
    if (webScraper.loadFromString(html)) {
      List<Map<String, dynamic>> coursElements =
          webScraper.getElement('div > div > ul > li', ['data-role']);
      coursElements.removeWhere((element) {
        return element['attributes']['data-role'] == null;
      });

      List<String> hoursElements =
          webScraper.getElementTitle('p.ui-li-aside > strong');

      List<String> roomElements = webScraper.getElementTitle('li > h3');

      List<Map<String, String>> cours = [];
      for (int i = 0; i < coursElements.length; i++) {
        cours.add({
          'cours': coursElements[i]['title'].split("(")[0],
          'hour': hoursElements[i].trim(),
          'room': roomElements[i].trim().split("(")[0],
          'type': coursElements[i]['title'].substring(
              coursElements[i]['title'].length - 2,
              coursElements[i]['title'].length)
        });
      }

      return cours;
    } else {
      throw Exception('Failed to load EDT');
    }
  }
}

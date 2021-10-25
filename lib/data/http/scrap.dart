import 'package:web_scraper/web_scraper.dart';

class Scrap {
  static String getDay(String html) {
    final webScraper = WebScraper();
    if (webScraper.loadFromString(html)) {
      return webScraper.getElementTitle('div > div > h1')[0];
    } else {
      throw Exception('Failed to load day');
    }
  }

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
          'room': roomElements[i].trim(),
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

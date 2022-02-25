import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uphf_edt/data/models/lesson.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:web_scraper/web_scraper.dart';

class Scrap {
  static DateTime scrapDateFromHTML(String html) {
    initializeDateFormatting('fr_FR', null);

    final WebScraper scraper = WebScraper();
    if (!scraper.loadFromString(html)) {
      throw Exception('Impossible de charger le HTML');
    }
    final String date =
        scraper.getElementTitle('div > div > h1').first.toLowerCase();

    return DateFormat('EEEE d MMMM', 'fr_FR').parse(date);
  }

  static SchoolDay scrapSchoolDayFromHTML(String html) {
    String formattedHtml = html.replaceAll('\n', '');
    formattedHtml = formattedHtml.replaceAll('&#9;', '');

    final RegExp regExp = RegExp(
        r'<li data-role="list-divider">(.*?)<span class="ui-li-count">(.*?)</span></li>            <li>                    <h3>(.*?)</h3>                    <p><strong>                    (.*?)                    </strong></p>                    <p><strong>                    (.*?)                    </strong></p>                    <p style="color:red;">(.*?)</p>                    <p style="white-space:normal;padding-top:4px;text-transform: lowercase;font-style:italic">(.*?)</p>                    <p class="ui-li-aside" style="width:35%"><strong>                    (.*?)                    </strong></p>');
    final List<Match> matches = regExp.allMatches(formattedHtml).toList();
    /*
      group(1): title
      group(2): type
      group(3): room
      group(4): mode ('Présentiel', 'Distanciel')
      group(5): teacher
      group(6): informations
      group(7): subtitle
      group(8): time
    */
    List<Lesson> lessons = [];
    for (var match in matches) {
      lessons.add(
        Lesson(
          title: match.group(1),
          type: match.group(2),
          room: match.group(3),
          teacher: match.group(5),
          informations: match.group(6),
          time: match.group(8),
        ),
      );
    }

    return SchoolDay(
      scrapDateFromHTML(html),
      lessons,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/data/web/scrap.dart';

void main() {
  test(
    'Given html source code When scrapDateFromHTML(String html) is called Then the date page is return',
    () {
      // Given
      String html =
          '''
&#9;&#9;<div data-role="page">

&#9;&#9;&#9;<div data-role="header">
&#9;&#9;&#9;&#9;<a href="#" data-role="button" id="btn_prec" data-icon="arrow-l">Prec.</a>
&#9;&#9;&#9;&#9;<h1 style="font-size:14px;">Lundi 21 F&eacute;vrier</h1>
&#9;&#9;&#9;&#9;<a href="#" data-role="button" id="btn_suiv" data-icon="arrow-r">Suiv.</a>
&#9;&#9;&#9;&#9;
&#9;&#9;&#9;</div>
''';

      // When
      final DateTime date = Scrap.scrapDateFromHTML(html);

      // Then
      expect(date, DateTime(1970, 2, 21));
    },
  );

  test(
    'Given html source code When scrapSchoolDayFromHTML(String html) is called Then a SchoolDay is return',
    () {
      // Given
      String html =
          '''
&#9;&#9;<div data-role="page">

&#9;&#9;&#9;<div data-role="header">
&#9;&#9;&#9;&#9;<a href="#" data-role="button" id="btn_prec" data-icon="arrow-l">Prec.</a>
&#9;&#9;&#9;&#9;<h1 style="font-size:14px;">Lundi 21 F&eacute;vrier</h1>
&#9;&#9;&#9;&#9;<a href="#" data-role="button" id="btn_suiv" data-icon="arrow-r">Suiv.</a>
&#9;&#9;&#9;&#9;
&#9;&#9;&#9;</div>
&#9;&#9;
&#9;&#9;&#9;<div data-role="content">
&#9;&#9;&#9;&#9;
&#9;&#9;&#9;&#9;<ul data-role="listview" data-theme="d" data-divider-theme="b">
&#9;&#9;&#9;&#9;&#9;            <li data-role="list-divider">LANGAGE ET SCRIPTING (P3IN1LAN)<span class="ui-li-count">DS</span></li>
&#9;&#9;&#9;&#9;&#9;            <li>
&#9;&#9;&#9;&#9;                    <h3>
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;AB1-011 S (ABEL DE PUJOL1)
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;</h3>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    Pr&eacute;sentiel
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    T. DELOT
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p style="color:red;"></p>
&#9;&#9;&#9;&#9;                    <p style="white-space:normal;padding-top:4px;text-transform: lowercase;font-style:italic">LANGAGE ET SCRIPTING (P3IN1LAN)-DS</p>
&#9;&#9;&#9;&#9;                    <p class="ui-li-aside" style="width:35%"><strong>
&#9;&#9;&#9;&#9;                    &#9;8:30-10:00
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;&#9;            </li>
&#9;&#9;&#9;&#9;&#9;            <li data-role="list-divider">INFORMATIQUE 3 (P3IN2IN3)<span class="ui-li-count">DS</span></li>
&#9;&#9;&#9;&#9;&#9;            <li>
&#9;&#9;&#9;&#9;                    <h3>
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;AB1-011 S (ABEL DE PUJOL1)
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;</h3>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    C. WILBAUT
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p style="color:red;"></p>
&#9;&#9;&#9;&#9;                    <p style="white-space:normal;padding-top:4px;text-transform: lowercase;font-style:italic">INFORMATIQUE 3 (P3IN2IN3)-DS</p>
&#9;&#9;&#9;&#9;                    <p class="ui-li-aside" style="width:35%"><strong>
&#9;&#9;&#9;&#9;                    &#9;10:30-12:00
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;&#9;            </li>
&#9;&#9;&#9;&#9;&#9;            <li data-role="list-divider">BASESDEDONNEES (P3IN3BAD)<span class="ui-li-count">DS</span></li>
&#9;&#9;&#9;&#9;&#9;            <li>
&#9;&#9;&#9;&#9;                    <h3>
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;CAR-A COQUET (CARPEAUX)
&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;</h3>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    Pr&eacute;sentiel
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p><strong>
&#9;&#9;&#9;&#9;&#9;                    C. ROZE
&#9;&#9;&#9;&#9;                    </strong></p>
&#9;&#9;&#9;&#9;                    <p style="color:red;"></p>
&#9;&#9;&#9;&#9;                    <p style="white-space:normal;padding-top:4px;text-transform: lowercase;font-style:italic">BASESDEDONNEES (P3IN3BAD)-DS</p>
&#9;&#9;&#9;&#9;                    <p class="ui-li-aside" style="width:35%"><strong>
&#9;&#9;&#9;&#9;                    &#9;13:30-15:00
&#9;&#9;&#9;&#9;                    </strong></p><span style="display:none"></span>
&#9;&#9;&#9;&#9;&#9;            </li>  
&#9;&#9;&#9;&#9;&#9;  
&#9;&#9;&#9;&#9;</ul>   
&#9;&#9;&#9;&#9;    
&#9;&#9;&#9;&#9;    
&#9;&#9;&#9;&#9;&#9;
&#9;&#9;&#9;&#9;
&#9;&#9;&#9;&#9;
&#9;&#9;&#9;</div>
&#9;&#9;
          ''';

      // When
      final SchoolDay schoolDay = Scrap.scrapSchoolDayFromHTML(html);

      // Then
      expect(schoolDay.date, DateTime(1970, 2, 21));
      expect(schoolDay.lessons.length, 3);
      expect(schoolDay.lessons[0].title, 'LANGAGE ET SCRIPTING (P3IN1LAN)');
      expect(schoolDay.lessons[0].type, 'DS');
      expect(schoolDay.lessons[0].teacher, 'T. DELOT');
      expect(schoolDay.lessons[0].room, 'AB1-011 S (ABEL DE PUJOL1)');
      expect(schoolDay.lessons[0].time, '8:30-10:00');
      expect(schoolDay.lessons[1].title, 'INFORMATIQUE 3 (P3IN2IN3)');
      expect(schoolDay.lessons[1].type, 'DS');
      expect(schoolDay.lessons[1].teacher, 'C. WILBAUT');
      expect(schoolDay.lessons[1].room, 'AB1-011 S (ABEL DE PUJOL1)');
      expect(schoolDay.lessons[1].time, '10:30-12:00');
      expect(schoolDay.lessons[2].title, 'BASESDEDONNEES (P3IN3BAD)');
      expect(schoolDay.lessons[2].type, 'DS');
      expect(schoolDay.lessons[2].teacher, 'C. ROZE');
      expect(schoolDay.lessons[2].room, 'CAR-A COQUET (CARPEAUX)');
      expect(schoolDay.lessons[2].time, '13:30-15:00');
    },
  );
}

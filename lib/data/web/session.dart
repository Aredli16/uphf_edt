import 'package:http/http.dart' as http;
import 'package:uphf_edt_v2/data/models/lesson.dart';
import 'package:uphf_edt_v2/data/models/school_day.dart';
import 'package:uphf_edt_v2/data/utils/datehelper.dart';

class Session {
  static final Session _instance = Session._();
  static Session get instance => _instance;
  late http.Client _client;

  late String username;
  late String password;
  late String jSessionId;
  late String lt;
  late String execution;
  late String eventId;
  late String ipAddress;
  late String userAgent;
  late String agimus;
  late String ticket;
  late String javaxFacesViewState;
  Session._();

  Future<bool> checkPostLogin() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://cas.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://cas.uphf.fr/cas/login?service=https%3A%2F%2Fvtmob.uphf.fr%2Fesup-vtclient-up4%2Fstylesheets%2Fmobile%2Fwelcome.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'service':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var data =
        'username=$username&password=$password&lt=$lt&execution=$execution&_eventId=$eventId&ipAddress=$ipAddress&userAgent=$userAgent&submit=Connexion&ipAddress=$ipAddress&userAgent=$userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$jSessionId?$query'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkUsernameAndPassword(
      String username, String password) async {
    this.username = username;
    this.password = password;

    var headers = {
      'Connection': 'keep-alive',
      'Upgrade-Insecure-Requests': '1',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'none',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'service':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await http.get(Uri.parse('https://cas.uphf.fr/cas/login?$query'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception('Get: http.get error: statusCode= ${res.statusCode}');
    }

    updatejSessionIdFromHeaders(res.headers);

    updateHiddenInputsFromHTML(res.body);

    return checkPostLogin();
  }

  Future<SchoolDay> get(
      http.Client client, String username, String password) async {
    _client = client;
    this.username = username;
    this.password = password;

    var headers = {
      'Connection': 'keep-alive',
      'Upgrade-Insecure-Requests': '1',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'none',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'service':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await _client.get(
        Uri.parse('https://cas.uphf.fr/cas/login?$query'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception('Get: http.get error: statusCode= ${res.statusCode}');
    }

    updatejSessionIdFromHeaders(res.headers);

    updateHiddenInputsFromHTML(res.body);

    return await postLogin();
  }

  Future<SchoolDay> getFinalPage() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-site',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer': 'https://cas.uphf.fr/',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var res = await _client.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml;jsessionid=$jSessionId'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception(
          'Get Final Page: http.get error: statusCode= ${res.statusCode}');
    }

    return scrapResponse(res.body);
  }

  Future<SchoolDay> getNextDay() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://vtmob.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'org.apache.myfaces.trinidad.faces.FORM=redirectForm&_noJavaScript=false&javax.faces.ViewState=$javaxFacesViewState&source=redirectForm:semSuiv';

    var res = await _client.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 200) {
      throw Exception(
          'Get Next Day: http.post error: statusCode= ${res.statusCode}');
    }

    return scrapResponse(res.body);
  }

  Future<SchoolDay> getPage() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-site',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer': 'https://cas.uphf.fr/',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'ticket': ticket,
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await _client.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml?$query'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception(
          'Get Page: http.get error: statusCode= ${res.statusCode}');
    }

    updateJSessionIdFromHTML(res.body);

    return getFinalPage();
  }

  Future<SchoolDay> getPreviousDay() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://vtmob.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'org.apache.myfaces.trinidad.faces.FORM=redirectForm&_noJavaScript=false&javax.faces.ViewState=$javaxFacesViewState&source=redirectForm:semPrec';

    var res = await _client.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 200) {
      throw Exception(
          'Get Previous Day: http.post error: statusCode= ${res.statusCode}');
    }

    return scrapResponse(res.body);
  }

  Future<SchoolDay> getSpecificDay(DateTime date) async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var res = await http.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception(
          'Get a Specific Day: http.get error: statusCode= ${res.statusCode}');
    }

    return postCalendar(date);
  }

  Future<SchoolDay> postCalendar(DateTime date) async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://vtmob.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'formCal:date=${DateHelper.convertDateTimeToStringUPHFFormat(date)}&org.apache.myfaces.trinidad.faces.FORM=formCal&_noJavaScript=false&javax.faces.ViewState=!1&source=formCal:hiddenLink';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      throw Exception(
          'Post Calendar: http.post error: statusCode= ${res.statusCode}');
    }

    return getFinalPage();
  }

  Future<SchoolDay> postLogin() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://cas.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer':
          'https://cas.uphf.fr/cas/login?service=https%3A%2F%2Fvtmob.uphf.fr%2Fesup-vtclient-up4%2Fstylesheets%2Fmobile%2Fwelcome.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'service':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var data =
        'username=$username&password=$password&lt=$lt&execution=$execution&_eventId=$eventId&ipAddress=$ipAddress&userAgent=$userAgent&submit=Connexion&ipAddress=$ipAddress&userAgent=$userAgent';

    var res = await _client.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$jSessionId?$query'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      throw Exception(
          'Post Login: http.post error: statusCode= ${res.statusCode}');
    }

    updateAgimusFromHeaders(res.headers);

    updateTicketFromUrl(res.headers['location']!);

    return await getPage();
  }

  SchoolDay scrapResponse(String html) {
    updateJavaxFacesViewStateHiddenInputFromHTML(html);

    String formattedHTML = html.replaceAll('&#9;', '');
    formattedHTML = formattedHTML.replaceAll('\n', '');

    final RegExp regExp = RegExp(
        r'<li data-role="list-divider">(.*?)<span class="ui-li-count">(.*?)</span></li>            <li>                    <h3>(.*?)</h3>                    <p><strong>                    (.*?)                    </strong></p>                    <p><strong>                    (.*?)                    </strong></p>                    <p style="color:red;">(.*?)</p>                    <p style="white-space:normal;padding-top:4px;text-transform: lowercase;font-style:italic">(.*?)</p>                    <p class="ui-li-aside" style="width:35%"><strong>                    (.*?)                    </strong></p>');
    final Iterable<Match> matches = regExp.allMatches(formattedHTML);
    List<Lesson> lessons = [];
    for (var matche in matches) {
      /*
        group(1) = title
        group(2) = type
        group(3) = room
        group(4) = mode
        group(5) = teacher
        group(6) = informations
        group(7) = subtitle
        group(8) = time
      */
      lessons.add(
        Lesson(
          title: matche.group(1)!.trim(),
          type: matche.group(2)!.trim(),
          room: matche.group(3)!.trim(),
          teacher: matche.group(5)!.trim(),
          time: matche.group(8)!.trim(),
          informations: matche.group(6)!.trim(),
        ),
      );
    }
    return SchoolDay(
      date: DateHelper.getDayFromHTML(formattedHTML, 'div > div > h1'),
      lessons: lessons,
    );
  }

  void updateAgimusFromHeaders(Map<String, String> headers) {
    agimus = headers['set-cookie']!.split(';')[0];
    agimus = agimus.split('=')[1];
  }

  void updateHiddenInputsFromHTML(String html) {
    final RegExp regExp =
        RegExp(r'<input type="hidden" name="(.*?)" value="(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    for (Match match in matches) {
      switch (match.group(1)) {
        case 'lt':
          lt = match.group(2)!;
          break;
        case 'execution':
          execution = match.group(2)!;
          break;
        case '_eventId':
          eventId = match.group(2)!;
          break;
        case 'ipAddress':
          ipAddress = match.group(2)!;
          break;
        case 'userAgent':
          userAgent = match.group(2)!;
          break;
      }
    }
  }

  void updateJavaxFacesViewStateHiddenInputFromHTML(String html) {
    final RegExp regExp = RegExp(
        r'<input type="hidden" name="javax.faces.ViewState" value="(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    javaxFacesViewState = matches.last.group(1)!;
  }

  void updatejSessionIdFromHeaders(Map<String, String> headers) {
    jSessionId = headers['set-cookie']!.split(';')[0];
    jSessionId = jSessionId.split('=')[1];
  }

  void updateJSessionIdFromHTML(String html) {
    final RegExp regExp = RegExp(r'jsessionid=(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    for (Match match in matches) {
      jSessionId = match.group(1)!;
    }
  }

  void updateTicketFromUrl(String url) {
    ticket = url.split('ticket=')[1];
  }
}

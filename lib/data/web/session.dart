import 'package:http/http.dart' as http;
import 'package:uphf_edt/data/models/school_day.dart';
import 'package:uphf_edt/data/utils/date_helper.dart';
import 'package:uphf_edt/data/web/scrap.dart';

class Session {
  Session._privateConstructor();
  static final Session instance = Session._privateConstructor();

  late http.Client client;
  late String jSessionId;
  late String userAgent;
  late String agimus;
  late String username;
  late String password;
  late String lt;
  late String ipAddress;
  late String viewState;

  void updateJSessionIdFromHeaders(Map<String, String> headers) {
    jSessionId = headers['set-cookie']!.split(';')[0].split('JSESSIONID=')[1];
  }

  void updateJSessionIdFromHTMLPage(String html) {
    final RegExp regExp = RegExp(r'jsessionid=(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    if (matches.isNotEmpty) {
      jSessionId = matches.first.group(1)!;
    }
  }

  void updateAgimusFromHeaders(Map<String, String> headers) {
    agimus = headers['set-cookie']!.split(';')[0].split('AGIMUS=')[1];
  }

  void updateHiddenInputFromHTMLPage(String html) {
    final RegExp regExp =
        RegExp(r'<input type="hidden" name="(.*?)" value="(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    for (final Match match in matches) {
      switch (match.group(1)) {
        case 'userAgent':
          userAgent = match.group(2)!;
          break;
        case 'lt':
          lt = match.group(2)!;
          break;
        case 'ipAddress':
          ipAddress = match.group(2)!;
          break;
      }
    }
  }

  void updateViewStateFromHTMLPage(String html) {
    final RegExp regExp = RegExp(
        r'<input type="hidden" name="javax.faces.ViewState" value="(.*?)"');
    final Iterable<Match> matches = regExp.allMatches(html);
    if (matches.isNotEmpty) {
      viewState = matches.first.group(1)!;
    }
  }

  Future<SchoolDay> get(
      http.Client client, String username, String password) async {
    this.client = client;
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

    final res = await http.get(
        Uri.parse('https://cas.uphf.fr/cas/login?$query'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception("Impossible de se connecter à l'hôte distant");
    }

    updateJSessionIdFromHeaders(res.headers);

    updateHiddenInputFromHTMLPage(res.body);

    return await _postLogin();
  }

  Future<SchoolDay> _postLogin() async {
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
          'https://cas.uphf.fr/cas/login?service=https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
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
        'username=$username&password=$password&lt=$lt&execution=e1s1&_eventId=submit&ipAddress=$ipAddress&userAgent=$userAgent&submit=Connexion&ipAddress=$ipAddress&userAgent=$userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$jSessionId?$query'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      throw Exception("Impossible de d'identifier l'utilisateur");
    }

    updateAgimusFromHeaders(res.headers);

    return await _getPage(res.headers['location']!);
  }

  Future<SchoolDay> _getPage(String location) async {
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

    var res = await http.get(Uri.parse(location), headers: headers);

    if (res.statusCode != 200) {
      throw Exception('Impossible de récuperer le ticket de connexion');
    }

    updateJSessionIdFromHTMLPage(res.body);

    return await _getFinalPage();
  }

  Future<SchoolDay> _getFinalPage() async {
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

    var res = await http.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml;jsessionid=$jSessionId'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception("Impossible de récupérer l'emploi du temps");
    }

    updateViewStateFromHTMLPage(res.body);

    return Scrap.scrapSchoolDayFromHTML(res.body);
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
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml;jsessionid=259209C7B6B3F65630E3CE7390E89F79',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$jSessionId; AGIMUS=$agimus',
      'Accept-Encoding': 'gzip',
    };

    var res = await http.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers);

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la récupération du calendrier');
    }

    return _postCalendar(date);
  }

  Future<SchoolDay> _postCalendar(DateTime date) async {
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
        'formCal:date=${DateHelper.convertDateTimeTwoDigit(date)}&org.apache.myfaces.trinidad.faces.FORM=formCal&_noJavaScript=false&javax.faces.ViewState=!1&source=formCal:hiddenLink';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      throw Exception(
          "Impossible d'envoyer les informations de date au serveur distant");
    }

    return await _getFinalPage();
  }

  Future<bool> isLog(String username, String password) async {
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

    final res = await http.get(
        Uri.parse('https://cas.uphf.fr/cas/login?$query'),
        headers: headers);

    updateJSessionIdFromHeaders(res.headers);

    updateHiddenInputFromHTMLPage(res.body);

    return await _statusCodePostLogin();
  }

  Future<bool> _statusCodePostLogin() async {
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
          'https://cas.uphf.fr/cas/login?service=https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
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
        'username=$username&password=$password&lt=$lt&execution=e1s1&_eventId=submit&ipAddress=$ipAddress&userAgent=$userAgent&submit=Connexion&ipAddress=$ipAddress&userAgent=$userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$jSessionId?$query'),
        headers: headers,
        body: data);

    if (res.statusCode == 302) {
      return true;
    } else {
      return false;
    }
  }
}

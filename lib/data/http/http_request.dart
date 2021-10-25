import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as scraper;

class HttpRequestHelper {
  HttpRequestHelper._privateConstructor();
  static final HttpRequestHelper instance =
      HttpRequestHelper._privateConstructor();

  Future<String> getCas(String username, String password) async {
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

    String jSessionId = res.headers['set-cookie']!.substring(11, 43);

    Map<String, String> hiddenInput = {};
    scraper
        .parse(res.body)
        .getElementsByClassName('row btn-row')[0]
        .querySelectorAll('input')
        .forEach((element) {
      hiddenInput[element.attributes['name'].toString()] =
          element.attributes['value'].toString();
    });

    return await postLogin(
      hiddenInput['userAgent']!,
      jSessionId,
      username,
      password,
      hiddenInput['lt']!,
      hiddenInput['execution']!,
      hiddenInput['_eventId']!,
      hiddenInput['ipAddress']!,
      hiddenInput['submit']!,
    );
  }

  Future<String> postLogin(
    String userAgent,
    String jSessionId,
    String username,
    String password,
    String token,
    String execution,
    String eventId,
    String ipAddress,
    String submit,
  ) async {
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
        'username=$username&password=$password&lt=$token&execution=$execution&_eventId=$eventId&ipAddress=$ipAddress&userAgent=$userAgent&submit=$submit&ipAddress=$ipAddress&userAgent=$userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$jSessionId?$query'),
        headers: headers,
        body: data);

    String agimus = res.headers['set-cookie']!.substring(7, 81);
    String location = res.headers['location']!;

    return await getVtTicket(userAgent, agimus, location);
  }

  Future<String> getVtTicket(
      String userAgent, String agimus, String location) async {
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

    String jSessionId = scraper
        .parse(res.body)
        .getElementsByTagName('link')[2]
        .attributes['href']!
        .substring(74, 106);

    return await getVt(userAgent, jSessionId, agimus);
  }

  Future<String> getVt(
      String userAgent, String jSessionId, String agimus) async {
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

    return res.body;
  }

  Future<String> getNextPage(
      String userAgent, String jSessionId, String agimus) async {
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
        'org.apache.myfaces.trinidad.faces.FORM=redirectForm&_noJavaScript=false&javax.faces.ViewState=%211&source=redirectForm%3AsemSuiv';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    return res.body;
  }

  Future<String> getPreviousPage(
      String userAgent, String jSessionId, String agimus) async {
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
        'org.apache.myfaces.trinidad.faces.FORM=redirectForm&_noJavaScript=false&javax.faces.ViewState=%211&source=redirectForm%3AsemPrec';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    return res.body;
  }
}

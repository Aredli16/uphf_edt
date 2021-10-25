import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as scraper;

class HttpRequestHelper {
  HttpRequestHelper._privateConstructor();
  static final HttpRequestHelper instance =
      HttpRequestHelper._privateConstructor();

  String _jSessionId = '';
  String _userAgent = '';
  String _agimus = '';
  String _username = '';
  String _password = '';
  String _token = '';
  String _execution = '';
  String _eventId = '';
  String _ipAddress = '';
  String _submit = '';
  String _facesForm = '';
  String _noJavaScript = '';
  String _viewState = '';

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

    _jSessionId = res.headers['set-cookie']!.substring(11, 43);

    Map<String, String> hiddenInput = {};
    scraper
        .parse(res.body)
        .getElementsByClassName('row btn-row')[0]
        .querySelectorAll('input')
        .forEach((element) {
      hiddenInput[element.attributes['name'].toString()] =
          element.attributes['value'].toString();
    });

    _username = username;
    _password = password;
    _userAgent = hiddenInput['userAgent']!;
    _token = hiddenInput['lt']!;
    _execution = hiddenInput['execution']!;
    _eventId = hiddenInput['_eventId']!;
    _ipAddress = hiddenInput['ipAddress']!;
    _submit = hiddenInput['submit']!;
    return await postLogin();
  }

  Future<String> postLogin() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://cas.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': _userAgent,
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
      'Cookie': 'JSESSIONID=$_jSessionId',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'service':
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var data =
        'username=$_username&password=$_password&lt=$_token&execution=$_execution&_eventId=$_eventId&ipAddress=$_ipAddress&userAgent=$_userAgent&submit=$_submit&ipAddress=$_ipAddress&userAgent=$_userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$_jSessionId?$query'),
        headers: headers,
        body: data);

    _agimus = res.headers['set-cookie']!.substring(7, 81);
    String location = res.headers['location']!;

    return await getVtTicket(location);
  }

  Future<String> getVtTicket(String location) async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': _userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-site',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer': 'https://cas.uphf.fr/',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'AGIMUS=$_agimus',
      'Accept-Encoding': 'gzip',
    };

    var res = await http.get(Uri.parse(location), headers: headers);

    _jSessionId = scraper
        .parse(res.body)
        .getElementsByTagName('link')[2]
        .attributes['href']!
        .substring(74, 106);

    return await getVt();
  }

  Future<String> getVt() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': _userAgent,
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Sec-GPC': '1',
      'Sec-Fetch-Site': 'same-site',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-User': '?1',
      'Sec-Fetch-Dest': 'document',
      'Referer': 'https://cas.uphf.fr/',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$_jSessionId; AGIMUS=$_agimus',
      'Accept-Encoding': 'gzip',
    };

    var res = await http.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml;jsessionid=$_jSessionId'),
        headers: headers);

    _getNewHiddenInputState(res.body);

    return res.body;
  }

  Future<String> getNextPage() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://vtmob.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': _userAgent,
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
      'Cookie': 'JSESSIONID=$_jSessionId; AGIMUS=$_agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'org.apache.myfaces.trinidad.faces.FORM=$_facesForm&_noJavaScript=$_noJavaScript&javax.faces.ViewState=$_viewState&source=redirectForm%3AsemSuiv';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    _getNewHiddenInputState(res.body);

    return res.body;
  }

  Future<String> getPreviousPage() async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
      'Origin': 'https://vtmob.uphf.fr',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': _userAgent,
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
      'Cookie': 'JSESSIONID=$_jSessionId; AGIMUS=$_agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'org.apache.myfaces.trinidad.faces.FORM=$_facesForm&_noJavaScript=$_noJavaScript&javax.faces.ViewState=$_viewState&source=redirectForm%3AsemPrec';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    _getNewHiddenInputState(res.body);

    return res.body;
  }

  void _getNewHiddenInputState(String html) {
    List<Element> hiddenInput = scraper
        .parse(html)
        .getElementById('redirectForm')!
        .querySelectorAll('input');
    _facesForm = hiddenInput[5].attributes['value']!;
    _noJavaScript = hiddenInput[6].attributes['value']!;
    _viewState = hiddenInput[7].attributes['value']!;
  }
}

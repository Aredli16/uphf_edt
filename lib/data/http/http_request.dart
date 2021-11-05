import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as scraper;

/// HttpClient wrapper for the scraper
///
/// This is a workaround for the fact that the scraper library doesn't support
///
/// http requests
class HttpRequestHelper {
  /// Private constructor for singleton pattern implementation of the class [HttpRequestHelper]
  HttpRequestHelper._privateConstructor();

  /// Instance of the http client for the scraper library to use for http requests to the web server
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

  /// Get the JSESSIONID cookie value from the response
  ///
  /// This is used to keep the session alive
  ///
  /// [response] The response from the server
  ///
  /// Hidden inputs are collected from the response and used to build the next request
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

    if (res.statusCode != 200) {
      // Error during the request to the server (maybe the server is down) or the server returned an error
      throw Exception("Impossible de se connecter à l'hôte distant");
    }

    _jSessionId = res.headers['set-cookie']!.substring(11,
        43); // jSessionId is the first cookie in the response header (the JSESSIONID cookie)

    // hidden inputs are collected from the response and used to build the next request (hidden inputs are used to keep the session alive)
    Map<String, String> hiddenInput = {};
    scraper
        .parse(res.body)
        .getElementsByClassName('row btn-row')[0]
        .querySelectorAll('input')
        .forEach((element) {
      hiddenInput[element.attributes['name'].toString()] =
          element.attributes['value'].toString();
    });

    _username = username; // username is the username of the user
    _password = password; // password is the password of the user
    _userAgent = hiddenInput[
        'userAgent']!; // userAgent is the user agent of the http client
    _token =
        hiddenInput['lt']!; // lt is the token used to authenticate the user
    _execution = hiddenInput[
        'execution']!; // execution is the execution used to authenticate the user
    _eventId = hiddenInput[
        '_eventId']!; // eventId is the event id used to authenticate the user
    _ipAddress =
        hiddenInput['ipAddress']!; // ipAddress is the ip address of the user
    _submit = hiddenInput[
        'submit']!; // submit is the submit value used to authenticate the user

    return await _postLogin();
  }

  /// Login the user into the server
  ///
  /// [username] The username of the user
  /// [password] The password of the user
  ///
  /// Agimus is used to keep the session alive too
  Future<String> _postLogin() async {
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

    // hiddentInput are used here
    var data =
        'username=$_username&password=$_password&lt=$_token&execution=$_execution&_eventId=$_eventId&ipAddress=$_ipAddress&userAgent=$_userAgent&submit=$_submit&ipAddress=$_ipAddress&userAgent=$_userAgent';

    var res = await http.post(
        Uri.parse(
            'https://cas.uphf.fr/cas/login;jsessionid=$_jSessionId?$query'),
        headers: headers,
        body: data);

    if (res.statusCode != 302) {
      // Error during the request to the server (maybe username and password are incorrect) or the server returned an error
      throw Exception("Impossible de d'identifier l'utilisateur");
    }

    _agimus = res.headers['set-cookie']!.substring(
        7, 81); // agimus is the second cookies used to keep the session alive
    String location = res.headers[
        'location']!; // location of the next page is indicated into the response header

    return await _getVtTicket(location);
  }

  /// Get the vt ticket from the server
  ///
  /// [location] The location of the next page
  ///
  /// Get a new JSESSIONID cookie into html page
  Future<String> _getVtTicket(String location) async {
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

    if (res.statusCode != 200) {
      // Error during the request to the server
      throw Exception('Impossible de récuperer le ticket de connexion');
    }

    _jSessionId = scraper
        .parse(res.body)
        .getElementsByTagName('link')[2]
        .attributes['href']!
        .split(';')[1]
        .substring(11, 43); // Get the new jSessionId from html page

    return await _getVt();
  }

  /// Get the vt html page from the server
  ///
  /// Get the new inputs states from the next request
  ///
  /// nextPage, previousPage, specificPage need this inputs to navigate in the server
  ///
  /// Return the vt html page
  Future<String> _getVt() async {
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

    if (res.statusCode != 200) {
      // Error during the request to the server
      throw Exception("Impossible de récupérer l'emploi du temps");
    }

    try {
      // Try to get the new inputs states
      _getNewHiddenInputState(res.body);
    } catch (e) {
      // If the input state is not found, the server is not responding correctly
      throw Exception("Impossible de récupérer l'emploi du temps");
    }

    return res.body;
  }

  /// Get the inputs states into the html page
  ///
  /// Needed to navigate into vt page
  void _getNewHiddenInputState(String html) {
    List<Element> hiddenInput = scraper
        .parse(html)
        .getElementById('redirectForm')!
        .querySelectorAll('input');
    _facesForm = hiddenInput[5].attributes['value']!;
    _noJavaScript = hiddenInput[6].attributes['value']!;
    _viewState = hiddenInput[7].attributes['value']!;
  }

  /// Get the next page of the schedule
  ///
  /// Return the new html page
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

    // inputs states are needed to navigate in the server
    // the navigation is specified thanks to last parameter ("source=semSuiv")
    var data =
        'org.apache.myfaces.trinidad.faces.FORM=$_facesForm&_noJavaScript=$_noJavaScript&javax.faces.ViewState=$_viewState&source=redirectForm%3AsemSuiv';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 200) {
      // Error during the request to the server
      try {
        // Try to get initial page and reconnect the user
        return await getCas(_username, _password);
      } catch (e) {
        // Error during the request to the server
        throw Exception('Erreur durant la récupération de la prochaine page');
      }
    }

    try {
      // Try to get the new inputs states
      _getNewHiddenInputState(res.body);
    } catch (e) {
      // Error during the request to the server
      throw Exception('Erreur durant la récupération de la prochaine page');
    }

    return res.body;
  }

  /// Get the previous page of the schedule
  ///
  /// Return the new html page
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

    // inputs states are needed to navigate in the server
    // the navigation is specified thanks to last parameter ("source=semPrec")
    var data =
        'org.apache.myfaces.trinidad.faces.FORM=$_facesForm&_noJavaScript=$_noJavaScript&javax.faces.ViewState=$_viewState&source=redirectForm%3AsemPrec';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode != 200) {
      // Error during the request to the server
      try {
        // Try to get initial page and reconnect the user
        return await getCas(_username, _password);
      } catch (e) {
        // Error during the request to the server
        throw Exception('Erreur durant la récupération de la page precédente');
      }
    }

    try {
      // Try to get the new inputs states
      _getNewHiddenInputState(res.body);
    } catch (e) {
      // Error during the request to the server
      throw Exception('Erreur durant la récupération de la page precédente');
    }

    return res.body;
  }

  /// Get a specific page thanks to the date
  ///
  /// Format of the date is dd/mm/yyyy
  ///
  /// Return the html page
  Future<String> getASpecificDay(String date) async {
    var headers = {
      'Connection': 'keep-alive',
      'Cache-Control': 'max-age=0',
      'Upgrade-Insecure-Requests': '1',
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

    var res = await http.get(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers);

    if (res.statusCode != 200) {
      // Error during the request
      try {
        // Try to get initial page and reconnect user
        return await getCas(_username, _password);
      } catch (e) {
        // Errro during the reconnection
        throw Exception(
            'Erreur lors du chargement de la page à la date: $date');
      }
    }

    Map<String, String> hiddenInputCal =
        {}; // Hidden input of the calendar page

    try {
      // Try to scrap the hiddenInputCal
      scraper
          .parse(res.body)
          .getElementById('formCal')!
          .querySelectorAll('input')
          .forEach((element) {
        if (element.attributes['value'] != null) {
          hiddenInputCal[element.attributes['name']!] =
              element.attributes['value']!;
        }
      });
    } catch (e) {
      // Error during the scrap
      throw Exception('Erreur lors du chargement de la page à la date: $date');
    }

    return await postDayCalendar(
      hiddenInputCal['org.apache.myfaces.trinidad.faces.FORM']!,
      hiddenInputCal['_noJavaScript']!,
      hiddenInputCal['javax.faces.ViewState']!,
      date,
    );
  }

  /// Get the specific day of the schedule
  ///
  /// Return the html page
  Future<String> postDayCalendar(
      String facesFormCalendar,
      String noJavaScriptCalendar,
      String viewStateCalendar,
      String date) async {
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
          'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml',
      'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Cookie': 'JSESSIONID=$_jSessionId; AGIMUS=$_agimus',
      'Accept-Encoding': 'gzip',
    };

    var data =
        'formCal:date=$date&org.apache.myfaces.trinidad.faces.FORM=$facesFormCalendar&_noJavaScript=$noJavaScriptCalendar&javax.faces.ViewState=$viewStateCalendar&source=formCal:hiddenLink';

    var res = await http.post(
        Uri.parse(
            'https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/calendar.xhtml'),
        headers: headers,
        body: data);

    if (res.statusCode == 200) {
      // Error during the request
      try {
        // Try to get initial page and reconnect user
        return await getCas(_username, _password);
      } catch (e) {
        // Errro during the reconnection
        throw Exception(
            "Impossible d'envoyer les informations de date au serveur distant");
      }
    }

    // Return the html page with the vt method
    return await _getVt();
  }

  /// Used to check if user is log or not
  ///
  /// Return true if user is log
  ///
  /// Return false if user is not log
  Future<bool> isLog(String username, String password) async {
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

    var jSessionId = res.headers['set-cookie']!.substring(11, 43);

    Map<String, String> hiddenInput = {};
    scraper
        .parse(res.body)
        .getElementsByClassName('row btn-row')[0]
        .querySelectorAll('input')
        .forEach((element) {
      hiddenInput[element.attributes['name'].toString()] =
          element.attributes['value'].toString();
    });

    // If the status code is 302, the user is log because the response want to redirect the user to the vt page
    return await _statusCodePostLogin(
          username,
          password,
          hiddenInput['userAgent']!,
          hiddenInput['lt']!,
          hiddenInput['execution']!,
          hiddenInput['_eventId']!,
          hiddenInput['ipAddress']!,
          hiddenInput['submit']!,
          jSessionId,
        ) ==
        302;
  }

  /// Try to connect and check if the user is log
  ///
  /// Return the status code after the login
  ///
  /// 302 = Redirect => user is log
  Future<int> _statusCodePostLogin(
    String username,
    String password,
    String userAgent,
    String token,
    String execution,
    String eventId,
    String ipAddress,
    String submit,
    String jSessionId,
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

    return res.statusCode;
  }
}

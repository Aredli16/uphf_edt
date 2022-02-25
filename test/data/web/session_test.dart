import 'package:flutter_test/flutter_test.dart';
import 'package:uphf_edt/data/web/session.dart';

void main() {
  group("Data managment", () {
    test(
      'Given response headers When updateJSessionIdFromHeaders(Map<String, String> headers) is called Then jSessionId is update',
      () {
        // Given
        const responseHeaders = {
          'keep-alive': 'timeout=5, max=100',
          'pragma': 'no-cache',
          'server': 'Apache/2.4.25 (Debian)',
          'set-cookie':
              'JSESSIONID=7572E9644BF5E9D976CBF83E20601C46; Path=/cas/; Secure; HttpOnly',
          'vary': 'Accept-Encoding',
        };

        // When
        Session.instance.updateJSessionIdFromHeaders(responseHeaders);

        // Then
        expect(Session.instance.jSessionId, '7572E9644BF5E9D976CBF83E20601C46');
      },
    );

    test(
      'Given html source code When updateJSessionIdFromHTMLPage(String html) is called Then jSessionId is update',
      () {
        // Given
        const html =
            '<html><head><link class=mtn-class-td";jsessionid=7572E9644BF5E9D976CBF83E20601C46"/></head></html>';

        // When
        Session.instance.updateJSessionIdFromHTMLPage(html);

        // Then
        expect(Session.instance.jSessionId, '7572E9644BF5E9D976CBF83E20601C46');
      },
    );

    test(
      'Given response headers When updateAgimusFromHeaders(Map<String, String> headers) is called Then agimus is update',
      () {
        // Given
        const responseHeaders = {
          'keep-alive': 'timeout=5, max=100',
          'pragma': 'no-cache',
          'server': 'Apache/2.4.25 (Debian)',
          'set-cookie':
              'AGIMUS=TRACE-25014-AmKaQNV39YZLdFCRcgRqu6OxYcIQWOAezsSYmqZPaebEdOpIOg-cas.uphf.fr; Domain=.uphf.fr; Expires=Mon, 28-Feb-2022 16:58:48 GMT; Path=/; CASPRIVACY=""; CASTGC=TGT-72026-46cRFhFpoedCBE3uMG0gm2l0p3gtsQZGnzPEIskHrm1Xu4ce2E-cas.uphf.fr;',
        };

        // When
        Session.instance.updateAgimusFromHeaders(responseHeaders);

        // Then
        expect(Session.instance.agimus,
            'TRACE-25014-AmKaQNV39YZLdFCRcgRqu6OxYcIQWOAezsSYmqZPaebEdOpIOg-cas.uphf.fr');
      },
    );

    test(
      'Given html source code When updateHiddenInputFromHTMLPage(String html) is called Then lt token, ipAddress and userAgent are update',
      () {
        // Given
        const html =
            '<html><body><form><input type="hidden" name="lt" value="LT-7572E9644BF5E9D976CBF83E20601C46"/><input type="hidden" name="ipAddress" value="89.67.23.16"/><input type="hidden" name="userAgent" value="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36"/></form></body></html>';

        // When
        Session.instance.updateHiddenInputFromHTMLPage(html);

        // Then
        expect(Session.instance.lt, 'LT-7572E9644BF5E9D976CBF83E20601C46');
        expect(Session.instance.ipAddress, '89.67.23.16');
        expect(Session.instance.userAgent,
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36');
      },
    );

    test(
      'Given html source code When updateViewStateFromHTMLPage(String html) is called Then viewState is update',
      () {
        // Given
        const html =
            '<html><body><form><input type="hidden" name="javax.faces.ViewState" value="!1"/></form></body></html>';

        // When
        Session.instance.updateViewStateFromHTMLPage(html);

        // Then
        expect(Session.instance.viewState, '!1');
      },
    );
  });
}

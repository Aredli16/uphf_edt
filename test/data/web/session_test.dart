import 'package:flutter_test/flutter_test.dart';
import 'package:uphf_edt/data/web/session.dart';

void main() {
  group("Data managment", () {
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

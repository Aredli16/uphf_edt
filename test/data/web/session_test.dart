import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:uphf_edt_v2/data/web/session.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  group(
    'Data processing',
    () {
      test(
        'Given response headers When updatejSessionIdFromHeaders() is called Then jSessionId is update',
        () async {
          // Given
          final responseHeaders = {
            'set-cookie':
                'JSESSIONID=0C52D0EB72265EE4CFE28C680015B88D; Path=/cas/; Secure; HttpOnly'
          };

          // When
          Session.instance.updatejSessionIdFromHeaders(responseHeaders);

          // Then
          expect(
              Session.instance.jSessionId, '0C52D0EB72265EE4CFE28C680015B88D');
        },
      );

      test(
        'Given html response When updateHiddenInputsFromHTML() is called Then hidden inputs are update',
        () {
          // Given
          const html = ''' 
        <form id="fm1" class="fm-v clearfix" action="/cas/login" method="post">
          <div id="box-content">
          <div id="login"> <!-- suppression de class="box fl-panel"-->
              <div class="form-group">
              <label for="username" class="fl-label">Identifiant :</label>
                <script>
                function cleanupUsername(elt) {
                    elt.value = elt.value.toLowerCase().replace(/[()*]/g, '');
                }
              </script>
                    <input id="username" name="username" class="required" tabindex="1" class="form-control" onchange="cleanupUsername(this)" accesskey="i" type="text" value="" size="25" autocomplete="off"/>
              </div>
              <div class="form-group">
                <label for="password" class="fl-label">Mot de passe :</label>
                <input id="password" name="password" class="required" tabindex="2" class="form-control" accesskey="m" type="password" value="" size="25" autocomplete="off"/>
              </div>
              <div class="row btn-row">
                <input type="hidden" name="lt" value="LT-81373-HJAcIXbHLZWMEQDHFH3RohNK6ouuDZ-cas.uphf.fr" />
                  <input type="hidden" name="execution" value="e2s1" />
                  <input type="hidden" name="_eventId" value="submit" />
              <!-- addon token manager -->       
                  <input type="hidden" name="ipAddress" value="86.67.140.168"/>
                <input type="hidden" name="userAgent" value="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36" />
                <!-- Fin addon token manager --> 
                  <input class="btn btn-submit" name="submit" accesskey="l" value="Connexion" tabindex="4" type="submit" />
                  <input class="btn btn-reset" name="reset" accesskey="c" value="EFFACER" tabindex="5" type="reset" />
                <!-- IF USE ESUP TokenManager : start -->
                <input type="hidden" name="ipAddress" value="86.67.140.168"/>
                <input type="hidden" name="userAgent" value="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36" />
                  <!-- IF USE ESUP TokenManager : stop -->
              </div>
          </div> <!--fin div box login-->
          <div id="box-info" class="hidden-xs">
          <ul >
          <li ><a href=https://sesame.uphf.fr/identifiants.html target='_blank'>Identifiants oubliés</a></li>
          <li ><a href=https://sesame.uphf.fr/activation.html target='_blank'>Activation de mon compte</a></li>
          <li ><a href=https://sesame.uphf.fr/aide.html target='_blank'>Besoin d'aide ?</a></li>
          </ul>
          </div><!-- fin box-info -->
          <div class="clear">&nbsp;</div>
          </div><!--fin div box-content-->
          <div id="warning-conf"> <p><b>Pour des raisons de sécurité</b>, veuillez vous déconnecter et fermer votre navigateur lorsque vous avez fini d'accéder aux services authentifiés.</p><p>Vos identifiants sont strictement <b>confidentiels</b> et ne doivent en aucun cas être transmis à une tierce personne.</p></div>
        </form>
      ''';

          // When
          Session.instance.updateHiddenInputsFromHTML(html);

          // Then
          expect(Session.instance.lt,
              'LT-81373-HJAcIXbHLZWMEQDHFH3RohNK6ouuDZ-cas.uphf.fr');
          expect(Session.instance.execution, 'e2s1');
          expect(Session.instance.eventId, 'submit');
          expect(Session.instance.ipAddress, '86.67.140.168');
          expect(Session.instance.userAgent,
              'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36');
        },
      );

      test(
        'Given response headers When updateAgimusFromHeaders() is called Then agimus is update',
        () {
          // Given
          final responseHeaders = {
            'set-cookie':
                'AGIMUS=TRACE-24950-Q6QEh1Dy0ReFRlobWF5UVJeZDabQLes0JWnZ7Ynrou6aicuueV-cas.uphf.fr; Domain=.uphf.fr; Expires=Sat, 26-Feb-2022 15:33:44 GMT; Path=/'
          };

          // When
          Session.instance.updateAgimusFromHeaders(responseHeaders);

          // Then
          expect(Session.instance.agimus,
              'TRACE-24950-Q6QEh1Dy0ReFRlobWF5UVJeZDabQLes0JWnZ7Ynrou6aicuueV-cas.uphf.fr');
        },
      );

      test(
        'Given response location url When updateTicketFromUrl() is called Then ticket is update',
        () {
          // Given
          const url =
              "https://vtmob.uphf.fr/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml?ticket=ST-117206-rjdhBAWFEb76F0qJYMQF-cas.uphf.fr";

          // When
          Session.instance.updateTicketFromUrl(url);

          // Then
          expect(Session.instance.ticket,
              'ST-117206-rjdhBAWFEb76F0qJYMQF-cas.uphf.fr');
        },
      );

      test(
        'Given html response When updateJavaxFacesViewStateHiddenInputFromHTML() is called Then javaxFacesViewState hidden inputs are update',
        () {
          // Given
          const html = '''
        </div><form id="redirectForm" name="redirectForm" method="POST" onkeypress="return _submitOnEnter(event,'redirectForm');" 
        action="/esup-vtclient-up4/stylesheets/mobile/welcome.xhtml"><input id="redirectForm:semPrec" name="redirectForm:semPrec" 
        type="submit" onclick="submitForm('redirectForm',0,{source:'redirectForm:semPrec'});return false;" style="visibility:hidden;">
        <input id="redirectForm:semSuiv" name="redirectForm:semSuiv" type="submit" onclick="submitForm('redirectForm',0,{source:'redirectForm:semSuiv'});
        return false;" style="visibility:hidden;"><input id="redirectForm:resetJ" name="redirectForm:resetJ" type="submit" 
        onclick="submitForm('redirectForm',0,{source:'redirectForm:resetJ'});return false;" style="visibility:hidden;"><input id="redirectForm:goCal" name="
        redirectForm:goCal" type="submit" onclick="submitForm('redirectForm',0,{source:'redirectForm:goCal'});return false;" style="visibility:hidden;">
        <input id="redirectForm:changetype" name="redirectForm:changetype" type="submit" onclick="submitForm('redirectForm',0,{source:'redirectForm:change
        type'});return false;" style="visibility:hidden;"><input type="hidden" name="org.apache.myfaces.trinidad.faces.FORM" value="redirectForm">
        <input type="hidden" name="_noJavaScript" value="false"><span id="tr_redirectForm_Postscript"><input type="hidden" name="javax.faces.ViewState" value="!1"><
        script type="text/javascript">function _redirectFormValidator(f,s){return _validateInline(f,s);}var redirectForm_SF={};</script></span><script type
        ="text/javascript">_submitFormCheck();</script></form>
      ''';

          // When
          Session.instance.updateJavaxFacesViewStateHiddenInputFromHTML(html);

          // Then
          expect(Session.instance.javaxFacesViewState, '!1');
        },
      );

      test(
        'Given html page When updateJSessionIdFromHTML() is called Then the jSessionIs is update',
        () {
          // Given
          const html = ''' 
        &#9;
        &#9;<link rel="stylesheet" href="jquery.mobile-1.3.1.css">
        &#9;<link rel="stylesheet" href="calendar.css">
        &#9;<script src="jquery.js"></script>
        &#9;<script src="jquery.mobile-1.3.1.js"></script><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html dir="ltr" lang="fr"><head><title>Emploi du temps</title><meta name="generator" content="Apache MyFaces Trinidad"><link rel="stylesheet" charset="UTF-8" type="text/css" href="/esup-vtclient-up4/adf/styles/cache/minimal-ngipes-ltr-cmp.css;jsessionid=4C7AFC0B59937C1315BBC0E41C353536">
        &#9;<link rel="apple-touch-icon" href="/media/images/blank-icon.png">
      ''';

          // When
          Session.instance.updateJSessionIdFromHTML(html);

          // Then
          expect(
              Session.instance.jSessionId, '4C7AFC0B59937C1315BBC0E41C353536');
        },
      );
    },
  );
}

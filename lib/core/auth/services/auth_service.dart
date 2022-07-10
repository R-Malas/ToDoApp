import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthServiceV2 {
  // auth urls from todoist api
  static final authorizationEndpoint =
      Uri.parse('https://todoist.com/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://todoist.com/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:3000/redirect_url');
  static final revokeUrl =
      Uri.parse('https://api.todoist.com/sync/v8/access_tokens/revoke');
  static const clientId = 'e1f57971cf974348b6addfb6bc3522b0';
  static const secret = '729b9281b6684aad893379bf47930a7e';
  static const scope = [
    'task:add',
    'data:read',
    'data:read_write',
    'data:delete'
  ];
  static const verificationToken = '17686_6eeaf1c36f7e8a696db14b20';
  static const testToken = '0e18dc7b5d90873ec7b903ba4b8450878bf95964';

// final credentialsFile = File('~/.myapp/credentials.json'); // use shared pref instead for test then replace it with secure storage.
  late final SharedPreferences _preferences;

  AuthServiceV2(this._preferences);

  Future<oauth2.Client> createClient() async {
    /// Either load an OAuth2 client from saved credentials or authenticate a new
    /// one.
    var _sharedPref = _preferences;
    var exists = _sharedPref.getBool('isAuthenticated') ?? false;
    debugPrint('isAuthenticated $exists');

    // If the OAuth2 credentials have already been saved from a previous run, we
    // just want to reload them.
    if (exists) {
      var credentials = oauth2.Credentials.fromJson(
          _sharedPref.getString('credentials') ?? '{}');
      debugPrint('credentials from store $credentials');
      return oauth2.Client(credentials, identifier: clientId, secret: secret);
    }

    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: secret, delimiter: ',');

    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.
    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: scope);

    debugPrint('authorizationUrl from grant ${authorizationUrl.toString()}');

    // Redirect the resource owner to the authorization URL. Once the resource
    // owner has authorized, they'll be redirected to `redirectUrl` with an
    // authorization code. The `redirect` should cause the browser to redirect to
    // another URL which should also have a listener.
    //
    // `redirect` and `listen` are not shown implemented here. See below for the
    // details.
    // await redirect(authorizationUrl);
    // var responseUrl = await listen(redirectUrl);

    Uri responseUrl = Uri();

    // WebView(
    //   javascriptMode: JavascriptMode.unrestricted,
    //   initialUrl: authorizationUrl.toString(),
    //   navigationDelegate: (navReq) {
    //     if (navReq.url.startsWith(redirectUrl.toString())) {
    //       responseUrl = Uri.parse(navReq.url);
    //       debugPrint('responseUrl.queryParameters ${responseUrl.queryParameters}');
    //       return NavigationDecision.prevent;
    //     }
    //     return NavigationDecision.navigate;
    //   },
    // );

    if (await canLaunchUrl(authorizationUrl)) {
      if (!await launchUrl(authorizationUrl,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true, enableDomStorage: true))) {
        return throw Exception('Error while lunching web view!');
      }
    }
    bool isReturned = false;

    uriLinkStream.takeWhile((uri) {
      return isReturned =
          uri != null && uri.toString().startsWith(redirectUrl.toString());
    }).listen((Uri? uri) async {
      debugPrint('listening to url redirections $uri');
      if (uri != null && uri.toString().startsWith(redirectUrl.toString())) {
        responseUrl = uri;
        debugPrint(
            'responseUrl.queryParameters ${responseUrl.queryParameters}');
      }
    });

    // Once the user is redirected to `redirectUrl`, pass the query parameters to
    // the AuthorizationCodeGrant. It will validate them and extract the
    // authorization code to create a new Client.
    if (isReturned) {
      return grant.handleAuthorizationResponse(responseUrl.queryParameters);
    }
    return await Future.delayed(const Duration(seconds: 30));
  }
}

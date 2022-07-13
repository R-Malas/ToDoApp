import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:to_do_list/core/auth/providers/auth_notifier.dart';
import 'package:to_do_list/core/auth/services/auth_service.dart';
import 'package:to_do_list/core/routing/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sign in', style: Theme.of(context).textTheme.headline3),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      Provider.of<AuthNotifier>(context, listen: false).signIn(
                          (authorizationUrl) => authorizationCallbackStream(
                              authorizationUrl, context));
                      debugPrint('user Signed in');
                    },
                    child: const Text('Sign in'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uri> authorizationCallbackStream(Uri authorizationUrl, context) async {
    final completer = Completer<Uri>();
    debugPrint('launching Web view');

    if (await canLaunchUrl(authorizationUrl)) {
      if (!await launchUrl(authorizationUrl,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true, enableDomStorage: true))) {
        Navigator.pushNamed(context, AppRoutes.error,
            arguments: 'Error while lunching web view!');
      }
    } else {
      Navigator.pushNamed(context, AppRoutes.error,
          arguments: 'error while lunching url!');
    }

    // ... check initialLink
    final initialLink = await getInitialLink();
    debugPrint('initial link ${initialLink.toString()}');

    // Attach a listener to the stream
    _sub = uriLinkStream.listen((Uri? uri) {
      debugPrint('listening to url redirections $uri');
      if (uri != null &&
          uri.toString().startsWith(AuthService.redirectUrl.toString())) {
        completer.complete(uri);
        debugPrint('responseUrl.queryParameters ${uri}');
      }
    }, onError: (error) => debugPrint('error in uriLinkStream'));

    debugPrint('after uriLinkStream');
    return completer.future;
  }
}

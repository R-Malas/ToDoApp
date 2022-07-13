import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:to_do_list/core/auth/services/auth_service.dart';
import 'package:to_do_list/core/routing/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  final Uri authorizationUri;
  final void Function(Uri redirectUrl) onAuthCodeRedirectAttempt;

  const WebViewStack(
      {Key? key,
      required this.authorizationUri,
      required this.onAuthCodeRedirectAttempt})
      : super(key: key);

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
                initialUrl: widget.authorizationUri.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                userAgent: 'random',
                navigationDelegate: (navReq) {
                  debugPrint('on navigation $navReq');
                  if (navReq.url
                      .startsWith(AuthService.redirectUrl.toString())) {
                    widget.onAuthCodeRedirectAttempt(Uri.parse(navReq.url));
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login, (route) => false, arguments: {'isRedirected':true});
                      debugPrint('poped from webview ABDULLA');
                    }
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
                onPageStarted: (url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onProgress: (progress) {
                  setState(() {
                    loadingPercentage = progress;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                }),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}

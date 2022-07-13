import 'package:flutter/material.dart';
import 'package:to_do_list/core/routing/app_routes.dart';
import 'package:to_do_list/screens/add_to_do/add_to_do_screen.dart';
import 'package:to_do_list/screens/auth/login/login_screen.dart';
import 'package:to_do_list/screens/error_screen/error_screen.dart';
import 'package:to_do_list/screens/home/home_screen.dart';
import 'package:to_do_list/screens/splash/splash_screen.dart';
import 'package:to_do_list/shared_widgets/web_view_stack/web_view_stack.dart';

class RouteManagement {
  RouteManagement._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var routeName = settings.name;

    switch (routeName) {
      case AppRoutes.root:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.loginRedirects:
        if (settings.arguments != null) {
          Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (_) => WebViewStack(
                  authorizationUri: args['authorizationUri'],
                  onAuthCodeRedirectAttempt:
                      args['onAuthCodeRedirectAttempt']));
        }
        return MaterialPageRoute(
            builder: (_) =>
                const ErrorScreen(errorMessage: 'Something went wrong!'));
      case AppRoutes.todos:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddToDoScreen());
      case AppRoutes.error:
        return MaterialPageRoute(
            builder: (_) => ErrorScreen(
                  errorMessage: settings.arguments != null
                      ? settings.arguments as String
                      : 'Something went wrong!',
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => const ErrorScreen(
                errorMessage: 'Oops! looks like you took a wrong turn.'));
    }
  }
}

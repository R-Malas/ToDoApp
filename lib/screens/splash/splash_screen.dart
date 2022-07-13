import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/auth/providers/auth_notifier.dart';
import 'package:to_do_list/screens/auth/login/login_screen.dart';
import 'package:to_do_list/screens/error_screen/error_screen.dart';
import 'package:to_do_list/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var authState = context.watch<AuthNotifier>().authState;

    return Scaffold(
      body: SafeArea(
        child: checkIsAuthenticated(authState.isAuthenticated,
            authState.isLoading, authState.hasError, authState.errorMessage),
      ),
    );
  }

  Widget checkIsAuthenticated(
      bool isLoggedIn, bool isLoading, bool hasError, String errorMessage) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      if (!hasError) {
        return isLoggedIn ? const HomeScreen() : const LoginScreen();
      } else {
        return ErrorScreen(errorMessage: errorMessage);
      }
    }

    // var authState = context.read<AuthNotifier>().authState;
    // if (!authState.hasError) {
    //   if (authState.isAuthenticated) {
    //     return const HomeScreen();
    //   } else {
    //     return const LoginScreen();
    //   }
    // } else {
    //   return ErrorScreen(errorMessage: authState.errorMessage);
    // }
  }
}

import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:provider/provider.dart';
import 'package:to_do_list/core/auth/services/auth_service.dart';
import 'package:to_do_list/screens/error_screen/error_screen.dart';
import 'package:to_do_list/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // QuestionsService questionService = const QuestionsService();
  // late final Future getCategories;
  // late final Future<oauth2.Client> client;

  @override
  void initState() {
    super.initState();
    // debugPrint('in splash screen init state');
    // set future request here to prevent multiple requests on each setState call across the app
    // getCategories = questionService.getCategories();
    // client = Provider.of<AuthServiceV2>(context).createClient();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: Provider.of<AuthServiceV2>(context).createClient(),
        builder: (context, snapshot) {
          debugPrint('in future builder');
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('future waiting');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                        //   child: Image.asset(
                        //     'assets/img/quiz.png',
                        //     width: 200,
                        //   ),
                        // ),
                        CircularProgressIndicator(
                          color: Colors.limeAccent,
                        ),
                      ],
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     const Text('Powered by',
                  //         style: TextStyle(color: Colors.white, fontSize: 12)),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 10.0),
                  //       child: Image.asset(
                  //         'assets/img/trivia_logo.png',
                  //         width: 90,
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            debugPrint('has error ${snapshot.error.toString()}');
            return ErrorScreen(errorMessage: snapshot.error.toString());
          } else if (snapshot.hasData) {
            var data = snapshot.data as oauth2.Client;
            debugPrint('credentials $data');
            // Provider.of<SharedPreferences>(context)
            //     .setString('credentials', data.credentials.toJson());
            return const HomeScreen();
          } else {
            debugPrint('has some error Something went wrong!');
            return const ErrorScreen(errorMessage: 'Something went wrong!');
          }
        },
      ),
    ));
  }
}

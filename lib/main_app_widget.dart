import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/routing/route_management.dart';
import 'package:to_do_list/core/translations/generated/l10n.dart';
import 'package:to_do_list/core/translations/providers/lang_change_notifier.dart';
import 'package:to_do_list/screens/splash/splash_screen.dart';

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To Do List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        onGenerateRoute: RouteManagement.generateRoute,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          Translations.delegate
        ],
        supportedLocales: Translations.delegate.supportedLocales,
        locale: Provider.of<LanguageChangeNotifier>(context).currentLang);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/db/db_main.dart';
import 'package:to_do_list/core/providers/db_change_notifier.dart';
import 'package:to_do_list/core/providers/lang_change_notifier.dart';
import 'package:to_do_list/route_management.dart';
import 'package:to_do_list/screens/home/home_screen.dart';
import 'package:to_do_list/translations/generated/l10n.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider.value(value: MyDatabase()),
      ChangeNotifierProxyProvider<MyDatabase, DbChangeNotifier>(
          create: (context) => DbChangeNotifier(),
          update: (context, db, notifier) {
            return notifier!
              ..initTodoDb(db)
              ..getTaskStream();
          }),
      FutureProvider<SharedPreferences?>(
          create: (_) async => await SharedPreferences.getInstance(),
          updateShouldNotify: (prev, curr) => prev != curr && curr != null,
          initialData: null,
          lazy: false),
      ChangeNotifierProxyProvider<SharedPreferences?, LanguageChangeNotifier>(
          lazy: true,
          create: (context) => LanguageChangeNotifier(),
          update: (context, sharedPref, notifier) {
            if (sharedPref == null) return notifier!;
            return notifier!
              ..initSharedPref(
                  Provider.of<SharedPreferences?>(context, listen: false));
          }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To Do List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
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

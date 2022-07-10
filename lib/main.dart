import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:to_do_list/core/auth/services/auth_service.dart';
import 'package:to_do_list/core/db/db_main.dart';
import 'package:to_do_list/core/db/providers/db_change_notifier.dart';
import 'package:to_do_list/core/translations/providers/lang_change_notifier.dart';
import 'package:to_do_list/main_app_widget.dart';

Future<void> main() async {
  // Wait until shared pref is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // init shared pref
  SharedPreferences _sharedPref = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: MyDatabase()),
      Provider.value(value: _sharedPref),
      Provider.value(value: AuthServiceV2(_sharedPref)),
      ChangeNotifierProxyProvider<MyDatabase, DbChangeNotifier>(
          create: (context) => DbChangeNotifier(),
          update: (context, db, notifier) {
            return notifier!
              ..initTodoDb(db)
              ..getTaskStream();
          }),
      ChangeNotifierProxyProvider<SharedPreferences?, LanguageChangeNotifier>(
          create: (context) => LanguageChangeNotifier(),
          update: (context, sharedPref, notifier) {
            if (sharedPref == null) return notifier!;
            return notifier!
              ..initSharedPref(
                  Provider.of<SharedPreferences?>(context, listen: false));
          }),
    ],
    child: const MainAppWidget(),
  ));
}

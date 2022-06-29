import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/translations/generated/l10n.dart';

class LanguageChangeNotifier extends ChangeNotifier {
  late SharedPreferences _pref;
  Locale _currentLang = Translations.delegate.supportedLocales.first;

  Locale get currentLang => _currentLang;

  LanguageChangeNotifier();

  void initSharedPref(SharedPreferences? preferences) {
    if (preferences == null) return;
    _pref = preferences;
    var storedLang = _pref.getString('selectedLang');
    if (storedLang != null) {
      _currentLang =
          Translations.delegate.supportedLocales[int.parse(storedLang)];
    }
    notifyListeners();
  }

  // initSharedPref() async {
  //   _pref = await SharedPreferences.getInstance();
  //   var storedLang = _pref.getString('selectedLang');
  //   debugPrint(storedLang);
  //   if (storedLang != null) {
  //     _currentLang = Locale(storedLang);
  //   }
  //   notifyListeners();
  // }

  void changeLang(Locale selectedLang) {
    _currentLang = selectedLang;

    _pref.setString(
        'selectedLang',
        Translations.delegate.supportedLocales
            .indexWhere((element) => element == _currentLang)
            .toString());
    notifyListeners();
  }
}

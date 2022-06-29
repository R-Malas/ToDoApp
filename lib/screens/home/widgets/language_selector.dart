import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/providers/lang_change_notifier.dart';
import 'package:to_do_list/translations/generated/l10n.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButton(
          value: Provider.of<LanguageChangeNotifier>(context).currentLang,
          isExpanded: true,
          items: Translations.delegate.supportedLocales
              .map((Locale locale) => DropdownMenuItem<Locale>(
                    child: Text(locale.languageCode),
                    value: locale,
                  ))
              .toList(),
          onChanged: (Locale? value) {
            Translations.load(value as Locale);
            Provider.of<LanguageChangeNotifier>(context, listen: false)
                .changeLang(value);
          }),
    );
  }
}

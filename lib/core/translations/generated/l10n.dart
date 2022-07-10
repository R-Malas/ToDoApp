// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Translations {
  Translations();

  static Translations? _current;

  static Translations get current {
    assert(_current != null,
        'No instance of Translations was loaded. Try to initialize the Translations delegate before accessing Translations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Translations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Translations();
      Translations._current = instance;

      return instance;
    });
  }

  static Translations of(BuildContext context) {
    final instance = Translations.maybeOf(context);
    assert(instance != null,
        'No instance of Translations present in the widget tree. Did you add Translations.delegate in localizationsDelegates?');
    return instance!;
  }

  static Translations? maybeOf(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  /// `ToDos`
  String get homeTitle {
    return Intl.message(
      'ToDos',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `{total, plural, zero{you don't have any tasks} one{ {remaining, plural, zero{no remaining tasks} one{1 remaining task} other{}} of 1 task} other{ {remaining, plural, zero{no remaining tasks} one{1 remaining task} other{{remaining} remaining tasks}} of {total} tasks}}`
  String remainingTasks(num total, Object remaining) {
    return Intl.plural(
      total,
      zero: 'you don\'t have any tasks',
      one:
          ' {remaining, plural, zero{no remaining tasks} one{1 remaining task} other{}} of 1 task',
      other:
          ' {remaining, plural, zero{no remaining tasks} one{1 remaining task} other{{remaining} remaining tasks}} of {total} tasks',
      name: 'remainingTasks',
      desc: '',
      args: [total, remaining],
    );
  }

  /// `Go Back`
  String get goBack {
    return Intl.message(
      'Go Back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get taskTextLbl {
    return Intl.message(
      'Task',
      name: 'taskTextLbl',
      desc: '',
      args: [],
    );
  }

  /// `New task`
  String get taskTextHint {
    return Intl.message(
      'New task',
      name: 'taskTextHint',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get newTaskTitle {
    return Intl.message(
      'Add New Task',
      name: 'newTaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get submitBtn {
    return Intl.message(
      'Add',
      name: 'submitBtn',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredFieldMsg {
    return Intl.message(
      'This field is required',
      name: 'requiredFieldMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid text`
  String get validTextErrMsg {
    return Intl.message(
      'Please enter valid text',
      name: 'validTextErrMsg',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Translations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

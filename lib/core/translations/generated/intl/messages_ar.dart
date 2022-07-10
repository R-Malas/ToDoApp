// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(total, remaining) =>
      "${Intl.plural(total, zero: 'ليس لديك أي مهمة', one: ' ${Intl.plural(remaining, zero: 'لم يتبقى أي مهمة', one: 'باقي مهمة واحدة', two: '', few: '', many: '', other: '')} من أصل مهمة واحدة', two: ' ${Intl.plural(remaining, zero: 'لم يتبقى أي مهمة', one: 'باقي مهمة واحدة', two: 'باقي مهمتان', few: '', many: '', other: '')} من أصل مهمتان', few: ' ${Intl.plural(remaining, zero: 'لم يتبقى أي مهمة', one: 'باقي مهمة واحدة', two: 'باقي مهمتان', few: 'باقي ${remaining} مهام', many: '', other: '')} من أصل ${total} مهام', many: ' ${Intl.plural(remaining, zero: 'لم يتبقى أي مهمة', one: 'باقي مهمة واحدة', two: 'باقي مهمتان', few: 'باقي ${remaining} مهام', many: 'باقي ${remaining} مهمة', other: 'باقي ${remaining} مهمة')} من أصل ${total} مهمة', other: ' ${Intl.plural(remaining, zero: 'لم يتبقى أي مهمة', one: 'باقي مهمة واحدة', two: 'باقي مهمتان', few: 'باقي ${remaining} مهام', many: 'باقي ${remaining} مهمة', other: 'باقي ${remaining} مهمة')} من أصل ${total} مهمة')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "goBack": MessageLookupByLibrary.simpleMessage("رجوع"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("قائمة المهام"),
        "newTaskTitle": MessageLookupByLibrary.simpleMessage("أضف مهمة جديدة"),
        "remainingTasks": m0,
        "requiredFieldMsg":
            MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
        "submitBtn": MessageLookupByLibrary.simpleMessage("إضافة"),
        "taskTextHint": MessageLookupByLibrary.simpleMessage("مهمة جديدة"),
        "taskTextLbl": MessageLookupByLibrary.simpleMessage("المهمة"),
        "validTextErrMsg":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال تص المهمة")
      };
}

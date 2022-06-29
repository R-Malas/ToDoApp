// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
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
  String get localeName => 'en_US';

  static String m0(total, remaining) =>
      "${Intl.plural(total, zero: 'you don\'t have any tasks', one: ' ${Intl.plural(remaining, zero: 'no remaining tasks', one: '1 remaining task', other: '')} of 1 task', other: ' ${Intl.plural(remaining, zero: 'no remaining tasks', one: '1 remaining task', other: '${remaining} remaining tasks')} of ${total} tasks')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "goBack": MessageLookupByLibrary.simpleMessage("Go Back"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("ToDos"),
        "newTaskTitle": MessageLookupByLibrary.simpleMessage("Add New Task"),
        "remainingTasks": m0,
        "requiredFieldMsg":
            MessageLookupByLibrary.simpleMessage("This field is required"),
        "submitBtn": MessageLookupByLibrary.simpleMessage("Add"),
        "taskTextHint": MessageLookupByLibrary.simpleMessage("New task"),
        "taskTextLbl": MessageLookupByLibrary.simpleMessage("Task"),
        "validTextErrMsg":
            MessageLookupByLibrary.simpleMessage("Please enter valid text")
      };
}

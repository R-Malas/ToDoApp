import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:to_do_list/core/db/db_main.dart';
import 'package:to_do_list/translations/generated/l10n.dart';

class AddToDoScreen extends StatefulWidget {
  const AddToDoScreen({Key? key}) : super(key: key);

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).newTaskTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: _textController,
        builder: (context, value, _) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 16.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          labelText: Translations.of(context).taskTextLbl,
                          hintText: Translations.of(context).taskTextHint,
                          errorText: _errorText,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)))),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 16.0),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        child: Text(Translations.of(context).submitBtn),
                        onPressed: _textController.text.isNotEmpty
                            ? () => _addTask(context)
                            : null),
                  ),
                )
              ]);
        },
      ),
    );
  }

  void _addTask(BuildContext context) {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Translations.of(context).validTextErrMsg)));
    } else {
      var newTask = TasksCompanion(
          title: drift.Value<String>(_textController.text),
          isDone: const drift.Value<bool>(false));
      Provider.of<MyDatabase>(context, listen: false)
          .createTask(newTask)
          .then((value) => Navigator.of(context).pop())
          .catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }

  String? get _errorText {
    final text = _textController.text;
    if (text.isEmpty) {
      return Translations.of(context).requiredFieldMsg;
    }
    return null;
  }
}

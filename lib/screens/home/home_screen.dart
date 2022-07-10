import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:to_do_list/core/db/db_main.dart';
import 'package:to_do_list/core/db/providers/db_change_notifier.dart';
import 'package:to_do_list/core/routing/app_routes.dart';
import 'package:to_do_list/core/translations/generated/l10n.dart';
import 'package:to_do_list/screens/home/widgets/language_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<DbChangeNotifier>().tasksListStream;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.list,
                    color: Colors.blue,
                  ),
                ),
                LanguageSelector()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Translations.of(context).homeTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                Translations.of(context).remainingTasks(
                    Provider.of<DbChangeNotifier>(context).totalTasks,
                    Provider.of<DbChangeNotifier>(context).remainingTasks),
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  color: Colors.white),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    var noUpdateProvider =
                        Provider.of<DbChangeNotifier>(context, listen: false);
                    var updateProvider = Provider.of<DbChangeNotifier>(context);

                    return GestureDetector(
                      child: CheckboxListTile(
                        value: task.isDone,
                        title: Text(
                          task.title,
                          style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        onChanged: (value) {
                          final editedTask = TasksCompanion(
                              id: drift.Value<int>(task.id),
                              title: drift.Value<String>(task.title),
                              isDone: drift.Value<bool>(value ?? false));
                          noUpdateProvider.updateTask(editedTask);
                        },
                      ),
                      onLongPress: () {
                        updateProvider.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Item removed'),
                          backgroundColor: Colors.green[400],
                          duration: const Duration(seconds: 3),
                        ));
                      },
                    );
                  },
                  itemCount: tasks.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addTask)),
    );
  }
}

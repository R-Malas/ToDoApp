// use `flutter pub run build_runner build` to rebuild db_main.g.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;

// Tables
import 'package:to_do_list/core/db/tables/tasks_tbl.dart';
import 'package:to_do_list/core/db/tables/user_activity_tbl.dart';

part 'db_main.g.dart';

@DriftDatabase(tables: [Tasks, UserActivity, AuditActivities])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// get list of Tasks
  Stream<List<Task>> getAllTasksStream() {
    return select(tasks).watch();
  }

  /// get Task by Id
  Future<Task> getTaskById(int id) async {
    return await (select(tasks)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// update Task
  Future<bool> updateTask(TasksCompanion task) async {
    return await update(tasks).replace(task);
  }

  /// create Task
  Future<int> createTask(TasksCompanion task) async {
    return await into(tasks).insert(task);
  }

  /// delete task
  Future<int> deleteTask(int id) async {
    return await (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// get remaining tasks
// Future<int> getRemainingTasks() async {
//   var countExp = countAll(filter: tasks.isDone == false);
//   final query = selectOnly(tasks)..addColumns([countExp]);
//   return await query.map((row) => row.read(countExp)).getSingle();
// }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await path_provider.getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'todos_db.sqlite'));
    return NativeDatabase(file);
  });
}

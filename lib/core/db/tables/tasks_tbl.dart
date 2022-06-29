import 'package:drift/drift.dart';

/// Tasks Table
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  @required
  TextColumn get title => text().withLength(min: 3, max: 32)();

  @required
  BoolColumn get isDone => boolean()();
}

abstract class TasksCount extends View {
  Tasks get tasks;

  Expression<int> get remainingCount =>
      countAll(filter: tasks.isDone.equals(false));

  @override
  Query<HasResultSet, dynamic> as() =>
      select([remainingCount]).from(tasks).join([]);
}

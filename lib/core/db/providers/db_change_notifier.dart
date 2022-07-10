import 'package:flutter/material.dart';
import 'package:to_do_list/core/db/db_main.dart';

class DbChangeNotifier extends ChangeNotifier {
  MyDatabase? _todoDb;

  List<Task> _tasksListStream = [];

  List<Task> get tasksListStream => _tasksListStream;

  Task? _task;

  Task? get task => _task;

  bool _newTaskId = false;

  bool get newTaskId => _newTaskId;

  bool _isTaskUpdated = false;

  bool get isTaskUpdated => _isTaskUpdated;

  bool _isTaskDeleted = false;

  bool get isTaskDeleted => _isTaskDeleted;

  String _error = '';

  String get error => _error;

  DbChangeNotifier();

  void initTodoDb(MyDatabase todoDb) {
    _todoDb = todoDb;
  }

  void getTaskStream() {
    _todoDb?.getAllTasksStream().listen((event) {
      _tasksListStream = event;
      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();
      notifyListeners();
    });
  }

  void getTaskById(int id) {
    _todoDb?.getTaskById(id).then((value) {
      _task = value;
      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();
      notifyListeners();
    });
  }

  void createTask(TasksCompanion task) {
    _todoDb?.createTask(task).then((value) {
      _newTaskId = value >= 1;

      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();
      notifyListeners();
    });
  }

  void updateTask(TasksCompanion task) {
    _todoDb?.updateTask(task).then((value) {
      _isTaskUpdated = value;
      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();
      notifyListeners();
    });
  }

  void deleteTask(int id) {
    _todoDb?.deleteTask(id).then((value) {
      _isTaskDeleted = value == 1;
      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();
      notifyListeners();
    });
  }

  int get remainingTasks {
    return tasksListStream.where((item) => item.isDone == false).length;
  }

  int get totalTasks {
    return tasksListStream.length;
  }
}

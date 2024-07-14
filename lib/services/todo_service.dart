import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/todo.dart';

class TodoService with ChangeNotifier {
  late Box _todoBox;
  List<Todo> _tasks = [];

  TodoService() {
    _init();
  }

  Future<void> _init() async {
    _todoBox = await Hive.openBox('todoBox');
    _tasks = _todoBox.values.cast<Todo>().toList();
    notifyListeners();
  }

  List<Todo> get tasks => _tasks;

  void addTask(String title) {
    final task = Todo(
      title: title,
      isComplete: false,
    );
    _tasks.add(task);
    _todoBox.add(task);
    notifyListeners();
  }

  void deleteTask(Todo task) {
    _tasks.remove(task);
    _todoBox.delete(task.key);
    notifyListeners();
  }

  void toggleTask(Todo task) {
    task.isComplete = !task.isComplete;
    task.save();
    notifyListeners();
  }
}

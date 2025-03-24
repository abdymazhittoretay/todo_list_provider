import 'package:flutter/material.dart';

class TodosModel extends ChangeNotifier {
  final List<String> _todos = [];

  final List<List<dynamic>> _deletedTodos = [];

  List<String> get todos => _todos;

  List<List<dynamic>> get deletedTodos => _deletedTodos;

  void addToDo(String todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateToDo(int index, String newTodo) {
    _todos[index] = newTodo;
    notifyListeners();
  }

  void removeToDo(int index) {
    _deletedTodos.add([index, _todos[index]]);
    _todos.removeAt(index);
    notifyListeners();
  }

  void recoverDeleted(int index) {
    _todos.insert(_deletedTodos[index][0], _deletedTodos[index][1]);
    _deletedTodos.removeAt(index);
    notifyListeners();
  }
}

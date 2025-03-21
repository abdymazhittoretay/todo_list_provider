import 'package:flutter/material.dart';

class TodosModel extends ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => _todos;

  void addToDo(String todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateToDo(int index, String newTodo) {
    _todos[index] = newTodo;
    notifyListeners();
  }

  void removeToDo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}

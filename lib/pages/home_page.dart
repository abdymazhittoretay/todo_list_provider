import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/models/todos_model.dart';
import 'package:todo_list_provider/pages/deleted_todos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todos"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeletedTodosPage()),
                );
              },
              icon: Icon(Icons.list_alt),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<TodosModel>(
                    builder: (context, value, child) {
                      List<String> todos = value.todos;
                      if (todos.isEmpty) {
                        return Center(child: Text("There are no todos yet."));
                      } else {
                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.only(bottom: 16.0),
                              title: Text(todos[index]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _updateController.text = todos[index];
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: TextField(
                                              controller: _updateController,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  _updateController.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (_updateController
                                                      .text
                                                      .isNotEmpty) {
                                                    value.updateToDo(
                                                      index,
                                                      _updateController.text,
                                                    );
                                                    _updateController.clear();
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Update"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      value.removeToDo(index);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Write your todo here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      decoration: BoxDecoration(color: Colors.black),
                      child: IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            Provider.of<TodosModel>(
                              context,
                              listen: false,
                            ).addToDo(_controller.text);
                            _focusNode.unfocus();
                            _controller.clear();
                          }
                        },
                        icon: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

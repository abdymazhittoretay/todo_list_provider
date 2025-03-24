import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/models/todos_model.dart';

class DeletedTodosPage extends StatefulWidget {
  const DeletedTodosPage({super.key});

  @override
  State<DeletedTodosPage> createState() => _DeletedTodosPageState();
}

class _DeletedTodosPageState extends State<DeletedTodosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deleted Todos"), centerTitle: true),
      body: Consumer<TodosModel>(
        builder: (context, value, child) {
          List deletedTodos = value.deletedTodos;
          return ListView.builder(
            itemCount: deletedTodos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(deletedTodos[index][1]),
                trailing: IconButton(
                  onPressed: () {
                    value.recoverDeleted(index);
                  },
                  icon: Icon(Icons.restore),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/pages/deleted_todos_page.dart';
import 'package:todo_list_provider/pages/login_page.dart';
import 'package:todo_list_provider/services/auth.dart';
import 'package:todo_list_provider/services/firestore_service.dart';

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
          leading: IconButton(
            onPressed: () async {
              await Auth().signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            icon: Icon(Icons.exit_to_app),
          ),
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirestoreService().readTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List todos = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot document = todos[index];
                            final String docID = document.id;
                            final Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            final todo = data["todo"];
                            if (data["user"] == Auth().currentUser!.email) {
                              return ListTile(
                                contentPadding: EdgeInsets.only(bottom: 16.0),
                                title: Text(todo),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _updateController.text = todo;
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
                                                      FirestoreService()
                                                          .updateTodo(
                                                            docID,
                                                            _updateController
                                                                .text,
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
                                        FirestoreService().deleteTodo(docID);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return null;
                          },
                        );
                      } else {
                        return Center(child: Text("There are no todos!"));
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
                            FirestoreService().addTodo(_controller.text);
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

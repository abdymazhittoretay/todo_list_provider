import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/models/todos_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todos")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(child: SizedBox()),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
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
                          FocusScope.of(context).unfocus();
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_service.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _taskController,
                      decoration: const InputDecoration(labelText: 'New Task'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<TodoService>(context, listen: false).addTask(
                          _taskController.text,
                        );
                        _taskController.clear();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<TodoService>(
                builder: (context, todoService, child) {
                  return ListView.builder(
                    itemCount: todoService.tasks.length,
                    itemBuilder: (context, index) {
                      final task = todoService.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            todoService.deleteTask(task);
                          },
                        ),
                        leading: Checkbox(
                          value: task.isComplete,
                          onChanged: (bool? value) {
                            todoService.toggleTask(task);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

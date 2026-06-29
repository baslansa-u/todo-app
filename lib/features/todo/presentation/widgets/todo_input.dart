import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/todo.dart';
import '../bloc/todo_bloc.dart';

class TodoInput extends StatefulWidget {
  const TodoInput({
    super.key,
  });

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text(
              "Add",
            ),
          )
        ],
      ),
    );
  }

  void _addTodo() {
    if (titleController.text.isEmpty) {
      return;
    }

    final todo = Todo(
      id: const Uuid().v4(),
      title: titleController.text,
      description: descriptionController.text,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    context.read<TodoBloc>().add(
          AddTodoEvent(todo),
        );

    titleController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}

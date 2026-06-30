import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/date_picker_field.dart';

import '../../domain/entity/todo.dart';
import '../bloc/todo_bloc.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;

  const EditTodoDialog({
    super.key,
    required this.todo,
  });

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.todo.title,
    );

    descriptionController = TextEditingController(
      text: widget.todo.description,
    );

    selectedDueDate = widget.todo.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Todo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: 10),
          DatePickerField(
            selectedDate: selectedDueDate,
            onChanged: (date) => setState(() => selectedDueDate = date),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) return;
            context.read<TodoBloc>().add(
                  UpdateTodoEvent(
                    widget.todo.copyWith(
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedDueDate, // ← เพิ่มตรงนี้
                    ),
                  ),
                );

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

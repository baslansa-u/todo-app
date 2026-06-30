import 'package:flutter/material.dart';
import 'package:todo_app/features/todo/presentation/widgets/date_picker_field.dart';
import 'package:uuid/uuid.dart';

import 'package:todo_app/features/todo/domain/entity/todo.dart';

class AddTodoDialog extends StatefulWidget {
  final ValueChanged<Todo> onAdd;

  const AddTodoDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDueDate;

  final _uuid = const Uuid();

  void _submit() {
    if (titleController.text.trim().isEmpty) {
      return;
    }
    widget.onAdd(
      Todo(
        id: _uuid.v4(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        isCompleted: false,
        createdAt: DateTime.now(),
        dueDate: selectedDueDate,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Todo",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3, // ← กล่องสูงขึ้น กด enter ได้
              decoration: const InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true, // ← label ขึ้นบนแทนตรงกลาง
              ),
            ),
            const SizedBox(height: 10),
            DatePickerField(
              selectedDate: selectedDueDate,
              onChanged: (date) => setState(() => selectedDueDate = date),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Add"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

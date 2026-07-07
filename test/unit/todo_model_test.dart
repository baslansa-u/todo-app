import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';

import '../fixtures/todo.dart';

void main() {
  group('TodoModel', () {
    test('maps from entity without losing fields', () {
      final dueDate = DateTime(2025, 2, 15);
      final todo = testTodo.copyWith(
        isCompleted: true,
        dueDate: dueDate,
      );

      final model = TodoModel.fromEntity(todo);

      expect(model.id, todo.id);
      expect(model.title, todo.title);
      expect(model.description, todo.description);
      expect(model.isCompleted, isTrue);
      expect(model.createdAt, todo.createdAt);
      expect(model.dueDate, dueDate);
    });

    test('maps to entity without losing fields', () {
      final dueDate = DateTime(2025, 3, 20);
      final model = TodoModel(
        id: 'model-1',
        title: 'Persisted todo',
        description: 'Loaded from Hive',
        isCompleted: true,
        createdAt: DateTime(2025, 3, 1),
        dueDate: dueDate,
      );

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.description, model.description);
      expect(entity.isCompleted, isTrue);
      expect(entity.createdAt, model.createdAt);
      expect(entity.dueDate, dueDate);
    });
  });
}

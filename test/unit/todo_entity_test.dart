import 'package:flutter_test/flutter_test.dart';

import '../fixtures/todo.dart';

void main() {
  group('Todo', () {
    test('copyWith preserves due date when no due date argument is passed', () {
      final dueDate = DateTime(2025, 4, 10);
      final todo = testTodo.copyWith(dueDate: dueDate);

      final copy = todo.copyWith(title: 'Updated title');

      expect(copy.title, 'Updated title');
      expect(copy.dueDate, dueDate);
    });

    test('copyWith can intentionally clear due date', () {
      final todo = testTodo.copyWith(dueDate: DateTime(2025, 4, 10));

      final copy = todo.copyWith(dueDate: null);

      expect(copy.dueDate, isNull);
    });
  });
}

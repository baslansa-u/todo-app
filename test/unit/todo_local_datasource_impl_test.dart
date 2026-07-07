import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/exception.dart';
import 'package:todo_app/features/todo/data/datasource/todo_local_datasource_impl.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';

import '../fixtures/todo.dart';
import '../mocks/mock_hive_box.dart';

void main() {
  late MockHiveBox box;
  late TodoLocalDataSourceImpl dataSource;
  late TodoModel model;

  setUpAll(() {
    registerFallbackValue(TodoModel.fromEntity(testTodo));
  });

  setUp(() {
    box = MockHiveBox();
    dataSource = TodoLocalDataSourceImpl(box);
    model = TodoModel.fromEntity(testTodo);
  });

  group('TodoLocalDataSourceImpl', () {
    test('reads todos from Hive values', () async {
      when(() => box.values).thenReturn([model]);

      final result = await dataSource.getTodos();

      expect(result, [model]);
      verify(() => box.values).called(1);
    });

    test('wraps read errors in DatabaseException', () async {
      when(() => box.values).thenThrow(Exception('bad box'));

      expect(
        dataSource.getTodos,
        throwsA(
          isA<DatabaseException>().having(
            (exception) => exception.message,
            'message',
            'cant get todo',
          ),
        ),
      );
    });

    test('writes todo using id as the Hive key', () async {
      when(() => box.put(model.id, model)).thenAnswer((_) async {});

      await dataSource.addTodo(model);

      verify(() => box.put(model.id, model)).called(1);
    });

    test('wraps write errors in DatabaseException', () async {
      when(() => box.put(model.id, model)).thenThrow(Exception('bad write'));

      expect(
        () => dataSource.addTodo(model),
        throwsA(
          isA<DatabaseException>().having(
            (exception) => exception.message,
            'message',
            'cant add todo',
          ),
        ),
      );
    });

    test('updates todo using id as the Hive key', () async {
      when(() => box.put(model.id, model)).thenAnswer((_) async {});

      await dataSource.updateTodo(model);

      verify(() => box.put(model.id, model)).called(1);
    });

    test('deletes todo by id', () async {
      when(() => box.delete(model.id)).thenAnswer((_) async {});

      await dataSource.deleteTodo(model.id);

      verify(() => box.delete(model.id)).called(1);
    });
  });
}

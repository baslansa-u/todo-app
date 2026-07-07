import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/exception.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';
import 'package:todo_app/features/todo/data/repository/todo_repository_impl.dart';

import '../fixtures/todo.dart';
import '../mocks/mock_local_datasource.dart';

void main() {
  late MockTodoLocalDataSource localDataSource;
  late TodoRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(TodoModel.fromEntity(testTodo));
  });

  setUp(() {
    localDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(localDataSource);
  });

  group('TodoRepositoryImpl', () {
    test('returns todos from the local datasource as entities', () async {
      when(() => localDataSource.getTodos()).thenAnswer(
        (_) async => [
          TodoModel.fromEntity(testTodo),
          TodoModel.fromEntity(testTodo.copyWith(id: '2')),
        ],
      );

      final result = await repository.getTodos();

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => []),
        [testTodo, testTodo.copyWith(id: '2')],
      );
      verify(() => localDataSource.getTodos()).called(1);
    });

    test('translates get failures into DatabaseFailure', () async {
      when(() => localDataSource.getTodos()).thenThrow(
        DatabaseException('read failed'),
      );

      final result = await repository.getTodos();

      expect(result.isLeft(), isTrue);
      expect(
        result.swap().getOrElse(() => ValidationFailure('')),
        isA<DatabaseFailure>(),
      );
      expect(
        result.swap().getOrElse(() => ValidationFailure('')).message,
        'read failed',
      );
    });

    test('adds todo through the local datasource', () async {
      when(() => localDataSource.addTodo(any())).thenAnswer((_) async {});

      final result = await repository.addTodo(testTodo);

      expect(result, const Right(unit));
      final captured =
          verify(() => localDataSource.addTodo(captureAny())).captured.single;
      expect(captured, isA<TodoModel>());
      expect((captured as TodoModel).id, testTodo.id);
    });

    test('translates add failures into DatabaseFailure', () async {
      when(() => localDataSource.addTodo(any())).thenThrow(
        DatabaseException('write failed'),
      );

      final result = await repository.addTodo(testTodo);

      expect(result.isLeft(), isTrue);
      expect(
        result.swap().getOrElse(() => ValidationFailure('')).message,
        'write failed',
      );
    });

    test('updates todo through the local datasource', () async {
      when(() => localDataSource.updateTodo(any())).thenAnswer((_) async {});

      final result = await repository.updateTodo(testTodo);

      expect(result, const Right(unit));
      final captured = verify(() => localDataSource.updateTodo(captureAny()))
          .captured
          .single;
      expect((captured as TodoModel).id, testTodo.id);
    });

    test('deletes todo through the local datasource', () async {
      when(() => localDataSource.deleteTodo(testTodo.id))
          .thenAnswer((_) async {});

      final result = await repository.deleteTodo(testTodo.id);

      expect(result, const Right(unit));
      verify(() => localDataSource.deleteTodo(testTodo.id)).called(1);
    });
  });
}

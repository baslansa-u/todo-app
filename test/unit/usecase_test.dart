import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/update_todo_usecase.dart';

import '../fixtures/todo.dart';
import '../mocks/mock_repository.dart';

void main() {
  // setup
  late MockTodoRepository mockRepository;
  setUp(() {
    mockRepository = MockTodoRepository();
  });

  // test
  group('AddTodoUsecase', () {
    group('call()', () {
      test('should return Unit when repository.addTodo is successful',
          () async {
        // Arrange
        final usecase = AddTodoUsecase(mockRepository);

        final params = AddTodoParams(todo: testTodo);

        when(() => mockRepository.addTodo(testTodo))
            .thenAnswer((_) async => Right(unit));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(unit));
        verify(() => mockRepository.addTodo(testTodo)).called(1);
      });

      test('should return Failure when repository.addTodo fails', () async {
        // Arrange
        final mockRepository = MockTodoRepository();
        final usecase = AddTodoUsecase(mockRepository);
        final params = AddTodoParams(todo: testTodo);
        final failure = DatabaseFailure('Failed to add todo');

        when(() => mockRepository.addTodo(testTodo))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Left(failure));
        verify(() => mockRepository.addTodo(testTodo)).called(1);
      });
    });
  });

  group('DeleteTodoUsecase', () {
    group('call()', () {
      test('should return Unit when repository.deleteTodo is successful',
          () async {
        // Arrange
        final usecase = DeleteTodoUsecase(mockRepository);
        final params = DeleteTodoParams(id: testTodo.id);

        when(() => mockRepository.deleteTodo(testTodo.id))
            .thenAnswer((_) async => Right(unit));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(unit));
        verify(() => mockRepository.deleteTodo(testTodo.id)).called(1);
      });

      test('should return Failure when repository.deleteTodo fails', () async {
        // Arrange
        final mockRepository = MockTodoRepository();
        final usecase = DeleteTodoUsecase(mockRepository);
        final params = DeleteTodoParams(id: testTodo.id);
        final failure = DatabaseFailure('Failed to delete todo');

        when(() => mockRepository.deleteTodo(testTodo.id))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Left(failure));
        verify(() => mockRepository.deleteTodo(testTodo.id)).called(1);
      });
    });
  });

  group('GetTodosUsecase', () {
    group('call()', () {
      test('should return todos when repository.getTodos is successful',
          () async {
        // Arrange
        final usecase = GetTodosUsecase(mockRepository);
        when(() => mockRepository.getTodos())
            .thenAnswer((_) async => Right([testTodo]));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => []), [testTodo]);
        verify(() => mockRepository.getTodos()).called(1);
      });

      test('should return Failure when repository.getTodos fails', () async {
        // Arrange
        final usecase = GetTodosUsecase(mockRepository);
        final failure = DatabaseFailure('Failed to get todos');
        when(() => mockRepository.getTodos())
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Left(failure));
        verify(() => mockRepository.getTodos()).called(1);
      });
    });
  });

  group('UpdateTodoUsecase', () {
    group('call()', () {
      test('should return Unit when repository.updateTodo is successful',
          () async {
        // Arrange
        final usecase = UpdateTodoUsecase(mockRepository);
        final params = UpdateTodoParams(todo: testTodo);
        when(() => mockRepository.updateTodo(testTodo))
            .thenAnswer((_) async => Right(unit));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(unit));
        verify(() => mockRepository.updateTodo(testTodo)).called(1);
      });

      test('should return Failure when repository.updateTodo fails', () async {
        // Arrange
        final usecase = UpdateTodoUsecase(mockRepository);
        final params = UpdateTodoParams(todo: testTodo);
        final failure = DatabaseFailure('Failed to update todo');
        when(() => mockRepository.updateTodo(testTodo))
            .thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Left(failure));
        verify(() => mockRepository.updateTodo(testTodo)).called(1);
      });
    });
  });
}

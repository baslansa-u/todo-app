import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/update_todo_usecase.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

import '../fixtures/todo.dart';
import '../helpers/in_memory_todo_repository.dart';

void main() {
  TodoBloc buildBloc(TodoRepository repository) {
    return TodoBloc(
      AddTodoUsecase(repository),
      DeleteTodoUsecase(repository),
      GetTodosUsecase(repository),
      UpdateTodoUsecase(repository),
    );
  }

  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'loads todos from the repository',
      build: () => buildBloc(InMemoryTodoRepository([testTodo])),
      act: (bloc) => bloc.add(LoadTodos()),
      expect: () => [
        TodoLoading(),
        TodoLoaded([testTodo]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'filters loaded todos by completion status and title query',
      build: () => buildBloc(InMemoryTodoRepository()),
      seed: () => TodoLoaded([
        testTodo,
        testTodo.copyWith(
          id: '2',
          title: 'Done Todo',
          isCompleted: true,
        ),
      ]),
      act: (bloc) {
        bloc.add(const ChangeTodoFilter(TodoFilter.completed));
        bloc.add(const SearchByTitle('done'));
      },
      expect: () => [
        isA<TodoLoaded>()
            .having((state) => state.filter, 'filter', TodoFilter.completed),
        isA<TodoLoaded>()
            .having((state) => state.searchQuery, 'searchQuery', 'done')
            .having((state) => state.filteredTodos.length, 'matches', 1),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits an error when loading todos fails',
      build: () => buildBloc(
        FailingTodoRepository(getFailure: DatabaseFailure('Could not read')),
      ),
      act: (bloc) => bloc.add(LoadTodos()),
      expect: () => [
        TodoLoading(),
        const TodoError('Could not read'),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'adds a todo to the top of the loaded list',
      build: () => buildBloc(InMemoryTodoRepository([testTodo])),
      seed: () => TodoLoaded([testTodo]),
      act: (bloc) => bloc.add(
        AddTodoEvent(testTodo.copyWith(id: '2', title: 'New Todo')),
      ),
      expect: () => [
        isA<TodoLoaded>()
            .having((state) => state.todos.length, 'todo count', 2)
            .having((state) => state.todos.first.id, 'first todo id', '2'),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits an error when adding a todo fails',
      build: () => buildBloc(
        FailingTodoRepository(addFailure: DatabaseFailure('Could not add')),
      ),
      seed: () => const TodoLoaded([]),
      act: (bloc) => bloc.add(AddTodoEvent(testTodo)),
      expect: () => [
        const TodoError('Could not add'),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'updates a todo in the loaded list',
      build: () => buildBloc(InMemoryTodoRepository([testTodo])),
      seed: () => TodoLoaded([testTodo]),
      act: (bloc) => bloc.add(
        UpdateTodoEvent(testTodo.copyWith(title: 'Updated Todo')),
      ),
      expect: () => [
        isA<TodoLoaded>().having(
          (state) => state.todos.single.title,
          'title',
          'Updated Todo',
        ),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'deletes a todo from the loaded list',
      build: () => buildBloc(InMemoryTodoRepository([testTodo])),
      seed: () => TodoLoaded([testTodo]),
      act: (bloc) => bloc.add(DeleteTodoEvent(testTodo.id)),
      expect: () => [
        isA<TodoLoaded>().having((state) => state.todos, 'todos', isEmpty),
      ],
    );

    test('keeps both todos when concurrent adds complete sequentially',
        () async {
      final repository = ControlledTodoRepository();
      final bloc = buildBloc(repository);

      bloc.add(LoadTodos());
      repository.completeLoad();
      await expectLater(
        bloc.stream,
        emitsInOrder([
          TodoLoading(),
          const TodoLoaded([]),
        ]),
      );

      final first = testTodo.copyWith(id: '1', title: 'First');
      final second = testTodo.copyWith(id: '2', title: 'Second');

      bloc.add(AddTodoEvent(first));
      bloc.add(AddTodoEvent(second));
      await repository.waitForPendingAdds(2);

      repository.completeAdd(first.id);
      await pumpEventQueue();

      repository.completeAdd(second.id);
      await pumpEventQueue();

      final state = bloc.state;
      expect(state, isA<TodoLoaded>());
      expect(
        (state as TodoLoaded).todos.map((todo) => todo.id),
        ['2', '1'],
      );

      await bloc.close();
    });

    test('persists and reloads an add that arrives while loading', () async {
      final repository = ControlledTodoRepository();
      final bloc = buildBloc(repository);
      final todo = testTodo.copyWith(id: 'queued');

      bloc.add(LoadTodos());
      bloc.add(AddTodoEvent(todo));

      await repository.waitForPendingAdds(1);
      repository.completeAdd(todo.id);
      repository.completeLoad();

      await pumpEventQueue();

      final state = bloc.state;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos, [todo]);

      await bloc.close();
    });
  });
}

class FailingTodoRepository implements TodoRepository {
  final Failure? getFailure;
  final Failure? addFailure;
  final Failure? updateFailure;
  final Failure? deleteFailure;

  FailingTodoRepository({
    this.getFailure,
    this.addFailure,
    this.updateFailure,
    this.deleteFailure,
  });

  @override
  Future<Either<Failure, Unit>> addTodo(Todo todo) async {
    final failure = addFailure;
    return failure == null ? const Right(unit) : Left(failure);
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    final failure = deleteFailure;
    return failure == null ? const Right(unit) : Left(failure);
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    final failure = getFailure;
    return failure == null ? const Right([]) : Left(failure);
  }

  @override
  Future<Either<Failure, Unit>> updateTodo(Todo todo) async {
    final failure = updateFailure;
    return failure == null ? const Right(unit) : Left(failure);
  }
}

class ControlledTodoRepository implements TodoRepository {
  final List<Todo> _todos = [];
  final Map<String, Completer<Either<Failure, Unit>>> _pendingAdds = {};
  final Completer<void> _loadCompleter = Completer<void>();
  final Completer<void> _pendingAddsChanged = Completer<void>();

  @override
  Future<Either<Failure, Unit>> addTodo(Todo todo) async {
    final completer = Completer<Either<Failure, Unit>>();
    _pendingAdds[todo.id] = completer;
    if (!_pendingAddsChanged.isCompleted) _pendingAddsChanged.complete();

    final result = await completer.future;
    result.fold((_) {}, (_) => _todos.insert(0, todo));
    return result;
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    await _loadCompleter.future;
    return Right(List.unmodifiable(_todos));
  }

  @override
  Future<Either<Failure, Unit>> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((item) => item.id == todo.id);
    if (index != -1) _todos[index] = todo;
    return const Right(unit);
  }

  void completeAdd(String id) {
    _pendingAdds.remove(id)?.complete(const Right(unit));
  }

  void completeLoad() {
    if (!_loadCompleter.isCompleted) _loadCompleter.complete();
  }

  Future<void> waitForPendingAdds(int count) async {
    while (_pendingAdds.length < count) {
      await _pendingAddsChanged.future;
      await pumpEventQueue();
    }
  }
}

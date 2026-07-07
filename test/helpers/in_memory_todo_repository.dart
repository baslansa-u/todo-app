import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

class InMemoryTodoRepository implements TodoRepository {
  final List<Todo> _todos;

  InMemoryTodoRepository([List<Todo> initialTodos = const []])
      : _todos = List.of(initialTodos);

  @override
  Future<Either<Failure, Unit>> addTodo(Todo todo) async {
    _todos.insert(0, todo);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    return Right(List.unmodifiable(_todos));
  }

  @override
  Future<Either<Failure, Unit>> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((item) => item.id == todo.id);
    if (index == -1) {
      return Left(DatabaseFailure('Todo not found'));
    }

    _todos[index] = todo;
    return const Right(unit);
  }
}

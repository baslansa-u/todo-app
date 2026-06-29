import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';

// add,delete,edit,complete,filter
abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();

  Future<Either<Failure, Unit>> addTodo(
    Todo todo,
  );

  Future<Either<Failure, Unit>> updateTodo(
    Todo todo,
  );

  Future<Either<Failure, Unit>> deleteTodo(
    String id,
  );
}

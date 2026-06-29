import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

class GetTodosUsecase {
  final TodoRepository repository;

  GetTodosUsecase(this.repository);

  Future<Either<Failure, List<Todo>>> call() => repository.getTodos();
}

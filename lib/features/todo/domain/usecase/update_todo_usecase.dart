import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

class UpdateTodoUsecase {
  final TodoRepository repository;

  UpdateTodoUsecase(this.repository);

  Future<Either<Failure, Unit>> call(UpdateTodoParams params) =>
      repository.updateTodo(params.todo);
}

class UpdateTodoParams extends Equatable {
  final Todo todo;

  const UpdateTodoParams({required this.todo});
  @override
  List<Object?> get props => [todo];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

class AddTodoUsecase {
  final TodoRepository repository;

  AddTodoUsecase(this.repository);

  Future<Either<Failure, Unit>> call(AddTodoParams params) =>
      repository.addTodo(params.todo);
}

class AddTodoParams extends Equatable {
  final Todo todo;

  const AddTodoParams({required this.todo});
  @override
  List<Object?> get props => [todo];
}

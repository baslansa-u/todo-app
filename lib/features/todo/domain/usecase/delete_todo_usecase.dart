import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

class DeleteTodoUsecase {
  final TodoRepository repository;

  DeleteTodoUsecase(this.repository);

  Future<Either<Failure, Unit>> call(DeleteTodoParams params) =>
      repository.deleteTodo(params.id);
}

class DeleteTodoParams extends Equatable {
  final String id;

  const DeleteTodoParams({required this.id});
  @override
  List<Object?> get props => [id];
}

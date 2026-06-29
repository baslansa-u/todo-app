import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/exception.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/features/todo/data/datasource/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';

final class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> addTodo(Todo todo) async {
    try {
      await localDataSource.addTodo(TodoModel.fromEntity(todo));
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    try {
      await localDataSource.deleteTodo(id);
      return Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final response = await localDataSource.getTodos();
      return Right(response.map((e) => e.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTodo(Todo todo) async {
    try {
      await localDataSource.updateTodo(TodoModel.fromEntity(todo));
      return Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}

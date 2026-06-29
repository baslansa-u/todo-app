import 'package:hive/hive.dart';
import 'package:todo_app/core/error/exception.dart';
import 'package:todo_app/features/todo/data/datasource/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box box;

  TodoLocalDataSourceImpl(this.box);

  @override
  Future<void> addTodo(TodoModel todo) async {
    try {
      await box.put(todo.id, todo);
    } catch (e) {
      throw DatabaseException("cant add todo");
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      throw DatabaseException("cant remove todo");
    }
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      return box.values.cast<TodoModel>().toList();
    } catch (e) {
      throw DatabaseException("cant get todo");
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await box.put(todo.id, todo);
    } catch (e) {
      throw DatabaseException("cant update todo");
    }
  }
}

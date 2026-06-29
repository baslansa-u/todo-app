import 'package:todo_app/features/todo/data/models/todo_model.dart';

abstract interface class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();

  Future<void> updateTodo(TodoModel todo);

  Future<void> deleteTodo(String id);

  Future<void> addTodo(TodoModel todo);
}

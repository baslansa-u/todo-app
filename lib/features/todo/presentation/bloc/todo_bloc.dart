import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/todo_repository.dart';

part 'todo_state.dart';
part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(
    this._todoRepository,
  ) : super(TodoState()) {
    // TODO: add event handlers
  }

  final TodoRepository _todoRepository;
}
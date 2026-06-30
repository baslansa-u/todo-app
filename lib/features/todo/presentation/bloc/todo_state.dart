part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoLoaded(
    this.todos, {
    this.filter = TodoFilter.all,
  });

  int get total => todos.length;
  int get remaining => todos.where((e) => !e.isCompleted).length;
  int get done => todos.where((e) => e.isCompleted).length;

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((e) => !e.isCompleted).toList();

      case TodoFilter.completed:
        return todos.where((e) => e.isCompleted).toList();

      case TodoFilter.all:
        return todos;
    }
  }

  // emit(current.copyWith(todos: updatedList))
  TodoLoaded copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
  }) {
    return TodoLoaded(
      todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [todos, filter];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

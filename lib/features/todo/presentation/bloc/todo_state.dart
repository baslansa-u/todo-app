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
  final String searchQuery;

  const TodoLoaded(
    this.todos, {
    this.filter = TodoFilter.all,
    this.searchQuery = '',
  });

  int get total => todos.length;
  int get remaining => todos.where((e) => !e.isCompleted).length;
  int get done => todos.where((e) => e.isCompleted).length;

  List<Todo> get filteredTodos {
    var result = todos;

    result = switch (filter) {
      TodoFilter.active => todos.where((e) => !e.isCompleted).toList(),
      TodoFilter.completed => todos.where((e) => e.isCompleted).toList(),
      TodoFilter.all => todos,
    };

    if (searchQuery.isNotEmpty) {
      result = result
          .where(
              (e) => e.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  // emit(current.copyWith(todos: updatedList))
  TodoLoaded copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
    String? searchQuery,
  }) {
    return TodoLoaded(
      todos ?? this.todos,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [todos, filter, searchQuery];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

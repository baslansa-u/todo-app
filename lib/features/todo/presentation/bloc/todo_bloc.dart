import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entity/todo.dart';
import 'package:todo_app/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/update_todo_usecase.dart';

part 'todo_state.dart';
part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTodoUsecase addTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  final GetTodosUsecase getTodosUsecase;
  final UpdateTodoUsecase updateTodoUsecase;

  TodoBloc(
    this.addTodoUsecase,
    this.deleteTodoUsecase,
    this.getTodosUsecase,
    this.updateTodoUsecase,
  ) : super(TodoLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodoEvent);
    on<UpdateTodoEvent>(_onUpdateTodoEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
    on<ChangeTodoFilter>(_onChangeFilter);
    on<SearchByTitle>(_onSearchByTitle);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await getTodosUsecase();
    result.fold((failure) => emit(TodoError(failure.message)), (todo) {
      emit(TodoLoaded(todo));
    });
  }

  Future<void> _onAddTodoEvent(
      AddTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    final current = state as TodoLoaded;

    final result = await addTodoUsecase(
      AddTodoParams(
        todo: event.todo,
      ),
    );

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => emit(current.copyWith(
        todos: [event.todo, ...current.todos],
      )),
    );
  }

  Future<void> _onUpdateTodoEvent(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    final current = state as TodoLoaded;

    final result = await updateTodoUsecase(
      UpdateTodoParams(
        todo: event.todo,
      ),
    );

    result.fold(
      (failure) => emit(
        TodoError(
          failure.message,
        ),
      ),
      (_) => emit(
        current.copyWith(
            todos: current.todos
                .map((t) => t.id == event.todo.id ? event.todo : t)
                .toList()),
      ),
    );
  }

  Future<void> _onDeleteTodoEvent(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) return;
    final current = state as TodoLoaded;

    final result = await deleteTodoUsecase(
      DeleteTodoParams(
        id: event.id,
      ),
    );

    result.fold(
      (failure) => emit(
        TodoError(
          failure.message,
        ),
      ),
      (_) => emit(
        current.copyWith(
            todos: current.todos.where((t) => t.id != event.id).toList()),
      ),
    );
  }

  void _onChangeFilter(ChangeTodoFilter event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;

      emit(current.copyWith(filter: event.filter));
    }
  }

  void _onSearchByTitle(SearchByTitle event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;

      emit(current.copyWith(searchQuery: event.title));
    }
  }
}

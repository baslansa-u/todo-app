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
  ) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodoEvent);
    on<UpdateTodoEvent>(_onUpdateTodoEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
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
    emit(TodoLoading());

    final result = await addTodoUsecase(
      AddTodoParams(
        todo: event.todo,
      ),
    );

    result.fold((failure) => emit(TodoError(failure.message)), (_) {
      add(LoadTodos());
    });
  }

  Future<void> _onUpdateTodoEvent(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

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
      (_) {
        add(LoadTodos());
      },
    );
  }

  Future<void> _onDeleteTodoEvent(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

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
      (_) {
        add(LoadTodos());
      },
    );
  }
}

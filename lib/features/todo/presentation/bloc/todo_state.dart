part of 'todo_bloc.dart';

class TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadedState extends TodoState {
  TodoLoadedState();
}

class TodoErrorState extends TodoState {
  TodoErrorState({required this.message});
  final String message;
}
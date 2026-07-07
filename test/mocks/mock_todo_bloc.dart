import 'package:bloc_test/bloc_test.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

class MockTodoBloc extends MockBloc<TodoEvent, TodoState> implements TodoBloc {}

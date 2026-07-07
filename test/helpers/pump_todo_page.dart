import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/pages/todo_page.dart';

Future<void> pumpTodoPage(
  WidgetTester tester,
  TodoBloc mockBloc, {
  TodoState initialState = const TodoLoaded([]),
  List<TodoState> states = const [],
}) async {
  whenListen(
    mockBloc,
    Stream<TodoState>.fromIterable(states),
    initialState: initialState,
  );
  when(() => mockBloc.state).thenReturn(initialState);

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<TodoBloc>.value(
        value: mockBloc,
        child: TodoPage(onToggleTheme: () {}),
      ),
    ),
  );
}

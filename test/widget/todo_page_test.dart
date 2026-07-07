import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:todo_app/features/todo/presentation/widgets/edit_todo_dialog.dart';

import '../fixtures/todo.dart';
import '../helpers/pump_todo_page.dart';
import '../mocks/mock_todo_bloc.dart';

void main() {
  late MockTodoBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(_FakeTodoEvent());
  });

  setUp(() {
    mockBloc = MockTodoBloc();
  });

  testWidgets('shows loading without the add button', (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoading(),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('shows an error message', (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: const TodoError('Could not load todos'),
    );

    expect(find.text('Could not load todos'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('shows summary and todos when loaded', (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoaded([
        testTodo,
        testTodo.copyWith(
          id: '2',
          title: 'Completed Todo',
          isCompleted: true,
        ),
      ]),
    );

    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Test Todo'), findsOneWidget);
    expect(find.text('Completed Todo'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('submits an AddTodoEvent from the add dialog', (tester) async {
    await pumpTodoPage(tester, mockBloc);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddTodoDialog), findsOneWidget);

    final dialogFields = find.descendant(
      of: find.byType(AddTodoDialog),
      matching: find.byType(TextField),
    );

    await tester.enterText(dialogFields.at(0), 'New task');
    await tester.enterText(dialogFields.at(1), 'Details');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final event = verify(() => mockBloc.add(captureAny())).captured.last;
    expect(event, isA<AddTodoEvent>());
    expect((event as AddTodoEvent).todo.title, 'New task');
    expect(event.todo.description, 'Details');
    expect(find.byType(AddTodoDialog), findsNothing);
  });

  testWidgets('dispatches filter and search events', (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoaded([testTodo]),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Active'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'test');

    verify(() => mockBloc.add(const ChangeTodoFilter(TodoFilter.active)))
        .called(1);
    verify(() => mockBloc.add(const SearchByTitle('test'))).called(1);
  });

  testWidgets('dispatches UpdateTodoEvent when a todo is checked',
      (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoaded([testTodo]),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final event = verify(() => mockBloc.add(captureAny())).captured.last;
    expect(event, isA<UpdateTodoEvent>());
    expect((event as UpdateTodoEvent).todo.id, testTodo.id);
    expect(event.todo.isCompleted, isTrue);
  });

  testWidgets('dispatches DeleteTodoEvent when delete is tapped',
      (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoaded([testTodo]),
    );

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    final event = verify(() => mockBloc.add(captureAny())).captured.last;
    expect(event, const DeleteTodoEvent('1'));
  });

  testWidgets('submits an UpdateTodoEvent from the edit dialog',
      (tester) async {
    await pumpTodoPage(
      tester,
      mockBloc,
      initialState: TodoLoaded([testTodo]),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(EditTodoDialog), findsOneWidget);

    final dialogFields = find.descendant(
      of: find.byType(EditTodoDialog),
      matching: find.byType(TextField),
    );

    await tester.enterText(dialogFields.at(0), 'Edited task');
    await tester.enterText(dialogFields.at(1), 'Edited details');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final event = verify(() => mockBloc.add(captureAny())).captured.last;
    expect(event, isA<UpdateTodoEvent>());
    expect((event as UpdateTodoEvent).todo.id, testTodo.id);
    expect(event.todo.title, 'Edited task');
    expect(event.todo.description, 'Edited details');
    expect(find.byType(EditTodoDialog), findsNothing);
  });
}

class _FakeTodoEvent extends Fake implements TodoEvent {}

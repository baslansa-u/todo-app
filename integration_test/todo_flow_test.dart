import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/update_todo_usecase.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/pages/todo_page.dart';

import '../test/helpers/in_memory_todo_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('creates, completes, filters, and deletes a todo',
      (tester) async {
    final repository = InMemoryTodoRepository();
    final bloc = TodoBloc(
      AddTodoUsecase(repository),
      DeleteTodoUsecase(repository),
      GetTodosUsecase(repository),
      UpdateTodoUsecase(repository),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TodoBloc>.value(
          value: bloc,
          child: TodoPage(onToggleTheme: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Integration task');
    await tester.enterText(find.byType(TextField).at(1), 'Created in test');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Integration task'), findsOneWidget);
    expect(find.text('Created in test'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('Integration task'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('No todo'), findsOneWidget);

    await bloc.close();
  });
}

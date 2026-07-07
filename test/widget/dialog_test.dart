import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/todo/presentation/widgets/add_todo_dialog.dart';

import '../helpers/pump_todo_page.dart';
import '../mocks/mock_todo_bloc.dart';

void main() {
  // setup
  late MockTodoBloc mockBloc;
  setUp(() {
    mockBloc = MockTodoBloc();
  });

  // test
  testWidgets(
    'should show dialog when button is tapped',
    (tester) async {
      // Arrange
      await pumpTodoPage(tester, mockBloc);

      // Act
      final addButton = find.byType(FloatingActionButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddTodoDialog), findsOneWidget);
    },
  );
  testWidgets('should close dialog when Cancel is tapped', (tester) async {
    // Arrange
    await pumpTodoPage(tester, mockBloc);

    // Act
    final addButton = find.byType(FloatingActionButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final cancelButton = find.text('Cancel');
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(AddTodoDialog), findsNothing);
  });
}

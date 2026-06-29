import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/edit_todo_dialog.dart';
import 'package:todo_app/features/todo/presentation/widgets/todo_input.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({
    super.key,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();

    context.read<TodoBloc>().add(
          LoadTodos(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo",
        ),
      ),
      body: Column(
        children: [
          const TodoInput(),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TodoError) {
                  return Center(
                    child: Text(
                      state.message,
                    ),
                  );
                }
                if (state is TodoLoaded) {
                  if (state.filteredTodos.isEmpty) {
                    return const Center(
                      child: Text(
                        "No todo yet",
                      ),
                    );
                  }
                  final remaining = state.todos
                      .where(
                        (todo) => !todo.isCompleted,
                      )
                      .length;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "Total: ${state.todos.length} | Remaining: $remaining",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                    ChangeTodoFilter(
                                      TodoFilter.all,
                                    ),
                                  );
                            },
                            child: const Text("All"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                    ChangeTodoFilter(
                                      TodoFilter.active,
                                    ),
                                  );
                            },
                            child: const Text("Active"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                    ChangeTodoFilter(
                                      TodoFilter.completed,
                                    ),
                                  );
                            },
                            child: const Text("Completed"),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredTodos.length,
                          itemBuilder: (_, index) {
                            final todo = state.filteredTodos[index];
                            return ListTile(
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                todo.description,
                              ),
                              leading: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (value) {
                                  context.read<TodoBloc>().add(
                                        UpdateTodoEvent(
                                          todo.copyWith(
                                            isCompleted: value ?? false,
                                          ),
                                        ),
                                      );
                                },
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => EditTodoDialog(
                                          todo: todo,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<TodoBloc>().add(
                                            DeleteTodoEvent(todo.id),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

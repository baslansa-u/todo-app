import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:todo_app/features/todo/presentation/widgets/edit_todo_dialog.dart';
import 'package:todo_app/features/todo/presentation/widgets/filter_tab_bar.dart';
import 'package:todo_app/features/todo/presentation/widgets/search_bar.dart';
import 'package:todo_app/features/todo/presentation/widgets/summary_card.dart';
import 'package:todo_app/features/todo/presentation/widgets/todo_list_item.dart';

class TodoPage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const TodoPage({
    super.key,
    required this.onToggleTheme,
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
      appBar: _buildAppBar(),
      floatingActionButton: _buildAddTodoButton(),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) return _buildLoading();
          if (state is TodoError) return _buildError(state.message);
          if (state is TodoLoaded) return _buildLoaded(context, state);
          return const SizedBox();
        },
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Todo App"),
      elevation: 1,
      actions: [
        IconButton(
          onPressed: widget.onToggleTheme,
          icon: const Icon(Icons.dark_mode_outlined),
        ),
      ],
    );
  }

  // Loading state
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Error state
  Widget _buildError(String message) {
    return Center(child: Text(message));
  }

  // Loaded state
  Widget _buildLoaded(BuildContext context, TodoLoaded state) {
    return Column(
      children: [
        _buildSummary(state),
        _buildFilter(context, state),
        const SizedBox(height: 10),
        _buildTodoList(context, state),
      ],
    );
  }

  // Summary cards
  Widget _buildSummary(TodoLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: SummaryCard(
              title: "Total",
              value: state.total,
              icon: Icons.list_alt,
            ),
          ),
          Expanded(
            child: SummaryCard(
              title: "Active",
              value: state.remaining,
              icon: Icons.pending_actions,
            ),
          ),
          Expanded(
            child: SummaryCard(
              title: "Done",
              value: state.done,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }

  // Filter tab bar
  Widget _buildFilter(BuildContext context, TodoLoaded state) {
    return Column(
      children: [
        FilterTabBar(
          selectedFilter: state.filter,
          onChanged: (filter) {
            context.read<TodoBloc>().add(ChangeTodoFilter(filter));
          },
        ),
        SearchBarWidget(
          hintText: "Search task...",
          onChanged: (query) {
            context.read<TodoBloc>().add(
                  SearchByTitle(query),
                );
          },
        )
      ],
    );
  }

  // Todo list
  Widget _buildTodoList(BuildContext context, TodoLoaded state) {
    if (state.filteredTodos.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No todo")),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: state.filteredTodos.length,
        itemBuilder: (_, index) {
          final todo = state.filteredTodos[index];
          return TodoListItem(
            todo: todo,
            onChanged: (value) {
              context.read<TodoBloc>().add(
                    UpdateTodoEvent(
                      todo.copyWith(isCompleted: value ?? false),
                    ),
                  );
            },
            onEdit: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<TodoBloc>(),
                  child: EditTodoDialog(todo: todo),
                ),
              );
            },
            onDelete: () {
              context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
            },
          );
        },
      ),
    );
  }

  Widget _buildAddTodoButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        onPressed: _showAddTodo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  // bottom
  void _showAddTodo() {
    showDialog(
      context: context,
      builder: (_) => AddTodoDialog(
        onAdd: (todo) {
          context.read<TodoBloc>().add(AddTodoEvent(todo));
        },
      ),
    );
  }
}

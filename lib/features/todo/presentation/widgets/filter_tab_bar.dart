import 'package:flutter/material.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

class FilterTabBar extends StatelessWidget {
  final TodoFilter selectedFilter;
  final ValueChanged<TodoFilter> onChanged;

  const FilterTabBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTab(
          context,
          "All",
          TodoFilter.all,
        ),
        _buildTab(
          context,
          "Active",
          TodoFilter.active,
        ),
        _buildTab(
          context,
          "Completed",
          TodoFilter.completed,
        ),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context,
    String title,
    TodoFilter filter,
  ) {
    final selected = selectedFilter == filter;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            foregroundColor: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            onChanged(filter);
          },
          child: Text(title),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onChanged;

  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: selectedDate ?? DateTime.now(),
    );

    onChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Due Date",
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          suffixIcon: selectedDate != null
              ? IconButton(
                  tooltip: "Clear due date",
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    onChanged(null);
                  },
                )
              : null,
        ),
        child: InkWell(
          onTap: () => _pickDate(context),
          child: Text(
            selectedDate == null
                ? "Select date"
                : "${selectedDate!.day}/"
                    "${selectedDate!.month}/"
                    "${selectedDate!.year}",
          ),
        ),
      ),
    );
  }
}

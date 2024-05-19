import 'package:flutter/material.dart';

Future<void> selectDate(
    BuildContext context,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
    ) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(), // Change the theme for the date picker
        child: child!,
      );
    },
  );
  if (picked != null) {
    onDateSelected(picked);
  }
}

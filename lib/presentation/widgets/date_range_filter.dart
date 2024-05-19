// date_range_filter.dart
import 'package:flutter/material.dart';

Future<void> showCustomDateRangePicker(BuildContext context, void Function(DateTime, DateTime) onFilter) async {
  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: Colors.black,
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    onFilter(picked.start, picked.end);
  }
}

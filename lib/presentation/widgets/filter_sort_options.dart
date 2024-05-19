import 'package:flutter/material.dart';
import 'package:track_expense/presentation/widgets/date_range_filter.dart'; // Import the new file
import 'package:track_expense/presentation/widgets/sort_options.dart'; // Import the new file

class FilterSortOptions extends StatelessWidget {
  final void Function(DateTime, DateTime) onFilter;
  final void Function(String) onSort;

  const FilterSortOptions({
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.black.withOpacity(0.5), // Transparent background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                showCustomDateRangePicker(context, onFilter);
              },
              icon: Icon(Icons.filter_list, color: Colors.white),
              label: Text('Filter', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Transparent background
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
              ),
            ),
          ),
          SizedBox(width: 20), // Add some space between the buttons
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                showSortOptions(context, onSort);
              },
              icon: Icon(Icons.sort, color: Colors.white),
              label: Text('Sort', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Transparent background
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
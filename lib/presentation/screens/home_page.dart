import 'package:flutter/material.dart';
import 'add_expense.dart';
import 'package:track_expense/presentation/screens/profile_page.dart';
import 'package:track_expense/presentation/widgets/bottom_navigation_bar.dart';
import 'package:track_expense/presentation/widgets/header_widget.dart';
import 'package:track_expense/presentation/widgets/expense_list_widget.dart';
import 'package:track_expense/presentation/widgets/filter_sort_options.dart'; // Import the new file

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  DateTime startDate = DateTime(2000, 1, 1);
  DateTime endDate = DateTime.now();
  String sortBy = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleFilter(DateTime start, DateTime end) {
    setState(() {
      startDate = start;
      endDate = end;
    });
    _refreshExpenseList(); // Trigger refresh when filter changes
  }

  void _handleSort(String sortByValue) {
    setState(() {
      sortBy = sortByValue;
    });
    _refreshExpenseList(); // Trigger refresh when sort changes
  }

  void _refreshExpenseList() {
    setState(() {
      // No need for the key if it's not used
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          HeaderWidget(),
          SizedBox(height: 30.0),
          if (_currentPageIndex == 0) ...[
            FilterSortOptions(
              onFilter: _handleFilter,
              onSort: _handleSort,
            ),
            Divider(color: Colors.white, thickness: 0.3),
          ],
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                ExpenseListWidget(
                  key: UniqueKey(), // Use UniqueKey to force rebuild
                  startDate: startDate,
                  endDate: endDate,
                  sortBy: sortBy,
                ),
                AddExpensePage(),
                ProfilePage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

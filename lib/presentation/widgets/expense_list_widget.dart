import 'package:flutter/material.dart';
import 'package:track_expense/data/database_helper.dart';
import 'package:track_expense/presentation/screens/expense_details_page.dart';
import 'package:track_expense/utils/date_utils.dart'; // Import your custom date formatting function

class ExpenseListWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String sortBy;
  final Key? key; // Add the key parameter

  ExpenseListWidget({
    required this.startDate,
    required this.endDate,
    required this.sortBy,
    this.key, // Update the constructor
  }) : super(key: key); // Pass the key to the superclass constructor

  @override
  _ExpenseListWidgetState createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  late Future<List<Map<String, dynamic>>> _expenseList;

  // Define a map to map each expense type to a specific color
  final Map<String, Color> _expenseTypeColors = {
    'Health': Colors.redAccent,
    'Education': Colors.orangeAccent,
    'Food': Colors.yellowAccent,
    'Transportation': Colors.greenAccent,
    'Entertainment': Colors.blueAccent,
    'Utilities': Colors.indigoAccent,
    'Clothing': Colors.purpleAccent,
    'Rent': Colors.pinkAccent,
    'Travel': Colors.tealAccent,
    'Gift': Colors.cyanAccent,
    'Others': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _expenseList = _fetchExpenses();
  }

  Future<List<Map<String, dynamic>>> _fetchExpenses() async {
    // Format start and end dates using formatDate function
    String formattedStartDate = formatDate(widget.startDate);
    String formattedEndDate = formatDate(widget.endDate);

    // Get expenses from the database using formatted dates
    List<Map<String, dynamic>> expenses = await DatabaseHelper().getExpenses(formattedStartDate, formattedEndDate);

    // Create a copy of the expenses list to avoid modifying the original list
    List<Map<String, dynamic>> sortedExpenses = List.from(expenses);

    // Sort expenses based on the sortBy parameter
    switch (widget.sortBy) {
      case 'Highest Amount':
        sortedExpenses.sort((a, b) => b['amount'].compareTo(a['amount']));
        break;
      case 'Lowest Amount':
        sortedExpenses.sort((a, b) => a['amount'].compareTo(b['amount']));
        break;
      case 'Recent':
        sortedExpenses.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
        break;
      case 'Oldest':
        sortedExpenses.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
        break;
      default:
      // Do nothing if sortBy parameter is not recognized
    }

    return sortedExpenses;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _expenseList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No expenses found', style: TextStyle(color: Colors.white)));
        } else {

          // Calculate total sum of all expenses
          double totalAmount = snapshot.data!.map<double>((expense) => expense['amount']).reduce((value, element) => value + element);
          String formattedStartDate = formatDate(widget.startDate);
          String formattedEndDate = formatDate(widget.endDate);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final expense = snapshot.data![index];
                    final String type = expense['type'];
                    final Color typeColor = _expenseTypeColors[type] ?? Colors.grey; // Default color for unknown types

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the ExpenseDetailsPage and pass the database ID of the selected expense
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseDetailsPage(expense: expense),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [typeColor.withOpacity(0.6), typeColor.withOpacity(0.8)], // Use expense type color for gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: typeColor.withOpacity(0.4), // Use expense type color for shadow
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              expense['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            subtitle: Text(
                              type,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${expense['amount']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // Add spacing between amount and delete icon
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Theme(
                                          data: ThemeData.dark(), // Set the theme to dark
                                          child: AlertDialog(
                                            backgroundColor: Colors.black, // Set background color to black
                                            title: Text(
                                              'Confirm Deletion',
                                              style: TextStyle(color: Colors.white), // Set text color to white
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this expense?',
                                              style: TextStyle(color: Colors.white), // Set text color to white
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await DatabaseHelper().deleteExpense(expense['id']); // Delete the expense from the database
                                                  setState(() {
                                                    _expenseList = _fetchExpenses(); // Refresh the expense list with the same date range
                                                  });
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: Text('Yes', style: TextStyle(color: Colors.white)), // Set text color to white
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: Text('No', style: TextStyle(color: Colors.white)), // Set text color to white
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20, // Set the size of the delete icon
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white), // Add border
                  borderRadius: BorderRadius.circular(10.0), // Add border radius
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$formattedStartDate to $formattedEndDate',
                        style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0), // Add space between texts
                      Text(
                        'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}


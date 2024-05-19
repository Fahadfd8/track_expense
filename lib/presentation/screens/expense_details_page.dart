import 'package:flutter/material.dart';
import 'package:track_expense/presentation/widgets/data_card.dart';
import 'package:track_expense/utils/date_utils.dart';

class ExpenseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> expense;

  ExpenseDetailsPage({required this.expense});

  @override
  Widget build(BuildContext context) {
    // Parse the date string to a DateTime object
    DateTime expenseDate = DateTime.parse(expense['date']);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Text(
                  'Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                DataCard(title: 'Title', value: '${expense['name']}'),
                SizedBox(height: 20),
                DataCard(title: 'Type', value: '${expense['type']}'),
                SizedBox(height: 20),
                DataCard(title: 'Amount', value: '\$${expense['amount']}'),
                SizedBox(height: 20),
                DataCard(title: 'Date', value: formatDate(expenseDate)), // Use formatDate function with expenseDate
                SizedBox(height: 20),
                DataCard(title: 'Description', value: '${expense['description']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

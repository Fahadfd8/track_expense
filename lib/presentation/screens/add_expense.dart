import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_expense/data/database_helper.dart';
import 'package:track_expense/utils/date_utils.dart';
import 'package:track_expense/utils/date_picker_util.dart'; // Add this import for date formatting

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define variables to hold form values
  String _name = '';
  String _type = '';
  double _amount = 0.0;
  DateTime? _selectedDate; // Make this nullable
  String _description = '';
  String? _dateError; // Variable to hold date error message

  // List of expense types for dropdown
  final List<String> _expenseTypes = [
    'Health',
    'Education',
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Clothing',
    'Rent',
    'Travel',
    'Gift',
    'Others'
  ];

  // Inside _AddExpensePageState class or any other class
  Future<void> _selectDate(BuildContext context) async {
    selectDate(context, _selectedDate, (DateTime picked) {
      setState(() {
        // Format the selected date using formatDate function from date_utils.dart
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
        _dateError = null; // Clear date error when a date is picked
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected date for display
    String formattedDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select Date';

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0), // Add space from the top
        child: SingleChildScrollView(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set border color to white
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white), // Set border color to white
                    borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Type',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Set border color to white
                      ),
                    ),
                    dropdownColor: Colors.black54, // Set dropdown background color to black
                    items: _expenseTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Container(
                          color: Colors.black54, // Set item background color to black
                          child: Text(
                            type,
                            style: TextStyle(color: Colors.white), // Set dropdown item text color to white
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                    selectedItemBuilder: (_) {
                      return _expenseTypes.map<Widget>((String item) {
                        return Text(
                          item,
                          style: TextStyle(color: Colors.white), // Set selected item text color to white
                        );
                      }).toList();
                    },
                    value: _type.isEmpty ? null : _type, // Set value to null to remove default selection
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set border color to white
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // Set border color to white
                      borderRadius: BorderRadius.circular(5.0), // Optional: Set border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: $formattedDate',
                            style: TextStyle(color: Colors.white), // Set text color to white
                          ),
                          if (_dateError != null) // Display date error message if any
                            Text(
                              _dateError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set border color to white
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _dateError = _selectedDate == null ? 'Please select a date' : null;
                    });

                    if (_formKey.currentState?.validate() ?? false && _selectedDate != null) {
                      final expense = {
                        'name': _name,
                        'type': _type,
                        'amount': _amount,
                        'date': formatDate(_selectedDate!), // Use formatted date here
                        'description': _description,
                      };
                      print('Date before format: $_selectedDate'); // Print date before format
                      print('Date after format: ${formatDate(_selectedDate!)}'); // Print date after format
                      await DatabaseHelper().insertExpense(expense);

                      // Clear the form and reset the state
                      _formKey.currentState?.reset();
                      setState(() {
                        _name = '';
                        _type = '';
                        _amount = 0.0;
                        _selectedDate = null;
                        _description = '';
                      });

                      // Show confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('New expense added'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Show error message if form is not valid
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

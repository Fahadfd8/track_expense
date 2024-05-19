import 'package:flutter/material.dart';
import 'presentation/app_theme.dart'; // Importing the app_theme.dart file
import 'package:track_expense/presentation/screens/front_page.dart';
// Importing the home_page.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getAppTheme(), // Use the common theme here
      home: FrontPage(),
    );
  }
}

// sort_options.dart
import 'package:flutter/material.dart';

void showSortOptions(BuildContext context, void Function(String) onSort) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Sort by', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Highest Amount', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSort('Highest Amount');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Lowest Amount', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSort('Lowest Amount');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Recent', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSort('Recent');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Oldest', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSort('Oldest');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

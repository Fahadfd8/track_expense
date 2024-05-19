import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      print('Database is already open.');
      return _database!;
    }

    print('Initializing database...');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Open the database and create tables if not exists
    final path = await getDatabasesPath();
    final databasePath = join(path, 'expenses.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create your tables here
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY,
            name TEXT,
            amount REAL,
            type TEXT,
            date TEXT
          )
        ''');
      },
    );

    print('Database initialized.');

    return _database!;
  }


  Future<List<Map<String, dynamic>>> getExpenses(String startDate, String endDate) async {
    final Database db = await database;

    try {
      final List<Map<String, dynamic>> expenses = await db.query(
        'expenses',
        where: "date BETWEEN ? AND ?",
        whereArgs: [startDate, endDate],
      );

      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }



  Future<void> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;
    await db.insert('expenses', expense);
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

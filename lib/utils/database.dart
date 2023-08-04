import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Run on database creation
void _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS receipts (
      id INTEGER PRIMARY KEY,
      date TEXT,
      amount INTEGER,
      store TEXT,
      description TEXT,
      fileName TEXT
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS profiles (
      id INTEGER PRIMARY KEY,
      iban TEXT NOT NULL,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL
    );
  ''');
}

/// Initialize and return the database
Future<Database> initDb() async {
  const dbName = 'easymoney.db';
  final databasesPath = await getDatabasesPath();
  final dbPath = join(databasesPath, dbName);
  try {
    await Directory(databasesPath).create(recursive: true);
  } catch (_) {}

  final db = await openDatabase(
    dbPath,
    onCreate: _onCreate,
    version: 1,
    singleInstance: true,
  );

  return db;
}

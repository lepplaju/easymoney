import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Run on database creation
void _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS profiles (
      id INTEGER PRIMARY KEY,
      profileName TEXT NOT NULL,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      iban TEXT NOT NULL,
      target TEXT NOT NULL
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS invoices (
      id INTEGER PRIMARY KEY,
      profileId INTEGER NOT NULL,
      date TEXT NOT NULL,
      target TEXT NOT NULL,
      name TEXT NOT NULL,
      amount INTEGER NOT NULL,
      fileName TEXT NOT NULL,
      FOREIGN KEY (profileId) REFERENCES profiles (id) ON DELETE CASCADE ON UPDATE CASCADE
    );
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS receipts (
      id INTEGER PRIMARY KEY,
      date TEXT,
      amount INTEGER,
      store TEXT,
      description TEXT,
      fileName TEXT,
      profileId INT NOT NULL,
      FOREIGN KEY (profileId) REFERENCES profiles (id) ON DELETE CASCADE ON UPDATE CASCADE
    );
  ''');
}

/// Configures the database
void _onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
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
    onConfigure: _onConfigure,
    onCreate: _onCreate,
    version: 1,
    singleInstance: true,
  );

  return db;
}

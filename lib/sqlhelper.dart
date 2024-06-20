import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SqlHelper {
  // Function to create the tables
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE userdata(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      numberOne TEXT NOT NULL, 
      numberTwo TEXT NOT NULL, 
      answer TEXT NOT NULL
    )
    """);
  }

  // Function to open the database
  static Future<sql.Database> db() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'userdataDB.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Function to create a new item (insert data)
  static Future<int> createItem(Map<String, dynamic> data) async {
    final db = await SqlHelper.db();
    final id = await db.insert('userdata', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Function to get all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('userdata', orderBy: "id");
  }

  // Function to get a single item by id
  static Future<Map<String, dynamic>> getItem(int id) async {
    final db = await SqlHelper.db();
    final List<Map<String, dynamic>> maps =
    await db.query('userdata', where: "id = ?", whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Function to update an item
  static Future<int> updateItem(Map<String, dynamic> data) async {
    final db = await SqlHelper.db();
    final result = await db
        .update('userdata', data, where: "id = ?", whereArgs: [data['id']]);
    return result;
  }

  // Function to delete an item
  static Future<void> deleteItem(int id) async {
    final db = await SqlHelper.db();
    try {
      await db.delete("userdata", where: "id = ?", whereArgs: [id]);
      print("Deleted item with id: $id");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
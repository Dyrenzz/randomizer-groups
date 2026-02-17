// import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/models/group.dart';

class DatabaseHelper {
  
  static DatabaseHelper? _databaseHelper;    // Singleton DatabaseHelper
  static Database? _database;                // Singleton Databse

  // Table name
  String groupTable = 'group_table';

  // Column value
  String colId = 'id';
  String colGroupName = 'group_name';
  String colDescription = 'description';
  String colMembersName = 'members_name';


  DatabaseHelper._createInstance();         // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

// --------------------------
  // Database reference
  Future<Database> get database async {
    // Null-aware assignment operator '??='
    _database ??= await initializeDatabase();
    return _database!;
  }

// --------------------------
  // Intialize the database
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    String directory = await getDatabasesPath();
    // Join the directory with the file names
    String path = join(directory, '$groupTable.db');

    // Open or create the database at a given path
    var groupsDatabase = await openDatabase(
      // Set the path to the database
      path, 
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades
      version: 1, 
      // When the database is first created, create a table to store groups.
      onCreate: _createDb);
    return groupsDatabase;
  }

  // Create database methode
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $groupTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colGroupName VARCHAR(63), $colDescription TEXT, $colMembersName TEXT)');
  }
// --------------------------

  /// Fetch Operation: Get all group object from database
  // List >> [], Map >> {}
  Future<List<Map<String, Object?>>> getGroupMapList() async {
    Database db = await database;
    
    // var result = await db.rawQuery('SELECT * FROM $groupTable order by $colGroupId ASC');
    var result = await db.query(groupTable, orderBy: '$colId ASC');
    return result;
  }

  /// Get Group Operation: Get group
  Future<List<Map<String, Object?>>> getGroupById(int id) async {
    Database db = await database;

    var result = await db.query(groupTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  /// Insert Operation: Insert a Group object to database
  // e.g >> Group groupA = Group(_groupName: _groupName, _description: _description, _membersName: [])
  Future<int> insertGroup(Group group) async {
    // Get a reference to the database.
    Database db = await database;

    var result = await db.insert(groupTable, group.toMap());
    return result;
  }

  /// Update Operation: Update a Group object and save it to database
  Future<int> updateGroup(Group group) async {
    // Get a reference to the database.
    var db = await database;

    var result = await db.update(
      groupTable, 
      group.toMap(), 
      where: '$colId = ?', 
      whereArgs: [group.id]
    );
    return result;
  }

  /// Delete Operation: Delete a Group from database
  Future<int> deleteGroupById(int id) async {
    // Get a reference to the database.
    var db = await database;

    int result = await db.rawDelete('DELETE FROM $groupTable WHERE $colId = $id');
    return result;
  }

  /// Get number of Group objects in database
  Future<int> getCount() async {
    // Get a reference to the database.
    Database db = await database;

    List<Map<String, Object?>> count = await db.rawQuery('SELECT COUNT(*) FROM $groupTable');
    int result = Sqflite.firstIntValue(count) ?? 0;
    return result;
  }
}
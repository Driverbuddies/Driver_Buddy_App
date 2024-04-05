import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static const _databaseName = "data";
  static const _databaseVersion = 1;

  static const table = "driver"; // Use "driver" for the existing table

  static const columnId = "_id";
  static const columnName = "name";
  static const columnEmail = "email";
  static const columnDob = "dob";
  static const columnAadhar = "aadhar";
  static const columnDl = "dl";
  static const columnIssueDate = "issue_date";
  static const columnExpiryDate = "expiry_date";
  static const columnReferredBy = "referred_by";
  static const columnPassword = "password";

  // Make this class a singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;

  // Unnamed constructor for creating an instance of DatabaseHelper
  factory DatabaseHelper() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // This opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    // Set the databaseFactory to databaseFactoryFfi
    databaseFactory = databaseFactoryFfi;

    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
    );
  }

  // When the database is first created, create the "driver" table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table('
      '$columnId INTEGER PRIMARY KEY,'
      '$columnName TEXT,'
      '$columnEmail TEXT,'
      '$columnDob TEXT,'
      '$columnAadhar TEXT,'
      '$columnDl TEXT,'
      '$columnIssueDate TEXT,'
      '$columnExpiryDate TEXT,'
      '$columnReferredBy TEXT,'
      '$columnPassword TEXT'
      ')',
    );
  }

  // Method to insert data into the "driver" table
  Future<int> insertDriver(Map<String, dynamic> driverData) async {
    Database db = await instance.database;
    return await db.insert(table, driverData);
  }

  //
}

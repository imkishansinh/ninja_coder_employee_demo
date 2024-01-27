import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/employee.dart';

class EmployeeDatasource {
  static final EmployeeDatasource _instance = EmployeeDatasource._();
  Database? _database;
  String dbName = 'employee.db';

  EmployeeDatasource._();

  factory EmployeeDatasource({String? dbName}) {
    if (dbName != null) {
      _instance.dbName = dbName;
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'employee.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE Employee("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "role TEXT,"
        "joiningDate TEXT,"
        "leavingDate TEXT)");
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    var result = await db.insert('Employee', employee.toMap());
    return result;
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    var result = await db.query('Employee');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Employee>> getActiveEmployees() async {
    final db = await database;
    var result = await db.query('Employee', where: 'leavingDate IS NULL');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Employee>> getFormerEmployees() async {
    final db = await database;
    var result = await db.query('Employee', where: 'leavingDate IS NOT NULL');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    var result = await db.update('Employee', employee.toMap(),
        where: 'id = ?', whereArgs: [employee.id]);
    return result;
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    var result = await db.delete('Employee', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('Employee');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

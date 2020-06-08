import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'employee.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Emp11DB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Employee1 ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "dept TEXT"
          ")");
      await db.execute("CREATE TABLE Employee2 ("
          "id INTEGER PRIMARY KEY,"
          "dos TEXT,"
          "salm DOUBLE"
          ")");
      await db.execute(
          "INSERT INTO Employee1 ('id', 'name', 'dept') values (?,?,?)",
          [1, "Ramesh", "IT"]);
      await db.execute(
          "INSERT INTO Employee1 ('id', 'name', 'dept') values (?,?,?)",
          [2, "Suresh", "MG"]);
      await db.execute(
          "INSERT INTO Employee1 ('id', 'name', 'dept') values (?,?,?)",
          [3, "Rajesh", "CS"]);
      await db.execute(
          "INSERT INTO Employee2 ('id', 'dos', 'salm') values (?,?,?)",
          [1, "2/2/2020", 25000]);
      await db.execute(
          "INSERT INTO Employee2 ('id', 'dos', 'salm') values (?,?,?)",
          [2, "3/2/2020", 23000]);
      await db.execute(
          "INSERT INTO Employee2 ('id', 'dos', 'salm') values (?,?,?)",
          [3, "1/2/2020", 18000]);
    });
  }

  Future<List<Employee>> getemployees() async {
    final db = await database;
    List<Map> results = await db.rawQuery(
        'SELECT * FROM Employee1 JOIN Employee2 on Employee2.id = Employee1.id GROUP BY Employee1.id');
    List<Employee> employees = new List();
    if (results.length > 0) {
      for (int i = 0; i < results.length; i++) {
        employees.add(Employee.fromMap(results[i]));
      }
    }
    return employees;
  }
}

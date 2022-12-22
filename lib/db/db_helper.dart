import 'package:flutter_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const _version = 1;
  static const String _tablename = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}task.db';
      _db =
          await openDatabase(path, version: _version, onCreate: ((db, version) {
        print("Creating a new database");
        return db.execute(
          "CREATE TABLE $_tablename("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, note TEXT, date STRING, "
          "startTime STRING, endTime STRING, "
          "remind INTEGER, repeat STRING, "
          "color INTEGER, isCompleted INTEGER) ",
        );
      }));
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tablename, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tablename);
  }

  static delete(Task? task) async {
    await _db!.delete(_tablename, where: 'id=?', whereArgs: [task!.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
        UPDATE tasks SET isCompleted = ? where id = ?
    ''', [1, id]);
  }
}

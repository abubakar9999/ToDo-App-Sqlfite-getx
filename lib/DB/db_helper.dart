import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static const _dbName = 'todo.db';
  static const _dbVersion = 1;
  static const _table = 'todo';
  static const _todoTitle = 'todoTitle';
  static const _todo = 'todo';
  static const _todoId = 'todoId';
  Database? _bd;
  Future<void> init() async {
    final docomentDirectory = await getApplicationDocumentsDirectory();
    final path = join(docomentDirectory.path, _dbName);
    _bd = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $_table(
  $_todoId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $_todoTitle TEXT,
  $_todo TEXT
)''');
  }

  Future<int?> insert(String? title, String? todo) async {
    return await _bd?.insert(_table, {_todoTitle: title, _todo: todo}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>?> quaryAllRows() async {
    return await _bd?.query(_table);
  }

  Future<int?> updated(int? columnId, String? title, String? todo) async {
    return await _bd?.update(_table, {_todoId: columnId, _todoTitle: title, _todo: todo}, where: '$_todoId=?', whereArgs: [columnId]);
  }

  Future<int?> delete(int columnId) async {
    return await _bd?.delete(_table, where: '$_todoId=?', whereArgs: [columnId]);
  }
}

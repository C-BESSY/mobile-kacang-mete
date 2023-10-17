import 'dart:io' as io;
import 'package:path/path.dart' as p;

import 'package:kacang_mete/common/constants/query_init_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBUtil {
  Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future _initDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "kacangMete.db");
    Database db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(queryInitDb);
        },
      ),
    );
    return db;
  }

  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    Database database = await db;
    return await database.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getRelation(
    String tableName, {
    required String foreignCol,
    required dynamic foreignKey,
  }) async {
    Database database = await db;
    return await database
        .query(tableName, where: "$foreignCol = ?", whereArgs: [foreignKey]);
  }

  Future<Map<String, dynamic>?> find(
    String tableName, {
    String col = 'id',
    required dynamic args,
  }) async {
    Database database = await db;
    final res =
        await database.query(tableName, where: "$col = ?", whereArgs: [args]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<int> insert(String tableName,
      {required Map<String, dynamic> row}) async {
    Database database = await db;
    return await database.insert(tableName, row);
  }

  Future<int> update(String tableName, int id,
      {required Map<String, dynamic> row}) async {
    Database database = await db;
    return await database
        .update(tableName, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String tableName, int id, {required String where, required List whereArgs}) async {
    Database database = await db;
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

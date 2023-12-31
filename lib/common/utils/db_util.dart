import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:path/path.dart' as p;

import 'package:kacang_mete/common/constants/query_init_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBUtil {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      _db = await _initDatabaseDesktop();
    } else {
      _db = await _initDatabaseMobile();
    }
    return _db!;
  }

  Future _initDatabaseMobile() async {
    WidgetsFlutterBinding.ensureInitialized();
    Database database = await sql.openDatabase(
      p.join(await sql.getDatabasesPath(), 'kacangMete.db'),
      onCreate: (db, version) async {
        await db.execute(initQueryItem);
        await db.execute(initQueryDefaultItem);
        await db.execute(initQueryItemVarian);
        await db.execute(initQueryDefaultItemVarian);
        await db.execute(initQueryDefaultItemVarianKacangTanah);
        await db.execute(initQueryKategori);
        await db.execute(initQueryDefaultKategori);
        await db.execute(initQueryPenjualan);
        await db.execute(initQueryPembelian);
      },
      version: 1,
    );
    return database;
  }

  Future _initDatabaseDesktop() async {
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

  Future<List<Map<String, dynamic>>> runRawQuery(String query) async {
    Database database = await db;
    return await database.rawQuery(query);
  }

  Future<int> getSumHargaByMonthYear(bool isPembelian, DateTime date) async {
    Database database = await db;
    final query = await database.rawQuery('''
      SELECT SUM(${isPembelian ? 'p.harga' : 'p.stored_price'}) as total
      FROM ${isPembelian ? 'pembelian' : 'penjualan'} p
      WHERE strftime('%Y', p.tgl) = '${date.year}' AND strftime('%m', p.tgl) = '${addZeroDigit(date.month)}';
''');
    if (query.first['total'] == null || query.isEmpty) return 0;
    return query.first['total'] as int;
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

  Future<bool> delete(String tableName, int id) async {
    Database database = await db;
    final query =
        await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    if (query == 0) return false;
    return true;
  }
}

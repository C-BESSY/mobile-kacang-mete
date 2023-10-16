import 'dart:io' as io;
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider extends ChangeNotifier {
  Database? _db;
  Database? get db => _db;

  Future initDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "kacangMete.db");
    _db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
    CREATE TABLE item
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(150) NOT NULL
    );

    CREATE TABLE item_varian
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      varian VARCHAR(150) NOT NULL,
      harga BIGINT NOT NULL,
      item_id INT NOT NULL,
      FOREIGN KEY (item_id) REFERENCES item(id)
    );

    CREATE TABLE kategori
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama VARCHAR(150) NOT NULL
    );

    CREATE TABLE pembelian
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      harga BIGINT NOT NULL,
      keterangan VARCHAR(150) NOT NULL,
      tgl date NOT NULL,
      kategori_id INT NOT NULL,
      FOREIGN KEY (kategori_id) REFERENCES kategori(id)
    );

    CREATE TABLE penjualan
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tgl date NOT NULL,
      qty INT NOT NULL,
      stored_price BIGINT NOT NULL,
      item_varian_id INT NOT NULL,
      FOREIGN KEY (item_varian_id) REFERENCES item_varian(id)
    );
    ''');
        },
      ),
    );
    notifyListeners();
  }
}

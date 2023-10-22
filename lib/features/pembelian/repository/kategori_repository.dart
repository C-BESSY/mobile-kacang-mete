import 'package:flutter/foundation.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/features/pembelian/types/kategori_type.dart';

class KategoriRepository {
  final DBUtil db = DBUtil();
  final String tableName = "kategori";

  Future<KategoriType?> getKategori({
    required int id,
  }) async {
    try {
      final data = await db.find(tableName, args: id);
      if (data != null) return KategoriType.fromDB(data);
      return null;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }

  Future<KategoriType?> getKategoriByName(
      {required String kategoriName}) async {
    try {
      final data = await db.find(tableName, col: 'name', args: kategoriName);
      if (data != null) return KategoriType.fromDB(data);
      return null;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }

  Future<List<KategoriType>> getKategoris() async {
    try {
      final datas = await db.getTableData(tableName);
      return datas.map((data) => KategoriType.fromDB(data)).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }

  Future<int> insertKategori({required KategoriType kategori}) async {
    try {
      return await db.insert("kategori", row: kategori.toMap());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return 0;
    }
  }
}

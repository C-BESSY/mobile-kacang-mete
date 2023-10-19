// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/pembelian/repository/kategori_repository.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';

class PembelianRepository {
  final DBUtil db = DBUtil();
  final String tableName = "pembelian";

  Future<PembelianType?> getPembelian({
    required int id,
  }) async {
    try {
      final data = await db.find(tableName, args: id);
      if (data != null) return PembelianType.fromDB(data);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> insertPembelian(
    BuildContext context, {
    required PembelianType pembelian,
  }) async {
    try {
      final kategori = await KategoriRepository()
          .getKategoriByName(kategoriName: pembelian.kategori.name);
      int kategoriId = kategori == null
          ? await KategoriRepository()
              .insertKategori(kategori: pembelian.kategori)
          : kategori.id;
      final insertId = await db.insert(tableName,
          row: pembelian.toMap()
            ..addAll({'kategori_id': kategoriId})
            ..remove('kategori'));
      if (insertId == 0) throw "Data tidak terinsert";
      return true;
    } catch (error) {
      print(error);
      showErrorApi(context, error);
      return false;
    }
  }
}

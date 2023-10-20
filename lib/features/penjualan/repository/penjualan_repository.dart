// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';

class PenjualanRepository {
  final DBUtil db = DBUtil();
  final String tableName = "penjualan";

  Future<PenjualanType?> getPenjualan({
    required int id,
  }) async {
    try {
      final data = await db.find(tableName, args: id);
      if (data != null) return PenjualanType.fromDB(data);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> insertPenjualan(
    BuildContext context, {
    required PenjualanType penjualan,
  }) async {
    try {
      final insertId = penjualan.id == 0
          ? await db.insert(tableName, row: penjualan.toMap())
          : await db.update(tableName, penjualan.id, row: penjualan.toMap());
      if (insertId == 0) throw "Data tidak terinsert";
      showSuccessMessage(context,
          "Sukses ${penjualan.id == 0 ? 'Menambah' : 'Mengubah'} Penjualan");
      return true;
    } catch (error) {
      print(error);
      showErrorApi(context, error);
      return false;
    }
  }

  Future<bool> deletePenjualan(context, {required int id}) async {
    try {
      if (!await db.delete(tableName, id)) throw "Tidak bisa dihapus";
      showSuccessMessage(context, "Sukses Menghapus Penjualan");
      return true;
    } catch (error) {
      return false;
    }
  }
}

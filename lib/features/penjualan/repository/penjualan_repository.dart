// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/item/repository/item_varian_repository.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';
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
      final insertId = await db.insert(tableName, row: penjualan.toMap());
      if (insertId == 0) throw "Data tidak terinsert";
      return true;
    } catch (error) {
      print(error);
      showErrorApi(context, error);
      return false;
    }
  }
}

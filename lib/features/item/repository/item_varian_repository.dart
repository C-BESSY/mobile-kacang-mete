// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemVarianRepository {
  final DBUtil db = DBUtil();
  final String tableName = "item_varian";

  Future<ItemVarianType?> getVarian({required int id}) async {
    try {
      final data = await db.find(
        tableName,
        args: id,
      );
      if (data == null) {
        throw "Not Found";
      }
      return ItemVarianType.fromDB(data);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }

  Future<List<ItemVarianType>> getVariansByItem({
    required int itemId,
  }) async {
    try {
      final datas = await db.getRelation(
        tableName,
        foreignCol: "item_id",
        foreignKey: itemId,
      );
      return datas.map((data) => ItemVarianType.fromDB(data)).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }

  Future<bool> insertItemVarian(
    BuildContext context, {
    required ItemVarianType varian,
  }) async {
    try {
      if (varian.id == null) {
        await db.insert(tableName, row: varian.toMap());
      } else {
        await db.update(tableName, varian.id!, row: varian.toMap());
      }
      return true;
    } catch (error) {
      showErrorApi(context, error);
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }

  Future<bool> deleteItemVarian(
    BuildContext context, {
    required ItemVarianType varian,
  }) async {
    try {
      await db.delete(tableName, varian.id!);
      return true;
    } catch (error) {
      showErrorApi(context, error);
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }
}

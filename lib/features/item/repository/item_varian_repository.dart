import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemVarianRepository {
  final DBUtil db = DBUtil();
  final String tableName = "item_varian";

  Future<List<ItemVarianType>> getVariansByItem(
    BuildContext context, {
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
      print(error);
      return [];
    }
  }

  Future<bool> insertItemVarian(BuildContext context,
      {required Map<String, dynamic> row}) async {
    try {
      await db.insert(tableName, row: row);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

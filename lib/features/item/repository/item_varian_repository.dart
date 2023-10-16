import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemVarianRepository {
  final DBUtil db = DBUtil();
  final String tableName = "item_varian";

  Future<ItemVarianType?> getVarians(context, {required int varianId}) async {
    try {
      final data = await db.find(
        tableName,
        args: varianId,
      );
      if (data == null) {
        throw "Not Found";
      }
      return ItemVarianType.fromDB(data);
    } catch (error) {
      print(error);
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
      print(error);
      return [];
    }
  }

  Future<bool> insertItemVarian(BuildContext context,
      {required Map<String, dynamic> row}) async {
    try {
      //TODO: check if the row varians is deleted then in db deleted to!
      if (row['id'] == null) {
        await db.insert(tableName, row: row);
      } else {
        await db.update(tableName, row['id'], row: row);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

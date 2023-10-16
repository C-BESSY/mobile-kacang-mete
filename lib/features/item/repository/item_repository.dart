// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/item/repository/item_varian_repository.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemRepository {
  final DBUtil db = DBUtil();
  final String tableName = "item";

  Future<List<ItemType>> getItems(BuildContext context) async {
    try {
      final datas = await db.getTableData(tableName);
      return datas.map((data) => ItemType.fromDB(data)).toList();
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> insertItem(
    BuildContext context, {
    required String itemName,
    String? rawName,
    required List<ItemVarianType> variants,
  }) async {
    try {
      final item =
          await db.find(tableName, col: 'name', args: rawName ?? itemName);
      final row = {
        'name': itemName,
      };
      int itemId = 0;
      if (item == null) {
        itemId = await db.insert(tableName, row: row);
      } else {
        itemId = item['id'];
        await db.update(tableName, itemId, row: row);
      }
      for (var varian in variants) {
        await ItemVarianRepository().insertItemVarian(context,
            row: {'item_id': itemId}..addAll(varian.toMap()));
      }
      return true;
    } catch (error) {
      print(error);
      showErrorApi(context, error);
      return false;
    }
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/show_dialog_widget.dart';
import 'package:kacang_mete/features/item/repository/item_varian_repository.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemRepository {
  final DBUtil db = DBUtil();
  final String tableName = "item";

  Future<ItemType?> getItem({required int itemId}) async {
    try {
      final data = await db.find(tableName, args: itemId);
      if (data != null) return ItemType.fromDB(data);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<ItemType?> getItemByName({required String itemName}) async {
    try {
      final data = await db.find(tableName, col: 'name', args: itemName);
      if (data != null) return ItemType.fromDB(data);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<ItemType>> getItems(BuildContext context) async {
    try {
      final datas = await db.getTableData(tableName);
      final List<ItemType> dataToBeReturn = [];
      for (var element in datas) {
        dataToBeReturn.add(await ItemType.fromDB(element));
      }
      return dataToBeReturn;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> deleteItem(
    BuildContext context, {
    required ItemType item,
  }) async {
    try {
      await db.delete(tableName, item.id);
      showSuccessMessage(context, "Sukses Menghapus Item");
      return true;
    } catch (error) {
      showErrorApi(context, error);
      print(error);
      return false;
    }
  }

  Future<bool> insertItem(
    BuildContext context, {
    required String itemName,
    String? rawName,
    required List<ItemVarianType> variants,
  }) async {
    try {
      final item = await getItemByName(itemName: rawName ?? itemName);
      final row = {
        'name': itemName,
      };
      int itemId =
          item == null ? await db.insert(tableName, row: row) : item.id;

      if (item != null) {
        await db.update(tableName, itemId, row: row);
        final currentVarian =
            await ItemVarianRepository().getVariansByItem(itemId: itemId);
        final deletedVarian = currentVarian
            .where((variant) => !variants
                .where((selVariant) => selVariant.id == variant.id)
                .map((selVariant) => selVariant.id)
                .toList()
                .contains(variant.id))
            .toList();
        for (var deletedVar in deletedVarian) {
          await ItemVarianRepository()
              .deleteItemVarian(context, varian: deletedVar);
        }
      }

      for (var varian in variants) {
        await ItemVarianRepository()
            .insertItemVarian(context, varian: varian..itemId = itemId);
      }

      showSuccessMessage(
          context, "Sukses ${item == null ? 'Menambah' : 'Mengubah'} Item");
      return true;
    } catch (error) {
      print(error);
      showErrorApi(context, error);
      return false;
    }
  }
}

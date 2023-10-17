import 'package:kacang_mete/features/item/repository/item_repository.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';

class ItemVarianType {
  final int? id;
  int itemId;
  final String varian;
  final int harga;
  ItemVarianType({
    this.id,
    required this.varian,
    required this.harga,
    required this.itemId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'varian': varian,
      'harga': harga,
      'item_id': itemId,
    };
  }

  factory ItemVarianType.fromDB(Map<String, dynamic> data) {
    return ItemVarianType(
      id: data['id'],
      varian: data['varian'],
      harga: data['harga'],
      itemId: data['item_id'],
    );
  }

  Future<ItemType> getItem() async {
    final data = await ItemRepository().getItem(itemId: itemId);
    return data!;
  }
}

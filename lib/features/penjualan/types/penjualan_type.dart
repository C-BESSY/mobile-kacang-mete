import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class PenjualanType {
  final int id;
  final int quantity;
  final int storedPrice;
  final ItemVarianType varian;
  final String date;
  const PenjualanType({
    required this.id,
    required this.quantity,
    required this.storedPrice,
    required this.varian,
    required this.date,
  });

  Future<ItemType> get item {
    return varian.getItem();
  }

  Map<String, dynamic> toMap() {
    return {
      "qty": quantity,
      "stored_price": storedPrice,
      "tgl": date,
      "item_varian_id": varian.id
    };
  }
}

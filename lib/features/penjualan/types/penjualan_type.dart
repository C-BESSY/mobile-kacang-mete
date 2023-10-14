import 'package:kacang_mete/features/item/types/item_type.dart';

class PenjualanType {
  final int id;
  final int quantity;
  final int storedPrice;
  final ItemType item;
  const PenjualanType({
    required this.id,
    required this.quantity,
    required this.storedPrice,
    required this.item,
  });

  int get currentPrice {
    final item = this.item;
    if (item.jenis.isEmpty) return 0;
    return item.jenis.first.harga * quantity;
  }
}

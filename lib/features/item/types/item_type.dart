import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemType {
  final int id;
  final String name;
  final List<ItemVarianType> varian;
  const ItemType({
    required this.id,
    required this.name,
    required this.varian,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory ItemType.fromDB(Map<String, dynamic> data) {
    return ItemType(
      id: data['id'],
      name: data['name'],
      varian: [],
    );
  }
}

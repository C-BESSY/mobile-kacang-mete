import 'package:kacang_mete/features/item/types/item_jenis_type.dart';

class ItemType {
  final int id;
  final String name;
  final List<ItemJenisType> jenis;
  const ItemType({
    required this.id,
    required this.name,
    required this.jenis,
  });
}

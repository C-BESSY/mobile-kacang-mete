class ItemVarianType {
  final int? id;
  final String varian;
  final int harga;
  const ItemVarianType({
    this.id,
    required this.varian,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'varian': varian,
      'harga': harga,
    };
  }

  factory ItemVarianType.fromDB(Map<String, dynamic> data) {
    return ItemVarianType(
      id: data['id'],
      varian: data['varian'],
      harga: data['harga'],
    );
  }
}

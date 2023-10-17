class KategoriType {
  final int id;
  final String name;
  const KategoriType({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory KategoriType.fromDB(Map<String, dynamic> data) {
    return KategoriType(id: data['id'], name: data['name']);
  }
}

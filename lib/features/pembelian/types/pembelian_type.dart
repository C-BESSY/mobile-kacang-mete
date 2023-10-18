import 'package:kacang_mete/features/pembelian/repository/kategori_repository.dart';
import 'package:kacang_mete/features/pembelian/types/kategori_type.dart';

class PembelianType {
  final int id;
  final int harga;
  final String keterangan;
  final String date;
  final KategoriType kategori;
  const PembelianType({
    required this.id,
    required this.kategori,
    required this.harga,
    required this.keterangan,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "harga": harga,
      "keterangan": keterangan,
      "tgl": date,
      "kategori": kategori.name
    };
  }

  static Future<PembelianType> fromDB(Map<String, dynamic> data) async {
    final KategoriType kategori =
        await KategoriRepository().getKategori(id: data['kategori_id']) ??
            const KategoriType(id: 0, name: "Kategori tidak ditemukan/dihapus");
    return PembelianType(
      id: data['id'],
      harga: data['harga'],
      keterangan: data['keterangan'],
      date: data['tgl'],
      kategori: kategori,
    );
  }
}

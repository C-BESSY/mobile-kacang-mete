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
}

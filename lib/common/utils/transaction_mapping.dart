import 'package:kacang_mete/features/pembelian/repository/pembelian_repository.dart';
import 'package:kacang_mete/features/penjualan/repository/penjualan_repository.dart';

Future<List<dynamic>> transactionMapping(
    List<Map<String, dynamic>> rawData) async {
  final List<dynamic> response = [];

  for (var data in rawData) {
    if (data['is_pembelian'] == 1) {
      response.add(await PembelianRepository().getPembelian(id: data['id']));
    } else {
      response.add(await PenjualanRepository().getPenjualan(id: data['id']));
    }
  }
  return response;
}

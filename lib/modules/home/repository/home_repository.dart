import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/features/pembelian/repository/pembelian_repository.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';
import 'package:kacang_mete/features/penjualan/repository/penjualan_repository.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';

class HomeRepository {
  final DBUtil db = DBUtil();

  Future getOverview(DateTime date) async {
    final pembelian = await db.getSumHargaByMonthYear(true, date);
    final penjualan = await db.getSumHargaByMonthYear(false, date);
    return OverviewData(
        pembelian: pembelian,
        penjualan: penjualan,
        balance: penjualan - pembelian);
  }

  Future<List<dynamic>> getRecentTrasaction() async {
    try {
      final response = [];
      final rawData = await db.runRawQuery('''
      SELECT *
        FROM (
          SELECT id, tgl, true as is_pembelian
          FROM pembelian
          UNION ALL
          SELECT id, tgl, false
          FROM penjualan
        )
        order by tgl desc
        limit 10;
        ''');
      for (var data in rawData) {
        if (data['is_pembelian'] == 1) {
          response
              .add(await PembelianRepository().getPembelian(id: data['id']));
        } else {
          response
              .add(await PenjualanRepository().getPenjualan(id: data['id']));
        }
      }
      return response;
    } catch (error) {
      print("Error : $error");
      return [];
    }
  }
}

import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/utils/transaction_mapping.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';

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

      return await transactionMapping(rawData);
    } catch (error) {
      print("Error : $error");
      return [];
    }
  }
}

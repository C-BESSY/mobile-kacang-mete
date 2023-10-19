import 'package:intl/intl.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/utils/transaction_mapping.dart';
import 'package:kacang_mete/modules/transaction/types/weekly_income_expense_type.dart';

class TransactionRepository {
  DBUtil db = DBUtil();

  Future<Map<String, int>> getTheEdgeOfDate(DateTime date) async {
    final query = await db.runRawQuery('''
     SELECT min(strftime('%d', tgl)) as tgl_awal, max(strftime('%d', tgl)) as tgl_akhir
      FROM (
        SELECT id, tgl, true as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, false
        FROM penjualan
      )
      WHERE strftime('%Y', tgl) = '${date.year}' AND strftime('%m', tgl) = '${date.month}';
''');
    if (query.first['tgl_awal'] == null || query.isEmpty) {
      return {'firstDate': 0, 'lastDate': 0};
    }
    return {
      'firstDate': int.parse(query.first['tgl_awal']),
      'lastDate': int.parse(query.first['tgl_akhir'])
    };
  }

  Future<List<dynamic>> getDataDaily(DateTime date) async {
    try {
      final query = await db.runRawQuery('''
      SELECT *
      FROM (
        SELECT id, tgl, true as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, false
        FROM penjualan
      )
      WHERE strftime('%Y', tgl) = '${date.year}' 
      AND strftime('%m', tgl) = '${date.month}' 
      AND strftime('%d', tgl) = '${date.day}';
    ''');
      return await transactionMapping(query);
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<int> getDailySumIncome(DateTime selectedDate) async {
    final database = await db.runRawQuery('''
    SELECT SUM(stored_price) as total_penjualan
    FROM penjualan
    WHERE strftime('%Y', tgl) = '${selectedDate.year}' 
    AND strftime('%m', tgl) = '${selectedDate.month}' 
    AND strftime('%d', tgl) = '${selectedDate.day}';
    ''');
    if (database.isEmpty) {
      return 0;
    }
    if (database.first['total_penjualan'] == null) {
      return 0;
    }
    return database.first['total_penjualan'] as int;
  }

  Future<int> getDailySumExpense(DateTime selectedDate) async {
    final database = await db.runRawQuery('''
      SELECT SUM(harga) as total_pembelian
      FROM pembelian
      WHERE strftime('%Y', tgl) = '${selectedDate.year}' 
      AND strftime('%m', tgl) = '${selectedDate.month}' 
      AND strftime('%d', tgl) = '${selectedDate.day}';
    ''');
    if (database.isEmpty) {
      return 0;
    }
    if (database.first['total_pembelian'] == null) {
      return 0;
    }
    return database.first['total_pembelian'] as int;
  }

  Future<WeeklyIncomeExpenseType> getWeeklyIncomeExpense(
      DateTime startOfWeek, DateTime endOfWeek) async {
    try {
      final database = await db.runRawQuery('''
      SELECT 
       SUM(CASE WHEN is_pembelian THEN harga ELSE 0 END) AS total_pembelian,
       SUM(CASE WHEN NOT is_pembelian THEN harga ELSE 0 END) AS total_penjualan
      FROM (
        SELECT id, tgl, harga, true as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, false
        FROM penjualan
      )
      where tgl BETWEEN '${DateFormat("yyyy-MM-dd").format(startOfWeek)}' and '${DateFormat("yyyy-MM-dd").format(endOfWeek)}'
    ''');
      return WeeklyIncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const WeeklyIncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }
}

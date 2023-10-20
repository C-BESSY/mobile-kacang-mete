// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/utils/transaction_mapping.dart';
import 'package:kacang_mete/modules/transaction/types/date_edge.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionRepository {
  DBUtil db = DBUtil();

  Future<DateEdge> getTheEdgeOfDate(DateTime date) async {
    try {
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
        throw "Data masih kosong!";
      }
      return DateEdge.forDaily(query.first);
    } catch (error) {
      print(error);
      return const DateEdge(theStart: 0, theEnd: 0);
    }
  }

  Future<DateEdge> getTheEdgeOfMonth() async {
    try {
      final query = await db.runRawQuery('''
      SELECT min(strftime('%m', tgl)) as bln_awal, max(strftime('%m', tgl)) as bln_akhir
      FROM (
        SELECT id, tgl, harga, true as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, false
        FROM penjualan
      )
    ''');
      if (query.first['bln_awal'] == null || query.isEmpty) {
        throw "Data masih kosong";
      }
      return DateEdge.forMonthly(query.first);
    } catch (error) {
      print(error);
      return const DateEdge(theStart: 0, theEnd: 0);
    }
  }

  Future<DateEdge> getTheEdgeOfYear() async {
    try {
      final query = await db.runRawQuery('''
      SELECT min(strftime('%Y', tgl)) as thn_awal, max(strftime('%Y', tgl)) as thn_akhir
      FROM (
        SELECT id, tgl, harga, true as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, false
        FROM penjualan
      )
    ''');
      if (query.first['thn_awal'] == null || query.isEmpty) {
        throw "Data masih kosong";
      }
      return DateEdge.forYearly(query.first);
    } catch (error) {
      print(error);
      return const DateEdge(theStart: 0, theEnd: 0);
    }
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

  Future<IncomeExpenseType> getWeeklyIncomeExpense(
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
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Data masih kosong";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }

  Future<IncomeExpenseType> getMontlyIncomeExpense(int month) async {
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
      where strftime('%m', tgl) = '$month' 
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Data masih kosong";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }

  Future<IncomeExpenseType> getYearlyIncomeExpense(int year) async {
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
      where strftime('%Y', tgl) = '$year' 
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Data masih kosong";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }
}

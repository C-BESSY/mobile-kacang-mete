// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:kacang_mete/common/utils/db_util.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
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
          SELECT id, tgl, 1 as is_pembelian
          FROM pembelian
          UNION ALL
          SELECT id, tgl, 0
          FROM penjualan
          )
        WHERE strftime('%Y', tgl) = '${date.year}' AND strftime('%m', tgl) = '${addZeroDigit(date.month)}';
        ''');
      if (query.first['tgl_awal'] == null || query.isEmpty) {
        throw "Transaction Edge Day: Data masih kosong!";
      }
      return DateEdge.forDaily(query.first);
    } catch (error) {
      print(error);
      return const DateEdge(theStart: 0, theEnd: 0);
    }
  }

  Future<DateEdge> getTheEdgeOfMonth(int year) async {
    try {
      final query = await db.runRawQuery('''
      SELECT min(strftime('%m', tgl)) as bln_awal, max(strftime('%m', tgl)) as bln_akhir
      FROM (
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
       WHERE strftime('%Y', tgl) = '$year'
    ''');
      if (query.first['bln_awal'] == null || query.isEmpty) {
        throw "Transaction Edge Month: Data masih kosong!";
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
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
    ''');
      if (query.first['thn_awal'] == null || query.isEmpty) {
        throw "Transaction Edge Year: Data masih kosong!";
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
        SELECT id, tgl, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, 0
        FROM penjualan
      )
      WHERE strftime('%Y', tgl) = '${date.year}' 
      AND strftime('%m', tgl) = '${addZeroDigit(date.month)}' 
      AND strftime('%d', tgl) = '${addZeroDigit(date.day)}';
    ''');
      return await transactionMapping(query);
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<IncomeExpenseType> getWeeklyIncomeExpense(
      DateTime startOfWeek, DateTime endOfWeek) async {
    try {
      final database = await db.runRawQuery('''
      SELECT 
       SUM(CASE WHEN is_pembelian THEN harga ELSE 0 END) AS total_pembelian,
       SUM(CASE WHEN NOT is_pembelian THEN harga ELSE 0 END) AS total_penjualan
      FROM (
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
      where tgl BETWEEN '${DateFormat("yyyy-MM-dd").format(startOfWeek)}' and '${DateFormat("yyyy-MM-dd").format(endOfWeek)}'
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Transaction Weekly: Data masih kosong!";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }

  Future<IncomeExpenseType> getMontlyIncomeExpense(int month, int year) async {
    try {
      final database = await db.runRawQuery('''
      SELECT 
       SUM(CASE WHEN is_pembelian THEN harga ELSE 0 END) AS total_pembelian,
       SUM(CASE WHEN NOT is_pembelian THEN harga ELSE 0 END) AS total_penjualan
      FROM (
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
      where strftime('%m', tgl) = '${addZeroDigit(month)}'
       and strftime('%Y', tgl) = '$year'
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Transaction Monthly: Data masih kosong!";
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
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
      where strftime('%Y', tgl) = '$year' 
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Transaction Yearly: Data masih kosong!";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }

  Future<IncomeExpenseType> getAllIncomeExpense() async {
    try {
      final database = await db.runRawQuery('''
      SELECT 
       SUM(CASE WHEN is_pembelian THEN harga ELSE 0 END) AS total_pembelian,
       SUM(CASE WHEN NOT is_pembelian THEN harga ELSE 0 END) AS total_penjualan
      FROM (
        SELECT id, tgl, harga, 1 as is_pembelian
        FROM pembelian
        UNION ALL
        SELECT id, tgl, stored_price, 0
        FROM penjualan
      )
    ''');
      if (database.first['total_pembelian'] == null || database.isEmpty) {
        throw "Transaction all: Data masih kosong";
      }
      return IncomeExpenseType.fromDB(database.first);
    } catch (error) {
      print(error);
      return const IncomeExpenseType(sumExpense: 0, sumIncome: 0);
    }
  }
}

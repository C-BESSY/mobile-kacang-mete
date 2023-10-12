import 'package:kacang_mete/common/utils/helper_util.dart';

enum TransactionType { pengeluaran, penjualan }

extension TransactionTypeToString on TransactionType {
  String get value {
    return capitalizeWord(name);
  }
}

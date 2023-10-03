enum TransactionType { pengeluaran, pemasukan }

extension TransactionTypeToString on TransactionType {
  String get value {
    return name[0].toUpperCase() + name.substring(1);
  }
}

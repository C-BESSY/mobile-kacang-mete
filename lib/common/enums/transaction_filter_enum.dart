enum TransactionFilterEnum {
  harian,
  mingguan,
  bulanan,
  tahunan,
}

extension TransactionFilterEnumExtension on String {
  TransactionFilterEnum get transaction {
    switch (this) {
      case "harian":
        return TransactionFilterEnum.harian;
      case "mingguan":
        return TransactionFilterEnum.mingguan;
      case "bulanan":
        return TransactionFilterEnum.bulanan;
      default:
        return TransactionFilterEnum.tahunan;
    }
  }
}

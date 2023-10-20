class IncomeExpenseType {
  final int sumIncome;
  final int sumExpense;

  const IncomeExpenseType({
    required this.sumIncome,
    required this.sumExpense,
  });

  factory IncomeExpenseType.fromDB(Map<String, dynamic> data) {
    return IncomeExpenseType(
      sumIncome: data['total_pembelian'],
      sumExpense: data['total_penjualan'],
    );
  }
}

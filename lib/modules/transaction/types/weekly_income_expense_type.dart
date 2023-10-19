class WeeklyIncomeExpenseType {
  final int sumIncome;
  final int sumExpense;

  const WeeklyIncomeExpenseType({
    required this.sumIncome,
    required this.sumExpense,
  });

  factory WeeklyIncomeExpenseType.fromDB(Map<String, dynamic> data) {
    return WeeklyIncomeExpenseType(
      sumIncome: data['total_pembelian'],
      sumExpense: data['total_penjualan'],
    );
  }
}

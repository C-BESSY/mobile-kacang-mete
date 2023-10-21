import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/date_edge.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionMonthlyWidget extends StatefulWidget {
  final int selectedYear;
  const TransactionMonthlyWidget({super.key, required this.selectedYear});

  @override
  State<TransactionMonthlyWidget> createState() =>
      _TransactionMonthlyWidgetState();
}

class _TransactionMonthlyWidgetState extends State<TransactionMonthlyWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<Widget> get cardOverview async {
    final IncomeExpenseType incomeExpense = await TransactionRepository()
        .getYearlyIncomeExpense(widget.selectedYear);
    return CardOverviewWidget(
      overviewData: OverviewData(
          pembelian: incomeExpense.sumExpense,
          penjualan: incomeExpense.sumIncome,
          balance: incomeExpense.sumIncome - incomeExpense.sumExpense),
      description: "Tahun ${widget.selectedYear}",
    );
  }

  Future<List<Widget>> get rows async {
    List<Widget> data = [];
    DateEdge dateEdge =
        await TransactionRepository().getTheEdgeOfMonth(widget.selectedYear);
    final screenWidth = MediaQuery.of(context).size.width;
    for (int i = dateEdge.theStart; (i != 0 && i <= dateEdge.theEnd); i++) {
      IncomeExpenseType monthlyData = await TransactionRepository()
          .getMontlyIncomeExpense(i, widget.selectedYear);
      data.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${getMonthName(i)} ${widget.selectedYear}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              Row(
                children: [
                  Text(
                    intToIDR(monthlyData.sumIncome),
                    style: const TextStyle(color: Colors.green),
                  ),
                  SizedBox(
                    width: screenWidth * 0.025,
                  ),
                  Text(
                    intToIDR(monthlyData.sumExpense),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        FutureBuilder<Widget>(
          future: cardOverview,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data ?? const SizedBox();
            }
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025, vertical: screenHeight * 0.025),
          child: FutureBuilder<List<Widget>>(
            future: rows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Wrap(
                  children: snapshot.data ?? <Widget>[],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

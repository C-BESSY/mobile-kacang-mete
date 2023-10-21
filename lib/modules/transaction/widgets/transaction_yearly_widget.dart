import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/date_edge.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionYearlyWidget extends StatefulWidget {
  const TransactionYearlyWidget({super.key});

  @override
  State<TransactionYearlyWidget> createState() =>
      _TransactionYearlyWidgetState();
}

class _TransactionYearlyWidgetState extends State<TransactionYearlyWidget> {
  DateEdge dateEdge = const DateEdge(theStart: 0, theEnd: 0);

  @override
  void initState() {
    super.initState();
    TransactionRepository().getTheEdgeOfYear().then((value) => setState(() {
          dateEdge = value;
        }));
  }

  Future<Widget> get cardOverview async {
    final IncomeExpenseType incomeExpense =
        await TransactionRepository().getAllIncomeExpense();
    return CardOverviewWidget(
      overviewData: OverviewData(
          pembelian: incomeExpense.sumExpense,
          penjualan: incomeExpense.sumIncome,
          balance: incomeExpense.sumIncome - incomeExpense.sumExpense),
      description: "Keseluruhan",
    );
  }

  Future<List<Widget>> get rows async {
    List<Widget> data = [];
    final screenWidth = MediaQuery.of(context).size.width;
    for (int i = dateEdge.theStart; (i != 0 && i <= dateEdge.theEnd); i++) {
      IncomeExpenseType yearlyData =
          await TransactionRepository().getYearlyIncomeExpense(i);
      data.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$i",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              Row(
                children: [
                  Text(
                    intToIDR(yearlyData.sumIncome),
                    style: const TextStyle(color: Colors.green),
                  ),
                  SizedBox(
                    width: screenWidth * 0.025,
                  ),
                  Text(
                    intToIDR(yearlyData.sumExpense),
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

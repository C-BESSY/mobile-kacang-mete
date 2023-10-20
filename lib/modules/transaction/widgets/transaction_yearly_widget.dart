import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/date_edge.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionYearlyWidget extends StatefulWidget {

  const TransactionYearlyWidget({super.key});

  @override
  State<TransactionYearlyWidget> createState() => _TransactionYearlyWidgetState();
}

class _TransactionYearlyWidgetState extends State<TransactionYearlyWidget> {
  DateEdge dateEdge = DateEdge(theStart: 0, theEnd: 0);

  @override
  void initState() {
    super.initState();
    TransactionRepository()
        .getTheEdgeOfYear()
        .then((value) => setState(() {
              dateEdge = value;
              debugPrint("${value.theStart} ${value.theEnd}");
            }));
  }

  Future<List<Widget>> get rows async {
    List<Widget> data = [];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    for (int i = dateEdge.theStart; (i != 0 && i <= dateEdge.theEnd); i++) {
      IncomeExpenseType yearlyData = await TransactionRepository()
          .getYearlyIncomeExpense(i);
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
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(
                    width: screenWidth * 0.025,
                  ),
                  Text(
                    intToIDR(yearlyData.sumExpense),
                    style: TextStyle(color: Colors.red),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // CardOverviewWidget(title: "2023", description: "Yearly Transaction"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
          child: FutureBuilder<List<Widget>>(
            future: rows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while waiting.
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show an error message if there's an error.
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

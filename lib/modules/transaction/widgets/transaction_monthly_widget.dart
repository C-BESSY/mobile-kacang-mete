import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
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
  DateEdge dateEdge = DateEdge(theStart: 0, theEnd: 0);

  @override
  void initState() {
    super.initState();
    TransactionRepository()
        .getTheEdgeOfMonth(widget.selectedYear)
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
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(
                    width: screenWidth * 0.025,
                  ),
                  Text(
                    intToIDR(monthlyData.sumExpense),
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
        // CardOverviewWidget(title: "2023", description: "Monthly Transaction "),
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

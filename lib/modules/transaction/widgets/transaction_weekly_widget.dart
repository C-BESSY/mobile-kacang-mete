import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';

class TransactionWeeklyWidget extends StatelessWidget {
  final String selectedMonth;

  const TransactionWeeklyWidget({super.key, required this.selectedMonth});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final numberOfWeeks = 5;

    return Column(
      children: [
        CardOverviewWidget(
          title: "$selectedMonth - Weekly",
          description: "Transaction Weekly",
        ),
        ...List.generate(numberOfWeeks, (weekIndex) {
          final weekNumber = weekIndex + 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.025,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Week $weekNumber",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Rp. 1.000.000",
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(
                          width: screenWidth * 0.025,
                        ),
                        const Text(
                          "Rp. 1.000.000",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

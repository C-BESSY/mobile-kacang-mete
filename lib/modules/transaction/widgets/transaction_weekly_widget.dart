import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/weekly_income_expense_type.dart';

class TransactionWeeklyWidget extends StatefulWidget {
  final DateTime selectedDate;
  const TransactionWeeklyWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  State<TransactionWeeklyWidget> createState() =>
      _TransactionWeeklyWidgetState();
}

class _TransactionWeeklyWidgetState extends State<TransactionWeeklyWidget> {
  List<DateTime> _calculateWeekStartDates(DateTime currentDate) {
    List<DateTime> weekStartDates = [];
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);

    while (currentDate.month == firstDayOfMonth.month) {
      weekStartDates.add(firstDayOfMonth);
      firstDayOfMonth = firstDayOfMonth.add(const Duration(days: 7));
    }
    return weekStartDates;
  }
  final TransactionRepository transactionRepository = TransactionRepository();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final weekStartDates = _calculateWeekStartDates(widget.selectedDate);
    final numberOfWeeks = weekStartDates.length;
    
    return Column(
      children: [
        // CardOverviewWidget(
        //   description: "Weekly Transaction", 
        //   overviewData: OverviewData(
        //     pembelian: 0, 
        //     penjualan: 0, 
        //     balance: 0
        //   ),
        // ),
        ...List.generate(numberOfWeeks, (weekIndex) {
          final weekNumber = weekIndex + 1;
          final startDate = weekStartDates[weekIndex];
          final endDate = weekIndex < weekStartDates.length - 1
              ? weekStartDates[weekIndex + 1].subtract(const Duration(days: 1))
              : DateTime(startDate.year, startDate.month, startDate.day + 6);

          final dateRange =
              "${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)}";

          return FutureBuilder<WeeklyIncomeExpenseType>(
            future: transactionRepository.getWeeklyIncomeExpense(startDate, endDate), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final incomeExpense = snapshot.data;
              
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
                      Text(
                        "Week $weekNumber",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            intToIDR(incomeExpense!.sumIncome),
                            style: const TextStyle(color: Colors.green),
                          ),
                          SizedBox(
                            width: screenWidth * 0.025,
                          ),
                          Text(
                            intToIDR(incomeExpense.sumExpense),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.7),
                  child: Text(
                    dateRange,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
              );
              }
            }
          );
        }),
      ],
    );
  }

  String _getMonthName(int month) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }
}

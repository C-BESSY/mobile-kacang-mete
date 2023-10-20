import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/modules/home/repository/home_repository.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

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
  @override
  void initState() {
    super.initState();
  }

  Future<Widget> get cardOverview async {
    final OverviewData overviewData =
        await HomeRepository().getOverview(widget.selectedDate);
    return CardOverviewWidget(
      overviewData: overviewData,
      description: dateTimeToMonth(widget.selectedDate),
    );
  }

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
        ...List.generate(
          numberOfWeeks,
          (weekIndex) {
            final weekNumber = weekIndex + 1;
            final startDate = weekStartDates[weekIndex];
            final endDate = weekIndex < weekStartDates.length - 1
                ? weekStartDates[weekIndex + 1]
                    .subtract(const Duration(days: 1))
                : DateTime(startDate.year, startDate.month, startDate.day + 6);

            final dateRange =
                "${startDate.day} ${getMonthName(startDate.month)} - ${endDate.day} ${getMonthName(endDate.month)}";

            return FutureBuilder<IncomeExpenseType>(
              future: transactionRepository.getWeeklyIncomeExpense(
                  startDate, endDate),
              builder: (context, snapshot) {
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Week $weekNumber",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                                Text(
                                  dateRange,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                              ],
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
                    ],
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}

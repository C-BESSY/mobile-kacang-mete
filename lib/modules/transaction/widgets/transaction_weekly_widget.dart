import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/modules/home/repository/home_repository.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionWeeklyWidget extends StatefulWidget {
  final DateTime selectedDate;

  const TransactionWeeklyWidget({
    Key? key,
    required this.selectedDate,
  });

  @override
  State<TransactionWeeklyWidget> createState() =>
      _TransactionWeeklyWidgetState();
}

class Week {
  DateTime startOfWeek;
  DateTime endOfWeek;

  Week(this.startOfWeek, this.endOfWeek);
}

class _TransactionWeeklyWidgetState extends State<TransactionWeeklyWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<Widget> getCardOverview() async {
    final OverviewData overviewData =
        await HomeRepository().getOverview(widget.selectedDate);
    return CardOverviewWidget(
      overviewData: overviewData,
      description: dateTimeToMonth(widget.selectedDate),
    );
  }

  List<Week> _calculateWeeksInMonth(DateTime currentDate) {
    List<Week> weeks = [];
    int year = currentDate.year;
    int month = currentDate.month;
    int currentDay = 1;
    DateTime firstDayOfMonth = DateTime(year, month, currentDay);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    while (currentDay <= lastDayOfMonth.day) {
      DateTime startOfWeek = firstDayOfMonth;
      while (startOfWeek.weekday != DateTime.sunday) {
        startOfWeek = startOfWeek.subtract(const Duration(days: 1));
      }

      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      if (endOfWeek.isAfter(lastDayOfMonth)) {
        endOfWeek = lastDayOfMonth;
      }

      weeks.add(Week(startOfWeek, endOfWeek));
      currentDay = endOfWeek.day + 1;
      firstDayOfMonth = endOfWeek.add(const Duration(days: 1));
    }

    return weeks;
  }

  final TransactionRepository transactionRepository = TransactionRepository();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final weeksInMonth = _calculateWeeksInMonth(widget.selectedDate);

    return Column(
      children: [
        FutureBuilder<Widget>(
          future: getCardOverview(),
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
        for (int weekIndex = 0; weekIndex < weeksInMonth.length; weekIndex++)
          FutureBuilder<IncomeExpenseType>(
            future: transactionRepository.getWeeklyIncomeExpense(
              weeksInMonth[weekIndex].startOfWeek,
              weeksInMonth[weekIndex].endOfWeek,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final incomeExpense = snapshot.data;
                final week = weeksInMonth[weekIndex];
                final weekNumber = weekIndex + 1;
                final startDate = week.startOfWeek;
                final endDate = week.endOfWeek;
                final dateRange =
                    "${startDate.day} ${getMonthName(startDate.month)} - ${endDate.day} ${getMonthName(endDate.month)}";

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
          ),
      ],
    );
  }
}

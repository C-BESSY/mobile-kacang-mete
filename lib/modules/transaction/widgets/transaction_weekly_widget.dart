import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final weekStartDates = _calculateWeekStartDates(widget.selectedDate);
    final numberOfWeeks = weekStartDates.length;

    // final numberOfWeeks = 5;

    return Column(
      children: [
        // CardOverviewWidget(
        //   title: "$selectedMonth",
        //   description: "Weekly Transaction",
        // ),
        ...List.generate(numberOfWeeks, (weekIndex) {
          final weekNumber = weekIndex + 1;
          final startDate = weekStartDates[weekIndex];
          final endDate = weekIndex < weekStartDates.length - 1
              ? weekStartDates[weekIndex + 1].subtract(Duration(days: 1))
              : DateTime(startDate.year, startDate.month, startDate.day + 6);

          final dateRange =
              "${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)}";

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

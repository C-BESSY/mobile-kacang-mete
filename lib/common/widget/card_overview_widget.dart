import 'package:flutter/material.dart';

class CardOverviewWidget extends StatelessWidget {
  final String title;
  final String description;
  const CardOverviewWidget({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: screenHeight * 0.05,
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //NANTI BUAT INI BIAR UNTUK WEEKLY, DLL BISA LAIN LAIN NILAI INCOME & SPENDING NYA
          children: [
            _CardWidget(
              mainColor: Colors.green.shade500,
              title: 'Income',
              iconPath: 'assets/icons/icon-income.png',
              value: "Rp. 5.000.000",
            ),
            _CardWidget(
              mainColor: Colors.red.shade500,
              title: 'Expense',
              iconPath: 'assets/icons/icon-expenses.png',
              value: "Rp. 5.000.000",
            ),
          ],
        )
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  final Color mainColor;
  final String title;
  final String iconPath;
  final String value;

  const _CardWidget({
    required this.mainColor,
    required this.title,
    required this.iconPath,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.025),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: mainColor,
            width: 2.0,
          ),
          color: mainColor,
        ),
        child: Row(
          children: [
            Image.asset(iconPath),
            SizedBox(
              width: screenWidth * 0.025,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

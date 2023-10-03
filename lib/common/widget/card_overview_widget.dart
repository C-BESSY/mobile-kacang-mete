import 'package:flutter/material.dart';

class CardOverviewWidget extends StatelessWidget {
  final String title;
  const CardOverviewWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Text(
          "Tanggal",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black,
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
          children: [
            _CardWidget(
              mainColor: Colors.green.shade500,
              title: 'Income',
              icon: Icons.card_travel,
              value: "Rp. 5.000.000",
            ),
            _CardWidget(
              mainColor: Colors.red.shade500,
              title: 'Expense',
              icon: Icons.card_travel,
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
  final IconData icon;
  final String value;

  const _CardWidget({
    required this.mainColor,
    required this.title,
    required this.icon,
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
            const Icon(
              Icons.add_card,
              color: Colors.white,
            ),
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

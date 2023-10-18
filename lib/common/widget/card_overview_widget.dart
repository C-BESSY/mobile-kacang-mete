import 'package:flutter/material.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';

class CardOverviewWidget extends StatelessWidget {
  final OverviewData overviewData;
  final String description;
  const CardOverviewWidget({
    super.key,
    required this.overviewData,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          intToIDR(overviewData.balance),
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
              iconPath: 'assets/icons/icon-income.png',
              value: intToIDR(overviewData.penjualan),
            ),
            _CardWidget(
              mainColor: Colors.red.shade500,
              title: 'Expense',
              iconPath: 'assets/icons/icon-expenses.png',
              value: intToIDR(overviewData.pembelian),
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
        width: screenWidth * 0.4,
        padding: EdgeInsets.all(screenWidth * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: mainColor,
            width: 2.0,
          ),
          color: mainColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                    fontSize: screenHeight * 0.018,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.015,
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

class OverviewData {
  final int pembelian;
  final int penjualan;
  final int balance;
  OverviewData({
    required this.pembelian,
    required this.penjualan,
    required this.balance,
  });
}

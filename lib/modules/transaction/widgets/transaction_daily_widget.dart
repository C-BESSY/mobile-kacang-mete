import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';

class TransactionDailyWidget extends StatelessWidget {
  final String selectedMonth;

  const TransactionDailyWidget({super.key, required this.selectedMonth});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                "1 $selectedMonth",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.035,
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
        ListView.separated(
          shrinkWrap: true,
          itemCount: 2,
          separatorBuilder: (context, index) =>
              SizedBox(height: screenHeight * 0.02),
          itemBuilder: (context, index) {
            return TransactionItemWidget(
              type: index % 2 == 0
                  ? TransactionType.pengeluaran
                  : TransactionType.penjualan,
              item: "Kacang Mete",
              ammount: "Rp. 1.000.000",
              date: "1 Okt 2023",
            );
          },
        ),
      ],
    );
  }
}

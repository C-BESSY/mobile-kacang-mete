import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';

class TransactionItemWidget extends StatelessWidget {
  final IconData icon;
  final TransactionType type;
  final String item;
  final String ammount;
  final String date;

  const TransactionItemWidget({
    super.key,
    required this.icon,
    required this.type,
    required this.item,
    required this.ammount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: screenWidth * 0.15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type.value),
              Text(item),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ammount,
                style: TextStyle(
                  color: type == TransactionType.pengeluaran
                      ? Colors.red.shade500
                      : Colors.green.shade500,
                ),
              ),
              Text(date),
            ],
          )
        ],
      ),
    );
  }
}

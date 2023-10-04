import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionType type;
  final String item;
  final String ammount;
  final String date;

  const TransactionItemWidget({
    super.key,
    required this.type,
    required this.item,
    required this.ammount,
    required this.date,
  });

  bool get isPengeluaran => type == TransactionType.pengeluaran;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Icon(isPengeluaran ? Icons.abc : Icons.add_card,
                      size: screenWidth * 0.10)),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.value, style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),),
                  Text(item, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12, color: Colors.grey[600]),),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ammount,
                style: TextStyle(
                  color: isPengeluaran
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

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/features/pembelian/pages/pembelian_page.dart';
import 'package:kacang_mete/features/penjualan/pages/penjualan_page.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionType type;
  final String item;
  final int ammount;
  final String date;
  final int primaryKey;

  const TransactionItemWidget({
    super.key,
    required this.type,
    required this.item,
    required this.ammount,
    required this.date,
    required this.primaryKey,
  });

  bool get isPengeluaran => type == TransactionType.pembelian;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
      child: GestureDetector(
        onTap: () {
          if (type == TransactionType.pembelian) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PembelianPage()));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PenjualanPage(
                  primaryKey: primaryKey,
                ),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(isPengeluaran
                      ? 'assets/icons/pengeluaran.png'
                      : 'assets/icons/penjualan.png'),
                  SizedBox(width: screenWidth * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.value,
                        style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item,
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    intToIDR(ammount),
                    style: TextStyle(
                      color: isPengeluaran
                          ? Colors.red.shade500
                          : Colors.green.shade500,
                    ),
                  ),
                  Text(formatDate(date)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

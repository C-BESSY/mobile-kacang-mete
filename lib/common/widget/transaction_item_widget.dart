import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/features/pembelian/pages/pembelian_page.dart';
import 'package:kacang_mete/features/pembelian/repository/pembelian_repository.dart';
import 'package:kacang_mete/features/penjualan/pages/penjualan_page.dart';
import 'package:kacang_mete/features/penjualan/repository/penjualan_repository.dart';

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

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
      child: Dismissible(
        key: Key(primaryKey.toString()),
        onDismissed: (index) async {
          if (type == TransactionType.pembelian) {
            await PembelianRepository()
                .deletePembelian(context, id: primaryKey);
          } else {
            await PenjualanRepository()
                .deletePenjualan(context, id: primaryKey);
          }
        },
        confirmDismiss: (dismiss) async =>
            await showConfirmationDialog(context),
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            if (type == TransactionType.pembelian) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PembelianPage(
                    primaryKey: primaryKey,
                  ),
                ),
              );
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
      ),
    );
  }
}

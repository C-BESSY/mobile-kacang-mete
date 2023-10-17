import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';
import 'package:kacang_mete/features/pembelian/types/kategori_type.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';

class TransactionDailyWidget extends StatefulWidget {
  final String selectedMonth;

  const TransactionDailyWidget({super.key, required this.selectedMonth});

  @override
  State<TransactionDailyWidget> createState() => _TransactionDailyWidgetState();
}

class _TransactionDailyWidgetState extends State<TransactionDailyWidget> {
  late DateTime _selectedDate;

  final recentTransaction = [
    const PembelianType(
      id: 1,
      harga: 1000000,
      keterangan: "Beli Plastik",
      date: "2023-10-10",
      kategori: KategoriType(id: 1, name: "Plastik"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CardOverviewWidget(
            title: widget.selectedMonth, description: "Daily Transaction"),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03,
            horizontal: screenWidth * 0.025,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1 ${widget.selectedMonth}",
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
          padding: EdgeInsets.zero,
          itemCount: recentTransaction.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: screenHeight * 0.02),
          itemBuilder: (context, index) {
            final item = recentTransaction[index];
            if (item is PembelianType) {
              return TransactionItemWidget(
                type: TransactionType.pembelian,
                item: item.kategori.name,
                ammount: item.harga,
                date: item.date,
              );
            }
            return null;
          },
        ),
      ],
    );
  }
}

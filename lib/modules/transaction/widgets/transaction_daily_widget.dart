import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';

class TransactionDailyWidget extends StatefulWidget {
  final DateTime selectedDate;
  const TransactionDailyWidget({super.key, required this.selectedDate});

  @override
  State<TransactionDailyWidget> createState() => _TransactionDailyWidgetState();
}

class _TransactionDailyWidgetState extends State<TransactionDailyWidget> {
  int firstDate = 0;
  int lastDate = 0;
  int sumIncome = 0;
  int sumExpense = 0;
  @override
  void initState() {
    super.initState();
    TransactionRepository()
        .getTheEdgeOfDate(widget.selectedDate)
        .then((value) => setState(() {
              firstDate = value['firstDate']!;
              lastDate = value['lastDate']!;
            }));
  }

  Future<List<Widget>> get rows async {
    List<Widget> data = [];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime selectedDate = widget.selectedDate;
    int sumIncome = 0;
    int sumExpense = 0;

    for (int i = firstDate; (i != 0 && i <= lastDate); i++) {
      List<dynamic> dailyData = await TransactionRepository().getDataDaily(
          DateTime(widget.selectedDate.year, widget.selectedDate.month, i));
      int dailyIncome = await TransactionRepository().getDailySumIncome(DateTime(widget.selectedDate.year, widget.selectedDate.month, i));
      int dailyExpense = await TransactionRepository().getDailySumExpense(DateTime(widget.selectedDate.year, widget.selectedDate.month, i));
      data.add(Column(
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
                  "$i ${dateTimeToMonth(widget.selectedDate)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      intToIDR(dailyIncome),
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      width: screenWidth * 0.025,
                    ),
                    Text(
                      intToIDR(dailyExpense),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: dailyData.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenHeight * 0.02),
            itemBuilder: (context, index) {
              final item = dailyData[index];
              if (item is PembelianType) {
                dailyExpense += item.harga;
                return TransactionItemWidget(
                  type: TransactionType.pembelian,
                  item: item.kategori.name,
                  ammount: item.harga,
                  date: item.date,
                );
              } else if (item is PenjualanType) {
                dailyIncome += item.storedPrice;
                String itemName = "";
                return TransactionItemWidget(
                  type: TransactionType.penjualan,
                  item: "$itemName - ${item.varian.varian}",
                  ammount: item.storedPrice,
                  date: item.date,
                );
              }
              return null;
            },
          ),
        ],
      ));
      // setState(() {
      //   sumIncome += dailyIncome;
      //   sumExpense += dailyExpense;
      // });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CardOverviewWidget(
            overviewData: OverviewData(
              pembelian: sumExpense,
              penjualan: sumIncome,
              balance: sumIncome - sumExpense,
            ),
            description: dateTimeToMonth(widget.selectedDate)),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.15),
          child: FutureBuilder<List<Widget>>(
            future: rows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while waiting.
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show an error message if there's an error.
              } else {
                return Wrap(
                  children: snapshot.data ?? <Widget>[],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

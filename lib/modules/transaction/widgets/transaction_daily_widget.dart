import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';
import 'package:kacang_mete/modules/home/repository/home_repository.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/income_expense_type.dart';

class TransactionDailyWidget extends StatefulWidget {
  final DateTime selectedDate;
  const TransactionDailyWidget({super.key, required this.selectedDate});

  @override
  State<TransactionDailyWidget> createState() => _TransactionDailyWidgetState();
}

class _TransactionDailyWidgetState extends State<TransactionDailyWidget> {
  @override
  void initState() {
    super.initState();
  }

  IncomeExpenseType generateDailyData(List<dynamic> datas) {
    int sumIncome = 0;
    int sumExpense = 0;
    for (var data in datas) {
      if (data is PembelianType) {
        sumExpense += data.harga;
      } else if (data is PenjualanType) {
        sumIncome += data.storedPrice;
      }
    }
    return IncomeExpenseType(sumIncome: sumIncome, sumExpense: sumExpense);
  }

  Future<Widget> get cardOverview async {
    final OverviewData overviewData =
        await HomeRepository().getOverview(widget.selectedDate);
    return CardOverviewWidget(
      overviewData: overviewData,
      description: dateTimeToMonth(widget.selectedDate),
    );
  }

  Future<List<Widget>> get rows async {
    List<Widget> data = [];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dateEdge =
        await TransactionRepository().getTheEdgeOfDate(widget.selectedDate);
    for (int i = dateEdge.theStart; (i != 0 && i <= dateEdge.theEnd); i++) {
      print(i);
      List<dynamic> dailyData = await TransactionRepository().getDataDaily(
          DateTime(widget.selectedDate.year, widget.selectedDate.month, i));
      IncomeExpenseType overviewDaily = generateDailyData(dailyData);
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
                      intToIDR(overviewDaily.sumIncome),
                      style: const TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      width: screenWidth * 0.025,
                    ),
                    Text(
                      intToIDR(overviewDaily.sumExpense),
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
                return TransactionItemWidget(
                  type: TransactionType.pembelian,
                  item: item.kategori.name,
                  ammount: item.harga,
                  date: item.date,
                );
              } else if (item is PenjualanType) {
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
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        FutureBuilder<Widget>(
          future: cardOverview,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data ?? const SizedBox();
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.15),
          child: FutureBuilder<List<Widget>>(
            future: rows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
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

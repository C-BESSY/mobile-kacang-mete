import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_daily_widget.dart';

class TransactionPage extends StatefulWidget{
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final String _selectedMonth = "Oktober 2023";

  @override
  Widget build(BuildContext context) {
  
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => debugPrint('should open datepicker'),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      Text("Harian"),
                    ],
                  ),
                )
              ],
            ),
          ),
          CardOverviewWidget(title: _selectedMonth),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 10,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenHeight * 0.02),
            itemBuilder: (context, index) {
              return TransactionDailyWidget(
                selectedMonth: _selectedMonth,
              );
            },
          ),
        ],
      ),
    );
  }
  
}
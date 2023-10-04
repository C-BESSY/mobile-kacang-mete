import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.1,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the radius as needed
                    child: Image.asset('assets/images/logo.jpg'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.35),
                  child: TextButton(
                    onPressed: () => debugPrint('should open datepicker'),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back),
                        Text(_selectedMonth),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          CardOverviewWidget(title: _selectedMonth),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.03,
              horizontal: screenWidth * 0.025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                TextButton(
                  onPressed: () => debugPrint('should see all'),
                  child: Text("See All"),
                )
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 10,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenHeight * 0.02),
            itemBuilder: (context, index) {
              return TransactionItemWidget(
                type: index % 2 == 0
                    ? TransactionType.pengeluaran
                    : TransactionType.pemasukan,
                item: "Kacang Mete",
                ammount: "Rp. 1.000.000",
                date: "1 Okt 2023",
              );
            },
          ),
        ],
      ),
    );
  }
  
}

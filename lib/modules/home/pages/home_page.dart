import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/modules/transaction/pages/transaction_page.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedMonth = "October 2023";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the radius as needed
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.25),
                  child: TextButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            _selectedMonth =
                                DateFormat('MMMM yyyy').format(date);
                          });
                        }
                      });
                    },
                    style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.expand_more_rounded,
                          color: Color.fromARGB(255, 156, 7, 255),
                        ),
                        Text(_selectedMonth),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const CardOverviewWidget(
            title: 'Rp. 9.400.000',
            description: "Account Balance",
          ),
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
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BasePage(isTransaction: true),
                            ),
                          )
                        },
                    child: Text("See All"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade200)))
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 10,
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';
import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';
import 'package:kacang_mete/modules/home/repository/home_repository.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  OverviewData overviewData =
      OverviewData(pembelian: 0, penjualan: 0, balance: 0);
  List<dynamic> recentTransaction = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    HomeRepository()
        .getOverview(_selectedDate)
        .then((value) => overviewData = value);
    HomeRepository().getRecentTrasaction(_selectedDate).then((value) {
      setState(() => recentTransaction = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-screenWidth * 0.085, 0),
                    child: TextButton(
                      onPressed: () {
                        showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                        ).then((date) {
                          HomeRepository()
                              .getOverview(date ?? _selectedDate)
                              .then((value) =>
                                  setState(() => overviewData = value));
                          HomeRepository()
                              .getRecentTrasaction(date ?? _selectedDate)
                              .then((value) {
                            setState(() => recentTransaction = value);
                          });
                          setState(() {
                            _selectedDate = date ?? _selectedDate;
                          });
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
                          Text(dateTimeToMonth(_selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox()
                ],
              ),
            ),
          ),
          CardOverviewWidget(
            overviewData: overviewData,
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
                        builder: (context) => BasePage(
                          isTransaction: true,
                          selectedDate: _selectedDate,
                        ),
                      ),
                    )
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade200)),
                  child: const Text("See All"),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: screenHeight * 0.15),
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
                  primaryKey: item.id,
                );
              } else if (item is PenjualanType) {
                return FutureBuilder<ItemType>(
                  future: item.varian.getItem(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String itemName = snapshot.data!.name;
                      return TransactionItemWidget(
                        type: TransactionType.penjualan,
                        item: "$itemName - ${item.varian.varian}",
                        ammount: item.storedPrice,
                        date: item.date,
                        primaryKey: item.id,
                      );
                    }
                  },
                );
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

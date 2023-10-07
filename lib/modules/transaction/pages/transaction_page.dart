import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:kacang_mete/common/widget/transaction_item_widget.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_daily_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class TransactionPage extends StatefulWidget {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => debugPrint('should open datepicker'),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back),
                      Text("Harian"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.horizontal_rule_rounded,
                                color: Color.fromARGB(255, 136, 135, 135),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.025),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Filter Transaction',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          debugPrint('should reset'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.grey),
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Sort By',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          debugPrint('Highest');
                                        },
                                        child: Text('Highest')),
                                    ElevatedButton(
                                        onPressed: () {
                                          debugPrint('Lowest');
                                        },
                                        child: Text('Lowest')),
                                    ElevatedButton(
                                        onPressed: () {
                                          debugPrint('Newest');
                                        },
                                        child: Text('Newest')),
                                    ElevatedButton(
                                        onPressed: () {
                                          debugPrint('Oldest');
                                        },
                                        child: Text('Oldest')),
                                  ],
                                ),
                                // onTap: () {
                                //   Navigator.pop(context);
                                // },
                              ),
                              const ListTile(
                                title: (Text('Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blue[100]),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(color: Colors.black)),
                                  ),
                                  onPressed: () =>
                                      debugPrint('should select date'),
                                  child: const Text(
                                    'Select Date',
                                    style: TextStyle(color: Colors.black),
                                  )),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      const Color.fromARGB(255, 28, 147, 245)),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                                onPressed: () {
                                  debugPrint('Should apply filters then close');
                                  Navigator.pop(context);
                                },
                                child: Text('Apply'),
                              ),
                              // ListTile(
                              //   subtitle: Text('Pick Date',textAlign: TextAlign.justify),
                              //   onTap: () {Navigator.pop(context);},2
                              // ),
                              // Text('data'),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.filter_list),
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

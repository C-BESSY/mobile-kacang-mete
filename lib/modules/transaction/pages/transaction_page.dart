import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_type_enum.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
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
  List<String> list = <String>['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

  final String _selectedMonth = "Oktober 2023";
  late String dropdownValue = list[0];

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
                DropdownMenu<String>(
                  enableSearch: false,
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    setState(() {dropdownValue = value!;});
                    debugPrint(value);
                  },
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                    shape: MaterialStateProperty.all(null),
                  ),
                  dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }
                  )
                  .toList(),
                ),
                const Align(
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                        debugPrint('should reset'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                          MaterialStateProperty.all(
                                            const Color.fromARGB(244, 224, 217, 217)),
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Sort By',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Highest');
                                      },
                                      child: const Text('Highest',
                                        style: TextStyle(color: Colors.black)
                                      )
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Lowest');
                                      },
                                      child: const Text('Lowest',
                                        style: TextStyle(color: Colors.black)
                                      )
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Newest');
                                      },
                                      child: const Text('Newest',
                                        style: TextStyle(color: Colors.black)
                                      )
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Oldest');
                                      },
                                      child: const Text('Oldest',
                                        style: TextStyle(color: Colors.black)
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              const ListTile(
                                title: (Text('Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold)
                                  )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: const MaterialStatePropertyAll(
                                        Colors.white),
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(color: Colors.black)),
                                    ),
                                    onPressed: () =>
                                      debugPrint('should select date'),
                                    child: const Text(
                                      'Select Date',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Container(margin: const EdgeInsets.only(right: 8),child: Text(_selectedMonth))
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.025),
                                child: ButtonWidget(
                                  () {
                                    debugPrint('ini buat apply + close');
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
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

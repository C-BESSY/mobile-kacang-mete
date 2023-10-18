import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_filter_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TransactionFilter extends StatefulWidget {
  final TransactionFilterEnum filterMode;
  final DateTime selectedDate;
  final Function(DateTime) onFilterClicked;
  const TransactionFilter({
    super.key,
    required this.filterMode,
    required this.selectedDate,
    required this.onFilterClicked,
  });

  @override
  State<TransactionFilter> createState() => _TransactionFilterState();
}

class _TransactionFilterState extends State<TransactionFilter> {
  late DateTime tempDate;

  @override
  void initState() {
    super.initState();
    tempDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  const Icon(
                    Icons.horizontal_rule_rounded,
                    color: Color.fromARGB(255, 136, 135, 135),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Transaction',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () => debugPrint('should reset'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(244, 224, 217, 217)),
                          ),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ),
                  if (widget.filterMode == TransactionFilterEnum.harian)
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
                                  style: TextStyle(color: Colors.black))),
                          ElevatedButton(
                              onPressed: () {
                                debugPrint('Lowest');
                              },
                              child: const Text('Lowest',
                                  style: TextStyle(color: Colors.black))),
                          ElevatedButton(
                              onPressed: () {
                                debugPrint('Newest');
                              },
                              child: const Text('Newest',
                                  style: TextStyle(color: Colors.black))),
                          ElevatedButton(
                              onPressed: () {
                                debugPrint('Oldest');
                              },
                              child: const Text('Oldest',
                                  style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ),
                  const ListTile(
                    title: (Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.black)),
                        ),
                        onPressed: () {
                          if (widget.filterMode ==
                              TransactionFilterEnum.harian) {
                            showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                            ).then((date) {
                              setState(() => tempDate = date ?? tempDate);
                            });
                          } else {
                            debugPrint('yg lain');
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.expand_more_rounded,
                              color: Color.fromARGB(255, 156, 7, 255),
                            ),
                            Text(widget.filterMode ==
                                    TransactionFilterEnum.harian
                                ? 'Pilih Bulan'
                                : ''),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Text(dateTimeToMonth(tempDate)),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: ButtonWidget(
                      () {
                        widget.onFilterClicked(tempDate);
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
    );
  }
}

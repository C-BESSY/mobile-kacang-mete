import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_filter_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/modules/transaction/repository/transaction_repository.dart';
import 'package:kacang_mete/modules/transaction/types/date_edge.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TransactionFilter extends StatefulWidget {
  final TransactionFilterEnum filterMode;
  final DateTime selectedDate;
  final Function(DateTime) onFilterClicked;
  final Function(bool) onSortBySelected;
  final bool isNewest;
  const TransactionFilter({
    super.key,
    required this.filterMode,
    required this.selectedDate,
    required this.onFilterClicked,
    required this.onSortBySelected,
    required this.isNewest,
  });

  @override
  State<TransactionFilter> createState() => _TransactionFilterState();
}

class _TransactionFilterState extends State<TransactionFilter> {
  late DateTime tempDate;
  late bool tempIsNewest = widget.isNewest;
  DateEdge dateEdge = const DateEdge(theStart: 0, theEnd: 0);
  @override
  void initState() {
    super.initState();
    tempDate = widget.selectedDate;
    TransactionRepository()
        .getTheEdgeOfYear()
        .then((value) => setState(() => dateEdge = value));
  }

  void _showYearPicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: tempDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (context, child) {
        return Dialog(
          child: YearPicker(
            firstDate: DateTime(dateEdge.theStart),
            lastDate: DateTime(dateEdge.theEnd),
            selectedDate: tempDate,
            onChanged: (DateTime value) {
              setState(() => tempDate = value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _SortByBtn(
                            title: "Newest",
                            onPressed: () =>
                                setState(() => tempIsNewest = true),
                            color: tempIsNewest
                                ? Colors.purple.shade500
                                : Colors.grey.shade300,
                            textColor:
                                tempIsNewest ? Colors.white : Colors.black,
                          ),
                          const SizedBox(height: 4),
                          _SortByBtn(
                            title: "Oldest",
                            onPressed: () =>
                                setState(() => tempIsNewest = false),
                            color: !tempIsNewest
                                ? Colors.purple.shade500
                                : Colors.grey.shade300,
                            textColor:
                                !tempIsNewest ? Colors.white : Colors.black,
                          ),
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
                                  TransactionFilterEnum.harian ||
                              widget.filterMode ==
                                  TransactionFilterEnum.mingguan) {
                            showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                            ).then((date) {
                              setState(() => tempDate = date ?? tempDate);
                            });
                          } else {
                            _showYearPicker(context);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.expand_more_rounded,
                              color: Color.fromARGB(255, 156, 7, 255),
                            ),
                            Text(widget.filterMode ==
                                        TransactionFilterEnum.harian ||
                                    widget.filterMode ==
                                        TransactionFilterEnum.mingguan
                                ? 'Pilih Bulan'
                                : 'Pilih Tahun'),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Text(
                            widget.filterMode == TransactionFilterEnum.bulanan
                                ? "Tahun ${tempDate.year}"
                                : dateTimeToMonth(tempDate)),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    child: ButtonWidget(
                      () {
                        widget.onFilterClicked(tempDate);
                        widget.onSortBySelected(tempIsNewest);
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

class _SortByBtn extends ElevatedButton {
  _SortByBtn({
    required String title,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) : super(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
          ),
          child: Container(
            child: Text(
              title,
              style: TextStyle(color: textColor),
            ),
          ),
        );
}

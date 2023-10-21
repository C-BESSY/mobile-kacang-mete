import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kacang_mete/common/enums/transaction_filter_enum.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_daily_widget.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_filter.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_monthly_widget.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_weekly_widget.dart';
import 'package:kacang_mete/modules/transaction/widgets/transaction_yearly_widget.dart';

class TransactionPage extends StatefulWidget {
  final DateTime? paramDate;
  const TransactionPage({super.key, this.paramDate});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late DateTime _selectedDate = widget.paramDate ?? DateTime.now();
  late TransactionFilterEnum dropdownValue = TransactionFilterEnum.harian;
  bool isNewest = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            bottom:false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.025),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<TransactionFilterEnum>(
                        isExpanded: true,
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: TransactionFilterEnum.values
                            .map((TransactionFilterEnum item) =>
                                DropdownMenuItem<TransactionFilterEnum>(
                                  value: item,
                                  child: Text(
                                    capitalizeWord(item.name),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: dropdownValue,
                        onChanged: (TransactionFilterEnum? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  const Align(),
                  Visibility(
                    visible: dropdownValue != TransactionFilterEnum.tahunan,
                    child: TransactionFilter(
                      filterMode: dropdownValue,
                      selectedDate: _selectedDate,
                      onFilterClicked: (date) {
                        setState(() => _selectedDate = date);
                      },
                      onSortBySelected: (val) {
                        setState(() => isNewest = val);
                      },
                      isNewest: isNewest,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (dropdownValue == TransactionFilterEnum.harian)
            TransactionDailyWidget(
              isNewest: isNewest,
              selectedDate: _selectedDate,
            ),
          if (dropdownValue == TransactionFilterEnum.mingguan)
            TransactionWeeklyWidget(
              selectedDate: _selectedDate,
            ),
          if (dropdownValue == TransactionFilterEnum.bulanan)
            TransactionMonthlyWidget(
              selectedYear: _selectedDate.year,
            ),
          if (dropdownValue == TransactionFilterEnum.tahunan)
            const TransactionYearlyWidget(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/common/widget/centered_appbar.widget.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/widgets/date_picker_widget.dart';
import 'package:kacang_mete/features/item/widgets/item_jenis_picker_widget.dart';
import 'package:kacang_mete/features/item/widgets/item_picker_widget.dart';
import 'package:kacang_mete/features/penjualan/repository/penjualan_repository.dart';
import 'dart:core';

import 'package:kacang_mete/features/penjualan/types/penjualan_type.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  ItemType? _selectedItem;
  ItemVarianType? _selectedJenis;
  List<ItemVarianType> _availableItemJenis = [];
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final TextEditingController _quantity = TextEditingController(text: "");
  late final List<InputType> inputList = [
    InputType("item", TextInputType.text, _quantity),
    InputType("jenis", TextInputType.text, _quantity),
    InputType("waktu", TextInputType.text, _quantity),
    InputType("Jumlah", TextInputType.number, _quantity),
  ];

  String get theTotal => _selectedJenis == null
      ? intToIDR(0)
      : intToIDR(int.parse(_quantity.text == "" ? "0" : _quantity.text) *
          _selectedJenis!.harga);

  void save() async {
    if (_formKey.currentState!.validate()) {
      final PenjualanType theData = PenjualanType(
        id: 0,
        quantity: int.parse(_quantity.text),
        storedPrice: int.parse(_quantity.text == "" ? "0" : _quantity.text) *
            _selectedJenis!.harga,
        varian: _selectedJenis!,
        date: selectedDate,
      );
      await PenjualanRepository().insertPenjualan(context, penjualan: theData);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BasePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CenteredAppBarWidget(
        title: "Penjualan",
        color: Colors.green.shade300,
        screenWidth: screenWidth,
      ),
      backgroundColor: Colors.green.shade300,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.025,
                  right: screenWidth * 0.025,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      theTotal,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.025,
                  horizontal: screenWidth * 0.025,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: inputList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: screenHeight * 0.02),
                        itemBuilder: (context, index) {
                          final inputData = inputList[index];
                          switch (inputData.label) {
                            case "item":
                              return ItemPickerWidget(
                                onSelected: (item, jenis) => setState(() {
                                  _selectedItem = item;
                                  _availableItemJenis = jenis!;
                                }),
                              );
                            case "jenis":
                              return ItemJenisPickerWidget(
                                onSelected: (item) =>
                                    setState(() => _selectedJenis = item),
                                items: _availableItemJenis,
                              );
                            case "waktu":
                              return DatePickerWidget(
                                onSelected: (DateTime date) => setState(() =>
                                    selectedDate =
                                        DateFormat('yyyy-MM-dd').format(date)),
                              );
                            default:
                              if (_selectedJenis != null) {
                                return TextFormField(
                                  controller: inputData.textController,
                                  keyboardType: inputData.inputType,
                                  decoration: InputDecoration(
                                    labelText: inputData.label,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    if (!RegExp(r'[a-zA-Z\W]')
                                        .hasMatch(value)) {
                                      setState(() => _quantity.text = value);
                                    }
                                  },
                                  validator: (value) => inputData.validator(
                                      inputData.label, value),
                                );
                              }
                          }
                          return null;
                        },
                      ),
                    ),
                    ButtonWidget(
                      save,
                      title: "Simpan",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

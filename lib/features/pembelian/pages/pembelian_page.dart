import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/common/widget/centered_appbar.widget.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';
import 'package:kacang_mete/features/pembelian/repository/pembelian_repository.dart';
import 'package:kacang_mete/features/pembelian/types/kategori_type.dart';
import 'package:kacang_mete/features/item/widgets/date_picker_widget.dart';
import 'package:kacang_mete/features/item/widgets/kategory_picker_widget.dart';
import 'package:kacang_mete/features/pembelian/types/pembelian_type.dart';

class PembelianPage extends StatefulWidget {
  const PembelianPage({super.key});

  @override
  State<PembelianPage> createState() => _PembelianPageState();
}

class _PembelianPageState extends State<PembelianPage> {
  final TextEditingController _keterangan = TextEditingController();
  final TextEditingController _harga = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  KategoriType? _selectedKategori;
  String? newKategori;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<ItemVarianType> _availableItemJenis = [];
  late final List<InputType> inputList = [
    InputType("Kategori", TextInputType.text, _keterangan),
    InputType("Keterangan", TextInputType.text, _keterangan),
    InputType("waktu", TextInputType.text, _keterangan),
    InputType("Harga", TextInputType.number, _harga),
  ];

  void save() async {
    if (_formKey.currentState!.validate()) {
      final PembelianType theData = PembelianType(
        id: 0,
        harga: int.parse(_harga.text),
        keterangan: _keterangan.text,
        date: selectedDate!,
        kategori: newKategori != null
            ? KategoriType(id: 0, name: newKategori!)
            : _selectedKategori!,
      );
      await PembelianRepository().insertPembelian(context, pembelian: theData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CenteredAppBarWidget(
        title: "Pembelian",
        color: Colors.red.shade400,
        screenWidth: screenWidth,
      ),
      backgroundColor: Colors.red.shade400,
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
                      intToIDR(
                          int.parse(_harga.text == "" ? "0" : _harga.text)),
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
                height: screenHeight * 0.82,
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: inputList.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        itemBuilder: (context, int index) {
                          final inputData = inputList[index];
                          switch (inputData.label) {
                            case "Kategori":
                              return Column(children: [
                                KategoryPickerWidget(
                                  onSelected: (kategori) => setState(() {
                                    _selectedKategori = kategori;
                                  }),
                                ),
                                if (_selectedKategori?.name == "Lainnya")
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.025),
                                    child: TextFormField(
                                      keyboardType: inputData.inputType,
                                      decoration: InputDecoration(
                                        labelText: inputData.label,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (value) =>
                                          setState(() => newKategori = value),
                                      validator: (value) => inputData.validator(
                                          inputData.label, value),
                                    ),
                                  ),
                              ]);
                            case "waktu":
                              return DatePickerWidget(
                                onSelected: (DateTime date) => setState(() =>
                                    selectedDate =
                                        DateFormat('yyyy-MM-dd').format(date)),
                              );
                            default:
                              return TextFormField(
                                controller: inputData.textController,
                                keyboardType: inputData.inputType,
                                decoration: InputDecoration(
                                  labelText: inputData.label,
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) => setState(() =>
                                    inputData.textController.text = value),
                                validator: (value) =>
                                    inputData.validator(inputData.label, value),
                              );
                          }
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

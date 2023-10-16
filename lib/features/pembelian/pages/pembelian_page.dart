import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/common/utils/helper_util.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/features/item/types/item_jenis_type.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';
import 'package:kacang_mete/features/item/widgets/item_jenis_picker_widget.dart';
import 'package:kacang_mete/features/item/widgets/item_picker_widget.dart';

class PembelianPage extends StatefulWidget {
  const PembelianPage({super.key});

  @override
  State<PembelianPage> createState() => _PembelianPageState();
}

class _PembelianPageState extends State<PembelianPage> {
  final _formKey = GlobalKey<FormState>();
  ItemType? _selectedItem;
  ItemJenisType? _selectedJenis;
  List<ItemJenisType> _availableItemJenis = [];
  final TextEditingController _quantity = TextEditingController(text: "0");
  late final List<InputType> inputList = [
    InputType("item", TextInputType.text, _quantity),
    InputType("keterangan", TextInputType.text, _quantity),
    InputType("Jumlah", TextInputType.number, _quantity),
  ];
  
  String get theTotal => _selectedJenis == null && _quantity.text == "0"
      ? intToIDR(0)
      : intToIDR(int.parse(_quantity.text) * _selectedJenis!.harga);

  void save() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BasePage()));
    }
}
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(
          child: Transform.translate(
            offset: Offset(-screenWidth * 0.04, 0),
            child: Text(
              "Pengeluaran",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.red.shade400,
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: inputList.length,
                        separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.02,),
                        itemBuilder: ( context, int index){
                          final inputData = inputList[index];
                          switch (inputData.label) {
                            case "item":
                              return ItemPickerWidget(
                                onSelected: (item, jenis) => setState(() {
                                  _selectedItem = item;
                                  _availableItemJenis = jenis;
                                }),
                              );
                            case "keterangan":
                              return ItemJenisPickerWidget(
                                onSelected: (item) =>
                                    setState(() => _selectedJenis = item),
                                items: _availableItemJenis,
                              );
                            default:
                              return TextFormField(
                                controller: inputData.textController,
                                keyboardType: inputData.inputType,
                                decoration: InputDecoration(
                                  labelText: inputData.label,
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) =>
                                    setState(() => _quantity.text = value),
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
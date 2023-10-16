import 'package:flutter/material.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/features/item/types/item_jenis_type.dart';

class ItemCardWidget extends StatefulWidget {
  final ItemVarianType varian;
  final VoidCallback onPressed;
  final void Function(ItemVarianType) onChanged;
  const ItemCardWidget({
    super.key,
    required this.varian,
    required this.onPressed,
    required this.onChanged,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _varian =
      TextEditingController(text: widget.varian.varian);
  late final TextEditingController _harga =
      TextEditingController(text: widget.varian.harga.toString());
  late final List<InputType> inputList = [
    InputType("Varian", TextInputType.text, _varian),
    InputType("Harga per-varian", TextInputType.number, _harga),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            onChanged: () => {
              widget.onChanged(ItemVarianType(
                id: widget.varian.id,
                varian: widget.varian.varian,
                harga: widget.varian.harga,
              ))
            },
            key: _formKey,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: inputList.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: screenHeight * 0.02),
              itemBuilder: (context, index) {
                final inputData = inputList[index];
                return TextFormField(
                  controller: inputData.textController,
                  keyboardType: inputData.inputType,
                  decoration: InputDecoration(
                    labelText: inputData.label,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      inputData.validator(inputData.label, value),
                );
              },
            ),
          ),
          ButtonWidget(
            widget.onPressed,
            title: "Hapus",
            color: Colors.brown.shade900,
          )
        ],
      ),
    );
  }
}

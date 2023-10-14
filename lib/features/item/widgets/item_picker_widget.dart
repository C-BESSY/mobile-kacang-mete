import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/features/item/types/item_jenis_type.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';

class ItemPickerWidget extends StatefulWidget {
  final Function(ItemType, List<ItemJenisType>) onSelected;
  const ItemPickerWidget({super.key, required this.onSelected});

  @override
  State<ItemPickerWidget> createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<ItemPickerWidget> {
  final TextEditingController _selectedItem = TextEditingController();
  final List<ItemType> items = [
    const ItemType(id: 1, name: "Kacang Mete", jenis: [
      ItemJenisType(id: 1, kategori: "1kg", harga: 100000),
      ItemJenisType(id: 2, kategori: "2kg", harga: 200000),
    ]),
    const ItemType(id: 1, name: "Kucing", jenis: [
      ItemJenisType(id: 1, kategori: "hitam", harga: 100000),
      ItemJenisType(id: 2, kategori: "kuning", harga: 200000),
    ]),
  ];

  List<ItemType> searchItem(String pattern) {
    return items
        .where(
            (item) => item.name.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _selectedItem,
        decoration: const InputDecoration(
          labelText: "Pilih Item",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return searchItem(pattern);
      },
      itemBuilder: (context, ItemType suggestion) {
        return Listener(
          child: ListTile(
            dense: true,
            title: Text(suggestion.name),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (ItemType suggestion) {
        widget.onSelected(suggestion, suggestion.jenis);
        _selectedItem.text = suggestion.name;
      },
      validator: (value) => InputType.validatedInput("Item", value),
    );
  }
}

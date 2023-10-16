import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';
import 'package:kacang_mete/features/item/types/item_type.dart';

class ItemPickerWidget extends StatefulWidget {
  final Function(ItemType, List<ItemVarianType>?) onSelected;
  final Function(String)? onChanged;
  const ItemPickerWidget({
    super.key,
    required this.onSelected,
    this.onChanged,
  });

  @override
  State<ItemPickerWidget> createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<ItemPickerWidget> {
  final TextEditingController _selectedItem = TextEditingController();
  final List<ItemType> items = [
    const ItemType(id: 1, name: "Kacang Mete", varian: [
      ItemVarianType(id: 1, varian: "1kg", harga: 100000),
      ItemVarianType(id: 2, varian: "2kg", harga: 200000),
    ]),
    const ItemType(id: 1, name: "Kucing", varian: [
      ItemVarianType(id: 1, varian: "Hitam", harga: 100000),
      ItemVarianType(id: 2, varian: "Kuning", harga: 200000),
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
        onChanged: (value) =>
            {if (widget.onChanged != null) widget.onChanged!(value)},
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
        widget.onSelected(suggestion, suggestion.varian);
        _selectedItem.text = suggestion.name;
      },
      validator: (value) => InputType.validatedInput("Item", value),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/features/item/types/item_jenis_type.dart';

class ItemJenisPickerWidget extends StatefulWidget {
  final Function(ItemJenisType) onSelected;
  final List<ItemJenisType> items;
  const ItemJenisPickerWidget({
    super.key,
    required this.onSelected,
    required this.items,
  });

  @override
  State<ItemJenisPickerWidget> createState() => _ItemJenisPickerWidgetState();
}

class _ItemJenisPickerWidgetState extends State<ItemJenisPickerWidget> {
  final TextEditingController _selectedItem = TextEditingController();
  List<ItemJenisType> searchItem(String pattern) {
    return widget.items
        .where((item) =>
            item.kategori.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _selectedItem,
        decoration: const InputDecoration(
          labelText: "Pilih Jenis",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return searchItem(pattern);
      },
      itemBuilder: (context, ItemJenisType suggestion) {
        return Listener(
          child: ListTile(
            dense: true,
            title: Text(suggestion.kategori),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (ItemJenisType suggestion) {
        widget.onSelected(suggestion);
        _selectedItem.text = suggestion.kategori;
      },
      validator: (value) => InputType.validatedInput("Jenis", value),
    );
  }
}

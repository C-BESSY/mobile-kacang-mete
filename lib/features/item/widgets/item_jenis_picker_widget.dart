import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/features/item/types/item_varian_type.dart';

class ItemJenisPickerWidget extends StatefulWidget {
  final Function(ItemVarianType) onSelected;
  final List<ItemVarianType> items;
  final ItemVarianType? initalVarian;
  const ItemJenisPickerWidget({
    super.key,
    required this.onSelected,
    required this.items,
    this.initalVarian,
  });

  @override
  State<ItemJenisPickerWidget> createState() => _ItemJenisPickerWidgetState();
}

class _ItemJenisPickerWidgetState extends State<ItemJenisPickerWidget> {
  late final TextEditingController _selectedItem =
      TextEditingController(text: widget.initalVarian?.varian ?? "");
  List<ItemVarianType> searchItem(String pattern) {
    return widget.items
        .where(
            (item) => item.varian.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      direction: AxisDirection.up,
      hideKeyboard: false,
      hideSuggestionsOnKeyboardHide: false,
      textFieldConfiguration: TextFieldConfiguration(
        controller: _selectedItem,
        decoration: const InputDecoration(
          labelText: "Pilih Varian",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return searchItem(pattern);
      },
      itemBuilder: (context, ItemVarianType suggestion) {
        return Listener(
          child: ListTile(
            dense: true,
            title: Text(suggestion.varian),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (ItemVarianType suggestion) {
        widget.onSelected(suggestion);
        _selectedItem.text = suggestion.varian;
      },
      validator: (value) => InputType.validatedInput("Varian", value),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/types/input_type.dart';
import 'package:kacang_mete/features/pembelian/repository/kategori_repository.dart';
import 'package:kacang_mete/features/pembelian/types/kategori_type.dart';

class KategoryPickerWidget extends StatefulWidget {
  final Function(KategoriType) onSelected;
  const KategoryPickerWidget({super.key, required this.onSelected});

  @override
  State<KategoryPickerWidget> createState() => _KategoryPickerWidgetState();
}

class _KategoryPickerWidgetState extends State<KategoryPickerWidget> {
  final TextEditingController _selectedItem = TextEditingController();

  Future<List<KategoriType>> searchItem(String pattern) async {
    final items = await KategoriRepository().getKategoris()
      ..add(
        const KategoriType(id: 0, name: "Lainnya"),
      );
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
          labelText: "Pilih Kategori",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return searchItem(pattern);
      },
      itemBuilder: (context, KategoriType suggestion) {
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
      onSuggestionSelected: (KategoriType suggestion) {
        widget.onSelected(suggestion);
        _selectedItem.text = suggestion.name;
      },
      validator: (value) => InputType.validatedInput("Item", value),
    );
  }
}

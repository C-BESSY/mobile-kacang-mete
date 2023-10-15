import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TypeAheadField(
            textFieldConfiguration: const TextFieldConfiguration(
              decoration: InputDecoration(
                labelText: "Jenis",
                border: OutlineInputBorder(),
              ),
            ),
            suggestionsCallback: (pattern) => ['Kacang Mete', 'Kacang']
                .where((x) => x.toLowerCase().contains(pattern.toLowerCase())),
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) => debugPrint(suggestion),
          ),
          SizedBox(
            height: screenHeight * 0.025,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Jumlah",
              border: OutlineInputBorder(),
            ),
          ),
          ButtonWidget(() {
            debugPrint('Ini item Apply');
          }, color: Colors.brown.shade900)
        ],
      ),
    );
  }
}

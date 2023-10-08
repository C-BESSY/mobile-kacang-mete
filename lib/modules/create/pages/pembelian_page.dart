import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';

class PembelianPage extends StatelessWidget {
  const PembelianPage({super.key});

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
                      'Rp. 100.000',
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
                      child: Column(
                        children: [
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Item",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            suggestionsCallback: (pattern) => [
                              'Kacang Mete',
                              'Kacang'
                            ].where((x) => x
                                .toLowerCase()
                                .contains(pattern.toLowerCase())),
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (String suggestion) =>
                                debugPrint(suggestion),
                          ),
                          SizedBox(
                            height: screenHeight * 0.025,
                          ),
                          TypeAheadField(
                            textFieldConfiguration: const TextFieldConfiguration(
                              decoration: InputDecoration(
                                labelText: "Jumlah",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            suggestionsCallback: (pattern) => [
                              'Kacang Mete',
                              'Kacang'
                            ].where((x) => x
                                .toLowerCase()
                                .contains(pattern.toLowerCase())),
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (String suggestion) =>
                                debugPrint(suggestion),
                          ),
                          SizedBox(
                            height: screenHeight * 0.025,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Keterangan",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonWidget(
                      () => debugPrint('ini simpan'),
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

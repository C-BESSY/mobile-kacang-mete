import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/modules/create/widget/item_card_widget.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final List<ItemCardWidget> arrOfItemCard = [
    ItemCardWidget(),
  ];
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
              "Item",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.brown.shade800,
      ),
      backgroundColor: Colors.brown.shade800,
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
                      'Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      'Kacang Mete',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          TypeAheadField(
                            textFieldConfiguration:
                                const TextFieldConfiguration(
                              decoration: InputDecoration(
                                labelText: "Nama Item",
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Jenis',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                TextButton(
                                  onPressed: () => setState(() {
                                    arrOfItemCard.add(const ItemCardWidget());
                                  }),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(244, 224, 217, 217)),
                                  ),
                                  child: const Text('Tambah'),
                                ),
                              ],
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: arrOfItemCard.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: screenHeight * 0.02),
                            itemBuilder: (context, index) {
                              final item = arrOfItemCard[index];
                              return item;
                            },
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

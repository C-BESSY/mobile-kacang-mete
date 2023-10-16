import 'package:flutter/material.dart';
import 'package:kacang_mete/common/widget/button_widget.dart';
import 'package:kacang_mete/common/widget/centered_appbar.widget.dart';
import 'package:kacang_mete/features/item/types/item_jenis_type.dart';
import 'package:kacang_mete/features/item/widgets/item_card_widget.dart';
import 'package:kacang_mete/features/item/widgets/item_picker_widget.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String? _selectedItem;
  String get visibleSelectedItem => _selectedItem == null
      ? "-"
      : (_selectedItem! == "" ? "-" : _selectedItem!);
  bool isCreateNew = true;
  List<ItemVarianType> variants = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !isCreateNew,
        child: FloatingActionButton(
          onPressed: () => debugPrint('should Delete'),
          child: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
      appBar: CenteredAppBarWidget(
        title: "Item",
        color: Colors.brown.shade800,
        screenWidth: screenWidth,
      ),
      backgroundColor: Colors.brown.shade800,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
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
                      visibleSelectedItem,
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
                constraints: BoxConstraints(
                    minHeight: screenHeight * 0.72, minWidth: double.infinity),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          ItemPickerWidget(
                            onSelected: (item, jenis) => setState(() {
                              _selectedItem = item.name;
                              variants = [...jenis!];
                              isCreateNew = false;
                            }),
                            onChanged: (value) => setState(() {
                              _selectedItem = value;
                              variants = [];
                              isCreateNew = true;
                            }),
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
                                  'Varian',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                TextButton(
                                  onPressed: () => setState(() {
                                    variants.add(const ItemVarianType(
                                        id: 0, varian: "", harga: 0));
                                  }),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(244, 224, 217, 217),
                                    ),
                                  ),
                                  child: const Text('Tambah'),
                                ),
                              ],
                            ),
                          ),
                          if (variants.isNotEmpty)
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: variants.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: screenHeight * 0.02),
                              itemBuilder: (context, index) {
                                final item = variants[index];
                                return ItemCardWidget(
                                  varian: item,
                                  onPressed: () => setState(() {
                                    variants.removeAt(index);
                                  }),
                                  onChanged: (varian) =>
                                      setState(() => variants[index] = varian),
                                );
                              },
                            )
                          else
                            const Text('Tidak Ada Varian')
                        ],
                      ),
                    ),
                    ButtonWidget(
                      () => debugPrint(_selectedItem),
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

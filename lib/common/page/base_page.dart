import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kacang_mete/modules/create/pages/item_page.dart';
import 'package:kacang_mete/modules/create/pages/pembelian_page.dart';
import 'package:kacang_mete/modules/home/pages/home_page.dart';
import 'package:kacang_mete/modules/create/pages/penjualan_page.dart';
import 'package:kacang_mete/modules/transaction/pages/transaction_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class BasePage extends StatefulWidget {
  final bool isTransaction;
  const BasePage({super.key, isTransaction})
      : isTransaction = isTransaction ?? false;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late final _pageController;
  late final _controller;
  bool isCreateOpen = false;

  int get maxCount => item.length;

  final item = [
    const HomePage(),
    const HomePage(),
    const TransactionPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.isTransaction ? 2 : 0);
    _controller = NotchBottomBarController(index: widget.isTransaction ? 2 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(item.length, (index) => item[index]),
          ),
          Positioned.fill(
            child: Visibility(
              visible: isCreateOpen,
              child: GestureDetector(
                onTap: () => setState(() => isCreateOpen = false),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Visibility(
              visible: isCreateOpen,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ItemPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: const Icon(Symbols.category, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PenjualanPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.blue,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: const Icon(Symbols.attach_money,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PembelianPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.red,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child:
                            const Icon(Symbols.send_money, color: Colors.white),
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: (item.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 500,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.star,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Create',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.currency_exchange,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.currency_exchange,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Transaction',
                ),
              ],
              onTap: (index) {
                setState(() => isCreateOpen = index == 1);
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}

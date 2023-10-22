// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kacang_mete/features/item/pages/item_page.dart';
import 'package:kacang_mete/features/pembelian/pages/pembelian_page.dart';
import 'package:kacang_mete/features/penjualan/pages/penjualan_page.dart';
import 'package:kacang_mete/modules/home/pages/home_page.dart';
import 'package:kacang_mete/modules/transaction/pages/transaction_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class BasePage extends StatefulWidget {
  final bool isTransaction;
  final DateTime? selectedDate;
  const BasePage({super.key, isTransaction, this.selectedDate})
      : isTransaction = isTransaction ?? false;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late final PageController _pageController;
  late final NotchBottomBarController _controller;
  bool isCreateOpen = false;
  int get maxCount => item.length;
  bool isHome = true;
  late final item = [
    const HomePage(),
    const HomePage(),
    TransactionPage(
      paramDate: widget.selectedDate,
    ),
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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
                onTap: () {
                  _controller.jumpTo(isHome ? 0 : 2);
                  setState(() => isCreateOpen = false);
                },
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
                  const _CreateBtnIcon(
                    target: ItemPage(),
                    bgColor: Colors.green,
                    icon: Symbols.category,
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const _CreateBtnIcon(
                      target: PenjualanPage(),
                      bgColor: Colors.blue,
                      icon: Symbols.attach_money,
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    const _CreateBtnIcon(
                      target: PembelianPage(),
                      bgColor: Colors.red,
                      icon: Symbols.send_money,
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
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              bottomBarItems: [
                _BottomBarBtn(icon: Icons.home_filled, label: 'Home'),
                _BottomBarBtn(icon: Icons.create, label: 'Create'),
                _BottomBarBtn(
                  icon: Icons.currency_exchange,
                  label: 'Transaction',
                ),
              ],
              onTap: (index) {
                setState(() => isCreateOpen = index == 1);
                if (index != 1) {
                  setState(() => isHome = index == 0);
                  _pageController.jumpToPage(index);
                }
              },
            )
          : null,
    );
  }
}

class _BottomBarBtn extends BottomBarItem {
  final IconData icon;
  final String label;
  _BottomBarBtn({required this.icon, required this.label})
      : super(
          inActiveItem: Icon(
            icon,
            color: Colors.blueGrey,
          ),
          activeItem: Icon(
            icon,
            color: Colors.blueAccent,
          ),
          itemLabel: label,
        );
}

class _CreateBtnIcon extends StatelessWidget {
  final StatefulWidget target;
  final MaterialColor bgColor;
  final IconData icon;
  const _CreateBtnIcon({
    required this.target,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => target));
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: bgColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

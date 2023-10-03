import 'package:flutter/material.dart';
import 'package:kacang_mete/common/widget/card_overview_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _selectedMonth = "Oktober 2023";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.025,
              horizontal: screenWidth * 0.025,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('images/logo.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.35),
                  child: TextButton(
                    onPressed: () => debugPrint('should open datepicker'),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back),
                        Text(_selectedMonth),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(children: [CardOverviewWidget(title: _selectedMonth)]),
        )
      ],
    );
  }
}

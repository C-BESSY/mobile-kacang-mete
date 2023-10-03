import 'package:flutter/material.dart';

class CardOverviewWidget extends StatelessWidget {
  final String title;
  const CardOverviewWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          "Tanggal",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: screenHeight * 0.025,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: screenHeight * 0.05,
            color: Colors.black,
          ),
        ),
        Container(
          color: Colors.green.shade500,
          child: Row(
            children: [
              Icon(Icons.add_card),
              Column(
                children: [Text('Income'), Text('Rp. 5.000.000')],
              )
            ],
          ),
        ),
      ],
    );
  }
}

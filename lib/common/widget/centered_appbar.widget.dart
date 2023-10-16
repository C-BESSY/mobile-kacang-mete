import 'package:flutter/material.dart';

class CenteredAppBarWidget extends AppBar {
  CenteredAppBarWidget({
    super.key,
    required String title,
    required Color color,
    required double screenWidth,
  }) : super(
          foregroundColor: Colors.white,
          title: Center(
            child: Transform.translate(
              offset: Offset(-screenWidth * 0.04, 0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ),
          backgroundColor: color,
        );
}

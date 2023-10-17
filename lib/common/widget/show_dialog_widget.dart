import 'package:flutter/material.dart';
import 'package:kacang_mete/common/page/base_page.dart';

enum DialogState { success, warning, info, error }

class ShowDialogWidget extends StatelessWidget {
  final String message;
  final DialogState state;
  final VoidCallback onPressed;

  const ShowDialogWidget({
    super.key,
    required this.message,
    this.state = DialogState.success,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (state) {
      case DialogState.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case DialogState.warning:
        iconData = Icons.warning;
        iconColor = Colors.yellow;
        break;
      case DialogState.info:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
      case DialogState.error:
      default:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
    }

    return AlertDialog(
      title: Icon(iconData, color: iconColor, size: 48),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}

void showSuccessMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return ShowDialogWidget(
        message: message,
        state: DialogState.success,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BasePage()));
        },
      );
    },
  );
}

void showErrorApi(BuildContext context, dynamic error) {
  String errorMessage = "Unknown Error";

  if (error is String) {
    errorMessage = error;
  }

  showDialog(
    context: context,
    builder: (context) {
      return ShowDialogWidget(
        message: errorMessage,
        state: DialogState.error,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    },
  );
}

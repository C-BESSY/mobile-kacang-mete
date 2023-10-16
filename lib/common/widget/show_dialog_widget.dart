import 'package:flutter/material.dart';

enum DialogState { success, warning, info, error }

class ShowDialogWidget extends StatelessWidget {
  final String message;
  final DialogState state;

  const ShowDialogWidget(
      {super.key, required this.message, this.state = DialogState.success});

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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
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
      );
    },
  );
}

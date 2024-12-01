import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSuccess(BuildContext context, String message, bool state) {
    _showSnackBar(
      context,
      message,
      state ? Colors.green : Colors.red,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.blue);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
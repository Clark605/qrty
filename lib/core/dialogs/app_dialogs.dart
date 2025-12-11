import 'package:flutter/material.dart';
import 'package:qrty/core/theme/app_colors.dart';

abstract class AppDialogs {
  static void showInfoMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static void showSuccessMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static void showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static Future<T?> selectionDialog<T>({
    required BuildContext context,
    required title,
    required List<Widget> options,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,

          title: title,
          content: SingleChildScrollView(child: ListBody(children: options)),
        );
      },
    );
  }
}

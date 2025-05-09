import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? cancelText = 'Cancel',
  String? confirmText = 'Yes',
  IconData? icon = Icons.help_outline,
  Color? cancelColor = Colors.deepOrange,
  Color? confirmColor = Colors.red,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      title: Row(
        children: [
          Icon(icon ?? Icons.help_outline, color: Colors.deepOrange),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // Block the pop
          },
          child: Text(
            cancelText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cancelColor ?? Colors.deepOrange,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Allow the pop
          },
          child: Text(
            confirmText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: confirmColor ?? Colors.red,
            ),
          ),
        ),
      ],
    ),
  ).then((value) => value ?? false); // Returns the decision made by the user
}

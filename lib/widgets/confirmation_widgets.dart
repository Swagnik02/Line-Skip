import 'package:flutter/material.dart';

Widget buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black45,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: 155,
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildButton({
  required String label,
  required VoidCallback onPressed,
  required Color backgroundColor,
  required Color textColor,
  bool outlined = false,
}) {
  final ButtonStyle style =
      outlined
          ? OutlinedButton.styleFrom(backgroundColor: backgroundColor)
          : FilledButton.styleFrom(backgroundColor: backgroundColor);

  final Widget button =
      outlined
          ? OutlinedButton(
            style: style,
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          )
          : FilledButton(
            style: style,
            onPressed: onPressed,
            child: Text(label),
          );

  return SizedBox(height: 50, width: double.infinity, child: button);
}

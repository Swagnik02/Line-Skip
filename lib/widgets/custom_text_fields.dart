import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const CustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Soft shadow color
            blurRadius: 6,
            offset: const Offset(0, 4), // Shadow direction
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white, // Background of TextField
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:line_skip/widgets/custom_text_fields.dart';

class ProfileWindow extends StatelessWidget {
  const ProfileWindow({
    super.key,
    required this.title,
    required this.subtitle,
    this.controller,
    this.hintText,
    this.imageFile,
    this.onImageTap,
  });

  final String title;
  final String subtitle;
  final TextEditingController? controller;
  final String? hintText;
  final ImageProvider? imageFile;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          if (controller != null && hintText != null)
            CustomTextField(textController: controller!, hintText: hintText!),
          const SizedBox(height: 20),
          if (onImageTap != null)
            Center(
              child: CustomPhotoSelectionBox(
                onTap: onImageTap!,
                imageFile: imageFile,
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class CustomPhotoSelectionBox extends StatelessWidget {
  const CustomPhotoSelectionBox({
    super.key,
    required this.onTap,
    this.imageFile,
  });

  final VoidCallback onTap;
  final ImageProvider? imageFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      splashColor: Colors.deepOrangeAccent.shade100.withOpacity(0.2),
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent),
          image:
              imageFile != null
                  ? DecorationImage(image: imageFile!, fit: BoxFit.cover)
                  : null,
        ),
        child:
            imageFile == null
                ? const Icon(Icons.add, size: 40, color: Colors.orangeAccent)
                : null,
      ),
    );
  }
}

PreferredSize customProgressIndicator(double progressValue) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 15),
    child: Column(
      children: [
        Spacer(),
        Container(
          width: double.infinity,
          height: 10,
          color: Colors.black12,
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ],
    ),
  );
}

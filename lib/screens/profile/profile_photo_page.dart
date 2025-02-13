import 'package:flutter/material.dart';
import 'package:line_skip/widgets/custom_floating_buttons.dart';

class ProfilePhotoPage extends StatelessWidget {
  final Function onSkip;

  ProfilePhotoPage({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            const Text(
              "Upload a Profile Photo",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(child: _buildPhotoBox(() {})),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFloatingSkip(
            onPressed: () {
              onSkip();
            },
          ),
          CustomFloatingNextButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoBox(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orangeAccent),
        ),
        child: const Icon(Icons.add, size: 40, color: Colors.orangeAccent),
      ),
    );
  }
}

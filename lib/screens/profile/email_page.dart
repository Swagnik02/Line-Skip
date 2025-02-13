import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_skip/widgets/custom_floating_buttons.dart';
import 'package:line_skip/widgets/custom_text_fields.dart';

class EmailPage extends StatelessWidget {
  final Function onNext;
  final Function onSkip;

  EmailPage({super.key, required this.onNext, required this.onSkip});

  final TextEditingController _emailController = TextEditingController();

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
              "Where should we send your bills?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your email.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            CustomTextField(nameController: _emailController),
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
            onPressed: () {
              if (_emailController.text.isNotEmpty) {
                User? user = FirebaseAuth.instance.currentUser;
                user?.updateEmail(_emailController.text);
                onNext();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter your email.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

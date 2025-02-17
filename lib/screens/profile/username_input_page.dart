import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_skip/widgets/custom_floating_buttons.dart';
import 'package:line_skip/widgets/custom_text_fields.dart';

class UsernameInputPage extends StatelessWidget {
  final Function onNext;

  UsernameInputPage({super.key, required this.onNext});

  final TextEditingController _nameController = TextEditingController();

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
              "How should we address you?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your username.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            CustomTextField(nameController: _nameController),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingNextButton(
        onPressed: () async {
          if (_nameController.text.isNotEmpty) {
            User? user = FirebaseAuth.instance.currentUser;
            user?.updateDisplayName(_nameController.text);
            DocumentReference userDocRef =
                FirebaseFirestore.instance.collection('users').doc(user?.uid);

            await userDocRef.update({'name': _nameController.text});

            onNext();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please enter your name.")),
            );
          }
        },
      ),
    );
  }
}

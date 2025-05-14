import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_skip/widgets/edit_profile_widgets.dart';
import 'package:line_skip/utils/constants.dart';
import 'package:line_skip/utils/photo_picker.dart';
import 'package:line_skip/widgets/custom_floating_buttons.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final PageController _pageController = PageController();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _selectedImage;
  int _currentPage = 0;

  double get _progressValue => (_currentPage + 1) / 3;

  void _updateProgress(int pageIndex) {
    setState(() => _currentPage = pageIndex);
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSkip() {
    Navigator.pushNamedAndRemoveUntil(context, authRoute, (route) => false);
  }

  Future<void> _pickImage() async {
    final image = await pickImage(context);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleUsernameSubmit() async {
    final name = _userNameController.text.trim();
    if (name.isEmpty) {
      return _showError("Please enter your name.");
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': name},
      );
      _onNext();
    }
  }

  Future<void> _handleEmailSubmit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return _showError("Please enter your email.");
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'email': email});
        _onNext();
      } catch (e) {
        _showError("Error updating email: $e");
      }
    }
  }

  Future<void> _handleProfileImageSubmit() async {
    if (_selectedImage == null) {
      return _showError("Please select a photo.");
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final imageUrl = await getImageLink(_selectedImage!, user.uid);

        if (imageUrl != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profileImage': imageUrl});
          _onNext();
          _onSkip(); // Final navigation
        } else {
          _showError("Failed to upload image.");
        }
      } catch (e) {
        _showError("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customProgressIndicator(_progressValue),
      backgroundColor: Colors.orangeAccent[400],
      body: PageView(
        controller: _pageController,
        onPageChanged: _updateProgress,
        children: [
          ProfileWindow(
            title: "How should we address you?",
            subtitle: "Enter your username.",
            controller: _userNameController,
            hintText: "Username",
          ),
          ProfileWindow(
            title: "Where should we send your receipts?",
            subtitle: "Enter your email.",
            controller: _emailController,
            hintText: "Email ID",
          ),
          ProfileWindow(
            title: "How do you look in a photo?",
            subtitle: "Upload a Profile Photo",
            onImageTap: _pickImage,
            imageFile:
                _selectedImage != null ? FileImage(_selectedImage!) : null,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    final buttons = [
      CustomFloatingNextButton(onPressed: _handleUsernameSubmit),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFloatingSkip(onPressed: _onSkip),
          CustomFloatingNextButton(onPressed: _handleEmailSubmit),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFloatingSkip(onPressed: _onSkip),
          CustomFloatingNextButton(onPressed: _handleProfileImageSubmit),
        ],
      ),
    ];
    return buttons[_currentPage];
  }
}

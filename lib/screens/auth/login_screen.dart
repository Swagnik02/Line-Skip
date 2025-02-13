import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:line_skip/providers/auth_provider.dart';
import 'package:line_skip/screens/auth/auth_service.dart';
import 'package:line_skip/screens/auth/login_widgets.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCodeSent = ref.watch(isCodeSentProvider);

    // Detect keyboard height
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFe0c1a4),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(keyboardVisible),
          _buildMainBody(context, ref, isCodeSent, keyboardVisible),
        ],
      ),
    );
  }

  Widget _buildBackground(bool keyboardVisible) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.cover,
        ),
        // Blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
        // Dynamic text based on keyboard visibility
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: keyboardVisible ? 30 : 50),
            customText(
              keyboardVisible ? 'Shop, scan, skip' : 'Line \n Skip',
              keyboardVisible ? 40 : 120,
            ),
            if (keyboardVisible) const SizedBox(height: 16),
            if (keyboardVisible) customText('Line Skip', 70),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBody(BuildContext context, WidgetRef ref, bool isCodeSent,
      bool keyboardVisible) {
    final height =
        keyboardVisible ? MediaQuery.of(context).size.height - 200 : 250;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: height.toDouble(),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isCodeSent
                ? OtpInput(
                    onVerifyOtp: (otp) async {
                      await AuthService.verifyOtp(context, ref, otp);
                    },
                  )
                : PhoneInput(
                    onSendOtp: (phoneNumber) async {
                      await AuthService.sendOtp(context, ref, phoneNumber);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

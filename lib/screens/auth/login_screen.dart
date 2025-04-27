import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/auth_provider.dart';
import 'dart:ui';
import 'package:line_skip/screens/auth/auth_service.dart';
import 'package:line_skip/screens/auth/login_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String? verificationId;
  bool codeSent = false;

  void onClickChangeNumber() {
    setState(() {
      codeSent = false;
      verificationId = null;
      phoneController.clear();
      otpController.clear();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFe0c1a4),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(keyboardVisible),
          _buildMainBody(context, ref, keyboardVisible),
        ],
      ),
    );
  }

  Widget _buildBackground(bool keyboardVisible) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: keyboardVisible ? 0 : 50),
            if (!keyboardVisible) customText('Line \n Skip', 120),
            if (keyboardVisible) const SizedBox(height: 16),
            if (keyboardVisible)
              SizedBox(
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBody(
      BuildContext context, WidgetRef ref, bool keyboardVisible) {
    final height =
        keyboardVisible ? MediaQuery.of(context).size.height - 200 : 400;
    final authController = ref.read(authControllerProvider);

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
            child: codeSent
                ? OtpInput(
                    onChangeNumber: onClickChangeNumber,
                    mobileNumber: authController.phoneNumber,
                    onVerifyOtp: (otp) async {
                      if (verificationId == null) return;

                      await AuthService.verifyOtp(
                        ref: ref,
                        verificationId: verificationId!,
                        otp: otp,
                      );
                      // Clear controllers after verification success
                      phoneController.clear();
                      otpController.clear();
                      // Navigate to next page here if needed
                    },
                  )
                : PhoneInput(
                    onSendOtp: (phoneNumber) async {
                      await AuthService.sendOtp(
                        ref: ref,
                        phoneNumber: phoneNumber,
                        onCodeSent: (vId) {
                          setState(() {
                            verificationId = vId;
                            codeSent = true;
                          });
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

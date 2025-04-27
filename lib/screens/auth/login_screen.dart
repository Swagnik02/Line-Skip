import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/screens/auth/auth_service.dart';
import 'package:line_skip/screens/auth/login_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? verificationId;
  String enteredPhoneNumber = '';
  bool codeSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _resetState() {
    setState(() {
      codeSent = false;
      verificationId = null;
      enteredPhoneNumber = '';
    });
    phoneController.clear();
    otpController.clear();
  }

  void _onCodeSent(String vId) {
    setState(() {
      verificationId = vId;
      codeSent = true;
    });
  }

  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    final containerHeight =
        isKeyboardVisible ? mediaQuery.size.height - 200 : 400.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFe0c1a4),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(isKeyboardVisible),
          _buildMainContent(containerHeight, isKeyboardVisible),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isKeyboardVisible) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(color: Colors.black.withOpacity(0)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: isKeyboardVisible ? 0 : 50),
            if (!isKeyboardVisible) customText('Line \n Skip', 120),
            if (isKeyboardVisible) const SizedBox(height: 16),
            if (isKeyboardVisible)
              SizedBox(
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent(double height, bool isKeyboardVisible) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: codeSent
                ? OtpInput(
                    onChangeNumber: _resetState,
                    mobileNumber: enteredPhoneNumber,
                    onVerifyOtp: (otp) async {
                      if (verificationId == null) {
                        _showError(context, 'Verification ID missing');
                        return;
                      }
                      await AuthService.verifyOtp(
                        ref: ref,
                        verificationId: verificationId!,
                        otp: otp,
                        onResult: (error) {
                          if (error != null) {
                            _showError(context, error);
                          } else {
                            _resetState();
                            // Navigate to next page
                          }
                        },
                      );
                    },
                  )
                : PhoneInput(
                    onSendOtp: (phoneNumber) async {
                      enteredPhoneNumber = phoneNumber;
                      await AuthService.sendOtp(
                        ref: ref,
                        phoneNumber: phoneNumber,
                        onCodeSent: _onCodeSent,
                        onError: (error) => _showError(context, error),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

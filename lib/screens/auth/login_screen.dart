import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/auth_provider.dart';
import 'package:line_skip/screens/auth/auth_service.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCodeSent = ref.watch(isCodeSentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
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
    );
  }
}

class PhoneInput extends StatelessWidget {
  final Function(String phoneNumber) onSendOtp;

  const PhoneInput({required this.onSendOtp, super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your phone number',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final phoneNumber = phoneController.text.trim();
            if (phoneNumber.isNotEmpty) {
              onSendOtp(phoneNumber);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a phone number')),
              );
            }
          },
          child: const Text('Send OTP'),
        ),
      ],
    );
  }
}

class OtpInput extends StatelessWidget {
  final Function(String otp) onVerifyOtp;

  const OtpInput({required this.onVerifyOtp, super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the OTP',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final otp = otpController.text.trim();
            if (otp.isNotEmpty) {
              onVerifyOtp(otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter the OTP')),
              );
            }
          },
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }
}

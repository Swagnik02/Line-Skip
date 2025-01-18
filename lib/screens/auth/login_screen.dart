import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final verificationIdProvider = StateProvider<String?>((ref) => null);
final isCodeSentProvider = StateProvider<bool>((ref) => false);

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
        child: Column(
          children: [
            if (!isCodeSent)
              PhoneInput(
                onSendOtp: (phoneNumber) async {
                  await sendOtp(context, ref, phoneNumber);
                },
              )
            else
              OtpInput(
                onVerifyOtp: (otp) async {
                  await verifyOtp(context, ref, otp);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> sendOtp(BuildContext context, WidgetRef ref, String phoneNumber) async {
    final auth = ref.read(authProvider);

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        _navigateToHome(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Verification failed: ${e.message}'),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        ref.read(verificationIdProvider.notifier).state = verificationId;
        ref.read(isCodeSentProvider.notifier).state = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ref.read(verificationIdProvider.notifier).state = verificationId;
      },
    );
  }

  Future<void> verifyOtp(BuildContext context, WidgetRef ref, String otp) async {
    final auth = ref.read(authProvider);
    final verificationId = ref.read(verificationIdProvider);

    if (verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Verification ID is null'),
      ));
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      _navigateToHome(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid OTP: ${e.toString()}'),
      ));
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home/');
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

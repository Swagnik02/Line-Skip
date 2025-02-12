import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_skip/providers/auth_provider.dart';
import 'package:line_skip/utils/constants.dart';

class AuthService {
  static Future<void> sendOtp(
      BuildContext context, WidgetRef ref, String phoneNumber) async {
    final auth = ref.read(authProvider);

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // _navigateToHome(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackbar(context, 'Verification failed: ${e.message}');
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

  static Future<void> verifyOtp(
      BuildContext context, WidgetRef ref, String otp) async {
    final auth = ref.read(authProvider);
    final verificationId = ref.read(verificationIdProvider);

    if (verificationId == null) {
      _showSnackbar(context, 'Verification ID is null');
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      // _navigateToHome(context);
    } catch (e) {
      _showSnackbar(context, 'Invalid OTP: ${e.toString()}');
    }
  }

  static void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, homeRoute);
  }

  static void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

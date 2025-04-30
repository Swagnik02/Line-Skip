import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/auth_provider.dart';

class AuthService {
  static Future<void> sendOtp({
    required WidgetRef ref,
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    final authController = ref.read(authControllerProvider);
    await authController.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  static Future<void> verifyOtp({
    required WidgetRef ref,
    required String verificationId,
    required String otp,
    required Function(String? error) onResult,
  }) async {
    final authController = ref.read(authControllerProvider);
    await authController.verifyOTP(
      verificationId: verificationId,
      smsCode: otp,
      onResult: (String? error) async {
        if (error == null) {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final userDoc =
                  FirebaseFirestore.instance.collection('users').doc(user.uid);

              final snapshot = await userDoc.get();
              if (!snapshot.exists) {
                await userDoc.set({
                  'createdAt': Timestamp.now(),
                  'phoneNumber': user.phoneNumber,
                  'uid': user.uid,
                });
              }
            }
          } catch (e) {
            onResult('Failed to save user: $e');
            return;
          }
        }

        // Return the result (null if success, or the error string)
        onResult(error);
      },
    );
  }

  static Future<void> logout({required WidgetRef ref}) async {
    final authController = ref.read(authControllerProvider);
    await authController.logout();
  }
}

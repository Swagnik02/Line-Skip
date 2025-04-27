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
    authController.phoneNumber = phoneNumber;
    await authController.sendOTP(
      phoneNumber: phoneNumber,
      codeSent: onCodeSent,
      onError: onError,
    );
  }

  static Future<void> verifyOtp({
    required WidgetRef ref,
    required String verificationId,
    required String otp,
  }) async {
    final authController = ref.read(authControllerProvider);
    await authController.verifyOTP(
      verificationId,
      otp,
    );
  }
}

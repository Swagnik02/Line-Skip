import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Stream for listening to authentication state changes
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

// Controller Provider
final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(),
);

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sending OTP
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? "Phone verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verifying OTP manually
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
    required Function(String? error) onResult,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      onResult(null);
    } catch (e) {
      onResult(e.toString());
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }
}

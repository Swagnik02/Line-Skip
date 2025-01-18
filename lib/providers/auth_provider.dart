import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final verificationIdProvider = StateProvider<String?>((ref) => null);
final isCodeSentProvider = StateProvider<bool>((ref) => false);

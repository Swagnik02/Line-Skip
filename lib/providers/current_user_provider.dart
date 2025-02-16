import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_skip/data/models/user_model.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier() : super(null) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      state = UserModel(
        id: user.uid,
        name: user.displayName ?? 'Unknown', // Default fallback
        email: user.email ?? 'No email',
        phoneNumber: user.phoneNumber ?? 'No phone number',
        profileImage: user.photoURL, // Added profileImage
        address: null, // Address needs to be fetched from Firestore
      );
    }
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

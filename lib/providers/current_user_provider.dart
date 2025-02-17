import 'package:cloud_firestore/cloud_firestore.dart';
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
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        state = UserModel(
          id: user.uid,
          name: userData['name'] ?? 'Unknown',
          email: userData['email'] ?? 'No email',
          phoneNumber: user.phoneNumber ?? 'No phone number',
          profileImage: userData['profileImage'],
          address: userData['address'],
        );
      } else {
        print("User document does not exist in Firestore.");
        state = UserModel(
          id: user.uid,
          name: user.displayName ?? 'Unknown',
          email: user.email ?? 'No email',
          phoneNumber: user.phoneNumber ?? 'No phone number',
          profileImage: user.photoURL,
          address: null,
        );
      }
    }
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_skip/data/models/user_model.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
      return CurrentUserNotifier();
    });

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  CurrentUserNotifier() : super(null) {
    _initUserListener();
  }

  void _initUserListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      _userSubscription = userDocRef.snapshots().listen((userDoc) {
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
        }
      });
    }
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    _userSubscription?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}

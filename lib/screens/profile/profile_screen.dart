import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/screens/profile/profile_input_page.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepOrangeAccent.shade100,
                      backgroundImage:
                          (user.profileImage != null &&
                                  user.profileImage!.isNotEmpty)
                              ? NetworkImage(user.profileImage!)
                              : null,
                      child:
                          (user.profileImage == null ||
                                  user.profileImage!.isEmpty)
                              ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      user.name.isNotEmpty ? user.name : "No Name Provided",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // User Email
                    Text(
                      user.email.isNotEmpty ? user.email : "No Email Provided",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    _profileOption(Icons.edit, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileInputPage();
                          },
                        ),
                      );
                    }),
                    _profileOption(Icons.lock, "Change Password", () {
                      // TODO: Implement password change
                    }),
                    _profileOption(Icons.logout, "Logout", () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        FirebaseAuth.instance.signOut();
                      }
                    }),
                  ],
                ),
              ),
    );
  }

  Widget _profileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/screens/profile/edit_profile_page.dart';
import 'package:line_skip/utils/constants.dart';
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
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepOrangeAccent.shade100,
                      backgroundImage:
                          (user.profileImage?.isNotEmpty ?? false)
                              ? NetworkImage(user.profileImage!)
                              : null,

                      child:
                          (user.profileImage?.isEmpty ?? true)
                              ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name.isNotEmpty ? user.name : "No Name Provided",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email.isNotEmpty ? user.email : "No Email Provided",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (user.phoneNumber.isNotEmpty)
                      Text(
                        user.phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 20),
                    _profileOption(context, Icons.edit, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage()),
                      );
                    }),
                    _profileOption(context, Icons.lock, "Change Password", () {
                      // TODO: Implement
                    }),
                    _profileOption(context, Icons.logout, "Logout", () async {
                      await FirebaseAuth.instance.signOut();
                      ref.read(currentUserProvider.notifier).clearUser();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        authRoute,
                        (route) => false,
                      );
                    }),
                  ],
                ),
              ),
    );
  }

  Widget _profileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

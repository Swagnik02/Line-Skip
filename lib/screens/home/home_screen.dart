import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/user_model.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/home/home_page_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final storeState = ref.watch(storesProvider);

    return Scaffold(
      appBar: HomeAppBar(user: user),
      backgroundColor: Colors.deepOrange.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const LocateStoreSearchBox(),
                const SizedBox(height: 16),
                const QuickOptions(),
                const SizedBox(height: 24),
                const Text(
                  "Popular Stores",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(child: AvailableStores(storeState: storeState)),
        ],
      ),
    );
  }
}

// Home App Bar with User Greeting
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;
  const HomeAppBar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Hello, ',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.black),
          ),
          Text(
            user?.name ?? "Guest",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent.shade100,
            radius: 25,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person, size: 35),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

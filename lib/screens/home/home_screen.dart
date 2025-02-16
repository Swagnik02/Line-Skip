import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/user_model.dart';
import 'package:line_skip/data/models/store_model.dart';
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
      appBar: _homeAppBar(context, user),
      backgroundColor: Colors.deepOrange.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocateStoreSearchBox(),
                const SizedBox(height: 16),
                _quickOptions(),
                const SizedBox(height: 20),
                const Text(
                  "Popular Stores",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _availableStores(storeState, context),
        ],
      ),
    );
  }

  /// AppBar with user greeting and profile icon
  AppBar _homeAppBar(BuildContext context, UserModel? user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Hello, ',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
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

  /// Quick Options Row
  Widget _quickOptions() {
    const options = [
      {"icon": Icons.leaderboard_sharp, "title": "Best Place"},
      {"icon": Icons.star_rounded, "title": "Favourites"},
      {"icon": Icons.receipt_long, "title": "Receipts"},
      {"icon": Icons.local_offer, "title": "Promos"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options
          .map((option) => QuickOption(
              icon: option["icon"] as IconData,
              title: option["title"] as String))
          .toList(),
    );
  }

  /// Display Available Stores
  Widget _availableStores(
      AsyncValue<List<Store>> storeState, BuildContext context) {
    return storeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (stores) => SizedBox(
        height: 350,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return DestinationCard(store: store);
          },
        ),
      ),
    );
  }
}

/// Store Card Widget
class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            store.hasTrolleyPairing ? Icons.shopping_cart : Icons.store,
            color: store.hasTrolleyPairing ? Colors.green : Colors.grey,
            size: 50,
          ),
          const SizedBox(height: 8),
          Text(
            store.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

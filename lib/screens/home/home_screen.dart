import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/user_model.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/screens/home/home_page_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: _homeAppBar(context, user),
      backgroundColor: Colors.deepOrange.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const LocateStoreSearchBox(),
                const SizedBox(height: 16),
                _quickOptions(),
                const SizedBox(height: 20),
                const Text(
                  "Popular Destinations",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _popularDestinations(),
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

  /// Horizontal ListView for Popular Destinations
  Widget _popularDestinations() {
    const destinations = [
      {
        "imagePath":
            "https://www.shutterstock.com/image-vector/storefront-city-vector-illustration-restaurant-260nw-626771693.jpg",
        "location": "Capadocia",
        "country": "Turkey"
      },
      {
        "imagePath":
            "https://www.shutterstock.com/image-vector/online-shopping-concept-260nw-1247954404.jpg",
        "location": "Snowlan",
        "country": "Cibadak"
      },
    ];

    return SizedBox(
      height: 350,
      child: Expanded(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 16.0),
            ...destinations.map((destination) => DestinationCard(
                  imagePath: destination["imagePath"]!,
                  location: destination["location"]!,
                  country: destination["country"]!,
                )),
          ],
        ),
      ),
    );
  }
}

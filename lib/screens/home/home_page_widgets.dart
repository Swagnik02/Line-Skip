import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/data/models/user_model.dart';
import 'package:line_skip/screens/store/store_detail_page.dart';
import 'package:line_skip/screens/store/store_selection_screen.dart';
import 'package:shimmer/shimmer.dart';

// Home App Bar with User Greeting
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? user;
  const HomeAppBar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
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
            backgroundColor: Colors.deepOrangeAccent,
            radius: 25,
            child: IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
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

class LocateStoreSearchBox extends StatelessWidget {
  const LocateStoreSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StoreSelectionPage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black54,
          //     blurRadius: 6,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Locate your store',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.black54),
            ),
            IconButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoreSelectionPage(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepOrangeAccent),
                fixedSize: WidgetStateProperty.all(Size(60, 60)),
              ),
              icon: SizedBox(
                child: Icon(
                  IconlyLight.search,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Option Button
class QuickOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const QuickOption({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 35,
            color: Colors.deepOrangeAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class DestinationCard extends StatelessWidget {
  final Store store;

  const DestinationCard({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailPage(store: store),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.circular(20)),
              child: Image.network(
                store.storeImage,
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.deepOrange.shade100,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 70 * MediaQuery.of(context).size.width / 100,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    width: MediaQuery.of(context).size.width * 0.7 - 16,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.2),
                          Color.fromRGBO(255, 255, 255, 0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7 - 24,
                          child: Text(
                            store.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded,
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.85),
                                size: 16),
                            Text(
                              store.location,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.85),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Options Section
class QuickOptions extends StatelessWidget {
  const QuickOptions({super.key});

  static const options = [
    {"icon": Icons.leaderboard_sharp, "title": "Best Place"},
    {"icon": Icons.star_rounded, "title": "Favourites"},
    {"icon": Icons.receipt_long, "title": "Receipts"},
    {"icon": Icons.local_offer, "title": "Promos"},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        return QuickOption(
          icon: option["icon"] as IconData,
          title: option["title"] as String,
        );
      }).toList(),
    );
  }
}

// Display Available Stores
class AvailableStores extends StatelessWidget {
  final AsyncValue<List<Store>> storeState;
  const AvailableStores({super.key, required this.storeState});

  @override
  Widget build(BuildContext context) {
    return storeState.when(
      loading: () => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 3,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.deepOrange.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 0.7 * MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (stores) => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: stores.length,
        itemBuilder: (context, index) => DestinationCard(store: stores[index]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/data/models/user_model.dart';
import 'package:line_skip/screens/store/store_detail_page.dart';
import 'package:line_skip/screens/store/store_selection_screen.dart';

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
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(
              store.storeImage,
            ),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name, // Corrected from `store.storeImage`
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    store.location,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
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
      loading: () => const Center(child: CircularProgressIndicator()),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/screens/store/store_detail_page.dart';
import 'package:line_skip/screens/store/store_selection_screen.dart';

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
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
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
              highlightColor: Colors.amber,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoreSelectionPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              iconSize: 35,
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 28,
            color: Colors.deepOrangeAccent.shade200,
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
              store.storeImage ??
                  'https://via.placeholder.com/400', // Default placeholder
            ),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {}, // Avoids crash on invalid URL
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

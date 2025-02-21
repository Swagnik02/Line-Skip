import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/store/store_page.dart';
import 'package:line_skip/screens/store/trolley_pairing_screen.dart';

class StoreDetailPage extends ConsumerWidget {
  final Store store;

  const StoreDetailPage({super.key, required this.store});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5E8C6), // Light green background
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Column(
              children: [
                Image.network(
                  store.storeImage,
                  fit: BoxFit.cover,
                  height: 400,
                  width: double.infinity,
                ),
                const Spacer(),
              ],
            ),
          ),

          // Store Details Card
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height - 350,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStoreInfo(),
                  const SizedBox(height: 12),
                  _buildOfferBanner(),
                  const SizedBox(height: 16),
                  VisitorForecastChart(
                    forecastValues: [50, 30, 65, 40, 40, 60, 20],
                    highlightedIndex: 3,
                  ),
                  const Spacer(),
                  _buildBookNowButton(context, ref),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds store name, location, and distance info.
  Widget _buildStoreInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              store.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.orange),
                Text(" ${store.location}",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.directions_walk, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text("${store.distance} km",
                  style: const TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the limited-time offer banner.
  Widget _buildOfferBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              store.offerText,
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
        ],
      ),
    );
  }

  /// Builds the "Book Now" button.
  Widget _buildBookNowButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ref.read(selectedStoreProvider.notifier).state = store;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => store.hasTrolleyPairing
                  ? const TrolleyPairingPage()
                  : const StorePage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          store.hasTrolleyPairing ? "Pair with trolley" : "Go to Cart",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class VisitorForecastChart extends StatelessWidget {
  final List<int> forecastValues;
  final int highlightedIndex;

  const VisitorForecastChart({
    Key? key,
    required this.forecastValues,
    this.highlightedIndex = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> times = [
      "8AM",
      "10AM",
      "12PM",
      "2PM",
      "4PM",
      "6PM",
      "8PM"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's visitor forecast",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              forecastValues.length,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: (forecastValues[index] * 1.5).toDouble(),
                    decoration: BoxDecoration(
                      color: index == highlightedIndex
                          ? Colors.orange
                          : Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: index == highlightedIndex
                          ? Border.all(
                              color: Colors.white.withOpacity(0.5), width: 2)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    times[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

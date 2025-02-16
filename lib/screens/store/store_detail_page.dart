import 'package:flutter/material.dart';
import 'package:line_skip/data/models/store_model.dart';

class StoreDetailPage extends StatelessWidget {
  final Store store;

  const StoreDetailPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
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
                  _buildVisitorForecast(),
                  Spacer(),
                  _buildBookNowButton(),
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

  /// Builds the visitor forecast chart dynamically.
  Widget _buildVisitorForecast() {
    const List<String> times = ["8AM", "11AM", "2PM", "5PM"];
    final List<int> forecast = store.visitorForecast ?? [10, 20, 15, 30];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's visitor forecast",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              forecast.length,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 16,
                    height: forecast[index].toDouble(),
                    decoration: BoxDecoration(
                      color: index == 3 ? Colors.orange : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(times[index]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the "Book Now" button.
  Widget _buildBookNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {}, // Implement booking logic here
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          "Book Now \$${store.price}",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

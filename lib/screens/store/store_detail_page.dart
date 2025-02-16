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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              store.storeImage ?? "assets/images/store_placeholder.jpg",
              fit: BoxFit.cover,
              height: 250,
            ),
          ),

          // Store Details Card
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Name & Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.orange),
                              Text(
                                " ${store.location}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_walk,
                                color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text("${store.distance} km",
                                style: const TextStyle(color: Colors.orange)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Limited Time Offer Banner
                  Container(
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
                            store.offerText ?? "No offers available",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.green),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Visitor Forecast
                  const Text(
                    "Today's visitor forecast",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Bar Chart (Dynamic)
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        store.visitorForecast?.length ?? 0,
                        (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 16,
                              height: store.visitorForecast?[index].toDouble(),
                              decoration: BoxDecoration(
                                color: index == 3
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(["8AM", "11AM", "2PM", "5PM"][index]),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Image Previews
                  // Row(
                  //   children: [
                  //     for (var i = 0; i < store.images.length; i++)
                  //       if (i < 3) ...[
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(12),
                  //           child: Image.asset(
                  //             store.images[i],
                  //             width: 50,
                  //             height: 50,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         const SizedBox(width: 8),
                  //       ],
                  //     if (store.images.length > 3)
                  //       Container(
                  //         width: 50,
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           color: Colors.grey.shade300,
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         alignment: Alignment.center,
                  //         child: Text("${store.images.length - 3}+", style: const TextStyle(color: Colors.grey)),
                  //       ),
                  //   ],
                  // ),

                  const SizedBox(height: 16),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Book Now \$${store.price}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
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
}

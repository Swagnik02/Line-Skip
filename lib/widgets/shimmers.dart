import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerStoreCard extends StatelessWidget {
  const ShimmerStoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7;
    final cardHeight = cardWidth * 1.777;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.deepOrange.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Simulate image area
              Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Simulate blur overlay for text
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  width: cardWidth - 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: cardWidth * 0.6,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            height: 14,
                            width: cardWidth * 0.4,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({super.key, required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.deepOrange.shade100,
      highlightColor: Colors.grey.shade100,
      child: Container(width: cardWidth, color: Colors.white),
    );
  }
}

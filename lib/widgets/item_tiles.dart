import 'package:flutter/material.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/utils/barcode_scanner.dart';
import 'package:line_skip/utils/helpers.dart';

class ItemTiles extends StatelessWidget {
  const ItemTiles({
    super.key,
    required this.item,
    required this.itemListNotifier,
  });

  final Item item;
  final CartNotifier itemListNotifier;

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final imageSize = windowWidth / 4;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFFf5efe7),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Image with error handling and loading placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: imageSize,
                      height: imageSize,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: imageSize / 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // Item Details
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${item.weight} gm',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.black45,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹ ${item.price}',
                              style: textTheme.titleLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            final barcode = await scan(context);
            // final barcode = '8901063035027';
            if (barcode == item.barcode) {
              itemListNotifier.removeItem(item.barcode);
            } else {
              showErrorDialog(context, 'Different Product Selected');
            }
          },
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

Future<String> scanBarcode(BuildContext context) async {
  String? barcode = await SimpleBarcodeScanner.scanBarcode(
    context,
    isShowFlashIcon: true,
    cameraFace: CameraFace.back,
    scanType: ScanType.barcode,
  );
  return barcode ?? '';
}

// Helper function to show a SnackBar with a given message
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Helper function to handle errors
void showError(BuildContext context, String errorMessage) {
  showMessage(context, errorMessage);
}

// Function to handle scanning and adding items to the cart
Future<void> scanToAddItems(BuildContext context,
    AsyncValue<List<Item>> inventoryState, WidgetRef ref) async {
  // final barcode = '8901063035027';
  if (kDebugMode) {
    Item item = Item(
      barcode: '8901063035027',
      name: 'Test Item',
      price: 10.0,
      imageUrl: 'https://example.com/image.jpg',
    );

    ref.read(cartItemsProvider.notifier).addItem(item);
    return;
  }

  final barcode = await scanBarcode(context);

  if (barcode.isNotEmpty) {
    inventoryState.when(
      data: (inventory) {
        // Create a map of barcodes to items for quick lookup
        final inventoryMap = {for (var item in inventory) item.barcode: item};

        // Look up the item by barcode
        final item = inventoryMap[barcode];

        if (item != null) {
          ref.read(cartItemsProvider.notifier).addItem(item);
        } else {
          showError(context, 'Item not found in inventory');
        }
      },
      loading: () {
        showMessage(context, 'Loading inventory...');
      },
      error: (error, stackTrace) {
        showError(context, 'Error loading inventory: $error');
      },
    );
  }
}

// Function to handle scanning and removing items from the cart
Future<void> scanToRemoveItems(
    BuildContext context, Item item, CartNotifier itemListNotifier) async {
  final barcode = await scanBarcode(context);
  // final barcode = '8901063035027';

  if (barcode == item.barcode) {
    itemListNotifier.removeItem(item.barcode);
  } else {
    showError(context, 'Different product selected');
  }
}

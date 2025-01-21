import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/cart/cart_screen.dart';
import 'package:line_skip/screens/cart/trolley_pairing_screen.dart';

class StoreSelectionPage extends ConsumerWidget {
  const StoreSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeState = ref.watch(storesProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                addStoresToFirestore();
              },
              icon: Icon(Icons.add))
        ],
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.deepOrangeAccent),
          ),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: storeState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (stores) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Select a Store',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown for store selection
              DropdownButton<Store>(
                value: selectedStore,
                hint: const Text("Choose your store"),
                isExpanded: true,
                iconSize: 30,
                elevation: 5,
                style: const TextStyle(color: Colors.black87, fontSize: 18),
                dropdownColor: Colors.white,
                items: stores.map<DropdownMenuItem<Store>>((Store store) {
                  return DropdownMenuItem<Store>(
                    value: store,
                    child: Row(
                      children: [
                        Icon(
                          store.hasTrolleyPairing
                              ? Icons.shopping_cart
                              : Icons.store,
                          color: store.hasTrolleyPairing
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(store.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Store? newValue) {
                  ref.read(selectedStoreProvider.notifier).state = newValue;
                },
              ),
              const SizedBox(height: 24),
              // Button to go to Store Details or Cart Screen
              if (selectedStore != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => selectedStore.hasTrolleyPairing
                            ? const TrolleyPairingPage()
                            : CartPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                    selectedStore.hasTrolleyPairing
                        ? "Pair Trolley"
                        : "Go to Cart",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          ref.refresh(storesProvider);
        },
        shape: CircleBorder(),
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}

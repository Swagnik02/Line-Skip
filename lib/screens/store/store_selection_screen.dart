import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/store/store_detail_page.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class StoreSelectionPage extends ConsumerWidget {
  const StoreSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeState = ref.watch(storesProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: storeState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (stores) {
            // Filter stores based on name or location
            final filteredStores = stores.where((store) {
              final storeName = store.name.toLowerCase();
              final storeLocation = store.location.toLowerCase();
              return storeName.contains(searchQuery) ||
                  storeLocation.contains(searchQuery);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
                  decoration: InputDecoration(
                    hintText: "Search by store name or location...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Store List
                Expanded(
                  child: filteredStores.isEmpty
                      ? const Center(child: Text("No stores found"))
                      : ListView.builder(
                          itemCount: filteredStores.length,
                          itemBuilder: (context, index) =>
                              _buildStoreTile(context, filteredStores[index]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => ref.refresh(storesProvider),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  /// Builds the store list tile with navigation to StoreDetailPage
  Widget _buildStoreTile(BuildContext context, Store store) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreDetailPage(store: store)),
      ),
      leading: Icon(
        store.hasTrolleyPairing ? Icons.shopping_cart : Icons.store,
        color: store.hasTrolleyPairing ? Colors.green : Colors.grey,
      ),
      title: Text(store.name),
      subtitle:
          Text(store.location, style: const TextStyle(color: Colors.grey)),
    );
  }
}

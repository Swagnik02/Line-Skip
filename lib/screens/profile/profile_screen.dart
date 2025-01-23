import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/providers/store_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            // Watch the selectedStore provider to get the store ID
            final selectedStore = ref.watch(selectedStoreProvider);

            return TextButton(
              onPressed: () {
                // Pass the selectedStore to the addItemsToFirestore function
                addItemsToFirestore(selectedStore!.docId);
              },
              child: const Text('Add me'),
            );
          },
        ),
      ),
    );
  }
}

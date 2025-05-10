import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/providers/receipt_provider.dart';

class ReceiptPage extends ConsumerWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.read(currentUserProvider)!.id;
    final receiptAsync = ref.watch(receiptsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('My Receipts')),
      body: receiptAsync.when(
        data: (receipts) {
          if (receipts.isEmpty) {
            return const Center(child: Text('No receipts found.'));
          }
          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return ListTile(
                title: Text('Receipt ID: ${receipt.receiptId}'),
                subtitle:
                    Text('Total: \$${receipt.totalAmount.toStringAsFixed(2)}'),
                // trailing: Text(receipt.formattedCreatedAt),
                onTap: () {
                  // Optional: Navigate to a ReceiptDetailsPage
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

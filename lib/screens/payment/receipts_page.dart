import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/providers/receipt_provider.dart';
import 'package:line_skip/screens/payment/view_receipt_page.dart';
import 'package:line_skip/utils/helpers.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';
import 'package:line_skip/widgets/custom_ink_well.dart';

class ReceiptPage extends ConsumerWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.read(currentUserProvider)!.id;
    final receiptAsync = ref.watch(receiptsProvider(userId));

    return Scaffold(
      appBar: CustomAppBar(title: 'My Receipts'),
      body: receiptAsync.when(
        data: (receipts) {
          if (receipts.isEmpty) {
            return const Center(child: Text('No receipts found.'));
          }
          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return ReceiptTile(receipt: receipt);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  const ReceiptTile({super.key, required this.receipt});

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    void viewReceipt() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewReceiptPage(receipt: receipt),
        ),
      );
    }

    return customInkWell(
      onTap: viewReceipt,
      borderRadius: 8.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipt.store.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${receipt.invoiceTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${receipt.items.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    icon: const Icon(Icons.receipt_long),
                    onPressed: viewReceipt,
                    iconSize: 28,
                    tooltip: 'View Receipt',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '#${receipt.transactionId}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatReceiptDate(receipt.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

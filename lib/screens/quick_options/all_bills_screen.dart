import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/providers/receipt_provider.dart';
import 'package:line_skip/widgets/bill_tiles.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class AllBillsScreen extends ConsumerWidget {
  const AllBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.read(currentUserProvider)!.id;
    final receiptAsync = ref.watch(receiptsProvider(userId));

    return Scaffold(
      appBar: CustomAppBar(title: 'My Bills'),
      body: receiptAsync.when(
        data: (receipts) {
          if (receipts.isEmpty) {
            return const Center(child: Text('No receipts found.'));
          }
          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index];
              return BillTiles(receipt: receipt);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

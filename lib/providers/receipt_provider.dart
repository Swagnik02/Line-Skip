import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/data/repositories/receipt_repository.dart';

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  return ReceiptRepository();
});

final receiptsProvider =
    FutureProvider.family<List<ReceiptModel>, String>((ref, userId) async {
  final repo = ref.read(receiptRepositoryProvider);
  return repo.fetchReceipts(userId);
});

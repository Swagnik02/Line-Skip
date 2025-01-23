import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/repositories/inventory_repository.dart';

// The provider to fetch the inventory for a specific store by store UID
final inventoryProvider =
    FutureProvider.family<List<Item>, String>((ref, storeDocId) async {
  final inventoryRepository = InventoryRepository();
  return await inventoryRepository.getInventory(storeDocId);
});

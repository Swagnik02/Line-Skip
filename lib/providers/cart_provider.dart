import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<Item>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Item>> {
  CartNotifier() : super([]);

  void addItem(Item item) {
    state = [...state, item];
  }

  void removeItem(Item item) {
    state = state.where((i) => i != item).toList();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/repositories/cart_repository.dart';

// Cart Repository Provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

// Cart Items Provider
final cartItemsProvider =
    StateNotifierProvider<CartNotifier, List<Item>>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return CartNotifier(cartRepository);
});

class CartNotifier extends StateNotifier<List<Item>> {
  final CartRepository cartRepository;

  CartNotifier(this.cartRepository) : super([]);

  // Fetch cart items
  Future<void> loadCartItems() async {
    state = await cartRepository.fetchCartItems();
  }

  // Add an item
  void addItem(Item item) {
    state = [...state, item];
    cartRepository.addItem(item);
  }

  // Remove an item
  void removeItem(String barcode) {
    state = state.where((item) => item.barcode != barcode).toList();
    cartRepository.removeItem(barcode);
  }

  // Update item weight (quantity in terms of weight)
  void updateWeight(String barcode, double weight) {
    state = state.map((item) {
      if (item.barcode == barcode) {
        return item.copyWith(weight: weight);
      }
      return item;
    }).toList();
    cartRepository.updateItemQuantity(barcode, weight);
  }

  // Calculate total price
  double calculateTotalPrice() {
    return state.fold(0, (sum, item) => sum + item.price);
  }

  // Calculate unique item count in the cart
  int calculateItemCount() {
    return state.length;
  }

  // Calculate total weight of the cart
  double calculateTotalWeight() {
    return state.fold(0, (sum, item) => sum + (item.weight ?? 0));
  }
}

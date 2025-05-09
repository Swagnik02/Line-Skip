import 'package:line_skip/data/models/item_model.dart';

class CartRepository {
  final List<Item> _cartItems = [];

  // Fetch all cart items
  Future<List<Item>> fetchCartItems() async {
    // Simulate a delay for fetching items
    await Future.delayed(const Duration(milliseconds: 500));
    return _cartItems;
  }

  // Clear all items in the cart
  void clearCart() {
    _cartItems.clear();
  }

  // Add an item to the cart
  void addItem(Item item) {
    _cartItems.add(item);
  }

  // Remove an item from the cart by barcode
  void removeItem(String barcode) {
    _cartItems.removeWhere((item) => item.barcode == barcode);
  }

  // Update item quantity in the cart
  void updateItemQuantity(String barcode, double weight) {
    for (var item in _cartItems) {
      if (item.barcode == barcode) {
        item.weight = weight;
        break;
      }
    }
  }

  // Get the total price of items in the cart
  double getTotalPrice() {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.weight));
  }
}

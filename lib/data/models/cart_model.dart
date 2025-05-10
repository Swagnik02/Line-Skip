// import 'package:line_skip/data/models/item_model.dart';

// class Cart {
//   // Map to store items in the cart with the barcode as the key
//   final Map<String, Item> items;

//   Cart({
//     required this.items,
//   });

//   // Get the total number of items in the cart
//   int get totalItems => items.length;

//   // Calculate the total amount of the cart
//   double get totalAmount =>
//       items.values.fold(0, (sum, item) => sum + item.price);

//   // Add an item to the cart
//   void addItem(Item item) {
//     items[item.barcode] = item;
//   }

//   // Remove an item from the cart
//   void removeItem(String barcode) {
//     items.remove(barcode);
//   }

//   // Clear the cart
//   void clearCart() {
//     items.clear();
//   }
// }

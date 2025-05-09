import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/item_model.dart';

class InventoryRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Flush inventory data
  void flushInventory() {}

  // Fetch inventory from Firestore based on store UID
  Future<List<Item>> getInventory(String storeUid) async {
    try {
      // Fetch the 'items' subcollection of a store
      final snapshot = await _firebaseFirestore
          .collection('stores')
          .doc(storeUid)
          .collection('items')
          .get();

      // Convert the snapshot data to Item objects using fromFirestore
      List<Item> items = snapshot.docs.map((doc) {
        // Create Item object using fromFirestore
        final item = Item.fromFirestore(doc);

        print(
            'Fetched Item: ${item.name}, Barcode: ${item.barcode}, Price: ${item.price}');

        return item;
      }).toList();

      return items;
    } catch (e) {
      throw Exception('Failed to fetch inventory: $e');
    }
  }
}

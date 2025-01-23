import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/item_model.dart'; // Ensure this points to the correct location of your Item model

class InventoryRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Fetch inventory from Firestore based on store UID
  Future<List<Item>> getInventory(String storeUid) async {
    try {
      // Fetch the 'items' subcollection of a store
      final snapshot = await _firebaseFirestore
          .collection('stores')
          .doc(storeUid)
          .collection('items')
          .get();

      // Convert the snapshot data to Item objects
      return snapshot.docs.map((doc) {
        return Item(
          barcode: doc['barcode'] ?? '', // Assuming 'barcode' is the field name in Firestore
          name: doc['name'] ?? '',
          brandName: doc['brandName'] ?? '',
          price: (doc['price'] ?? 0).toDouble(),
          weight: (doc['weight'] ?? 0).toDouble(),
          imageUrl: doc['imageUrl'] ?? '',
          category: doc['category'] ?? '',
          description: doc['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch inventory: $e');
    }
  }
}

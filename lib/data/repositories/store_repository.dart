import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Fetch stores from Firestore
  Future<List<Store>> getStores() async {
    try {
      // Fetch the stores collection
      final snapshot = await _firebaseFirestore.collection('stores').get();

      // Convert the snapshot data to Store objects
      return snapshot.docs
          .map((doc) => Store(
                name: doc['name'],
                description: doc['description'],
                hasTrolleyPairing: doc['hasTrolleyPairing'],
                location: doc['location'],
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch stores: $e');
    }
  }
}

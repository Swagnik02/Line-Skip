import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/store_model.dart';

class StoreRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Fetch stores from Firestore
  Future<List<Store>> getStores() async {
    try {
      // Fetch the stores collection ordered by createdAt
      final snapshot = await _firebaseFirestore
          .collection('stores')
          .orderBy('createdAt', descending: true) // Optional ordering
          .get();

      // Convert Firestore documents to Store objects
      return snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch stores: ${e.toString()}');
    }
  }
}

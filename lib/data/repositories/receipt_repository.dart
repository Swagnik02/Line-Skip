import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/receipt_model.dart';

class ReceiptRepository {
  final FirebaseFirestore _firestore;

  ReceiptRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch all receipts for a given userId
  Future<List<ReceiptModel>> fetchReceipts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('receipts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ReceiptModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching receipts: $e');
      return [];
    }
  }

  /// Optionally fetch a single receipt by ID
  Future<ReceiptModel?> fetchReceiptById(
      String userId, String receiptId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('receipts')
          .doc(receiptId)
          .get();

      if (doc.exists) {
        return ReceiptModel.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching receipt: $e');
      return null;
    }
  }
}

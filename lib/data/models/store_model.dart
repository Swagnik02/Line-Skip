import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;
  final String location;
  final String docId;
  final String? storeImage; // Optional store image

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
    required this.location,
    required this.docId,
    this.storeImage, // Optional parameter
  });

  // Convert Store object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'docId': docId,
      'storeImage': storeImage, // Nullable field
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

void addStoresToFirestore() async {
  // Firestore reference to the 'stores' collection
  final collectionRef = FirebaseFirestore.instance.collection('stores');
  final docRef =
      collectionRef.doc(); // Generate a new document reference with an ID

  // Create a Store object, passing the generated docRef.id as the docId
  final store = Store(
    name: 'Store G',
    description: 'Spencer.',
    hasTrolleyPairing: false,
    location: 'Tollygunge',
    docId: docRef.id,
  );

  try {
    // Save the Store object to Firestore using the document reference
    await docRef.set(store.toMap());
    print('Added: ${store.name} with docId: ${docRef.id}');
  } catch (e) {
    print('Failed to add ${store.name}: $e');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;
  final String location;

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
    required this.location,
  });

  // Convert Store object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

void addStoresToFirestore() async {
  // Firestore reference to the 'stores' collection
  final collectionRef = FirebaseFirestore.instance.collection('stores');
  final store = Store(
    name: 'Store G',
    description: 'Sspencer.',
    hasTrolleyPairing: false,
    location: 'Tollygunge',
  );

  try {
    // Add store data to Firestore with an Auto ID
    await collectionRef.add(store.toMap());
    print('Added: ${store.name}');
  } catch (e) {
    print('Failed to add ${store.name}: $e');
  }
}

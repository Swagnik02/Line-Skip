import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;
  final String location;
  final String docId;
  final String? storeImage; // Optional store image
  final double? distance; // Optional distance from user location
  final String? offerText; // Optional limited-time offer text
  final List<int>?
      visitorForecast; // Optional visitor forecast for different times
  final double? price; // Optional price for booking

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
    required this.location,
    required this.docId,
    this.storeImage, // Optional field
    this.distance, // Optional field
    this.offerText, // Optional field
    this.visitorForecast, // Optional field
    this.price, // Optional field
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
      'distance': distance,
      'offerText': offerText,
      'visitorForecast': visitorForecast,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Factory constructor to create a Store instance from Firestore data
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      hasTrolleyPairing: map['hasTrolleyPairing'] ?? false,
      location: map['location'] ?? '',
      docId: map['docId'] ?? '',
      storeImage: map['storeImage'],
      distance: (map['distance'] as num?)
          ?.toDouble(), // Convert nullable num to double
      offerText: map['offerText'],
      visitorForecast: map['visitorForecast'] != null
          ? List<int>.from(map['visitorForecast'])
          : null, // Handle nullable visitor forecast
      price:
          (map['price'] as num?)?.toDouble(), // Convert nullable num to double
    );
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

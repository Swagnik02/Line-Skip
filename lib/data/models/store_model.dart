import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;
  final String location;
  final String docId;
  final String storeImage; // Made it non-nullable with a default value
  final double distance;
  final String offerText;
  final List<int> visitorForecast;
  final double price;
  final DateTime? createdAt;

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
    required this.location,
    required this.docId,
    this.storeImage = '',
    this.distance = 0.0, // Default value
    this.offerText = '', // Default value
    this.visitorForecast = const [], // Default empty list
    this.price = 0.0, // Default value
    this.createdAt,
  });

  // Convert Store object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'storeImage': storeImage.isNotEmpty ? storeImage : null,
      'distance': distance,
      'offerText': offerText,
      'visitorForecast': visitorForecast.isNotEmpty ? visitorForecast : null,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Factory constructor to create Store from Firestore data
  factory Store.fromJson(Map<String, dynamic> json, String docId) {
    return Store(
      name: json['name'] ?? 'Unknown Store',
      description: json['description'] ?? '',
      hasTrolleyPairing: json['hasTrolleyPairing'] ?? false,
      location: json['location'] ?? 'Unknown Location',
      docId: docId,
      storeImage: json['storeImage'] ?? 'https://dummyimage.com/400',
      distance: (json['distance'] ?? 0).toDouble(),
      offerText: json['offerText'] ?? 'No offers available',
      visitorForecast: (json['visitorForecast'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      price: (json['price'] ?? 0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

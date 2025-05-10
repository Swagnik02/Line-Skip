import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;
  final String location;
  final String storeId;
  final String storeImage;
  final List<int> visitorForecast;
  final DateTime? createdAt;
  final String storeUpiId;
  final String mobileNumber;
  final String ownerName;

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
    required this.location,
    required this.storeId,
    this.storeImage = '',
    this.visitorForecast = const [],
    this.createdAt,
    this.storeUpiId = '',
    this.mobileNumber = '',
    this.ownerName = '',
  });

  // Convert Store object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'storeImage': storeImage.isNotEmpty ? storeImage : null,
      'visitorForecast': visitorForecast.isNotEmpty ? visitorForecast : null,
      'createdAt': FieldValue.serverTimestamp(),
      'storeUpiId': storeUpiId.isNotEmpty ? storeUpiId : null,
      'mobileNumber': mobileNumber.isNotEmpty ? mobileNumber : null,
      'ownerName': ownerName.isNotEmpty ? ownerName : null,
    };
  }

  // Factory constructor to create Store from Firestore data
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['storeId'],
      name: json['name'] ?? 'Unknown Store',
      description: json['description'] ?? '',
      hasTrolleyPairing: json['hasTrolleyPairing'] ?? false,
      location: json['location'] ?? 'Unknown Location',
      storeImage: json['storeImage'] ?? 'https://dummyimage.com/400',
      visitorForecast: (json['visitorForecast'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      storeUpiId: json['storeUpiId'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
    );
  }

  // Convert Store object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'storeImage': storeImage.isNotEmpty ? storeImage : null,
      'visitorForecast': visitorForecast.isNotEmpty ? visitorForecast : null,
      'createdAt': createdAt?.toIso8601String(),
      'storeUpiId': storeUpiId.isNotEmpty ? storeUpiId : null,
      'mobileNumber': mobileNumber.isNotEmpty ? mobileNumber : null,
      'ownerName': ownerName.isNotEmpty ? ownerName : null,
    };
  }
}

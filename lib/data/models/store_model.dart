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

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'storeImage': storeImage.isNotEmpty ? storeImage : null,
      'visitorForecast': visitorForecast.isNotEmpty ? visitorForecast : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'storeUpiId': storeUpiId.isNotEmpty ? storeUpiId : null,
      'mobileNumber': mobileNumber.isNotEmpty ? mobileNumber : null,
      'ownerName': ownerName.isNotEmpty ? ownerName : null,
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    final dynamic timestamp = json['createdAt'];
    DateTime? createdAt;
    if (timestamp is Timestamp) {
      createdAt = timestamp.toDate();
    }

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
      createdAt: createdAt,
      storeUpiId: json['storeUpiId'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'hasTrolleyPairing': hasTrolleyPairing,
      'location': location,
      'storeImage': storeImage.isNotEmpty ? storeImage : null,
      'visitorForecast': visitorForecast.isNotEmpty ? visitorForecast : null,
      'storeUpiId': storeUpiId.isNotEmpty ? storeUpiId : null,
      'mobileNumber': mobileNumber.isNotEmpty ? mobileNumber : null,
      'ownerName': ownerName.isNotEmpty ? ownerName : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}

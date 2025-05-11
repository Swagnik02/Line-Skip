import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String barcode;
  String name;
  String brandName;
  double price;
  double tax;
  double weight;
  String imageUrl;
  String category;
  String description;

  // Constructor
  Item({
    required this.barcode,
    this.name = "",
    this.brandName = "",
    this.price = 0,
    double? tax,
    this.weight = 0,
    this.imageUrl = "",
    this.category = "",
    this.description = "",
  }) : tax = 0.05 * price;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brandName': brandName,
      'price': price,
      'tax': tax,
      'weight': weight,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
    };
  }

  // Create from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      barcode: json['barcode'],
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      price: json['price'] ?? 0.0,
      tax: json['tax'] ?? 0.0,
      weight: json['weight'] ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Create from Firestore DocumentSnapshot
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Item(
      barcode: data['barcode'] ?? '',
      name: data['name'] ?? '',
      brandName: data['brandName'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      tax: data['tax']?.toDouble() ?? 0.0,
      weight: data['weight']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'brandName': brandName,
      'price': price,
      'tax': tax,
      'weight': weight,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
    };
  }

  // Copy with updated fields
  Item copyWith({
    String? barcode,
    String? name,
    String? brandName,
    double? price,
    double? tax,
    double? weight,
    String? imageUrl,
    String? category,
    String? description,
  }) {
    return Item(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}

void addItemsToFirestore(String selectedStore) async {
  // Firestore reference to the 'stores' collection and the specific store document
  final storeRef =
      FirebaseFirestore.instance.collection('stores').doc(selectedStore);

  // Firestore reference to the 'items' subcollection inside the store document
  final itemsCollectionRef = storeRef.collection('items');

  // Create an Item object with the data you want to add
  final item = Item(
    barcode: '8901063035027',
    name: 'Milk Bikis',
    brandName: 'Britannia',
    price: 30,
    weight: 0.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1247.jpg',
    category: 'Snacks',
    description: 'Delicious milk-based biscuits.',
  );

  try {
    // Add the item to the 'items' subcollection of the selected store
    final docRef = itemsCollectionRef
        .doc(); // Create a new document reference for the item

    // Save the item to Firestore
    await docRef.set(item.toMap());
    print('Added: ${item.name} to Store with docId: $selectedStore');
  } catch (e) {
    print('Failed to add ${item.name}: $e');
  }
}

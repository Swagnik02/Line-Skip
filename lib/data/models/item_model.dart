class Item {
  String barcode;
  String name;
  String brandName;
  double price;
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
    this.weight = 0,
    this.imageUrl = "",
    this.category = "",
    this.description = "",
  });

  // Method to convert Item object to JSON (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brandName': brandName,
      'price': price,
      'weight': weight,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
    };
  }

  // Method to create Item object from JSON (for deserialization)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      barcode: json['barcode'],
      name: json['name'],
      brandName: json['brandName'],
      price: json['price'],
      weight: json['weight'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      description: json['description'],
    );
  }
}

List<Item> dummyItemList = [];

List<Item> dummyItemDb = [
  Item(
    barcode: '8901063035027',
    name: 'Milk Bikis',
    brandName: 'Britannia',
    price: 30,
    weight: 0.5,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx20IHClk2em1SYeiO8412FMhZ4B3ubjSObw&s',
  ),
  Item(
    barcode: ']C1AEGM700ROGMK0824',
    name: 'Mouse GM700',
    brandName: 'Ant Esports',
    price: 1000,
    weight: 50,
    imageUrl:
        'https://m.media-amazon.com/images/I/41tGB16ruOL._SX300_SY300_QL70_FMwebp_.jpg',
  ),
  Item(
      barcode: '8901393016185',
      name: 'Mentos',
      brandName: 'Mentos',
      price: 10,
      weight: 0.1,
      imageUrl:
          'https://www.bigbasket.com/media/uploads/p/l/40107653_7-mentos-pure-fresh-sugarfree-mint-flavour-chewing-gum.jpg'),
];

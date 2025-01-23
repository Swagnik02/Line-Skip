import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/item_model.dart';

List<Item> dummyItems = [
  Item(
    barcode: '8901063035027',
    name: 'Milk Bikis',
    brandName: 'Britannia',
    price: 30,
    weight: 0.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1247.jpg',
    category: 'Snacks',
    description: 'Delicious milk-based biscuits.',
  ),
  Item(
    barcode: ']C1AEGM700ROGMK0824',
    name: 'Mouse GM700',
    brandName: 'Ant Esports',
    price: 1000,
    weight: 0.05,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1190.jpg',
    category: 'Electronics',
    description: 'High-performance gaming mouse.',
  ),
  Item(
    barcode: '8906018030458',
    name: 'Good Day Cookies',
    brandName: 'Britannia',
    price: 20,
    weight: 0.15,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1119.jpg',
    category: 'Snacks',
    description: 'Crunchy and tasty cookies.',
  ),
  Item(
    barcode: '4897081000031',
    name: 'Wireless Keyboard',
    brandName: 'Logitech',
    price: 2500,
    weight: 0.7,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/498.jpg',
    category: 'Electronics',
    description: 'Compact and wireless keyboard.',
  ),
  Item(
    barcode: '9780143127741',
    name: 'The Martian',
    brandName: 'Penguin Books',
    price: 500,
    weight: 0.4,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/345.jpg',
    category: 'Books',
    description: 'Sci-fi thriller by Andy Weir.',
  ),
  Item(
    barcode: '8901030678901',
    name: 'Bournvita',
    brandName: 'Cadbury',
    price: 200,
    weight: 0.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/278.jpg',
    category: 'Beverages',
    description: 'Chocolate drink for energy.',
  ),
  Item(
    barcode: '8901234567890',
    name: 'Notebook A5',
    brandName: 'Classmate',
    price: 40,
    weight: 0.3,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/338.jpg',
    category: 'Stationery',
    description: 'Durable and lightweight notebook.',
  ),
  Item(
    barcode: '8907014023012',
    name: 'Parker Pen',
    brandName: 'Parker',
    price: 300,
    weight: 0.05,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/282.jpg',
    category: 'Stationery',
    description: 'Elegant and smooth writing pen.',
  ),
  Item(
    barcode: '8906026879087',
    name: 'Tide Detergent',
    brandName: 'Tide',
    price: 120,
    weight: 1.0,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/639.jpg',
    category: 'Household',
    description: 'Powerful laundry detergent.',
  ),
  Item(
    barcode: '9780194738048',
    name: 'Oxford Dictionary',
    brandName: 'Oxford',
    price: 800,
    weight: 0.6,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/202.jpg',
    category: 'Books',
    description: 'Comprehensive English dictionary.',
  ),
  Item(
    barcode: '8901053002027',
    name: 'Saffola Gold',
    brandName: 'Saffola',
    price: 600,
    weight: 1.0,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/507.jpg',
    category: 'Groceries',
    description: 'Heart-healthy cooking oil.',
  ),
  Item(
    barcode: '9789389620242',
    name: 'The Alchemist',
    brandName: 'HarperCollins',
    price: 400,
    weight: 0.25,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1147.jpg',
    category: 'Books',
    description: 'Inspirational novel by Paulo Coelho.',
  ),
  Item(
    barcode: '8901218023458',
    name: 'Fair & Lovely',
    brandName: 'Unilever',
    price: 80,
    weight: 0.1,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/609.jpg',
    category: 'Personal Care',
    description: 'Fairness cream for all skin types.',
  ),
  Item(
    barcode: '8905047000238',
    name: 'Coca-Cola',
    brandName: 'Coca-Cola',
    price: 40,
    weight: 0.33,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/777.jpg',
    category: 'Beverages',
    description: 'Refreshing carbonated drink.',
  ),
  Item(
    barcode: '8901147111301',
    name: 'Dairy Milk',
    brandName: 'Cadbury',
    price: 50,
    weight: 0.15,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/589.jpg',
    category: 'Snacks',
    description: 'Creamy milk chocolate.',
  ),
  Item(
    barcode: '8901031010011',
    name: 'Coca Cola',
    brandName: 'Coca Cola',
    price: 40,
    weight: 1.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/267.jpg',
  ),
  Item(
    barcode: '8902345678912',
    name: 'Pepsi',
    brandName: 'PepsiCo',
    price: 35,
    weight: 1.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/118.jpg',
  ),
  Item(
    barcode: '8901212345678',
    name: 'KitKat',
    brandName: 'Nestle',
    price: 25,
    weight: 0.1,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/397.jpg',
  ),
  Item(
    barcode: '8909876543210',
    name: 'Parle-G',
    brandName: 'Parle',
    price: 10,
    weight: 0.2,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/691.jpg',
  ),
  Item(
    barcode: '8905632109876',
    name: 'Sprite',
    brandName: 'Coca Cola',
    price: 40,
    weight: 1.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/73.jpg',
  ),
  Item(
    barcode: '8900987654321',
    name: 'Thums Up',
    brandName: 'Coca Cola',
    price: 40,
    weight: 1.5,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1140.jpg',
  ),
  Item(
    barcode: '8900000000001',
    name: 'Maggi Noodles',
    brandName: 'Nestle',
    price: 12,
    weight: 0.07,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1247.jpg',
  ),
  Item(
    barcode: '8900000000002',
    name: 'Lay’s Classic',
    brandName: 'PepsiCo',
    price: 20,
    weight: 0.06,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1190.jpg',
  ),
  Item(
    barcode: '8900000000003',
    name: 'Bourbon Biscuits',
    brandName: 'Britannia',
    price: 30,
    weight: 0.2,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1119.jpg',
  ),
  Item(
    barcode: '8900000000004',
    name: 'Real Juice',
    brandName: 'Dabur',
    price: 90,
    weight: 1,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/498.jpg',
  ),
  Item(
    barcode: '8900000000005',
    name: 'Good Day',
    brandName: 'Britannia',
    price: 25,
    weight: 0.25,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/345.jpg',
  ),
  Item(
    barcode: '8900000000006',
    name: 'Oreo',
    brandName: 'Cadbury',
    price: 30,
    weight: 0.12,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/278.jpg',
  ),
  Item(
    barcode: '8900000000007',
    name: 'Almond Milk',
    brandName: 'Sofit',
    price: 120,
    weight: 1,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/338.jpg',
  ),
  Item(
    barcode: '8900000000008',
    name: 'Choco Pie',
    brandName: 'Lotte',
    price: 90,
    weight: 0.3,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/282.jpg',
  ),
  Item(
    barcode: '8900000000009',
    name: 'Dairy Milk',
    brandName: 'Cadbury',
    price: 50,
    weight: 0.15,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/639.jpg',
  ),
  Item(
    barcode: '8900000000010',
    name: 'Nutella',
    brandName: 'Ferrero',
    price: 270,
    weight: 0.35,
    imageUrl:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/202.jpg',
  ),
];

Future<void> addItemsToFirestore(List<Item> items) async {
  try {
    // Reference to the Firestore collection
    CollectionReference itemsCollection =
        FirebaseFirestore.instance.collection('items');

    // Add each item to the collection
    for (Item item in items) {
      await itemsCollection.add(item.toMap());
    }

    print('Items added successfully to Firestore.');
  } catch (e) {
    print('Error adding items to Firestore: $e');
  }
}
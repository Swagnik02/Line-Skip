import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/inventory_provider.dart';
import 'package:line_skip/providers/store_provider.dart';

import 'package:line_skip/screens/store/cart_screen.dart';
import 'package:line_skip/screens/store/checkout_screen.dart';
import 'package:line_skip/widgets/custom_bottom_nav_bar.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CartPage(),
    CheckoutPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Trigger loading inventory data when the page is opened
    final selectedStore = ref.read(selectedStoreProvider);
    if (selectedStore != null) {
      // Trigger inventory loading by using the selected store's UID
      ref.read(inventoryProvider(selectedStore.docId));
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the selected store from the provider
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      appBar: _appBar(selectedStore),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
        bottomNavItems: [
          CustomStyle16NavBarItem(
            title: 'Cart',
            icon: Icons.shopping_cart,
          ),
          CustomStyle16NavBarItem(
            title: 'Payment',
            icon: Icons.payment,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add barcode scanning or similar functionality here
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(CupertinoIcons.barcode_viewfinder),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _appBar(Store? selectedStore) {
    return AppBar(
      backgroundColor:
          _currentIndex == 1 ? Colors.deepOrangeAccent : Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (selectedStore != null)
              Text(
                selectedStore.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            const Spacer(),
            _profile(),
          ],
        ),
      ),
    );
  }

  GestureDetector _profile() {
    return GestureDetector(
      onTap: () {
   
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        width: 150,
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.arrow_back_ios, color: Colors.black54),
              ),
              Container(
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.brown[800],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/user.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

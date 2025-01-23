import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/inventory_provider.dart';
import 'package:line_skip/providers/store_provider.dart';

import 'package:line_skip/screens/store/cart_screen.dart';
import 'package:line_skip/screens/store/checkout_screen.dart';
import 'package:line_skip/utils/barcode_scanner.dart';
import 'package:line_skip/widgets/custom_bottom_nav_bar.dart';

import 'package:line_skip/widgets/profile_icon_button.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [CartPage(), CheckoutPage()];

  @override
  void initState() {
    super.initState();
    final selectedStore = ref.read(selectedStoreProvider);
    if (selectedStore != null) {
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
    final selectedStore = ref.watch(selectedStoreProvider);
    final inventory = ref.watch(inventoryProvider(selectedStore?.docId ?? ''));

    return Scaffold(
      appBar: storePageAppBar(selectedStore),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
        bottomNavItems: [
          CustomStyle16NavBarItem(title: 'Cart', icon: Icons.shopping_cart),
          CustomStyle16NavBarItem(title: 'Payment', icon: Icons.payment),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          scanToAddItems(context, inventory, ref);
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar storePageAppBar(Store? selectedStore) {
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            const Spacer(),
            profileIconBtn(),
          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/inventory_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/store/cart_screen.dart';
import 'package:line_skip/screens/store/checkout_screen.dart';
import 'package:line_skip/utils/barcode_scanner.dart';
import 'package:line_skip/widgets/custom_bottom_nav_bar.dart';
import 'package:line_skip/widgets/store_page_widgets.dart';

class StorePage extends ConsumerWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStore = ref.watch(selectedStoreProvider);
    final inventory = ref.watch(inventoryProvider(selectedStore?.docId ?? ''));
    final currentIndex = ref.watch(currentPageProvider);

    final screens = const [
      CartPage(),
      CheckoutPage(),
    ];

    return Scaffold(
      appBar: buildAppBar(ref, selectedStore),
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(currentPageProvider.notifier).state = index,
        bottomNavItems: [
          CustomStyle16NavBarItem(title: 'Cart', icon: Icons.shopping_cart),
          CustomStyle16NavBarItem(title: 'Payment', icon: Icons.payment),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => scanToAddItems(context, inventory, ref),
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Provider to manage current page state
final currentPageProvider = StateProvider<int>((ref) => 0);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/ble_provider.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/providers/inventory_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/store/cart_screen.dart';
import 'package:line_skip/screens/store/checkout_screen.dart';
import 'package:line_skip/utils/barcode_scanner.dart';
import 'package:line_skip/widgets/confirmation_dialog.dart';
import 'package:line_skip/widgets/custom_bottom_nav_bar.dart';
import 'package:line_skip/widgets/store_page_widgets.dart';
import 'package:line_skip/widgets/weight_tracker_button.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  bool _dialogShown = false;

  @override
  void dispose() {
    // Reset cart provider state
    ref.read(cartItemsProvider.notifier).resetCart();
    ref.invalidate(inventoryProvider);

    ref.read(bleProvider.notifier).disconnect();
    ref.invalidate(cartItemsProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedStore = ref.watch(selectedStoreProvider);
    final inventory = ref.watch(
      inventoryProvider(selectedStore?.storeId ?? ''),
    );
    final currentIndex = ref.watch(currentPageProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    final screens = const [CartPage(), CheckoutPage()];

    ref.listen<BLEState>(bleProvider, (prev, next) {
      final actualWeight = next.receivedData;
      final isWeightBalanced = cartNotifier.validateWeight(actualWeight);

      if (!isWeightBalanced && !_dialogShown) {
        _dialogShown = true;
        showDeviceDialog(context, ref).then((_) => _dialogShown = false);
      }

      if (isWeightBalanced) {
        _dialogShown = false;
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        bool exitConfirmed = await showConfirmationDialog(
          context: context,
          title: "Exit Confirmation",
          message:
              "Are you sure you want to exit? Any unsaved progress will be lost.",
          cancelText: "Cancel",
          confirmText: "Yes",
          icon: Icons.exit_to_app,
          cancelColor: Colors.deepOrange,
          confirmColor: Colors.red,
        );
        if (exitConfirmed) {
          dispose();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: buildAppBar(ref, selectedStore, context),
        body: screens[currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap:
              (index) => ref.read(currentPageProvider.notifier).state = index,
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
      ),
    );
  }
}

// Provider to manage current page state
final currentPageProvider = StateProvider<int>((ref) => 0);

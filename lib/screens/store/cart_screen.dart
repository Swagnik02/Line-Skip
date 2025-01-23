import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/widgets/item_tiles.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    return Scaffold(
      body: Center(
          child: cartItems.isEmpty
              ? _emptyBody()
              : _cartBody(cartItems, cartNotifier)),
    );
  }

  ListView _cartBody(List<Item> cartItems, CartNotifier cartNotifier) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ItemTiles(
          item: item,
          itemListNotifier: cartNotifier,
        );
      },
    );
  }

  Column _emptyBody() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.cart_badge_plus,
          size: 100,
          color: Colors.deepOrangeAccent,
        ),
        SizedBox(height: 16),
        Text(
          "Your cart is empty!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Start adding items by scanning them.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

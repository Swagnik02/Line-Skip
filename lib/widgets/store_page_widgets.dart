import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/screens/store/store_page.dart';
import 'package:line_skip/widgets/profile_icon_button.dart';

AppBar buildAppBar(WidgetRef ref, Store? selectedStore) {
  return AppBar(
    backgroundColor: ref.watch(currentPageProvider) == 1
        ? Colors.deepOrangeAccent
        : Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CartItemCount(),
          const Spacer(),
          if (selectedStore != null)
            SizedBox(
              width: 170,
              child: Text(
                selectedStore.name,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          const Spacer(),
          profileIconBtn(),
        ],
      ),
    ),
  );
}

class CartItemCount extends ConsumerWidget {
  const CartItemCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemsProvider).length;

    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 203, 153),
            Color(0xFFe8d981),
            Color(0xFFe8d981),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          itemCount.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

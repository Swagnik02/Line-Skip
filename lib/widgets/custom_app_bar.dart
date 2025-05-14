import 'package:flutter/material.dart';

AppBar customLineSkipAppBar({Widget? leading, List<Widget>? actions}) {
  return AppBar(
    toolbarHeight: 300,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: leading,
    actions: actions,
    title: Stack(
      children: [
        // Outline text
        Text(
          'Line \nSkip',
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 4,
            height: 0.8,
            fontFamily: 'Gagalin',
            fontSize: 120,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = const Color.fromARGB(255, 73, 73, 73),
          ),
        ),
        // Inner text
        Text(
          'Line \nSkip',
          textAlign: TextAlign.center,
          style: const TextStyle(
            letterSpacing: 4,
            height: 0.8,
            fontFamily: 'Gagalin',
            fontSize: 120,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

// AppBar _appBar() {
//   return AppBar(
//     backgroundColor:
//         _currentIndex == 1 ? Colors.deepOrangeAccent : Colors.white,
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     title: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           // Cart Title with Item Count
//           _cartItemCount(),
//           const SizedBox(width: 8),
//           Text(
//             _currentIndex == 1 ? 'Items' : 'Cart',
//             style: TextStyle(
//               color: _currentIndex == 1 ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           Spacer(),
//           _profile(),
//         ],
//       ),
//     ),
//   );
// }
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.title = "", this.actions});

  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          title == "Payment Confirmation"
              ? Icons.close_rounded
              : Icons.arrow_back_ios_new_rounded,
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.deepOrangeAccent),
        ),
      ),
      actions: actions,
      title: Text(title ?? "", style: const TextStyle(color: Colors.black)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

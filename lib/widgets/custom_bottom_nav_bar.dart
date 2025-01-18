import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> bottomNavItems;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.bottomNavItems,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 12,
      currentIndex: currentIndex,
      onTap: onTap,
      items: bottomNavItems,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
          Colors.deepOrangeAccent, // Change the selected item color
      unselectedItemColor: Colors.grey[600], // Color for unselected items
      backgroundColor: Colors.white,
      iconSize: 30, // Adjust icon size for better visibility
      showUnselectedLabels: false, // Hide labels for unselected items
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class CustomStyle16NavBarItem extends BottomNavigationBarItem {
  CustomStyle16NavBarItem({
    required String title,
    required IconData icon,
  }) : super(
          icon: Icon(
            icon,
            size: 28, // Customize icon size
            color: Colors.grey[600], // Default color for unselected items
          ),
          label: title,
          activeIcon: Icon(
            icon,
            size: 32, // Customize active icon size
            color: Colors.deepOrangeAccent, // Active icon color
          ),
        );
}

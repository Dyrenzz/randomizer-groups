import 'package:flutter/material.dart';
import 'package:flutter_application_1/unused/colors.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;
  final bool isDark = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  // Set this based on your app's theme
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark ? darkMode[700]! : lightMode[400]!,
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          // Item
          unselectedItemColor: isDark ? darkMode[1100] : lightMode[900],
          selectedItemColor: isDark ? darkMode[1300] : lightMode[1100],

          // Label
          unselectedLabelStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),

          backgroundColor: isDark ? darkMode[500] : lightMode[300],
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: List.from([
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined, size: 30.0),
              activeIcon: Icon(Icons.people_alt, size: 40.0),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 30.0),
              activeIcon: Icon(Icons.add_box, size: 40.0),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline, size: 30.0),
              activeIcon: Icon(Icons.info, size: 40.0),
              label: 'Notifications',
            ),
          ]),
        ),
      ),
    );
  }
}

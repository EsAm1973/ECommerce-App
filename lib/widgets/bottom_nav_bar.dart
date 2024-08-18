import 'package:ecommerce_app/Screens/Cart_Screen.dart';
import 'package:ecommerce_app/Screens/Favorite_Screen.dart';
import 'package:ecommerce_app/Screens/HomePage.dart';
import 'package:ecommerce_app/Screens/Profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ButtomNavScreen extends StatefulWidget {
  const ButtomNavScreen({super.key, required this.username});
  final String username;

  @override
  State<ButtomNavScreen> createState() => _ButtomNavScreenState();
}

class _ButtomNavScreenState extends State<ButtomNavScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(
        username: widget.username,
      ),
      FavoriteScreen(
        username: widget.username,
      ),
      ShoppingCart(
        username: widget.username,
      ),
      ProfileScreen(
        username: widget.username,
      ),
    ];
    return SafeArea(
      child: Scaffold(
          body: screens[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.grey.shade900, boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.grey.withOpacity(.1))
            ]),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: GNav(
                  gap: 4,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  duration: const Duration(milliseconds: 500),
                  tabBackgroundColor: Colors.grey.shade800,
                  tabs: const [
                    GButton(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.favorite_border_outlined,
                      iconColor: Colors.white,
                      text: 'Fav',
                    ),
                    GButton(
                      icon: Icons.shopping_cart_outlined,
                      iconColor: Colors.white,
                      text: 'Cart',
                    ),
                    GButton(
                      icon: Icons.person_2_outlined,
                      iconColor: Colors.white,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multi_store_app_intec/Views/screens/nav_screens/home_screen.dart';
import 'package:multi_store_app_intec/Views/screens/nav_screens/favorite_screen.dart';
import 'package:multi_store_app_intec/Views/screens/nav_screens/store_screen.dart';
import 'package:multi_store_app_intec/Views/screens/nav_screens/cart_screen.dart';
import 'package:multi_store_app_intec/Views/screens/nav_screens/account_screen.dart';

import '../widgets/product_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const CartScreen(),
    const CartScreen(),
     AccountScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPage,
        onTap: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/love.png', width: 25),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/mart.png', width: 25),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/cart.png', width: 25),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/user.png', width: 25),
            label: 'Account',
          ),
        ],
      ),

    );
  }
}
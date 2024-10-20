import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'View/nav_screen/earning_screen.dart';
import 'View/nav_screen/edit_screen.dart';
import 'View/nav_screen/orders_screen.dart';
import 'View/nav_screen/upload_screen.dart';
import 'View/nav_screen/vendor_logout_screen.dart';


class MainVendorScreen extends StatefulWidget {

   MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  double _iconSize = 25;
  final List<Widget> _pages = [
    EarningScreen(),
    UploadScreen(),
   EditScreen(),
    OrdersScreen(),
    VendorLogoutScreen()
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.money_dollar),
                label: 'EARNINGS'),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: 'UPLOAD'),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'EDIT'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart),
                label: 'ORDERS'),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'LOGOUT'),
          ],
        ),
      body: _pages[_pageIndex],
      );
  }
}

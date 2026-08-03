import 'package:flutter/material.dart';
import 'package:my_app/screens/category_screen.dart';
import 'package:my_app/screens/new_product_screen.dart';
import 'package:my_app/screens/user_screen.dart';
//import 'package:my_app/screens/cart_screen.dart';

import 'empty_page.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    const HomeScreen(),
    //const NewProductScreen(),
    const CategoryScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const UsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.show_chart, color: Color(0xFF2563EB)),
        ),
        title: Text(
          _titles[currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFEAF0FF),
            child: Icon(Icons.person, color: Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Users',
          ),
        ],
      ),
    );
  }

  static const List<String> _titles = [
    'Home',
    'Categories',
    'Cart',
    'Wishlist',
    'Users',
  ];
}

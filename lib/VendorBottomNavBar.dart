
import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'vendor/vendorProductsPage.dart';/// Import your VendorProductsPage
import 'package:flutter/material.dart';
import 'profile.dart';
import 'order/viewOrders.dart'; // Import your Order History page
import 'package:flutter/material.dart';
import 'profile.dart';
// Import your Order History page
import 'order/orderDetailsScreen.dart'; // Import the OrderDetailsScreen

class VendorBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Home button action
              },
            ),
          ),
          Flexible(
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Settings button action
              },
            ),
          ),
          Flexible(
            child: IconButton(
              icon: Icon(Icons.list_alt), // New icon for My Products
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorProductsPage()), // Navigate to VendorProductsPage
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// Import the CartScreen if needed

class ShopperBottomNavBar extends StatelessWidget {
  const ShopperBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => orderDetailsScreen()),
          );
        },
        backgroundColor: Colors.green, // Set FloatingActionButton color to green
        child: const Icon(Icons.shopping_cart, color: Colors.white), // Set the icon color to white
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => viewOrders()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

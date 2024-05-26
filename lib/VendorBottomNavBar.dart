
import 'package:flutter/material.dart';
import 'profile.dart';
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
        ],
      ),
    );
  }
}

class ShopperBottomNavBar extends StatelessWidget {
  const ShopperBottomNavBar({super.key});


  @override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 86.0, // Standard height for BottomAppBar
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_basket),
                        label: 'Cart',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                    onTap: (index) {
          switch (index) {
            case 0:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => StockScreen()),
              // );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profileScreen()),
              );
              break;
          }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
}
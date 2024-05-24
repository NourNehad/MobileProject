

import 'package:flutter/material.dart';
import 'package:test/products/productScreen.dart';

class VendorBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   VendorBottomNavBar({
//     required this.selectedIndex,
//     required this.onItemTapped,
//  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Business',
              ),
            ],
            // currentIndex: selectedIndex,
            // onTap: onItemTapped,
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 - 28, // Adjust to center the button
          child: FloatingActionButton(
            onPressed: (){
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => productScreen()),
                );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:test/LoginScreen.dart';
import 'package:test/profile.dart';
import 'package:test/vendor/requestVendorScreen.dart';
 class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            // Your drawer header content here
            child: Text('Jewlarria'),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 133, 187, 232),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
            },
          ),
          ListTile(
            title: Text('Create Vendor Account'),
            onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => requestVendorScreen()),
                );
            },
          ),
           ListTile(
            title: Text('Log Out'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loginScreen()),
                );
            },
          ),
          // Add more ListTile widgets for additional items
        ],
      ),
    );
  }
}




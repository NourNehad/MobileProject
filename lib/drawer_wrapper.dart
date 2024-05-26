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
            child: Text(
              'Jewellerria',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profileScreen()),
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
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          // Add more ListTile widgets for additional items
        ],
      ),
    );
  }
}
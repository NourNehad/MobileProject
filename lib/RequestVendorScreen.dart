import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
class RequestVendorScreen extends StatefulWidget {
  @override
  _RequestVendorScreenState createState() => _RequestVendorScreenState();
}

class _RequestVendorScreenState extends State<RequestVendorScreen> {
  final authenticationInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void requestToBecomeVendor() async {
    User? user = authenticationInstance.currentUser;

    if (user != null) {
      try {
        // Update the user profile to mark as vendor
        //await _firestore.collection('users').doc(user.uid).update({
        //  'isVendor': true,
        //});

        // Create vendor profile
        await _firestore.collection('vendors').doc(user.uid).set({
          'id': user.uid,
          'name': nameController.text,
          'email': user.email ?? '',
          'phoneNumber': phoneNumberController.text,
          'address': addressController.text,
          'products': [],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vendor request submitted successfully')),
        );

        // Clear the text fields
        nameController.clear();
        phoneNumberController.clear();
        addressController.clear();
      } catch (e) {
        print('Error submitting vendor request: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit vendor request')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not signed in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request to Become a Vendor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: requestToBecomeVendor,
              child: Text("Request Vendor Status"),
            ),
          ],
        ),
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


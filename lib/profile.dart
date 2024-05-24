import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/products/allProducts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _currentUser;
  late DocumentSnapshot _userSnapshot;
  late  bool _isVendor;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _isVendor = userData['isVendor'] ?? false;
         _userSnapshot = userSnapshot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user image (Placeholder for now)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_placeholder.png'),
                // You can replace 'assets/user_placeholder.png' with your image path
              ),
            ),
            SizedBox(height: 20),
            // Display user email and username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${_currentUser?.email ?? "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username: ${_userSnapshot != null ? _userSnapshot['username'] ?? "N/A" : "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Button to display products or orders based on user type
            Center(
              child: _isVendor
                  ? ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MyProductsScreen()),
                        // );
                      },
                      child: Text('My Products'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        // Navigate to My Orders Screen
                      },
                      child: Text('My Orders'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

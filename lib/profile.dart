import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<profileScreen> {
  User? _currentUser;
  DocumentSnapshot? _userSnapshot;
  bool _isVendor = false;

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
        centerTitle: true, // Center the title
        backgroundColor: Colors.green, // Set the AppBar color to green
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Set the title text to white
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display user image (Placeholder for now)
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green[200], // Update the background color
                // You can replace this with the actual image path
              ),
            ),
            SizedBox(height: 20),
            // Display user email and username
            Container(
              color: Colors.grey[200], // Set background color to grey
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${_currentUser?.email ?? "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username: ${_userSnapshot != null ? _userSnapshot!['username'] ?? "N/A" : "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Button to display products or orders based on user type
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement navigation based on user type
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400], // Set button color to grey
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  _isVendor ? 'My Products' : 'My Orders',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
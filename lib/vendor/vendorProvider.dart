import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isVendor = false;

  User? get currentUser => _currentUser;
  bool get isVendor => _isVendor;

  VendorProvider() {
    _currentUser = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      _isVendor = userData['isVendor'] ?? false;
      notifyListeners();  // This notifies all listeners of the state change
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isVendor = false;
  bool _isAuth = true;
   String _username = '';
   DocumentSnapshot? _userSnapshot;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _vendorProducts = [];

  String get username => _username;
  User? get currentUser => _currentUser;
  bool get isVendor => _isVendor;
  bool get isAuth => _isAuth;
  DocumentSnapshot? get userSnapshot => _userSnapshot;
  List<Map<String, dynamic>> get products => _products; 
  List<Map<String, dynamic>> get vendorProducts => _vendorProducts; 

  VendorProvider() {
    _currentUser = _auth.currentUser;
    _fetchUserData();
    _fetchAllProducts();
    _isAuthentic();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      _isVendor = userData['isVendor'] ?? false;
      _username = userData['username'] ?? '';
      notifyListeners();  // This notifies all listeners of the state change
    }
  }

   Future<void> _fetchAllProducts() async {
    if (_currentUser != null) {
      QuerySnapshot productSnapshot = await _firestore
          .collection('products')
          .get();

      _products = productSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      notifyListeners();  // This notifies all listeners of the state change
    }
  }

Future<void> _fetchProductsVendor() async {
  if (_currentUser != null) {
    QuerySnapshot productSnapshot = await _firestore
        .collection('products')
        .where('vendorId', isEqualTo: _currentUser!.uid)
        .get();

      _vendorProducts = productSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    
    notifyListeners();  
  }
}

  Future<void> _isAuthentic() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        print('User is authenticated and exists in Firestore: ${user.uid}');
        _isAuth = true;
      } else {
        print('User does not exist in Firestore');
        _isAuth = false;
      }
    } else {
      print('User is not authenticated');
      _isAuth = false;
    }
    notifyListeners();
  }
}
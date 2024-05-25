import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cartProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
        final doc = await userCartRef.doc(productId).get();
        if (doc.exists) {
          await userCartRef.doc(productId).update({'quantity': FieldValue.increment(1)});
        } else {
          await userCartRef.doc(productId).set({'quantity': 1});
        }
        notifyListeners();
      }
    } catch (error) {
      print("Error adding to cart: $error");
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
        final doc = await userCartRef.doc(productId).get();
        if (doc.exists) {
          final currentQuantity = doc['quantity'] ?? 0;
          if (currentQuantity <= 1) {
            await userCartRef.doc(productId).delete();
          } else {
            await userCartRef.doc(productId).update({'quantity': FieldValue.increment(-1)});
          }
          notifyListeners();
        }
      }
    } catch (error) {
      print("Error removing from cart: $error");
    }
  }

  // Future<void> clearCart() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       final userId = user.uid;
  //       final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
  //       await userCartRef.get().then((querySnapshot) {
  //         querySnapshot.docs.forEach((doc) {
  //           doc.reference.delete();
  //         });
  //       });
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     print("Error clearing cart: $error");
  //   }
  // }

  Future<Map<String, Map<String, dynamic>>> getCartItems() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
      final querySnapshot = await userCartRef.get();
      Map<String, Map<String, dynamic>> cartItems = {};
      
      for (var doc in querySnapshot.docs) {
        final productId = doc.id;
        final productSnapshot = await _firestore.collection('products').doc(productId).get();
        
        if (productSnapshot.exists) {
          final productData = productSnapshot.data();
          if (productData != null) {
            productData['quantity'] = doc['quantity']; // Add quantity to product data
            cartItems[productId] = productData;
          }
        }
      }
      return cartItems;
    }
    return {};
  } catch (error) {
    print("Error getting cart items: $error");
    return {};
  }
}


  Future<int> getItemCount(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
        final doc = await userCartRef.doc(productId).get();
        return doc.exists ? doc['quantity'] ?? 0 : 0;
      }
      return 0;
    } catch (error) {
      print("Error getting item count: $error");
      return 0;
    }
  }

  Future<int> getTotalItems() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
        final querySnapshot = await userCartRef.get();
        num totalItems = 0;
        querySnapshot.docs.forEach((doc) {
          totalItems += doc['quantity'];
        });
        return totalItems.toInt();
      }
      return 0;
    } catch (error) {
      print("Error getting total items: $error");
      return 0;
    }
  }
  Future<void> clearCart() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
        await userCartRef.get().then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
        notifyListeners();
      }
    } catch (error) {
      print("Error clearing cart: $error");
    }
  }
  Future<void> placeOrder({
    required String address,
    required String paymentMethod,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userDocRef = _firestore.collection('users').doc(userId);
        final userCartRef = userDocRef.collection('cart');
        final orderRef = userDocRef.collection('orders').doc(); // Generate a new order ID
        final querySnapshot = await userCartRef.get();

        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> orderData = {
            'orderId': orderRef.id,
            'userId': userId,
            'address': address,
            'paymentMethod': paymentMethod,
            'orderDate': FieldValue.serverTimestamp(),
            'items': querySnapshot.docs.map((doc) => {
              'productId': doc.id,
              'quantity': doc['quantity'],
            }).toList(),
          };

          await orderRef.set(orderData);
          await clearCart(); // Clear the cart after placing the order
          notifyListeners();
        }
      }
    } catch (error) {
      print("Error placing order: $error");
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .get();
        return querySnapshot.docs.map((doc) => doc.data()..['orderId'] = doc.id).toList();
      }
      return [];
    } catch (error) {
      print("Error getting orders: $error");
      return [];
    }
  }
}

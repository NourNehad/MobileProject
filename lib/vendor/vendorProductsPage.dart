import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/notificationsScreen.dart';

class VendorProductsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Vendor Products'),
        ),
        body: Center(
          child: Text('You must be logged in to view your products.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .where('vendorId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found'));
          }

          var products = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8, // Adjusted aspect ratio for the new layout
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index].data() as Map<String, dynamic>;
              var productId = products[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      child: Center(
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product['title'],
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product['price']}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              // Navigate to edit product screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductScreen(productId: productId, productData: product),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditProductScreen extends StatelessWidget {
  final String productId;
  final Map<String, dynamic> productData;

  EditProductScreen({required this.productId, required this.productData});

  void _triggerNotification(BuildContext context, String title, double discountPercentage) {
    var currentUser = FirebaseAuth.instance.currentUser;
    var vendorName = currentUser != null ? currentUser.displayName ?? 'Vendor' : 'Vendor';
    var notificationMessage = '$vendorName made a discount of ${discountPercentage.toStringAsFixed(2)}% on $title';

    // Add notification to Firestore
    FirebaseFirestore.instance.collection('notifications').add({
      'message': notificationMessage,
      'timestamp': DateTime.now(),
    }).then((_) {
      // After adding notification, navigate to notifications screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => notificationsScreen()),
      );
    }).catchError((error) {
      // Handle error, if any
      print('Error adding notification: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController(text: productData['title']);
    var priceController = TextEditingController(text: productData['price'].toString());
    var oldPrice = productData['price'] is String ? double.parse(productData['price']) : productData['price'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var newPrice = double.parse(priceController.text);
                var discountPercentage = ((oldPrice - newPrice) / oldPrice) * 100;

                // Update product data in Firestore
                FirebaseFirestore.instance.collection('products').doc(productId).update({
                  'title': titleController.text,
                  'price': newPrice,
                }).then((_) {
                  // Trigger call to notification system
                  _triggerNotification(context, titleController.text, discountPercentage);
                  Navigator.pop(context);
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class productDetails extends StatelessWidget {
  final String productId;

  productDetails({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found'));
          }

          var product = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(product['imageUrl']),
                SizedBox(height: 16),
                Text(product['title'], style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Text("Price: \$${product['price']}", style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Text(product['description']),
              ],
            ),
          );
        },
      ),
    );
  }
}
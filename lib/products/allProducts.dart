import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/VendorBottomNavBar.dart';
import 'package:test/products/productScreen.dart';
import 'package:test/vendor/vendorProvider.dart';
import 'productDetails.dart';
import 'package:test/drawer_wrapper.dart';
import 'package:test/cart/cartScreen.dart'; // Import the CartScreen
import 'package:test/cart/cartProvider.dart';

class allProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    final cartProviderInstance = Provider.of<cartProvider>(context);
    bool isVendor = vendorProvider.isVendor;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => cartScreen()),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(), // Assuming MyDrawer is defined elsewhere
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
              childAspectRatio: 0.7, // Adjusted aspect ratio for the new layout
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index].data() as Map<String, dynamic>;
              var productId = products[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => productDetails(productId: productId),
                    ),
                  );
                },
                child: GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   alignment: Alignment.topRight,
                      //   child: IconButton(
                      //     icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                      //     onPressed: () {
                      //       cartProviderInstance.addToCart(productId);
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(content: Text('${product['title']} added to cart')),
                      //       );
                      //     },
                      //   ),
                      // ),
                      Center(
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100, // Ensuring the image is square
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
                              icon: Icon(Icons.add_shopping_cart,color: Colors.blue),
                              onPressed: () {
                                cartProviderInstance.addToCart(productId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${product['title']} added to cart')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => productScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: isVendor ? VendorBottomNavBar() : null,
    );
  }
}

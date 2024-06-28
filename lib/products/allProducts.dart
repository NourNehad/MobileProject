import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/VendorBottomNavBar.dart';
import 'package:test/products/productScreen.dart';
import 'package:test/vendor/vendorProvider.dart';
import 'productDetails.dart';
import 'package:test/drawer_wrapper.dart';
import 'package:test/cart/cartScreen.dart'; // Import the CartScreen
import 'package:test/cart/cartProvider.dart';

class allProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<allProducts> {
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    final cartProviderInstance = Provider.of<cartProvider>(context);

    void navigateToCategory(String category) {
      setState(() {
        selectedCategory = category;
      });
    }

    Future<bool> isVendor() async {
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      var userData = await FirebaseFirestore.instance.collection("users").doc(currentUserId).get();

      if (userData.exists && userData.data()!['isVendor'] == true) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("All products"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
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
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            FutureBuilder<bool>(
              future: isVendor(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // Return an empty container while waiting
                } else if (snapshot.hasData && snapshot.data == true) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome, you are now in your vendor account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if not a vendor
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryTile(
                          categoryName: 'All',
                          iconPath: 'assets/icons/all.svg', // Replace with appropriate icon path
                          onTap: () => navigateToCategory('All'),
                        ),
                        CategoryTile(
                          categoryName: 'Rings',
                          iconPath: 'assets/icons/ring.svg',
                          onTap: () => navigateToCategory('Ring'),
                        ),
                        CategoryTile(
                          categoryName: 'Bracelets',
                          iconPath: 'assets/icons/bracelet.svg',
                          onTap: () => navigateToCategory('Bracelet'),
                        ),
                        CategoryTile(
                          categoryName: 'Necklaces',
                          iconPath: 'assets/icons/necklace.svg',
                          onTap: () => navigateToCategory('Necklace'),
                        ),
                        CategoryTile(
                          categoryName: 'Earrings',
                          iconPath: 'assets/icons/earrings.svg',
                          onTap: () => navigateToCategory('Earring'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: selectedCategory == 'All'
                            ? FirebaseFirestore.instance.collection('products').snapshots()
                            : FirebaseFirestore.instance
                                .collection('products')
                                .where('category', isEqualTo: selectedCategory)
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

                          var products = snapshot.data!.docs.where((product) {
                            var title = product['title'].toString().toLowerCase();
                            return title.contains(searchQuery);
                          }).toList();

                          if (products.isEmpty) {
                            return Center(child: Text('No products match your search'));
                          }

                          return GridView.builder(
                            padding: EdgeInsets.all(10),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
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
                                child: Card(
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
                                              icon: Icon(Icons.add_shopping_cart, color: Colors.blue),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      bottomNavigationBar: vendorProvider.isVendor ? VendorBottomNavBar() : null,
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final String iconPath;
  final VoidCallback onTap;

  CategoryTile({required this.categoryName, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 50, color: Colors.green), // Replace with appropriate icon
            SizedBox(height: 5),
            Text(
              categoryName,
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

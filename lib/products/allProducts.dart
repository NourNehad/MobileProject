import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/VendorBottomNavBar.dart';
import 'package:test/vendor/vendorProvider.dart';
import 'productDetails.dart';
import 'package:test/vendor/requestVendorScreen.dart';
import 'package:test/drawer_wrapper.dart';
import 'package:provider/provider.dart';


class allProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final vendorProvider = Provider.of<VendorProvider>(context);
        bool isVendor = vendorProvider.isVendor;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
      ),
      drawer: MyDrawer(), // Assuming MyDrawer is defined elsewhere
      bottomNavigationBar: isVendor ?  VendorBottomNavBar() : null,
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

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  // leading: Image.network(doc['imageUrl']),
                  title: Text(doc['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productDetails(productId: doc.id),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

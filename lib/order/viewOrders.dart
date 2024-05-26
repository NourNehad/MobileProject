import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/cart/cartProvider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class viewOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider = Provider.of<cartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.green, // Set the AppBar color to green
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Set the title text to white
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: CartProvider.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('You have no orders.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderDate = (order['orderDate'] as Timestamp).toDate();
                final formattedDate = DateFormat('dd/MM/yyyy').format(orderDate);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order['orderId']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Order Date: $formattedDate'),
                      Text('Address: ${order['address']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
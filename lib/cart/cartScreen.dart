import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/cart/cartProvider.dart';
import 'package:test/order/orderDetailsScreen.dart'; // Import the OrderDetailsScreen
import 'package:test/order/viewOrders.dart'; // Import the OrderHistoryScreen

class cartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<cartScreen> {
  late Future<Map<String, Map<String, dynamic>>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = Provider.of<cartProvider>(context, listen: false).getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider = Provider.of<cartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.green, // Set the AppBar color to green
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Set the title text to white
      ),
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          } else {
            final cartItems = snapshot.data!;
            return ListView(
              padding: EdgeInsets.only(bottom: 100.0), // Add padding to avoid overlap with the BottomNavigationBar
              children: cartItems.entries.map((entry) {
                final productData = entry.value;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey), // Add border
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(productData['title']),
                    subtitle: Text('Quantity: ${productData['quantity']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await CartProvider.removeFromCart(entry.key);
                        setState(() {
                          _cartItemsFuture = CartProvider.getCartItems();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Removed ${productData['title']} from cart')),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => orderDetailsScreen()),
          );
        },
        backgroundColor: Colors.green, // Set FloatingActionButton color to green
        child: const Icon(Icons.shopping_cart, color: Colors.white), // Set the icon color to white
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => viewOrders()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

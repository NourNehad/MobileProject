import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/cart/cartProvider.dart';

class orderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<orderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  String _paymentMethod = 'Cash on Delivery'; // Default value

  @override
  Widget build(BuildContext context) {
    final CartProvider = Provider.of<cartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Order Details'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.green, // Set the AppBar color to green
        iconTheme: IconThemeData(
            color: Colors.white), // Set the back button color to white
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold), // Set the title text to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[200], // Set background color to grey
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address = value!;
                  },
                ),
              ),
              SizedBox(height: 20), // Adding space here
              Padding(
                padding: const EdgeInsets.only(
                    top: 20), // Adjust top padding as needed
                child: Container(
                  color: Colors.grey[200], // Set background color to grey
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment method:', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Cash on delivery',
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                          ),
                          Text('Cash on delivery'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Card',
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                          ),
                          Text('Card'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await CartProvider.placeOrder(
                        address: _address,
                        paymentMethod: _paymentMethod,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order placed successfully')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set button color to green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Place order',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
  String _paymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final CartProvider = Provider.of<cartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              SizedBox(height: 20), // Adding space here
              Padding(
                padding: const EdgeInsets.only(top: 20), // Adjust top padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Method', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Cash on Delivery',
                          groupValue: _paymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _paymentMethod = value!;
                            });
                          },
                        ),
                        Text('Cash on Delivery'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Visa',
                          groupValue: _paymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _paymentMethod = value!;
                            });
                          },
                        ),
                        Text('Visa'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

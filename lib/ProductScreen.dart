import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
 
class ProductScreen extends StatefulWidget { 
  @override 
  _ProductScreenState createState() => _ProductScreenState(); 
} 
 
class _ProductScreenState extends State<ProductScreen> { 
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
 
  void addProduct() async { 
    var currentUserId = FirebaseAuth.instance.currentUser!.uid; 
    var userData = await 
FirebaseFirestore.instance.collection("users").doc(currentUserId).get(); 
    FirebaseFirestore.instance.collection("products").doc().set({ 
      "title": titleController.text, 
      "price": priceController.text,
      "description": descriptionController.text,
      "imageUrl": imageUrlController.text,
      "vendorId": currentUserId, 
      "timeCreated": Timestamp.now() 
    }); 
    titleController.clear(); 
    priceController.clear();
    descriptionController.clear();
    imageUrlController.clear();
  
  }}
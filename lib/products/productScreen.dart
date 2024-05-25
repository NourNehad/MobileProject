import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class productScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<productScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String imageUrl = '';
  String category = 'Necklace'; 
  
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
            DropdownButton<String>(
              value: category,
              onChanged: (String? value) {
                setState(() {
                  category = value!;
                });
              },
              items: <String>[
                'Necklace',
                'Ring',
                'Bracelet',
                'Earring',
                'Watch',
                'Other',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () => _selectImage(context),
              child: Text('Select Image'),
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

  Future<void> _selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final File file = File(pickedImage.path);
      String fileName = pickedImage.name;
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('product_images/$fileName')
            .putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void addProduct() async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var userData = await FirebaseFirestore.instance.collection("users").doc(currentUserId).get();

    if (userData.exists && userData.data()!['isVendor'] == true) {
      FirebaseFirestore.instance.collection("products").add({
        "title": titleController.text,
        "price": priceController.text,
        "description": descriptionController.text,
        "imageUrl": imageUrl, // Use imageUrl instead of imageUrlController.text
        "vendorId": currentUserId,
        "timeCreated": Timestamp.now(),
        "category": category, // Add category field
      });

      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        imageUrl = ''; // Clear imageUrl after adding product
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only vendors can add products.'))
      );
    }
  }
}

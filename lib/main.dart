import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'allProducts.dart'; // Ensure this is the correct path to your AllProducts widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AllProducts(),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/errorHandling/loadingScreen.dart';
import 'package:test/loginScreen.dart';
import 'package:test/products/allProducts.dart';
import 'package:test/products/productScreen.dart';
import 'package:test/vendor/vendorProvider.dart'; 
import 'cart/cartScreen.dart';
import 'errorHandling/errorScreen.dart';
import 'package:test/firebase_options.dart';
import 'package:test/drawer_wrapper.dart';
import 'cart/cartProvider.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp()); 
} 

class MyApp extends StatefulWidget { 
  @override 
  _MyAppState createState() => _MyAppState(); 
} 

class _MyAppState extends State<MyApp> { 
  bool _initialized = false; 
  bool _error = false; 

  // Define an async function to initialize FlutterFire 
  void initializeFlutterFire() async { 
    try { 
      // Wait for Firebase to initialize and set _initialized state to true 
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() { 
        _initialized = true; 
        print("Firebase initialized successfully");
      }); 
    } catch(e) { 
      // Set _error state to true if Firebase initialization fails 
      setState(() { 
        _error = true; 
        print("Firebase initialization failed: $e");
      }); 
    } 
  } 

  @override 
  void initState() { 
    super.initState(); 
    initializeFlutterFire(); 
  } 

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => cartProvider()),
      ],

  child : MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      body: _error
          ? errorScreen()
          : !_initialized
              ? loadingScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return loadingScreen();
                    }
                    if (userSnapshot.hasData) {
                      return allProducts();
                    }
                    return loginScreen();
                  },
                ),
    ),
  )
  );
}
}
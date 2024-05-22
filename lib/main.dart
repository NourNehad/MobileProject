
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:test/LoadingScreen.dart';
import 'package:test/LoginScreen.dart';
import 'package:test/ProductScreen.dart'; 
import 'ErrorScreen.dart';
import 'package:test/firebase_options.dart';
 
void main() async { 
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); 
} 
 
 
class MyApp extends StatefulWidget { 
  // This widget is the root of your application. 
  @override 
  _MyAppState createState() => _MyAppState(); 
} 
 
class _MyAppState extends State<MyApp> { 
 
bool _initialized = false; 
  bool _error = false; 
 
  // Define an async function to initialize FlutterFire 
  void initializeFlutterFire() async { 
    try { 
      // Wait for Firebase to initialize and set `_initialized` state to true 
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() { 
        _initialized = true; 
         print("Firebase initialized successfully");
      }); 
    } catch(e) { 
      // Set `_error` state to true if Firebase initialization fails 
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
     
    return MaterialApp( 
      title: 'Flutter Demo', 
      theme: ThemeData( 
      primarySwatch: Colors.blue, 
      ), 
      home: _error
      ? ErrorScreen()
      :_initialized!=true  
        ? LoadingScreen()  
        : StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),  
              builder: (ctx, userSnapshot) { 
          if (userSnapshot.connectionState == ConnectionState.waiting) { 
             
            return LoadingScreen(); 
          } 
          if (userSnapshot.hasData) { 
             // the snapshot returned from the auth sdk has something inside means user is authenticated 
            return ProductScreen(); 
          } 
          return LoginScreen(); 
   
   
   }) 
    ); 
  } 
   
 
}
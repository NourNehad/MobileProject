import 'dart:convert'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart'; 
 import 'package:flutter/material.dart';
import 'package:test/products/allProducts.dart';
class loginScreen extends StatefulWidget { 
  @override 
  _LoginScreenState createState() => _LoginScreenState(); 
} 
 
class _LoginScreenState extends State<loginScreen> { 
  var emailController = TextEditingController(); 
  var passwordController = TextEditingController(); 
  var usernameController = TextEditingController(); 
 
  final authenticationInstance = FirebaseAuth.instance; 
 
  var authenticationMode = 0; 
   
 
  void toggleAuthMode() { 
    if (authenticationMode == 0) { 
      setState(() { 
        authenticationMode = 1; 
      }); 
    } else { 
      setState(() { 
        authenticationMode = 0; 
      }); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
     
    
    return Scaffold( 
      body: Container( 
        width: double.infinity, 
        height: 400, 
        margin: EdgeInsets.only(top: 100, left: 10, right: 10), 
        child: Card( 
          elevation: 5, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(20), 
          ), 
          child: Padding( 
            padding: const EdgeInsets.all(8.0), 
            child: Column( 
              children: [ 
                Center( 
                  child: Text( 
                    "Welcome to Jewelleria", 
                    style: TextStyle(fontSize: 30), 
                  ), 
                ), 
                TextField( 
                  decoration: InputDecoration(labelText: "Email"), 
                  controller: emailController, 
                  keyboardType: TextInputType.emailAddress, 
                ), 
                TextField( 
                  decoration: InputDecoration(labelText: "Password"), 
                  controller: passwordController, 
                  obscureText: true, 
                ), 
                if (authenticationMode == 1) 
                  TextField( 
                    decoration: InputDecoration(labelText: "Username"), 
                    controller: usernameController, 
                     
                  ), 
                ElevatedButton( 
                  onPressed: () { 
                    loginORsignup(); 
                  }, 
                  child: (authenticationMode == 1) 
                      ? Text("Sign up") 
                      : Text("Login"), 
                ), 
                TextButton( 
                  onPressed: () { 
                    toggleAuthMode(); 
                  }, 
                  child: (authenticationMode == 1) 
                      ? Text("Login instead") 
                      : Text("Sign up instead"), 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 


 
   void loginORsignup() async { 
     
    var email = emailController.text.trim(); 
    var password = passwordController.text.trim(); 
    var username = usernameController.text.trim(); 
    var isVendor = false;
    
    UserCredential authResult; 
 
try { 
    if (authenticationMode == 1)  // sign up 
    {  
       
      authResult  = await authenticationInstance.createUserWithEmailAndPassword( 
          email: email, 
          password: password, 
        ); 
 
        await FirebaseFirestore.instance 
            .collection('users') 
            .doc(authResult.user!.uid) 
            .set({ 
          'username': username, 
          'email': email, 
          'isVendor': isVendor
           
        });


        
      } 
     else //log in  
     { 
       authResult = await authenticationInstance.signInWithEmailAndPassword( 
          email: email, 
          password: password, 
        ); 

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => allProducts()),
    );
    } 
} catch (err) { 
  print(err.toString());

if (err.toString().contains("The supplied auth credential is incorrect, malformed or has expired")) {

     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(
            "Credentials are incorrect",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
           TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              
              child:  Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  } else if (err.toString().contains("The email address is badly formatted")){
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(
            "Wrong inputs validation. Make sure @ is included in your email!",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
           TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              
              child:  Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if(err.toString().contains("Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.")){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(
            "Access to this account has been temporarily disabled due to many failed login attempts. Please try again later",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
           TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              
              child:  Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }else if(err.toString().contains("The email address is already in use by another account.")){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(
            "The email address is already in use by another account.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
           TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              
              child:  Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 
} 
  } 
}
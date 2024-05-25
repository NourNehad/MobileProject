import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome to Jewelleria",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Text(
                authenticationMode == 1 ? "Create an account" : "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                ),
                controller: passwordController,
                obscureText: true,
              ),
              if (authenticationMode == 1) ...[
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Enter your username",
                  ),
                  controller: usernameController,
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  loginORsignup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Center(
                  child: Text(authenticationMode == 1 ? "Sign up" : "Login"),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Or sign in with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  toggleAuthMode();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                child: Text(authenticationMode == 1 ? "Login instead" : "Sign up instead"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => allProducts()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Center(
                  child: Text("Continue as Guest"),
                ),
              ),
            ],
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
      if (authenticationMode == 1) // sign up
      {
        authResult = await authenticationInstance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'username': username,
          'email': email,
          'isVendor': isVendor,
        });
      } else // log in
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

      String errorMessage = "An error occurred";
      if (err.toString().contains("The supplied auth credential is incorrect, malformed or has expired")) {
        errorMessage = "Credentials are incorrect";
      } else if (err.toString().contains("The email address is badly formatted")) {
        errorMessage = "Wrong inputs validation. Make sure @ is included in your email!";
      } else if (err.toString().contains("Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.")) {
        errorMessage = "Access to this account has been temporarily disabled due to many failed login attempts. Please try again later";
      } else if (err.toString().contains("The email address is already in use by another account.")) {
        errorMessage = "The email address is already in use by another account.";
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
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
              errorMessage,
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                  ),
                child: Text('OK', style: TextStyle(fontSize: 16)),
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
